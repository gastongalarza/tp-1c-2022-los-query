USE GD2C2022

--Esta table va a mostrar cada compra con el año y mes en el que se realizó.
CREATE TABLE INFORMADOS.BI_tiempo_compra(
id_compra int,
año int,
mes int
);

--Esta table va a mostrar cada venta con el año y mes en el que se realizó.
CREATE TABLE INFORMADOS.BI_tiempo_venta(
id_venta bigint,
año int,
mes int
);

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_tiempos')
	DROP PROCEDURE sp_migrar_bi_tiempos

GO

CREATE PROCEDURE sp_migrar_bi_tiempos
AS
BEGIN
	PRINT 'Migracion de BI tiempo de compra'
	INSERT INTO INFORMADOS.BI_tiempo_compra(id_compra,año,mes)
	SELECT id_compra,YEAR(fecha),MONTH(fecha)
	FROM INFORMADOS.compra  

	PRINT 'Migracion de BI tiempo de venta'
	INSERT INTO INFORMADOS.BI_tiempo_venta(id_venta,año,mes)
	SELECT id_venta,YEAR(fecha),MONTH(fecha)
	FROM INFORMADOS.venta  

END

GO

--Esta tabla va a tener las ventas realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_ventas_x_productos(
id_venta bigint,
id_cliente int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

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

--Esta tabla va a tener exactamente la info de canal_venta del transaccional
CREATE TABLE INFORMADOS.BI_canal_venta(
id_canal_venta int,
nombre_canal varchar(255),
costo_canal decimal(18,2)
);

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

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_venta_total(
id_venta int,
id_canal_venta int,
id_medio_pago_venta int,
precio_total_venta decimal(18,2)
);

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
--Esta tabla va a tener la misma info que la tabla medio pago venta del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_medio_pago_venta int,
nombre_medio_pago varchar(255),
costo_medio_pago decimal(18,2)
);
GO


--Esta tabla va a tener la misma info que la tabla medio pago compra del transaccional
CREATE TABLE INFORMADOS.BI_medio_pago_compra(
id_medio_pago_compra int,
nombre_medio_pago varchar(255)
);
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

--Esta tabla va a tener las compras realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_compras_x_producto(
id_compra int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
costo_total_producto decimal(18,2)
);

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

--Esta tabla va a tener las ventas relacionadas directamente con el canal y medio pago por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_compra_total(
id_compra int,
id_medio_pago_compra int,
costo_total_compra decimal(18,2)
);

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


/*
Hasta acá estas tablas se usarian para realizar la primer Vista solicitada, y a su vez vienen a ser algunas dimensiones MINIMAS
solicitadas en la consigna
*/

SELECT * FROM INFORMADOS.BI_compra_total ct
JOIN INFORMADOS.BI_tiempo_compra tc
ON ct.id_compra=tc.id_compra

SELECT * FROM INFORMADOS.BI_tiempo_venta



CREATE VIEW vw_ganancia_mensual_canal
AS
SELECT tv.año,tv.mes,(SELECT )
FROM INFORMADOS.BI_venta_total vt
LEFT JOIN INFORMADOS.BI_canal_venta cv
ON vt.id_canal_venta=cv.id_canal_venta
LEFT JOIN INFORMADOS.BI_medio_pago_venta mp
ON vt.id_medio_pago_venta=mp.id_medio_pago_venta
JOIN INFORMADOS.BI_tiempo_venta tv
ON vt.id_venta=tv.id_venta


------------------------------------------------------------------------


--Cantidad y monto vendido o comprado, por periodo de cada producto 
CREATE TABLE INFORMADOS.BI_productos_por_periodo(
id_producto int,
nombre_producto varchar(255),
movimiento varchar(6) , --Esta columna va a especificar si se trata de la Venta o Compra del producto
periodo varchar(10), --Periodo con formato 'yyyy-MM-dd' del producto 
cantidad_total int, --Cantidad total de compra o venta del producto
monto_total decimal(18,2) --Monto total gastado o ingresado del producto
);
/* 
Estas tablas se utilizarán para la segunda Vista, y además en la consigna pide como minimo una tabla 
de Producto, categoria de producto. La tabla BI_productos_por_periodo me parece util para tener una tabla donde se tenga registrado por mes los productos
vendidos y comprados con el monto ingresado o gastado. BI_productos_por_periodo servirá para hacer la segunda vista
*/

CREATE TABLE INFORMADOS.BI_productos
(
id_producto int,
nombre_producto varchar(255),
id_categoria int
);

CREATE TABLE INFORMADOS.BI_categoria_producto
(
id_categoria int,
nombre_categoria varchar(255)

);
/*
BI_categoria_producto, si bien la piden como requisito minimo en la consigna, no veo sentido q replique lo que está en el transaccional, pero se necesita 
para armar la 3era vista. Lo mismo que la tabla BI_productos
*/



