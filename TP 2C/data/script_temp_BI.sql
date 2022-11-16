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
CREATE TABLE INFORMADOS.BI_ventas_realizadas(
id_venta bigint,
id_cliente int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_ventas_realizadas')
	DROP PROCEDURE sp_migrar_bi_ventas_realizadas

GO

CREATE PROCEDURE sp_migrar_bi_ventas_realizadas
AS
BEGIN
	PRINT 'Migracion de BI ventas realizadas'
	INSERT INTO INFORMADOS.BI_ventas_realizadas(id_venta,id_cliente,id_producto,id_variante_producto,cantidad,precio_total_producto)
	SELECT ve.id_venta,ve.id_cliente,vp.id_producto,vp.id_variante_producto,pv.cantidad,(pv.cantidad*precio_unidad) as precio_total_producto
	FROM INFORMADOS.venta ve
	LEFT JOIN INFORMADOS.producto_por_venta pv
	ON ve.id_venta=pv.id_venta
	LEFT JOIN INFORMADOS.variante_producto vp
	ON pv.id_variante_producto=vp.id_variante_producto

END

GO

--Esta tabla va a tener las compras realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_compras_realizadas(
id_compra int,
id_producto varchar(255),
id_variante_producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_bi_compras_realizadas')
	DROP PROCEDURE sp_migrar_bi_compras_realizadas

GO

CREATE PROCEDURE sp_migrar_bi_compras_realizadas
AS
BEGIN
	PRINT 'Migracion de BI compras realizadas'
	INSERT INTO INFORMADOS.BI_compras_realizadas(id_compra,id_producto,id_variante_producto,cantidad,precio_total_producto)
	SELECT cr.id_compra,vp.id_producto,vp.id_variante_producto,pc.cantidad,(pc.cantidad*pc.precio_unidad) as precio_total_producto
	FROM INFORMADOS.compra cr
	LEFT JOIN INFORMADOS.producto_por_compra pc
	ON cr.id_compra=pc.id_compra
	LEFT JOIN INFORMADOS.variante_producto vp
	ON pc.id_variante_producto=vp.id_variante_producto

END

GO

--Esta tabla va a tener las ventas relacionadas directamente con el canal por el cual se vendio y el precio total de esa venta.
CREATE TABLE INFORMADOS.BI_canal_venta(
id_venta bigint,
canal varchar(255),
precio_total_venta decimal(18,2)
);

--Esta tabla va a tener aquellas ventas con su medio de pago y costo de transaccion
CREATE TABLE INFORMADOS.BI_medio_pago_venta(
id_venta int,
medio_pago varchar(255),
costo decimal(18,2)
);

/*
Hasta acá estas tablas se usarian para realizar la primer Vista solicitada, y a su vez vienen a ser algunas dimensiones MINIMAS
solicitadas en la consigna
*/

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



