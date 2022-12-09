-- VISTA 1: Las ganancias mensuales de cada canal de venta.
-- Se entiende por ganancias al total de las ventas, menos el total de las 
-- compras, menos los costos de transacción totales aplicados asociados los 
-- medios de pagos utilizados en las mismas.
-- columnas: canal de venta, año, mes, ganancias

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_ganancia_mensual_canal')
	DROP VIEW vw_ganancia_mensual_canal
GO


CREATE VIEW vw_ganancia_mensual_canal
AS
SELECT  ti.año, ti.mes, cv.nombre_canal,
	SUM(vt.precio_total_venta) - ROUND(SUM(fc.costo_total)/* / 4*/, 2) - ROUND(SUM(mp.costo_medio_pago), 2) AS ganancia
FROM INFORMADOS.BI_tiempo ti
LEFT JOIN INFORMADOS.BI_venta_total vt ON vt.id_tiempo = ti.id_tiempo
LEFT JOIN INFORMADOS.BI_canal_venta cv ON vt.id_canal_venta = cv.id_canal_venta
LEFT JOIN INFORMADOS.BI_medio_pago_venta mp ON vt.id_medio_pago_venta = mp.id_medio_pago_venta
LEFT JOIN INFORMADOS.BI_fact_compra fc ON fc.id_tiempo = ti.id_tiempo
GROUP BY ti.año, ti.mes, cv.nombre_canal
GO

-- VISTA 2: Los 5 productos con mayor rentabilidad anual, con sus respectivos %.
-- Se entiende por rentabilidad a los ingresos generados por el producto 
-- (ventas) durante el periodo menos la inversión realizada en el producto 
-- (compras) durante el periodo, todo esto sobre dichos ingresos. 
-- Valor expresado en porcentaje. 
-- Para simplificar, no es necesario tener en cuenta los descuentos aplicados.
-- columnas: producto, porcentaje (año?, se asume el último año?, se promedian todos los años historicos?)

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_mayor_rentabilidad_anual')
	DROP VIEW vw_mayor_rentabilidad_anual
GO

