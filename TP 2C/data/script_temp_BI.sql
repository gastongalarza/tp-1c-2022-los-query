USE GD2C2022

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_compra')
	DROP TABLE INFORMADOS.BI_fact_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_ventas_x_productos')
	DROP TABLE INFORMADOS.BI_ventas_x_productos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_compras_x_producto')
	DROP TABLE INFORMADOS.BI_compras_x_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_descuento_venta')
	DROP TABLE INFORMADOS.BI_descuento_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_compra_total')
	DROP TABLE INFORMADOS.BI_compra_total

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_compra')
	DROP TABLE INFORMADOS.BI_medio_pago_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_productos')
	DROP TABLE INFORMADOS.BI_productos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_categoria_producto')
	DROP TABLE INFORMADOS.BI_categoria_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_venta_total')
	DROP TABLE INFORMADOS.BI_venta_total

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_envio')
	DROP TABLE INFORMADOS.BI_tipo_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_descuento')
	DROP TABLE INFORMADOS.BI_tipo_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_proveedor')
	DROP TABLE INFORMADOS.BI_proveedor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_canal_venta')
	DROP TABLE INFORMADOS.BI_canal_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_venta')
	DROP TABLE INFORMADOS.BI_medio_pago_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo')
	DROP TABLE INFORMADOS.BI_tiempo

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_clientes')
	DROP TABLE INFORMADOS.BI_clientes

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_rango_etario')
	DROP TABLE INFORMADOS.BI_rango_etario

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_provincia')
	DROP TABLE INFORMADOS.BI_provincia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_envios_por_provincia')
	DROP TABLE INFORMADOS.BI_fact_envios_por_provincia

--Esta table va a mostrar cada compra con el a�o y mes en el que se realiz�.
CREATE TABLE INFORMADOS.BI_tiempo(
id_tiempo int IDENTITY(1,1) PRIMARY KEY,
a�o int,
mes int
);

--Idem INFORMADOS.categoria_producto por requi minimo
CREATE TABLE INFORMADOS.BI_categoria_producto(
id_categoria int PRIMARY KEY,
nombre_categoria varchar(255)
);

--Idem tabla INFORMADOS.productos por requisisto minimo
CREATE TABLE INFORMADOS.BI_productos(
id_producto nvarchar(50) PRIMARY KEY,
id_categoria int REFERENCES INFORMADOS.BI_categoria_producto(id_categoria),
nombre_producto varchar(255),
descripcion_producto varchar(255),
material_producto varchar(255),
marca_producto varchar(255)
);

--Esta tabla va a tener exactamente la info de canal_venta del transaccional
CREATE TABLE INFORMADOS.BI_canal_venta(
id_canal_venta int PRIMARY KEY,
nombre_canal varchar(255),
costo_canal decimal(18,2)
);

--Esta tabla va a tener la misma info que la tabla medio pago venta del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_medio_pago_venta int PRIMARY KEY,
nombre_medio_pago varchar(255),
costo_medio_pago decimal(18,2)
);

--Esta tabla va a tener la misma info que la tabla medio pago compra del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_compra(
id_medio_pago_compra int PRIMARY KEY,
nombre_medio_pago varchar(255)
);

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_compra_total(
id_compra int PRIMARY KEY,
id_medio_pago_compra int REFERENCES INFORMADOS.BI_medio_pago_compra(id_medio_pago_compra),
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
costo_total_compra decimal(18,2)
);

--Esta tabla va a tener las compras realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_compras_x_producto(
id_compra int REFERENCES INFORMADOS.BI_compra_total(id_compra),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_productos(id_producto),
cantidad int, 
costo_total_producto decimal(18,2)
);

--Tabla minima de RANGO ETARIO CLIENTE
CREATE TABLE INFORMADOS.BI_rango_etario(
id_rango_etario int PRIMARY KEY,
rango_etario varchar(5),
edad_minima int,
edad_maxima int
);

