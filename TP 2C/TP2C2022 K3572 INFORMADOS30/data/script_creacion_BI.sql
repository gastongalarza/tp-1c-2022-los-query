USE GD2C2022

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE schema_id = SCHEMA_ID('INFORMADOS'))
BEGIN
	DECLARE @DATABASE_NAME NCHAR = 'INFORMADOS'

	--------------------------------------  E L I M I N A R   FUNCTIONS  --------------------------------------
	DECLARE @SQL_FN NVARCHAR(MAX) = N'';

	SELECT @SQL_FN += N'
	DROP FUNCTION ' + @DATABASE_NAME + '.' + name  + ';' 
	FROM sys.objects WHERE type = 'FN' 
	AND schema_id = SCHEMA_ID(@DATABASE_NAME)

	PRINT @SQL_FN
	EXECUTE(@SQL_FN)

--------------------------------------  E L I M I N A R   S P  --------------------------------------
	DECLARE @SQL_SP NVARCHAR(MAX) = N'';

	SELECT @SQL_SP += N'
	DROP PROCEDURE ' + @DATABASE_NAME + '.' + name  + ';' 
	FROM sys.objects WHERE type = 'P' 
	AND schema_id = SCHEMA_ID(@DATABASE_NAME)

	EXECUTE(@SQL_SP)

	--------------------------------------  E L I M I N A R   F K  --------------------------------------
	DECLARE @SQL_FK NVARCHAR(MAX) = N'';
	
	SELECT @SQL_FK += N'
	ALTER TABLE ' + @DATABASE_NAME + '.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';' 
	FROM SYS.OBJECTS
	WHERE TYPE_DESC LIKE '%CONSTRAINT'
	AND type = 'F'
	AND schema_id = SCHEMA_ID(@DATABASE_NAME)
	
	--PRINT @SQL_FK
	EXECUTE(@SQL_FK)

	--------------------------------------  E L I M I N A R   P K  --------------------------------------
	DECLARE @SQL_PK NVARCHAR(MAX) = N'';
	
	SELECT @SQL_PK += N'
	ALTER TABLE ' + @DATABASE_NAME + '.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';' 
	FROM SYS.OBJECTS
	WHERE TYPE_DESC LIKE '%CONSTRAINT'
	AND type = 'PK'
	AND schema_id = SCHEMA_ID(@DATABASE_NAME)
	
	--PRINT @SQL_PK
	EXECUTE(@SQL_PK)

	------------------------------------  D R O P    T A B L E S   -----------------------------------
	DECLARE @SQL_DROP NVARCHAR(MAX) = N'';

	SELECT @SQL_DROP += N'
	DROP TABLE ' + @DATABASE_NAME + '.' + TABLE_NAME + ';' 
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = @DATABASE_NAME
	AND TABLE_TYPE = 'BASE TABLE'
	AND TABLE_NAME LIKE 'BI[_]%'

	--PRINT @SQL_DROP
	EXECUTE(@SQL_DROP)

	----------------------------------------- D R O P   V I E W  -------------------------------------
	DECLARE @SQL_VIEW NVARCHAR(MAX) = N'';

	SELECT @SQL_VIEW += N'
	DROP VIEW ' + @DATABASE_NAME + '.' + TABLE_NAME + ';' 
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = @DATABASE_NAME
	AND TABLE_TYPE = 'VIEW'
	AND TABLE_NAME LIKE 'BI[_]%'

	--PRINT @SQL_VIEW
	EXECUTE(@SQL_VIEW)

END
GO

--Dropeo tablas de hechos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_descuento')
	DROP TABLE INFORMADOS.BI_fact_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_venta')
	DROP TABLE INFORMADOS.BI_fact_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_envio')
	DROP TABLE INFORMADOS.BI_fact_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_compra')
	DROP TABLE INFORMADOS.BI_fact_compra