CREATE VIEW vw_mayor_rentabilidad_anual
AS
SELECT TOP 5
	vp.id_producto,
	((sum(vp.precio_total_producto)
		- (SELECT sum(fc.costo_total)
			FROM INFORMADOS.BI_fact_compra fc
			WHERE cast(concat(ti.año, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
				and fc.id_producto = vp.id_producto)
	) /	(SELECT sum(vp2.precio_total_producto) 
		FROM INFORMADOS.BI_ventas_x_productos vp2
		WHERE cast(concat(ti.año, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
			and vp2.id_producto = vp.id_producto)
	) * 100 AS porcentaje_rentabilidad
FROM INFORMADOS.BI_ventas_x_productos vp
LEFT JOIN INFORMADOS.BI_tiempo ti
ON vp.id_venta = ti.id_tiempo
WHERE cast(concat(ti.año, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
GROUP BY vp.id_producto, ti.año, ti.mes
ORDER BY porcentaje_rentabilidad desc
GO

-- VISTA 3: Las 5 categorías de productos más vendidos por rango etario de clientes por mes. 
-- columnas: rango_etareo, año, mes, categoria_nombre

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_categorias_por_rango_etarios')
	DROP VIEW vw_categorias_por_rango_etarios
GO

CREATE VIEW vw_categorias_por_rango_etarios
AS
select TOP 5 ra.rango_etario, pr.id_categoria, ti.mes
from INFORMADOS.BI_ventas_x_productos vp
join INFORMADOS.BI_productos pr ON pr.id_producto = vp.id_producto
join INFORMADOS.BI_venta_total vt ON vt.id_venta = vp.id_venta
join INFORMADOS.BI_tiempo ti ON ti.id_tiempo = vt.id_tiempo
join INFORMADOS.BI_clientes cl ON cl.id_cliente = vt.id_cliente
join INFORMADOS.BI_rango_etario ra ON ra.id_rango_etario = cl.id_rango_etario
join INFORMADOS.BI_categoria_producto ca ON ca.id_categoria = pr.id_categoria
group by pr.id_categoria, ti.mes, ra.rango_etario
order by sum(vp.cantidad) DESC
GO

-- VISTA 4:  Total de Ingresos por cada medio de pago por mes, descontando los costos 
-- por medio de pago (en caso que aplique) y descuentos por medio de pago 
-- (en caso que aplique)
-- columnas: medio_pago, año, mes, ingresos

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_ingresos_x_medio_pago')
	DROP VIEW vw_ingresos_x_medio_pago
GO

CREATE VIEW vw_ingresos_x_medio_pago
AS
SELECT mp.nombre_medio_pago, ti.mes,
	sum(vt.precio_total_venta) - coalesce(sum(mp.costo_medio_pago), 0) - 
		(CASE WHEN td.concepto_descuento = mp.nombre_medio_pago THEN dv.importe_descuento
			ELSE 0 end) AS total_ingresos
FROM INFORMADOS.BI_venta_total vt
JOIN INFORMADOS.BI_tiempo ti ON vt.id_venta = ti.id_tiempo
JOIN INFORMADOS.BI_medio_pago_venta mp ON mp.id_medio_pago_venta = vt.id_medio_pago_venta
JOIN INFORMADOS.BI_descuento_venta dv ON vt.id_venta = dv.id_venta
JOIN INFORMADOS.BI_tipo_descuento td ON dv.id_tipo_descuento_venta = td.id_tipo_descuento_venta
GROUP BY mp.nombre_medio_pago, ti.mes, td.concepto_descuento, dv.importe_descuento
GO


-- VISTA 5: Importe total en descuentos aplicados según su tipo de descuento, por canal de venta, por mes.
-- Se entiende por tipo de descuento como los 
-- correspondientes a envío, medio de pago, cupones, etc)
-- columnas: tipo_descuento, canal_de_venta, año, mes, importe

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_descuentos_aplicados_por_tipo')
	DROP VIEW vw_descuentos_aplicados_por_tipo
GO

CREATE VIEW vw_descuentos_aplicados_por_tipo
AS
select tp.concepto_descuento, ca.nombre_canal, ti.mes, sum(dv.importe_descuento) as importe
FROM INFORMADOS.BI_venta_total vt
JOIN INFORMADOS.BI_canal_venta ca ON vt.id_canal_venta = ca.id_canal_venta
JOIN INFORMADOS.BI_descuento_venta dv ON dv.id_venta = vt.id_venta
JOIN INFORMADOS.BI_tipo_descuento tp ON tp.id_tipo_descuento_venta = dv.id_tipo_descuento_venta
JOIN INFORMADOS.BI_tiempo ti ON ti.id_tiempo = vt.id_tiempo
GROUP BY ti.mes, tp.concepto_descuento, ca.nombre_canal
GO

-- VISTA 6: Porcentaje de envíos realizados a cada Provincia por mes.
-- El porcentaje debe representar la cantidad de envíos realizados a cada provincia sobre 
-- total de envío mensuales.
-- columnas: provincia, año, mes, porcentaje

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_envios_a_provincia_por_mes')
	DROP VIEW vw_envios_a_provincia_por_mes
GO

CREATE VIEW vw_envios_a_provincia_por_mes
AS
select pr.nombre, ti.mes,
	COUNT(te.nombre) / (
		SELECT count(te.nombre)
		FROM INFORMADOS.BI_venta_total vt2
		JOIN INFORMADOS.BI_tipo_envio te2 ON te2.id_tipo_envio = vt2.id_tipo_envio
		WHERE te.nombre <> 'Entrega en sucursal' AND ti.id_tiempo = vt2.id_tiempo
	) * 100 AS importe
FROM INFORMADOS.BI_provincia pr
JOIN INFORMADOS.BI_clientes cl ON cl.id_provincia = pr.id_provincia
JOIN INFORMADOS.BI_venta_total vt ON vt.id_cliente = cl.id_cliente
JOIN INFORMADOS.BI_tiempo ti ON ti.id_tiempo = vt.id_tiempo
JOIN INFORMADOS.BI_tipo_envio te ON te.id_tipo_envio = vt.id_tipo_envio
WHERE te.nombre <> 'Entrega en sucursal'
GROUP BY ti.mes, pr.nombre, te.nombre, ti.id_tiempo
GO

-- VISTA 7: Valor promedio de envío por Provincia por Medio De Envío anual.
-- columnas: provincia, medio_envio, año, valor

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_valor_promedio_envio_x_provincia_x_medio_envio_anual')
	DROP VIEW INFORMADOS.vw_valor_promedio_envio_x_provincia_x_medio_envio_anual
GO

CREATE VIEW INFORMADOS.vw_valor_promedio_envio_x_provincia_x_medio_envio_anual
AS
    SELECT 
	t.año AS [Año],
	p.nombre AS [Provincia],
	te.nombre AS [Tipo de envio],
	AVG(he.total_envios) as [Promedio Envios]
    FROM INFORMADOS.BI_fact_envio he
	INNER JOIN INFORMADOS.BI_tiempo t
    ON he.id_tiempo = t.id_tiempo
    INNER JOIN INFORMADOS.BI_provincia p
    ON he.id_provincia = p.id_provincia
    INNER JOIN INFORMADOS.BI_tipo_envio te
    ON he.id_tipo_envio = te.id_tipo_envio
    GROUP BY t.año, p.nombre, te.nombre

GO


-- VISTA 8: Aumento promedio de precios de cada proveedor anual. Para calcular este
-- indicador se debe tomar como referencia el máximo precio por año menos
-- el mínimo todo esto divido el mínimo precio del año. Teniendo en cuenta
-- que los precios siempre van en aumento.

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_aumento_promedio_precios_x_proveedor_anual')
	DROP VIEW INFORMADOS.vw_aumento_promedio_precios_x_proveedor_anual
GO

CREATE VIEW INFORMADOS.vw_aumento_promedio_precios_x_proveedor_anual
AS

	SELECT t.año as [Año],
	       hc.id_proveedor AS [Proveedor],
		   hc.id_producto AS [Producto],
		   AVG(INFORMADOS.get_aumento(t.año, hc.id_proveedor, hc.id_producto)) AS [Aumento promedio en precios]
    FROM INFORMADOS.BI_fact_compra hc
	INNER JOIN INFORMADOS.BI_tiempo t
	ON hc.id_tiempo = t.id_tiempo
    GROUP BY t.año, hc.id_proveedor, hc.id_producto
GO

-- VISTA 9: Los 3 productos con mayor cantidad de reposición por mes.
-- columnas: año, mes, codigo_prod1, nombre_prod2, codigo_prod2, nombre_prod2, codigo_prod3, nombre_prod3

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_tres_productos_mayor_cantidad_reposicion_x_mes')
	DROP VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes
GO

CREATE VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes AS

	SELECT
	 dt.año as [Año],
	 dt.mes as [Mes],
	 hc.id_producto as [Producto]
	from INFORMADOS.BI_tiempo dt
	INNER JOIN INFORMADOS.BI_fact_compra hc
	ON hc.id_tiempo = dt.id_tiempo
	WHERE hc.id_producto IN 
		(SELECT TOP 3 id_producto FROM INFORMADOS.BI_fact_compra
		WHERE id_tiempo = dt.id_tiempo
		GROUP BY id_producto
		ORDER BY SUM(cantidad) DESC)
	GROUP BY dt.año, dt.mes, hc.id_producto
GO