CREATE TABLE INFORMADOS.BI_provincia(
id_provincia int PRIMARY KEY,
nombre nvarchar(255)
);

--Idem tabla INFORMADOS.clientes por si fuera necesaria
CREATE TABLE INFORMADOS.BI_clientes(
id_cliente int PRIMARY KEY,
dni_cliente bigint,
nombre_cliente varchar(255),
apellido_cliente varchar(255),
direccion_cliente varchar(255),
telefono_cliente varchar(255),
mail_cliente varchar(255),
fecha_nacimiento date,
id_provincia int REFERENCES INFORMADOS.BI_provincia(id_provincia),
id_rango_etario int REFERENCES INFORMADOS.BI_rango_etario(id_rango_etario)
);

CREATE TABLE INFORMADOS.BI_tipo_envio(
id_tipo_envio int PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_tipo_descuento(
id_tipo_descuento_venta int PRIMARY KEY,
concepto_descuento nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
razon_social nvarchar(255),
domicilio nvarchar(255),
mail nvarchar(255)
);

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_venta_total(
id_venta int PRIMARY KEY,
id_canal_venta int REFERENCES INFORMADOS.BI_canal_venta(id_canal_venta),
id_medio_pago_venta int REFERENCES INFORMADOS.BI_medio_pago_venta(id_medio_pago_venta),
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_cliente int REFERENCES INFORMADOS.BI_clientes(id_cliente),
id_tipo_envio int REFERENCES INFORMADOS.BI_tipo_envio(id_tipo_envio),
precio_total_venta decimal(18,2)
);

CREATE TABLE INFORMADOS.BI_descuento_venta(
id_descuento_venta int PRIMARY KEY, --podria no existir y usar el idventa y tipo descuento
id_venta int REFERENCES INFORMADOS.BI_venta_total(id_venta),
id_tipo_descuento_venta int REFERENCES INFORMADOS.BI_tipo_descuento(id_tipo_descuento_venta),
importe_descuento decimal(18,2)
);

--Esta tabla va a tener las ventas realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_ventas_x_productos(
id_venta int REFERENCES INFORMADOS.BI_venta_total(id_venta),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_productos(id_producto),
cantidad int, 
precio_total_producto decimal(18,2)
PRIMARY KEY(id_venta, id_producto)
);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas de hechos para el armado de las vistas --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE INFORMADOS.BI_fact_compra(
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_productos(id_producto),
id_proveedor nvarchar(50) REFERENCES INFORMADOS.BI_proveedor(id_proveedor),
cantidad int,
precio_unidad decimal(18, 2),
PRIMARY KEY (id_tiempo, id_producto, id_proveedor)
);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de funciones --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'get_tiempo')
	DROP FUNCTION INFORMADOS.get_tiempo
GO

CREATE FUNCTION INFORMADOS.get_tiempo(@fecha DATE)
RETURNS INT
AS
BEGIN
	RETURN (select id_tiempo from INFORMADOS.BI_tiempo
			where a�o = year(@fecha) and mes = month(@fecha))
END
GO

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'get_rango_etario')
	DROP FUNCTION INFORMADOS.get_rango_etario
GO

CREATE FUNCTION INFORMADOS.get_rango_etario(@edad int)
RETURNS INT
AS
BEGIN
	RETURN (select id_rango_etario FROM INFORMADOS.BI_rango_etario
			where (edad_minima <= @edad AND edad_maxima > @edad) OR (edad_minima <= @edad AND edad_maxima IS NULL))
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos tablas dimensionales--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tiempos')
	DROP PROCEDURE sp_migrar_bi_tiempos
GO

CREATE PROCEDURE sp_migrar_bi_tiempos
AS
BEGIN
	PRINT 'Migracion de BI tiempos'
	INSERT INTO INFORMADOS.BI_tiempo(a�o, mes)
	SELECT DISTINCT YEAR(fecha), MONTH(fecha)
	FROM INFORMADOS.venta
	UNION
	SELECT DISTINCT YEAR(fecha), MONTH(fecha)
	FROM INFORMADOS.compra