--Dropeo Tablas dimensionales

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_producto')
	DROP TABLE INFORMADOS.BI_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_categoria_producto')
	DROP TABLE INFORMADOS.BI_categoria_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_envio')
	DROP TABLE INFORMADOS.BI_tipo_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_descuento')
	DROP TABLE INFORMADOS.BI_tipo_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_canal_venta')
	DROP TABLE INFORMADOS.BI_canal_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_venta')
	DROP TABLE INFORMADOS.BI_medio_pago_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo')
	DROP TABLE INFORMADOS.BI_tiempo

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_rango_etario')
	DROP TABLE INFORMADOS.BI_rango_etario

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_provincia')
	DROP TABLE INFORMADOS.BI_provincia

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE INFORMADOS.BI_tiempo(
id_tiempo int IDENTITY(1,1) PRIMARY KEY,
año int,
mes int
);

CREATE TABLE INFORMADOS.BI_categoria_producto(
id_categoria int PRIMARY KEY,
nombre_categoria varchar(255)
);

CREATE TABLE INFORMADOS.BI_producto(
id_producto nvarchar(50) PRIMARY KEY,
id_categoria int REFERENCES INFORMADOS.BI_categoria_producto(id_categoria),
nombre_producto varchar(255),
descripcion_producto varchar(255),
material_producto varchar(255),
marca_producto varchar(255)
);

CREATE TABLE INFORMADOS.BI_rango_etario(
id_rango_etario int PRIMARY KEY,
rango_etario varchar(5),
edad_minima int,
edad_maxima int
);

CREATE TABLE INFORMADOS.BI_canal_venta(
id_canal_venta int PRIMARY KEY,
nombre_canal varchar(255),
costo_canal decimal(18,2)
);

CREATE TABLE INFORMADOS.BI_tipo_descuento(
id_tipo_descuento int IDENTITY(1, 1) PRIMARY KEY,
tipo_descuento nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_medio_pago_venta int PRIMARY KEY,
nombre_medio_pago varchar(255),
costo_medio_pago decimal(18,2),
porcentaje_descuento decimal(18,2)
);

CREATE TABLE INFORMADOS.BI_tipo_envio(
id_tipo_envio int PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_provincia(
id_provincia int PRIMARY KEY,
nombre nvarchar(255)
);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas de hechos para el armado de las vistas --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE INFORMADOS.BI_fact_compra(
id_compra int IDENTITY(1,1) PRIMARY KEY,
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_producto(id_producto),
id_proveedor nvarchar(50),
cantidad int,
precio_unidad decimal(18, 2),
costo_total decimal(18, 2)
);

CREATE TABLE INFORMADOS.BI_fact_envio (
id_envio int IDENTITY(1,1) PRIMARY KEY,
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_provincia int REFERENCES INFORMADOS.BI_provincia(id_provincia),
id_tipo_envio int REFERENCES INFORMADOS.BI_tipo_envio,
cantidad_envios int,
costo_total decimal(18,2)
);

CREATE TABLE INFORMADOS.BI_fact_venta(
id_venta int IDENTITY(1,1) PRIMARY KEY,
id_canal_venta int REFERENCES INFORMADOS.BI_canal_venta(id_canal_venta),
id_medio_pago_venta int REFERENCES INFORMADOS.BI_medio_pago_venta(id_medio_pago_venta),
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_rango_etario int REFERENCES INFORMADOS.BI_rango_etario(id_rango_etario),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_producto(id_producto),
precio_total decimal(18,2),
cantidad_productos int,
cantidad_ventas int
);

CREATE TABLE INFORMADOS.BI_fact_descuento(
id_descuento int IDENTITY(1,1) PRIMARY KEY, 
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_tipo_descuento_venta int REFERENCES INFORMADOS.BI_tipo_descuento(id_tipo_descuento),
id_canal int REFERENCES INFORMADOS.BI_canal_venta(id_canal_venta),
id_medio_pago_venta int REFERENCES INFORMADOS.BI_medio_pago_venta(id_medio_pago_venta),
importe_total_descuento decimal(18,2)
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
	RETURN (SELECT id_tiempo FROM INFORMADOS.BI_tiempo WHERE año = year(@fecha) and mes = month(@fecha))
END
GO

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'get_rango_etario')
	DROP FUNCTION INFORMADOS.get_rango_etario
GO

CREATE FUNCTION INFORMADOS.get_rango_etario(@fecha_nacimiento date)
RETURNS INT
AS
BEGIN
	DECLARE @edad int = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE())

	RETURN (select id_rango_etario FROM INFORMADOS.BI_rango_etario
			where (edad_minima <= @edad AND edad_maxima > @edad) OR (edad_minima <= @edad AND edad_maxima IS NULL))
