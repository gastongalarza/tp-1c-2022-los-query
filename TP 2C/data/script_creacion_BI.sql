USE GD2C2022

--Dropeo tablas de hechos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_descuento')
	DROP TABLE INFORMADOS.BI_fact_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_venta')
	DROP TABLE INFORMADOS.BI_fact_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_envio')
	DROP TABLE INFORMADOS.BI_fact_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_compra')
	DROP TABLE INFORMADOS.BI_fact_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_proveedor')
	DROP TABLE INFORMADOS.BI_fact_proveedor

--Dropeo Tablas dimensionales

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_provincia')
	DROP TABLE INFORMADOS.BI_provincia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_envio')
	DROP TABLE INFORMADOS.BI_tipo_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_venta')
	DROP TABLE INFORMADOS.BI_medio_pago_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_descuento')
	DROP TABLE INFORMADOS.BI_tipo_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_canal_venta')
	DROP TABLE INFORMADOS.BI_canal_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_rango_etario')
	DROP TABLE INFORMADOS.BI_rango_etario

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_productos')
	DROP TABLE INFORMADOS.BI_productos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_categoria_producto')
	DROP TABLE INFORMADOS.BI_categoria_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo')
	DROP TABLE INFORMADOS.BI_tiempo

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
id_tipo_descuento int PRIMARY KEY,
concepto_descuento nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_medio_pago_venta int PRIMARY KEY,
nombre_medio_pago varchar(255),
costo_medio_pago decimal(18,2)
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

CREATE TABLE INFORMADOS.BI_fact_proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
razon_social nvarchar(255),
domicilio nvarchar(255),
mail nvarchar(255)
);

CREATE TABLE INFORMADOS.BI_fact_compra(
id_tiempo int REFERENCES INFORMADOS.BI_tiempo(id_tiempo),
id_producto nvarchar(50) REFERENCES INFORMADOS.BI_producto(id_producto),
id_proveedor nvarchar(50) REFERENCES INFORMADOS.BI_fact_proveedor(id_proveedor),
cantidad int,
precio_unidad decimal(18, 2),
costo_total decimal(18, 2),
PRIMARY KEY (id_tiempo, id_producto, id_proveedor)
);

CREATE TABLE INFORMADOS.BI_fact_envio (
id_fact_envio int IDENTITY(1,1) PRIMARY KEY,
id_envio int,
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
id_descuento int PRIMARY KEY, --podria no existir y usar el idventa y tipo descuento
id_venta int REFERENCES INFORMADOS.BI_fact_venta(id_venta),
id_tipo_descuento_venta int REFERENCES INFORMADOS.BI_tipo_descuento(id_tipo_descuento),
importe_descuento decimal(18,2)
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
	RETURN (SELECT (max(precio_unidad)-min(precio_unidad)) / min(precio_unidad)
	 FROM INFORMADOS.BI_fact_compra hc
	 INNER JOIN INFORMADOS.BI_tiempo t
	 ON hc.id_tiempo = t.id_tiempo
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
    INSERT INTO INFORMADOS.BI_tipo_descuento(id_tipo_descuento, concepto_descuento)
	SELECT * FROM INFORMADOS.tipo_descuento_venta
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
-- Creacion de procedimientos tablas de hechos--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_proveedor')
	DROP PROCEDURE sp_migrar_bi_proveedor
GO

CREATE PROCEDURE sp_migrar_bi_proveedor
AS
BEGIN
	PRINT 'Migracion de BI proveedor'
    INSERT INTO INFORMADOS.BI_proveedor
	SELECT DISTINCT * FROM INFORMADOS.proveedor
END
GO

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
    GROUP BY INFORMADOS.get_tiempo(fecha), vp.id_producto, id_proveedor, precio_unidad
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_envio')
	DROP PROCEDURE sp_migrar_fact_envio
GO

CREATE PROCEDURE sp_migrar_fact_envio
AS
BEGIN
	PRINT 'Migracion de BI Hechos Envio'
    INSERT INTO INFORMADOS.BI_fact_envio(id_envio,id_tiempo, id_provincia, id_tipo_envio, cantidad_envios, costo_total) 
    SELECT DISTINCT v.id_envio, INFORMADOS.get_tiempo(v.fecha), z.id_provincia, e.id_metodo_envio, COUNT(*), SUM(e.precio)
    FROM INFORMADOS.venta v
	INNER JOIN INFORMADOS.envio e ON v.id_envio = e.id_envio
	INNER JOIN INFORMADOS.zona z ON e.id_zona = z.id_zona
    GROUP BY v.id_envio, INFORMADOS.get_tiempo(v.fecha), z.id_provincia, e.id_metodo_envio
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_fact_venta')
	DROP PROCEDURE sp_migrar_bi_fact_venta
GO

CREATE PROCEDURE sp_migrar_bi_fact_venta
AS
BEGIN
	PRINT 'Migracion de BI fact venta'
	INSERT INTO INFORMADOS.BI_fact_venta(id_canal_venta, id_medio_pago_venta, id_tiempo,
		id_rango_etario, id_producto, precio_total, cantidad_productos, cantidad_ventas)
	SELECT DISTINCT ve.id_canal, ve.id_medio_pago_venta, INFORMADOS.get_tiempo(ve.fecha),
		INFORMADOS.get_rango_etario(c.fecha_nacimiento), vp.id_producto, SUM(ppv.cantidad) * COUNT(ve.id_venta),
		SUM(ppv.cantidad), COUNT(ve.id_venta)
	FROM INFORMADOS.venta ve
	JOIN INFORMADOS.cliente c ON ve.id_cliente = c.id_cliente
	JOIN INFORMADOS.producto_por_venta ppv ON ve.id_venta = ppv.id_venta
	JOIN INFORMADOS.variante_producto vp ON ppv.id_variante_producto = vp.id_variante_producto
	GROUP BY ve.id_canal, ve.id_medio_pago_venta, INFORMADOS.get_tiempo(ve.fecha), INFORMADOS.get_rango_etario(c.fecha_nacimiento), vp.id_producto
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_descuento_venta')
	DROP PROCEDURE sp_migrar_bi_descuento_venta
GO

--no se me ocurre como migrarlo que no sea otra manera que haciendo un cursor por cada venta que se agrega en fact_venta y agregando todos los descuentos
--de esa venta a la tabla esta
CREATE PROCEDURE sp_migrar_bi_descuento_venta
AS
BEGIN
	PRINT 'Migracion de BI descuento de venta'
    INSERT INTO INFORMADOS.BI_descuento_venta(id_descuento_venta, id_tipo_descuento_venta, id_venta, importe_descuento)
	SELECT * FROM INFORMADOS.descuento_venta
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



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
	EXECUTE sp_migrar_bi_proveedor
	EXECUTE sp_migrar_fact_compra
	EXECUTE sp_migrar_fact_envio
	EXECUTE sp_migrar_bi_fact_venta
	EXECUTE sp_migrar_bi_descuento_venta
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
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_descuento)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_proveedor)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_venta)
    AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_fact_envio)
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