END
GO

/*
BI_categoria_producto, si bien la piden como requisito minimo en la consigna, no veo sentido q replique lo que est� en el transaccional, pero se necesita 
para armar la 3era vista. Lo mismo que la tabla BI_productos
*/
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_categoria_producto')
	DROP PROCEDURE sp_migrar_bi_categoria_producto
GO

CREATE PROCEDURE sp_migrar_bi_categoria_producto
AS
BEGIN
	PRINT 'Migracion de BI categoria productos'
	INSERT INTO INFORMADOS.BI_categoria_producto
	SELECT * FROM INFORMADOS.categoria_producto
END
GO

--revisar que informacion es relevante
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_productos')
	DROP PROCEDURE sp_migrar_bi_productos
GO

CREATE PROCEDURE sp_migrar_bi_productos
AS
BEGIN
	PRINT 'Migracion de BI productos'
	INSERT INTO INFORMADOS.BI_productos(id_producto, id_categoria, nombre_producto, descripcion_producto, material_producto, marca_producto)
	SELECT p.id_producto, p.id_categoria, p.nombre, p.descripcion, p.material, p.marca
	FROM INFORMADOS.producto p
	JOIN INFORMADOS.categoria_producto cp ON p.id_categoria = cp.id_categoria
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_canal_venta')
	DROP PROCEDURE sp_migrar_bi_canal_venta
GO

CREATE PROCEDURE sp_migrar_bi_canal_venta
AS
BEGIN
	PRINT 'Migracion de BI canal venta'
	INSERT INTO INFORMADOS.BI_canal_venta
	SELECT * FROM INFORMADOS.canal_venta
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_medio_pago')
	DROP PROCEDURE sp_migrar_bi_medio_pago
GO

CREATE PROCEDURE sp_migrar_bi_medio_pago
AS
BEGIN
	PRINT 'Migracion de BI medio de pago venta'
	INSERT INTO INFORMADOS.BI_medio_pago_venta
	SELECT * FROM INFORMADOS.medio_pago_venta

	PRINT 'Migracion de BI medio de pago compra'
	INSERT INTO INFORMADOS.BI_medio_pago_compra
	SELECT * FROM INFORMADOS.medio_pago_compra
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_compra_total')
	DROP PROCEDURE sp_migrar_bi_compra_total
GO

CREATE PROCEDURE sp_migrar_bi_compra_total
AS
BEGIN
	PRINT 'Migracion de BI compra total'
	INSERT INTO INFORMADOS.BI_compra_total(id_compra, id_medio_pago_compra, id_tiempo, costo_total_compra)
	SELECT cr.id_compra, cr.id_medio_pago, t.id_tiempo,
		sum(cp.precio_unidad * cp.cantidad)
	FROM INFORMADOS.compra cr
	LEFT JOIN INFORMADOS.producto_por_compra cp ON cr.id_compra = cp.id_compra
	JOIN INFORMADOS.BI_tiempo t ON YEAR(cr.fecha) = t.a�o AND MONTH(cr.fecha) = t.mes
	GROUP BY cr.id_compra, cr.id_medio_pago, t.id_tiempo
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_compras_x_producto')
	DROP PROCEDURE sp_migrar_bi_compras_x_producto
GO

CREATE PROCEDURE sp_migrar_bi_compras_x_producto
AS
BEGIN
	PRINT 'Migracion de BI compras realizadas'
	INSERT INTO INFORMADOS.BI_compras_x_producto(id_compra, id_producto, cantidad, costo_total_producto)
	SELECT pc.id_compra, vp.id_producto, pc.cantidad,
		(pc.cantidad * pc.precio_unidad) AS costo_total_producto
	FROM INFORMADOS.producto_por_compra pc
	LEFT JOIN INFORMADOS.variante_producto vp ON pc.id_variante_producto = vp.id_variante_producto
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_rango_etario')
	DROP PROCEDURE sp_migrar_bi_rango_etario