END
GO

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'get_aumento')
	DROP FUNCTION INFORMADOS.get_aumento
GO

CREATE FUNCTION INFORMADOS.get_aumento(@anio int, @proveedor nvarchar(50), @producto nvarchar(50))
RETURNS DECIMAL
AS
BEGIN
	RETURN (SELECT (MAX(precio_unidad) - MIN(precio_unidad)) / MIN(precio_unidad) * 100
	FROM INFORMADOS.BI_fact_compra hc
	INNER JOIN INFORMADOS.BI_tiempo t ON hc.id_tiempo = t.id_tiempo
	WHERE hc.id_producto = @producto and hc.id_proveedor = @proveedor and t.año = @anio)
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
	INSERT INTO INFORMADOS.BI_tiempo(año, mes)
	SELECT DISTINCT YEAR(fecha), MONTH(fecha)
	FROM INFORMADOS.venta
	UNION
	SELECT DISTINCT YEAR(fecha), MONTH(fecha)
	FROM INFORMADOS.compra
END
GO

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

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_producto')
	DROP PROCEDURE sp_migrar_bi_producto
GO

CREATE PROCEDURE sp_migrar_bi_producto
AS
BEGIN
	PRINT 'Migracion de BI productos'
	INSERT INTO INFORMADOS.BI_producto(id_producto, id_categoria, nombre_producto, descripcion_producto, material_producto, marca_producto)
	SELECT p.id_producto, p.id_categoria, p.nombre, p.descripcion, p.material, p.marca
	FROM INFORMADOS.producto p
	JOIN INFORMADOS.categoria_producto cp ON p.id_categoria = cp.id_categoria
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

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_descuento')
	DROP PROCEDURE sp_migrar_bi_tipo_descuento
GO

CREATE PROCEDURE sp_migrar_bi_tipo_descuento
AS
BEGIN
	PRINT 'Migracion de BI tipos de descuento'
	INSERT INTO INFORMADOS.BI_tipo_descuento(tipo_descuento) values ('ENVIO GRATIS')
	INSERT INTO INFORMADOS.BI_tipo_descuento(tipo_descuento) values ('MEDIO DE PAGO')
	INSERT INTO INFORMADOS.BI_tipo_descuento(tipo_descuento) values ('CUPON')
    INSERT INTO INFORMADOS.BI_tipo_descuento(tipo_descuento) values ('ESPECIAL')
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_medio_pago_venta')
	DROP PROCEDURE sp_migrar_bi_medio_pago_venta
GO

CREATE PROCEDURE sp_migrar_bi_medio_pago_venta
AS
BEGIN
	PRINT 'Migracion de BI medio de pago venta'
	INSERT INTO INFORMADOS.BI_medio_pago_venta
	SELECT * FROM INFORMADOS.medio_pago_venta
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_envio')
	DROP PROCEDURE sp_migrar_bi_tipo_envio
GO

