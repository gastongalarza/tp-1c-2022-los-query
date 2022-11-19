USE GD2C2022
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_venta')
	DROP TABLE LOS_QUERY.BI_tiempo_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_compra')
	DROP TABLE LOS_QUERY.BI_tiempo_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_ventas_x_productos')
	DROP TABLE LOS_QUERY.BI_ventas_x_productos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_canal_venta')
	DROP TABLE LOS_QUERY..BI_canal_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_venta_total')
	DROP TABLE LOS_QUERY.BI_venta_total

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_venta')
	DROP TABLE LOS_QUERY.BI_medio_pago_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_medio_pago_compra')
	DROP TABLE LOS_QUERY.BI_medio_pago_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_compras_x_producto')
	DROP TABLE LOS_QUERY.BI_compras_x_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_compra_total')
	DROP TABLE LOS_QUERY.BI_compra_total

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_productos')
	DROP TABLE LOS_QUERY.BI_productos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_categoria_producto')
	DROP TABLE LOS_QUERY.BI_categoria_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_clientes')
	DROP TABLE LOS_QUERY.BI_clientes

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_rango_etario_cliente')
	DROP TABLE LOS_QUERY.BI_rango_etario_cliente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_provincia')
	DROP TABLE LOS_QUERY.BI_provincia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_descuento')
	DROP TABLE LOS_QUERY.BI_tipo_descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tipo_envio')
	DROP TABLE LOS_QUERY.BI_tipo_envio

--Esta table va a mostrar cada compra con el a�o y mes en el que se realiz�.
CREATE TABLE INFORMADOS.BI_tiempo_compra(
id_compra int,
a�o int,
mes int
);

--Esta table va a mostrar cada venta con el a�o y mes en el que se realiz�.
CREATE TABLE INFORMADOS.BI_tiempo_venta(
id_venta bigint,
a�o int,
mes int
);

--Esta tabla va a tener las ventas realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_ventas_x_productos(
id_venta bigint,
id_cliente int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

--Esta tabla va a tener exactamente la info de canal_venta del transaccional
CREATE TABLE INFORMADOS.BI_canal_venta(
id_canal_venta int,
nombre_canal varchar(255),
costo_canal decimal(18,2)
);

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_venta_total(
id_venta int,
id_canal_venta int,
id_medio_pago_venta int,
precio_total_venta decimal(18,2)
);

--Esta tabla va a tener la misma info que la tabla medio pago venta del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_medio_pago_venta int,
nombre_medio_pago varchar(255),
costo_medio_pago decimal(18,2)
);

--Esta tabla va a tener la misma info que la tabla medio pago compra del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_compra(
id_medio_pago_compra int,
nombre_medio_pago varchar(255)
);

--Esta tabla va a tener las compras realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_compras_x_producto(
id_compra int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
costo_total_producto decimal(18,2)
);

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_compra_total(
id_compra int,
id_medio_pago_compra int,
costo_total_compra decimal(18,2)
);

--Idem tabla INFORMADOS.productos por requisisto minimo
CREATE TABLE INFORMADOS.BI_productos
(
id_producto varchar(255),
id_categoria int,
nombre_producto varchar(255),
descripcion_producto varchar(255),
material_producto varchar(255),
marca_producto varchar(255)
);

--Idem INFORMADOS.categoria_producto por requi minimo
CREATE TABLE INFORMADOS.BI_categoria_producto
(
id_categoria int,
nombre_categoria varchar(255)
);

--Idem tabla INFORMADOS.clientes por si fuera necesaria
CREATE TABLE INFORMADOS.BI_clientes
(
id_cliente int,
id_zona int,
dni_cliente bigint,
nombre_cliente varchar(255),
apellido_cliente varchar(255),
direccion_cliente varchar(255),
telefono_cliente varchar(255),
mail_cliente varchar(255),
fecha_nacimiento date
);

--Tabla minima de RANGO ETARIO CLIENTE
CREATE TABLE INFORMADOS.BI_rango_etario_cliente
(
id_cliente int,
rango_etario varchar(5)
);

CREATE TABLE INFORMADOS.BI_provincia
(
codigo_provincia int IDENTITY PRIMARY KEY,
nombre nvarchar(255)
);


CREATE TABLE INFORMADOS.BI_tipo_descuento
(
id_tipo_descuento_venta int IDENTITY(1,1) PRIMARY KEY,
concepto_descuento nvarchar(255)
);