GO

CREATE PROCEDURE sp_migrar_bi_rango_etario
AS
BEGIN
	PRINT 'Migracion de BI rango etario'
	INSERT INTO INFORMADOS.BI_rango_etario values(1, '<25', 0, 25)
	INSERT INTO INFORMADOS.BI_rango_etario values(2, '25-35', 25, 35)
	INSERT INTO INFORMADOS.BI_rango_etario values(3, '35-55', 35, 55)
	INSERT INTO INFORMADOS.BI_rango_etario values(4, '>55', 55, NULL)
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_provincia')
	DROP PROCEDURE sp_migrar_bi_provincia
GO

CREATE PROCEDURE sp_migrar_bi_provincia
AS
BEGIN
	PRINT 'Migracion de BI provincias'
	INSERT INTO INFORMADOS.BI_provincia
	SELECT DISTINCT * FROM INFORMADOS.provincia WHERE nombre IS NOT NULL
END
GO

--verificar que informacion es escencial para las vistas, el resto sacarla
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_clientes')
	DROP PROCEDURE sp_migrar_bi_clientes
GO

CREATE PROCEDURE sp_migrar_bi_clientes
AS
BEGIN
	PRINT 'Migracion de BI Clientes'
	INSERT INTO INFORMADOS.BI_clientes(id_cliente, dni_cliente, nombre_cliente, apellido_cliente, direccion_cliente,
		telefono_cliente, mail_cliente, fecha_nacimiento, id_provincia, id_rango_etario)
	SELECT i.id_cliente, i.dni, i.nombre, i.apellido, i.direccion,
		i.telefono, i.mail, i.fecha_nacimiento, z.id_provincia, INFORMADOS.get_rango_etario(DATEDIFF(YEAR, i.fecha_nacimiento, GETDATE()))
	FROM INFORMADOS.cliente i
	JOIN INFORMADOS.zona z ON i.id_zona = z.id_zona
END
GO

select * from INFORMADOS.provincia, INFORMADOS.BI_provincia

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_envio')
	DROP PROCEDURE sp_migrar_bi_tipo_envio
GO

CREATE PROCEDURE sp_migrar_bi_tipo_envio
AS
BEGIN
	PRINT 'Migracion de BI tipos de envio'
    INSERT INTO INFORMADOS.BI_tipo_envio (id_tipo_envio, nombre)
	SELECT DISTINCT * FROM INFORMADOS.metodo_envio WHERE nombre IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_descuento')
	DROP PROCEDURE sp_migrar_bi_tipo_descuento
GO

CREATE PROCEDURE sp_migrar_bi_tipo_descuento
AS
BEGIN
	PRINT 'Migracion de BI tipos de descuento'
    INSERT INTO INFORMADOS.BI_tipo_descuento (id_tipo_descuento_venta, concepto_descuento)
	SELECT * FROM INFORMADOS.tipo_descuento_venta
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_proveedor')
	DROP PROCEDURE sp_migrar_bi_proveedor
GO

CREATE PROCEDURE sp_migrar_bi_proveedor
AS
BEGIN
	PRINT 'Migracion de BI proveedor'
    INSERT INTO INFORMADOS.BI_proveedor (id_proveedor, razon_social, domicilio, mail)
	SELECT DISTINCT id_proveedor, razon_social, direccion, mail
	FROM INFORMADOS.proveedor
	WHERE id_proveedor IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_venta_total')
	DROP PROCEDURE sp_migrar_bi_venta_total
GO