CREATE PROCEDURE sp_migrar_bi_tipo_envio
AS
BEGIN
	PRINT 'Migracion de BI tipos de envio'
    INSERT INTO INFORMADOS.BI_tipo_envio
	SELECT * FROM INFORMADOS.metodo_envio
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
	SELECT * FROM INFORMADOS.provincia
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos tablas de hechos --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_compra')
	DROP PROCEDURE sp_migrar_fact_compra
GO

CREATE PROCEDURE sp_migrar_fact_compra
AS
BEGIN
	PRINT 'Migracion de BI Hechos Compra'
    INSERT INTO INFORMADOS.BI_fact_compra(id_tiempo, id_producto, id_proveedor, cantidad, precio_unidad, costo_total) 
    SELECT INFORMADOS.get_tiempo(fecha), vp.id_producto, id_proveedor, SUM(cantidad), precio_unidad, SUM(cantidad * precio_unidad)
    FROM INFORMADOS.compra c
	JOIN INFORMADOS.producto_por_compra ppc ON ppc.id_compra = c.id_compra
	JOIN INFORMADOS.variante_producto vp ON vp.id_variante_producto = ppc.id_variante_producto
    GROUP BY INFORMADOS.get_tiempo(fecha), vp.id_producto, c.id_proveedor, precio_unidad
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_envio')
	DROP PROCEDURE sp_migrar_fact_envio
GO

CREATE PROCEDURE sp_migrar_fact_envio
AS
BEGIN
	PRINT 'Migracion de BI Hechos Envio'
    INSERT INTO INFORMADOS.BI_fact_envio(id_tiempo, id_provincia, id_tipo_envio, cantidad_envios, costo_total) 
    SELECT DISTINCT INFORMADOS.get_tiempo(v.fecha), z.id_provincia, e.id_metodo_envio, COUNT(*), SUM(e.precio)
    FROM INFORMADOS.venta v
	INNER JOIN INFORMADOS.envio e ON v.id_envio = e.id_envio
	INNER JOIN INFORMADOS.zona z ON e.id_zona = z.id_zona
    GROUP BY v.id_envio, INFORMADOS.get_tiempo(v.fecha), z.id_provincia, e.id_metodo_envio
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_venta')
	DROP PROCEDURE sp_migrar_fact_venta
GO

CREATE PROCEDURE sp_migrar_fact_venta
AS
BEGIN
	PRINT 'Migracion de BI fact venta'
	INSERT INTO INFORMADOS.BI_fact_venta(id_canal_venta, id_medio_pago_venta, id_tiempo,
		id_rango_etario, id_producto, precio_total, cantidad_productos, cantidad_ventas)
	SELECT DISTINCT ve.id_canal, ve.id_medio_pago_venta, INFORMADOS.get_tiempo(ve.fecha),
		INFORMADOS.get_rango_etario(c.fecha_nacimiento), vp.id_producto, SUM(ppv.cantidad * ppv.precio_unidad),
		SUM(ppv.cantidad), COUNT(ve.id_venta)
	FROM INFORMADOS.venta ve
	JOIN INFORMADOS.cliente c ON ve.id_cliente = c.id_cliente
	JOIN INFORMADOS.producto_por_venta ppv ON ve.id_venta = ppv.id_venta
	JOIN INFORMADOS.variante_producto vp ON ppv.id_variante_producto = vp.id_variante_producto
	GROUP BY ve.id_canal, ve.id_medio_pago_venta, INFORMADOS.get_tiempo(ve.fecha), INFORMADOS.get_rango_etario(c.fecha_nacimiento), vp.id_producto
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_descuento')
	DROP PROCEDURE sp_migrar_fact_descuento
GO