--Tabla minima de RANGO ETARIO CLIENTE
CREATE TABLE INFORMADOS.BI_tipo_envio
(
id_metodo_envio int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas de hechos para el armado de las vistas --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos tablas dimensionales--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tiempos')
	DROP PROCEDURE sp_migrar_bi_tiempos

GO

CREATE PROCEDURE sp_migrar_bi_tiempos
AS
BEGIN
	PRINT 'Migracion de BI tiempo de compra'
	INSERT INTO INFORMADOS.BI_tiempo_compra(id_compra,a�o,mes)
	SELECT id_compra,YEAR(fecha),MONTH(fecha)
	FROM INFORMADOS.compra  

	PRINT 'Migracion de BI tiempo de venta'
	INSERT INTO INFORMADOS.BI_tiempo_venta(id_venta,a�o,mes)
	SELECT id_venta,YEAR(fecha),MONTH(fecha)
	FROM INFORMADOS.venta  

END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_ventas_x_productos')
	DROP PROCEDURE sp_migrar_bi_ventas_x_productos

GO

CREATE PROCEDURE sp_migrar_bi_ventas_x_productos
AS
BEGIN
	PRINT 'Migracion de BI ventas realizadas'
	INSERT INTO INFORMADOS.BI_ventas_x_productos(id_venta,id_cliente,id_producto,id_variante_producto,cantidad,precio_total_producto)
	SELECT ve.id_venta,ve.id_cliente,vp.id_producto,vp.id_variante_producto,pv.cantidad,(pv.cantidad*precio_unidad) as precio_total_producto
	FROM INFORMADOS.venta ve
	LEFT JOIN INFORMADOS.producto_por_venta pv
	ON ve.id_venta=pv.id_venta
	LEFT JOIN INFORMADOS.variante_producto vp
	ON pv.id_variante_producto=vp.id_variante_producto

END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_canal_venta')
	DROP PROCEDURE sp_migrar_bi_canal_venta

GO

CREATE PROCEDURE sp_migrar_bi_canal_venta
AS
BEGIN
	PRINT 'Migracion de BI canal venta'
	INSERT INTO INFORMADOS.BI_canal_venta(id_canal_venta,nombre_canal,costo_canal)
	SELECT id_canal_venta,nombre,costo
	FROM INFORMADOS.canal_venta
END

GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_venta_total')
	DROP PROCEDURE sp_migrar_bi_venta_total

GO

CREATE PROCEDURE sp_migrar_bi_venta_total
AS
BEGIN
	PRINT 'Migracion de BI venta total'
	INSERT INTO INFORMADOS.BI_venta_total(id_venta,id_canal_venta,id_medio_pago_venta,precio_total_venta)
	SELECT ve.id_venta,ve.id_canal,ve.id_medio_pago_venta,sum(vp.precio_total_producto)
	FROM INFORMADOS.venta ve
	LEFT JOIN INFORMADOS.BI_ventas_x_productos vp
	ON ve.id_venta = vp.id_venta
	GROUP BY ve.id_venta,ve.id_canal,ve.id_medio_pago_venta ORDER BY ve.id_venta asc
END

GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_medio_pago')
	DROP PROCEDURE sp_migrar_bi_medio_pago

GO

CREATE PROCEDURE sp_migrar_bi_medio_pago
AS
BEGIN
	
	PRINT 'Migracion de BI medio de pago venta'
	INSERT INTO INFORMADOS.BI_medio_pago_venta(id_medio_pago_venta,nombre_medio_pago,costo_medio_pago)
	SELECT *
	FROM INFORMADOS.medio_pago_venta

	PRINT 'Migracion de BI medio de pago compra'
	INSERT INTO INFORMADOS.BI_medio_pago_compra(id_medio_pago_compra,nombre_medio_pago)
	SELECT *
	FROM INFORMADOS.medio_pago_compra
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_compras_x_producto')
	DROP PROCEDURE sp_migrar_bi_compras_x_producto

GO

CREATE PROCEDURE sp_migrar_bi_compras_x_producto
AS
BEGIN
	PRINT 'Migracion de BI compras realizadas'
	INSERT INTO INFORMADOS.BI_compras_x_producto(id_compra,id_producto,id_variante_producto,cantidad,costo_total_producto)
	SELECT cr.id_compra,vp.id_producto,vp.id_variante_producto,pc.cantidad,(pc.cantidad*pc.precio_unidad) as precio_total_producto
	FROM INFORMADOS.compra cr
	LEFT JOIN INFORMADOS.producto_por_compra pc
	ON cr.id_compra=pc.id_compra
	LEFT JOIN INFORMADOS.variante_producto vp
	ON pc.id_variante_producto=vp.id_variante_producto

END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_compra_total')
	DROP PROCEDURE sp_migrar_bi_compra_total

GO

CREATE PROCEDURE sp_migrar_bi_compra_total
AS
BEGIN
	PRINT 'Migracion de BI compra total'
	INSERT INTO INFORMADOS.BI_compra_total(id_compra,id_medio_pago_compra,costo_total_compra)
	SELECT cr.id_compra,cr.id_medio_pago,sum(cp.costo_total_producto)
	FROM INFORMADOS.compra cr
	LEFT JOIN INFORMADOS.BI_compras_x_producto cp
	ON cr.id_compra = cp.id_compra
	GROUP BY cr.id_compra,cr.id_medio_pago ORDER BY cr.id_compra asc
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_productos')
	DROP PROCEDURE sp_migrar_bi_productos

GO

CREATE PROCEDURE sp_migrar_bi_productos
AS
BEGIN
	PRINT 'Migracion de BI productos'
	INSERT INTO INFORMADOS.BI_productos(id_producto,id_categoria,nombre_producto,descripcion_producto,material_producto,marca_producto)
	SELECT *
	FROM INFORMADOS.producto
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
	INSERT INTO INFORMADOS.BI_categoria_producto(id_categoria,nombre_categoria)
	SELECT *
	FROM INFORMADOS.categoria_producto
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_clientes')
	DROP PROCEDURE sp_migrar_bi_clientes

GO

CREATE PROCEDURE sp_migrar_bi_clientes
AS
BEGIN
	PRINT 'Migracion de BI Clientes'
	INSERT INTO INFORMADOS.BI_clientes(id_cliente,id_zona,dni_cliente,nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,mail_cliente,fecha_nacimiento)
	SELECT *
	FROM INFORMADOS.cliente where id_cliente = 6

	INSERT INTO INFORMADOS.BI_rango_etario_cliente(id_cliente,rango_etario)
	SELECT id_cliente,	CASE WHEN FLOOR(DATEDIFF(DAY, fecha_nacimiento, cast(cast(GETDATE() as varchar(50)) as date)) / 365.20) < 25
						THEN '<25' 
						WHEN FLOOR(DATEDIFF(DAY, fecha_nacimiento, cast(cast(GETDATE() as varchar(50)) as date)) / 365.20) BETWEEN 25 AND 35
						THEN '25-35'
						WHEN FLOOR(DATEDIFF(DAY, fecha_nacimiento, cast(cast(GETDATE() as varchar(50)) as date)) / 365.20) BETWEEN 36 AND 55
						THEN '35-55'
						ELSE '>55' END
	FROM INFORMADOS.cliente
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_provincia')
	DROP PROCEDURE sp_migrar_bi_provincia

GO

CREATE PROCEDURE sp_migrar_bi_provincia
AS
BEGIN
	PRINT 'Migracion de BI provincias'
	INSERT INTO INFORMADOS.BI_provincia(nombre)
	SELECT DISTINCT pro.nombre FROM INFORMADOS.provincia pro WHERE nombre IS NOT NULL
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_descuento')
	DROP PROCEDURE sp_migrar_bi_tipo_descuento
GO

CREATE PROCEDURE sp_migrar_bi_tipo_descuento
AS
BEGIN
	PRINT 'Migracion de BI tipos de descuento'
    INSERT INTO INFORMADOS.BI_tipo_descuento (concepto_descuento)
	SELECT DISTINCT concepto_descuento 
	FROM INFORMADOS.tipo_descuento_venta WHERE concepto_descuento IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tipo_envio')
	DROP PROCEDURE sp_migrar_bi_tipo_envio
GO

CREATE PROCEDURE sp_migrar_bi_tipo_envio
AS
BEGIN
	PRINT 'Migracion de BI tipos de envio'
    INSERT INTO INFORMADOS.BI_tipo_envio (nombre)
	SELECT DISTINCT nombre
	FROM INFORMADOS.metodo_envio WHERE nombre IS NOT NULL
END

GO

/*
Hasta ac� estas tablas se usarian para realizar la primer Vista solicitada, y a su vez vienen a ser algunas dimensiones MINIMAS
solicitadas en la consigna
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos tablas de hechos--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--1
IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_ganancia_mensual_canal')
	DROP VIEW vw_ganancia_mensual_canal

GO

CREATE VIEW vw_ganancia_mensual_canal
AS
SELECT 
tv.a�o,
tv.mes,
cv.nombre_canal,
(	SUM(vt.precio_total_venta)	-	(SELECT ROUND(SUM(ct.costo_total_compra)/4,2)
										FROM INFORMADOS.BI_compra_total ct
										JOIN INFORMADOS.BI_tiempo_compra tc
										ON ct.id_compra=tc.id_compra 
										WHERE tc.a�o=tv.a�o AND tc.mes=tv.mes))	- (ROUND(SUM(mp.costo_medio_pago),2)) AS ganancia
FROM INFORMADOS.BI_venta_total vt
LEFT JOIN INFORMADOS.BI_canal_venta cv
ON vt.id_canal_venta=cv.id_canal_venta
LEFT JOIN INFORMADOS.BI_medio_pago_venta mp
ON vt.id_medio_pago_venta=mp.id_medio_pago_venta
JOIN INFORMADOS.BI_tiempo_venta tv
ON vt.id_venta=tv.id_venta
GROUP BY tv.a�o,tv.mes,cv.nombre_canal

GO
/* 
Estas tablas se utilizar�n para la segunda Vista
*/


--2

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vw_mayor_rentabilidad_anual')
	DROP VIEW vw_mayor_rentabilidad_anual

GO

CREATE VIEW vw_mayor_rentabilidad_anual
AS
SELECT
TOP 5
vp.id_producto,
((sum(vp.precio_total_producto)	-	(SELECT
									sum(costo_total_producto)
									FROM INFORMADOS.BI_compras_x_producto cp
									LEFT JOIN INFORMADOS.BI_tiempo_compra tc
									ON cp.id_compra=tc.id_compra
									WHERE cast(concat(tc.a�o,'-',tc.mes,'-','01') as date) between Dateadd(month,-12,Getdate()) and Getdate() and cp.id_producto=vp.id_producto
									)) /	( SELECT sum(vp2.precio_total_producto) 
										FROM INFORMADOS.BI_ventas_x_productos vp2
										LEFT JOIN INFORMADOS.BI_tiempo_venta tv2
										ON vp2.id_venta=tv2.id_venta
										WHERE cast(concat(tv2.a�o,'-',tv2.mes,'-','01') as date) between Dateadd(month,-12,Getdate()) and Getdate() and vp2.id_producto=vp.id_producto
										))*100 AS porcentaje_rentabilidad
FROM INFORMADOS.BI_ventas_x_productos vp
LEFT JOIN INFORMADOS.BI_tiempo_venta tv
ON vp.id_venta=tv.id_venta
WHERE cast(concat(tv.a�o,'-',tv.mes,'-','01') as date) between Dateadd(month,-12,Getdate()) and Getdate()
GROUP BY vp.id_producto
ORDER BY porcentaje_rentabilidad desc

GO
-- La consigna dice 5 categorias mas vendidas, pero son solo 3 las categorias de productos.
/*
CREATE VIEW vw_categorias_vendidas_mensual
AS
SELECT 1 AS ASD

*/


---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

 BEGIN TRANSACTION
 BEGIN TRY
    EXECUTE sp_migrar_bi_canal_venta
	EXECUTE sp_migrar_bi_categoria_producto
	EXECUTE sp_migrar_bi_clientes
	EXECUTE sp_migrar_bi_compra_total
	EXECUTE sp_migrar_bi_compras_x_producto
	EXECUTE sp_migrar_bi_medio_pago
	EXECUTE sp_migrar_bi_productos
	EXECUTE sp_migrar_bi_provincia
	EXECUTE sp_migrar_bi_tiempos
	EXECUTE sp_migrar_bi_tipo_descuento
	EXECUTE sp_migrar_bi_tipo_envio
	EXECUTE sp_migrar_bi_venta_total
	EXECUTE sp_migrar_bi_ventas_x_productos
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM INFORMADOS.BI_canal_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_categoria_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_clientes)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_rango_etario_cliente)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_compra_total)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_compras_x_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_medio_pago_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_medio_pago_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_productos)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_provincia)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tiempo_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tiempo_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_descuento)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_tipo_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_venta_total)
	AND EXISTS (SELECT 1 FROM INFORMADOS.BI_ventas_x_productos)
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