CREATE PROCEDURE sp_migrar_bi_venta_total
AS
BEGIN
	PRINT 'Migracion de BI venta total'
	INSERT INTO INFORMADOS.BI_venta_total(id_venta, id_canal_venta, id_medio_pago_venta, id_tiempo,
		id_cliente, id_tipo_envio, precio_total_venta)
	SELECT ve.id_venta, ve.id_canal, ve.id_medio_pago_venta, id_tiempo,
		ve.id_cliente, e.id_metodo_envio,
		sum(vp.precio_total_producto * vp.cantidad)
	FROM INFORMADOS.venta ve
	LEFT JOIN INFORMADOS.BI_ventas_x_productos vp ON ve.id_venta = vp.id_venta
	JOIN INFORMADOS.BI_tiempo t ON YEAR(ve.fecha) = t.a�o AND MONTH(ve.fecha) = t.mes
	JOIN INFORMADOS.envio e ON ve.id_envio = e.id_envio
	GROUP BY ve.id_venta, ve.id_canal, ve.id_medio_pago_venta, id_tiempo, ve.id_cliente, e.id_metodo_envio
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_descuento_venta')
	DROP PROCEDURE sp_migrar_bi_descuento_venta
GO

CREATE PROCEDURE sp_migrar_bi_descuento_venta
AS
BEGIN
	PRINT 'Migracion de BI descuento de venta'
    INSERT INTO INFORMADOS.BI_descuento_venta(id_descuento_venta, id_venta, id_tipo_descuento_venta, importe_descuento)
	SELECT * FROM INFORMADOS.descuento_venta
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_ventas_x_productos')
	DROP PROCEDURE sp_migrar_bi_ventas_x_productos
GO

CREATE PROCEDURE sp_migrar_bi_ventas_x_productos
AS
BEGIN
	PRINT 'Migracion de BI ventas realizadas'
	INSERT INTO INFORMADOS.BI_ventas_x_productos(id_venta, id_producto, cantidad, precio_total_producto)
	SELECT pv.id_venta, vp.id_producto, pv.cantidad,
		(pv.cantidad * pv.precio_unidad) as precio_total_producto
	FROM INFORMADOS.producto_por_venta pv
	LEFT JOIN INFORMADOS.variante_producto vp ON pv.id_variante_producto = vp.id_variante_producto
END
GO

SELECT vp.id_producto
FROM INFORMADOS.producto_por_venta pv
LEFT JOIN INFORMADOS.variante_producto vp ON pv.id_variante_producto = vp.id_variante_producto
group by vp.id_producto
having count(pv.id_venta) > 1

select id_venta, id_variante_producto
from informados.producto_por_venta
where id_venta = 126283

/*
Hasta ac� estas tablas se usarian para realizar la primer Vista solicitada, y a su vez vienen a ser algunas dimensiones MINIMAS
solicitadas en la consigna
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos tablas de hechos--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_compra')
	DROP PROCEDURE sp_migrar_fact_compra
GO

CREATE PROCEDURE sp_migrar_fact_compra
AS
BEGIN
	PRINT 'Migracion de BI Hechos Compra'
    INSERT INTO INFORMADOS.BI_fact_compra(id_tiempo, id_producto, id_proveedor, cantidad, precio_unidad) 
    SELECT DISTINCT INFORMADOS.get_tiempo(fecha), vp.id_producto, id_proveedor, SUM(cantidad),
		SUM(cantidad * precio_unidad) / SUM(cantidad)
    FROM INFORMADOS.compra c
	INNER JOIN INFORMADOS.producto_por_compra ppc ON ppc.id_compra = c.id_compra
	INNER JOIN INFORMADOS.variante_producto vp ON vp.id_variante_producto = ppc.id_variante_producto
    GROUP BY INFORMADOS.get_tiempo(fecha), vp.id_producto, id_proveedor
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VISTA 1: Las ganancias mensuales de cada canal de venta.
-- Se entiende por ganancias al total de las ventas, menos el total de las 
-- compras, menos los costos de transacci�n totales aplicados asociados los 
-- medios de pagos utilizados en las mismas.
-- columnas: canal de venta, a�o, mes, ganancias

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_ganancia_mensual_canal')
	DROP VIEW vw_ganancia_mensual_canal
GO

-- Por qu� se divid�a por 4?
CREATE VIEW vw_ganancia_mensual_canal
AS
SELECT  ti.a�o, ti.mes, cv.nombre_canal,
	SUM(vt.precio_total_venta) - ROUND(SUM(ct.costo_total_compra)/* / 4*/, 2) - ROUND(SUM(mp.costo_medio_pago), 2) AS ganancia