CREATE PROCEDURE sp_migrar_fact_descuento
AS
BEGIN
	PRINT 'Migracion de BI Hecho descuento'
    INSERT INTO INFORMADOS.BI_fact_descuento(id_tiempo, id_tipo_descuento_venta, id_canal, id_medio_pago_venta, importe_total_descuento)
	SELECT DISTINCT INFORMADOS.get_tiempo(v.fecha),
		(SELECT td.id_tipo_descuento FROM INFORMADOS.BI_tipo_descuento td WHERE td.tipo_descuento = mpv.nombre),
		v.id_canal,
		v.id_medio_pago_venta,
		(SUM(ppv.precio_unidad * ppv.cantidad) * (mpv.porcentaje_descuento))
	FROM INFORMADOS.venta v
	INNER JOIN INFORMADOS.medio_pago_venta mpv ON v.id_medio_pago_venta = mpv.id_medio_pago_venta
    INNER JOIN INFORMADOS.producto_por_venta ppv ON v.id_venta = ppv.id_venta
	WHERE mpv.porcentaje_descuento IS NOT NULL
    GROUP BY INFORMADOS.get_tiempo(v.fecha), v.id_canal, v.id_medio_pago_venta, mpv.nombre, mpv.porcentaje_descuento
	UNION
	SELECT DISTINCT INFORMADOS.get_tiempo(v.fecha),
		(SELECT td.id_tipo_descuento FROM INFORMADOS.BI_tipo_descuento td WHERE td.tipo_descuento = 'CUPON'),
		v.id_canal,
		v.id_medio_pago_venta,
		SUM(cpv.importe_cupon)
	FROM INFORMADOS.venta v
	INNER JOIN INFORMADOS.medio_pago_venta mpv ON v.id_medio_pago_venta = mpv.id_medio_pago_venta
    INNER JOIN INFORMADOS.cupon_por_venta cpv ON v.id_venta = cpv.id_venta
	WHERE cpv.importe_cupon IS NOT NULL
    GROUP BY INFORMADOS.get_tiempo(v.fecha), v.id_canal, v.id_medio_pago_venta
	UNION
	SELECT DISTINCT INFORMADOS.get_tiempo(v.fecha),
		(SELECT td.id_tipo_descuento FROM INFORMADOS.BI_tipo_descuento td WHERE td.tipo_descuento = 'ESPECIAL'),
		v.id_canal,
		v.id_medio_pago_venta,
		SUM(dv.importe_descuento)
	FROM INFORMADOS.venta v
	INNER JOIN INFORMADOS.medio_pago_venta mpv ON v.id_medio_pago_venta = mpv.id_medio_pago_venta
    INNER JOIN INFORMADOS.descuento_venta dv ON v.id_venta = dv.id_venta
	WHERE dv.importe_descuento IS NOT NULL
    GROUP BY INFORMADOS.get_tiempo(v.fecha), v.id_canal, v.id_medio_pago_venta
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VISTA 1: Las ganancias mensuales de cada canal de venta.
-- Se entiende por ganancias al total de las ventas, menos el total de las 
-- compras, menos los costos de transacción totales aplicados asociados los 
-- medios de pagos utilizados en las mismas.
-- columnas: canal de venta, año, mes, ganancias

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_ganancia_mensual_canal')
	DROP VIEW INFORMADOS.vw_ganancia_mensual_canal
GO

CREATE VIEW INFORMADOS.vw_ganancia_mensual_canal
AS
	SELECT  ti.año [Año], ti.mes [Mes], cv.nombre_canal [Canal de Venta],
		SUM(vt.precio_total) - SUM(mp.costo_medio_pago) - (SELECT SUM(fc.costo_total) FROM INFORMADOS.BI_fact_compra fc WHERE fc.id_tiempo = ti.id_tiempo) [Ganancias]
	FROM INFORMADOS.BI_tiempo ti
	JOIN INFORMADOS.BI_fact_venta vt ON vt.id_tiempo = ti.id_tiempo
	JOIN INFORMADOS.BI_canal_venta cv ON vt.id_canal_venta = cv.id_canal_venta
	JOIN INFORMADOS.BI_medio_pago_venta mp ON vt.id_medio_pago_venta = mp.id_medio_pago_venta
	GROUP BY ti.id_tiempo, ti.año, ti.mes, cv.nombre_canal