FROM INFORMADOS.BI_tiempo ti
LEFT JOIN INFORMADOS.BI_venta_total vt ON vt.id_tiempo = ti.id_tiempo
LEFT JOIN INFORMADOS.BI_canal_venta cv ON vt.id_canal_venta = cv.id_canal_venta
LEFT JOIN INFORMADOS.BI_medio_pago_venta mp ON vt.id_medio_pago_venta = mp.id_medio_pago_venta
LEFT JOIN INFORMADOS.BI_compra_total ct ON ct.id_tiempo = ti.id_tiempo
GROUP BY ti.a�o, ti.mes, cv.nombre_canal
GO

-- VISTA 2: Los 5 productos con mayor rentabilidad anual, con sus respectivos %.
-- Se entiende por rentabilidad a los ingresos generados por el producto 
-- (ventas) durante el periodo menos la inversi�n realizada en el producto 
-- (compras) durante el periodo, todo esto sobre dichos ingresos. 
-- Valor expresado en porcentaje. 
-- Para simplificar, no es necesario tener en cuenta los descuentos aplicados.
-- columnas: producto, porcentaje (a�o?, se asume el �ltimo a�o?, se promedian todos los a�os historicos?)

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_mayor_rentabilidad_anual')
	DROP VIEW vw_mayor_rentabilidad_anual
GO