GO

-- VISTA 2: Los 5 productos con mayor rentabilidad anual, con sus respectivos %.
-- Se entiende por rentabilidad a los ingresos generados por el producto 
-- (ventas) durante el periodo menos la inversión realizada en el producto 
-- (compras) durante el periodo, todo esto sobre dichos ingresos.
-- Valor expresado en porcentaje.
-- Para simplificar, no es necesario tener en cuenta los descuentos aplicados.
-- columnas: producto, porcentaje

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_mayor_rentabilidad_anual')
	DROP VIEW INFORMADOS.vw_mayor_rentabilidad_anual
GO

CREATE VIEW INFORMADOS.vw_mayor_rentabilidad_anual
AS
	SELECT TOP 5 vp.id_producto [Codigo Producto],
		(1 - sum(fc.costo_total) / sum(vp.precio_total)) * 100 [Porcentaje Rentabilidad]
	FROM INFORMADOS.BI_fact_venta vp
	LEFT JOIN INFORMADOS.BI_tiempo ti ON vp.id_tiempo = ti.id_tiempo
	LEFT JOIN INFORMADOS.BI_fact_compra fc ON fc.id_producto = vp.id_producto AND fc.id_tiempo = ti.id_tiempo
	WHERE cast(concat(ti.año, '-', ti.mes, '-', '01') as date) between Dateadd(month, -12, Getdate()) and Getdate()
	GROUP BY vp.id_producto
	ORDER BY [Porcentaje Rentabilidad] DESC
GO

-- VISTA 3: Las 5 categorías de productos más vendidos por rango etario de clientes por mes. 
-- columnas: rango_etareo, año, mes, categoria_nombre

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_categorias_por_rango_etarios')
	DROP VIEW INFORMADOS.vw_categorias_por_rango_etarios
GO

CREATE VIEW INFORMADOS.vw_categorias_por_rango_etarios
AS
	SELECT ra.rango_etario [Rango Etario], ti.año [Año], ti.mes [Mes], ca.nombre_categoria [Categoria]
	FROM INFORMADOS.BI_tiempo ti CROSS JOIN INFORMADOS.BI_rango_etario ra
	LEFT JOIN INFORMADOS.BI_fact_venta vp ON ra.id_rango_etario = vp.id_rango_etario AND ti.id_tiempo = vp.id_tiempo
	LEFt JOIN INFORMADOS.BI_producto pr ON pr.id_producto = vp.id_producto
	LEFT JOIN INFORMADOS.BI_categoria_producto ca ON ca.id_categoria = pr.id_categoria
	GROUP BY ti.mes, ti.año, ra.rango_etario, ca.nombre_categoria
	HAVING (ca.nombre_categoria) IN 
		(SELECT TOP 5 ca.nombre_categoria
		FROM INFORMADOS.BI_fact_venta fact
		ORDER BY sum(vp.cantidad_productos) DESC)
GO

--VISTA 4: Total de Ingresos por cada medio de pago por mes, descontando los costos
--por medio de pago (en caso que aplique) y descuentos por medio de pago
--(en caso que aplique).

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_total_ingresos_por_medio_pago_x_mes_aplicando_descuentos')
	DROP VIEW INFORMADOS.vw_total_ingresos_por_medio_pago_x_mes_aplicando_descuentos
GO

CREATE VIEW INFORMADOS.vw_total_ingresos_por_medio_pago_x_mes_aplicando_descuentos
AS
	SELECT t.año [Año], t.mes [Mes], hv.id_medio_pago_venta [Medio Pago],
	SUM(precio_total) - SUM(mpv.costo_medio_pago)
	- (SELECT SUM(hd.importe_total_descuento)
		FROM INFORMADOS.BI_fact_descuento hd
		WHERE hv.id_medio_pago_venta = hd.id_medio_pago_venta and hv.id_tiempo = hd.id_tiempo) [Total de Ingresos]
	FROM INFORMADOS.BI_fact_venta hv
	INNER JOIN INFORMADOS.BI_medio_pago_venta mpv ON hv.id_medio_pago_venta = mpv.id_medio_pago_venta
	INNER JOIN INFORMADOS.BI_tiempo t ON hv.id_tiempo = t.id_tiempo
	GROUP BY t.año, t.mes, hv.id_medio_pago_venta, hv.id_tiempo
GO

--VISTA 5: Importe total en descuentos aplicados según su tipo de descuento, por
--canal de venta, por mes. Se entiende por tipo de descuento como los
--correspondientes a envío, medio de pago, cupones, etc). 

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_importe_total_en_descuentos_aplicados_segun_tipo_descuento')
	DROP VIEW INFORMADOS.vw_importe_total_en_descuentos_aplicados_segun_tipo_descuento
GO

CREATE VIEW INFORMADOS.vw_importe_total_en_descuentos_aplicados_segun_tipo_descuento
AS
    SELECT t.año [Año],
		t.mes [Mes],
		cv.nombre_canal [Canal de Venta],
		td.tipo_descuento [Tipo descuento],
		SUM(hd.importe_total_descuento) [Importe total descuentos]
	FROM INFORMADOS.BI_fact_descuento hd
    INNER JOIN INFORMADOS.BI_tiempo t ON hd.id_tiempo = t.id_tiempo
	INNER JOIN INFORMADOS.BI_canal_venta cv ON hd.id_canal = cv.id_canal_venta
	INNER JOIN INFORMADOS.BI_tipo_descuento td ON td.id_tipo_descuento = hd.id_tipo_descuento_venta
    GROUP BY t.año, t.mes, cv.nombre_canal, td.tipo_descuento
GO

-- VISTA 6: Porcentaje de envíos realizados a cada Provincia por mes.
-- El porcentaje debe representar la cantidad de envíos realizados a cada provincia sobre 
-- total de envío mensuales.
-- columnas: provincia, año, mes, porcentaje

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_envios_a_provincia_por_mes')
	DROP VIEW INFORMADOS.vw_envios_a_provincia_por_mes
GO

CREATE VIEW INFORMADOS.vw_envios_a_provincia_por_mes
AS
	select pr.nombre [Provincia], ti.mes [Mes],
		ROUND(CAST(COUNT(te.nombre) AS FLOAT) / (
			SELECT count(te2.nombre)
			FROM INFORMADOS.BI_fact_envio vt2
			JOIN INFORMADOS.BI_tipo_envio te2 ON te2.id_tipo_envio = vt2.id_tipo_envio
			WHERE  ti.id_tiempo = vt2.id_tiempo
		) * 100,2) [Porcentaje]
	FROM INFORMADOS.BI_provincia pr
	JOIN INFORMADOS.BI_fact_envio fe ON fe.id_provincia = pr.id_provincia
	JOIN INFORMADOS.BI_tiempo ti ON ti.id_tiempo = fe.id_tiempo
	JOIN INFORMADOS.BI_tipo_envio te ON te.id_tipo_envio = fe.id_tipo_envio
	GROUP BY ti.mes, pr.nombre, ti.id_tiempo
GO

-- VISTA 7: Valor promedio de envío por Provincia por Medio De Envío anual.
-- columnas: provincia, medio_envio, año, valor

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_valor_promedio_envio_x_provincia_x_medio_envio_anual')
	DROP VIEW INFORMADOS.vw_valor_promedio_envio_x_provincia_x_medio_envio_anual
GO

CREATE VIEW INFORMADOS.vw_valor_promedio_envio_x_provincia_x_medio_envio_anual
AS
    SELECT t.año AS [Año],
		p.nombre AS [Provincia],
		te.nombre AS [Tipo de envio],
		AVG(he.costo_total) as [Promedio Envios]
    FROM INFORMADOS.BI_fact_envio he
	INNER JOIN INFORMADOS.BI_tiempo t ON he.id_tiempo = t.id_tiempo
    INNER JOIN INFORMADOS.BI_provincia p ON he.id_provincia = p.id_provincia
    INNER JOIN INFORMADOS.BI_tipo_envio te ON he.id_tipo_envio = te.id_tipo_envio
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
	SELECT t.año [Año],
		hc.id_proveedor [Proveedor],
		AVG(INFORMADOS.get_aumento(t.año, hc.id_proveedor, hc.id_producto)) [Aumento promedio de precios]
    FROM INFORMADOS.BI_fact_compra hc
	INNER JOIN INFORMADOS.BI_tiempo t ON hc.id_tiempo = t.id_tiempo
    GROUP BY t.año, hc.id_proveedor
GO

-- VISTA 9: Los 3 productos con mayor cantidad de reposición por mes.
-- columnas: año, mes, codigo_prod1, nombre_prod2, codigo_prod2, nombre_prod2, codigo_prod3, nombre_prod3

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_tres_productos_mayor_cantidad_reposicion_x_mes')
	DROP VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes
GO

CREATE VIEW INFORMADOS.vw_tres_productos_mayor_cantidad_reposicion_x_mes
AS
	SELECT distinct dt.año [Año],
	dt.mes [Mes]
	,	(
		SELECT  hc1.id_producto 
		FROM INFORMADOS.BI_fact_compra hc1
		WHERE hc1.id_tiempo = dt.id_tiempo
		GROUP BY hc1.id_producto
		ORDER BY SUM(hc1.cantidad) DESC
		OFFSET 0 ROWS 
		FETCH NEXT 1 ROWS ONLY 
	) AS id_producto_1
	,	(
		SELECT  hc2.id_producto
		FROM INFORMADOS.BI_fact_compra hc2
		WHERE hc2.id_tiempo = dt.id_tiempo
		GROUP BY hc2.id_producto
		ORDER BY SUM(hc2.cantidad) DESC
		OFFSET 1 ROWS  
		FETCH NEXT 1 ROWS ONLY 
	) AS id_producto_2
	,	(
		SELECT hc3.id_producto 
		FROM INFORMADOS.BI_fact_compra hc3
		WHERE hc3.id_tiempo = dt.id_tiempo
		GROUP BY hc3.id_producto
		ORDER BY SUM(hc3.cantidad) DESC
		OFFSET 2 ROWS 
		FETCH NEXT 1 ROWS ONLY 
	) AS id_producto_3
FROM INFORMADOS.BI_tiempo dt
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EJECUCION DE LOS PROCEDIMIENTOS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN TRANSACTION
BEGIN TRY
    EXECUTE sp_migrar_bi_tiempos
	EXECUTE sp_migrar_bi_categoria_producto
	EXECUTE sp_migrar_bi_producto
	EXECUTE sp_migrar_bi_rango_etario
	EXECUTE sp_migrar_bi_canal_venta
	EXECUTE sp_migrar_bi_tipo_descuento
	EXECUTE sp_migrar_bi_medio_pago_venta
	EXECUTE sp_migrar_bi_tipo_envio
	EXECUTE sp_migrar_bi_provincia
	EXECUTE sp_migrar_fact_compra
	EXECUTE sp_migrar_fact_envio
	EXECUTE sp_migrar_fact_venta
	EXECUTE sp_migrar_fact_descuento
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM INFORMADOS.BI_canal_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_categoria_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_rango_etario)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_medio_pago_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_provincia)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tiempo)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_descuento)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_venta)
    AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_descuento)
	)

   BEGIN
	PRINT 'Tablas migradas correctamente.';
	COMMIT TRANSACTION;
   END
	 ELSE
   BEGIN
    ROLLBACK TRANSACTION;
	THROW 50002, 'Se encontraron errores al migrar las tablas. No se migraron datos.',1;
   END
GO