CREATE VIEW vw_mayor_rentabilidad_anual
AS
SELECT TOP 5
	vp.id_producto,
	((sum(vp.precio_total_producto)
		- (SELECT sum(costo_total_producto)
			FROM INFORMADOS.BI_compras_x_producto cp
			WHERE cast(concat(ti.a�o, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
				and cp.id_producto = vp.id_producto)
	) /	(SELECT sum(vp2.precio_total_producto) 
		FROM INFORMADOS.BI_ventas_x_productos vp2
		WHERE cast(concat(ti.a�o, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
			and vp2.id_producto = vp.id_producto)
	) * 100 AS porcentaje_rentabilidad
FROM INFORMADOS.BI_ventas_x_productos vp
LEFT JOIN INFORMADOS.BI_tiempo ti
ON vp.id_venta = ti.id_tiempo
WHERE cast(concat(ti.a�o, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
GROUP BY vp.id_producto, ti.a�o, ti.mes
ORDER BY porcentaje_rentabilidad desc
GO

-- La consigna dice 5 categorias mas vendidas, pero son solo 3 las categorias de productos.
/*
CREATE VIEW vw_categorias_vendidas_mensual
AS
SELECT 1 AS ASD
*/

-- VISTA 3: Las 5 categor�as de productos m�s vendidos por rango etario de clientes por mes. 
-- columnas: rango_etareo, a�o, mes, categoria_nombre

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
-- columnas: medio_pago, a�o, mes, ingresos

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

/*
select vt.id_venta,vt.precio_total_venta,sum(mp.costo_medio_pago),(CASE WHEN td.concepto_descuento=mp.nombre_medio_pago THEN dv.importe_descuento ELSE 0 end)
from INFORMADOS.BI_venta_total vt 
JOIN INFORMADOS.BI_tiempo_venta tv
ON vt.id_venta=tv.id_venta 
JOIN INFORMADOS.BI_medio_pago_venta mp
ON mp.id_medio_pago_venta=vt.id_medio_pago_venta
JOIN INFORMADOS.BI_descuento_venta dv
ON vt.id_venta=dv.id_venta
JOIN INFORMADOS.BI_tipo_descuento td
ON dv.id_tipo_descuento_venta=td.id_tipo_descuento_venta
where tv.mes = 9 and vt.id_medio_pago_venta = 2
group by vt.id_venta,vt.precio_total_venta

select * from INFORMADOS.BI_descuento_venta where id_venta=125972

select * from INFORMADOS.BI_venta_total where id_venta=125972
*/
--5269916140.93 - 13900.00
--Tarjeta 2
--mes 9


-- VISTA 5: Importe total en descuentos aplicados seg�n su tipo de descuento, por canal de venta, por mes.
-- Se entiende por tipo de descuento como los 
-- correspondientes a env�o, medio de pago, cupones, etc)
-- columnas: tipo_descuento, canal_de_venta, a�o, mes, importe

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

-- VISTA 6: Porcentaje de env�os realizados a cada Provincia por mes.
-- El porcentaje debe representar la cantidad de env�os realizados a cada provincia sobre 
-- total de env�o mensuales.
-- columnas: provincia, a�o, mes, porcentaje

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

-- VISTA 7: Valor promedio de env�o por Provincia por Medio De Env�o anual.
-- columnas: provincia, medio_envio, a�o, valor


-- VISTA 8: Aumento promedio de precios de cada proveedor anual.
-- Los 3 productos con mayor cantidad de reposici�n por mes. 


-- VISTA 9: Los 3 productos con mayor cantidad de reposici�n por mes.
-- columnas: a�o, mes, codigo_prod1, nombre_prod2, codigo_prod2, nombre_prod2, codigo_prod3, nombre_prod3

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_tres_productos_mayor_cantidad_reposicion_x_mes')
	DROP VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes
GO

CREATE VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes AS

SELECT
 dt.a�o as [A�o],
 dt.mes as [Mes],
 hc.id_producto as [Producto]
from INFORMADOS.BI_fact_compra hc
INNER JOIN INFORMADOS.BI_tiempo dt
ON hc.id_tiempo = dt.id_tiempo
WHERE hc.id_producto IN 
    (SELECT TOP 3 id_producto FROM INFORMADOS.BI_fact_compra
    WHERE id_tiempo = dt.id_tiempo
    GROUP BY id_producto
    ORDER BY SUM(cantidad) DESC)
GROUP BY dt.a�o, dt.mes, hc.id_producto
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------
/*
 BEGIN TRANSACTION
 BEGIN TRY*/
    EXECUTE sp_migrar_bi_tiempos
	EXECUTE sp_migrar_bi_categoria_producto
	EXECUTE sp_migrar_bi_productos
	EXECUTE sp_migrar_bi_canal_venta
	EXECUTE sp_migrar_bi_medio_pago
	EXECUTE sp_migrar_bi_compra_total
	EXECUTE sp_migrar_bi_compras_x_producto
	EXECUTE sp_migrar_bi_rango_etario
	EXECUTE sp_migrar_bi_provincia
	EXECUTE sp_migrar_bi_clientes
	EXECUTE sp_migrar_bi_tipo_envio
	EXECUTE sp_migrar_bi_tipo_descuento
	EXECUTE sp_migrar_bi_proveedor
	EXECUTE sp_migrar_bi_venta_total
	EXECUTE sp_migrar_bi_descuento_venta
	EXECUTE sp_migrar_bi_ventas_x_productos
	EXECUTE sp_migrar_fact_compra
/*END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM INFORMADOS.BI_canal_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_categoria_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_clientes)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_rango_etario)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_compra_total)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_compras_x_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_medio_pago_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_medio_pago_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_productos)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_provincia)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tiempo)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_descuento)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_proveedor)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_venta_total)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_ventas_x_productos)
    AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_compra)
	)
   BEGIN
	PRINT 'Tablas migradas correctamente.';
	COMMIT TRANSACTION;
   END
	 ELSE
   BEGIN
    ROLLBACK TRANSACTION;
	THROW 50002, 'Se encontraron errores al migrar las tablas. Ne se migraron datos.',1;
   END
GO
*/

--SELECT * FROM INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes