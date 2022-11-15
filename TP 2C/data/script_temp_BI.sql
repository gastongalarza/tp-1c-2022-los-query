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

--Esta tabla va a tener las ventas realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_ventas_realizadas(
id_venta bigint,
producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

--Esta tabla va a tener las compras realizadas, con la informacion de cada producto por separado, con sus cantidades y precio total de ese producto.
CREATE TABLE INFORMADOS.BI_compras_realizadas(
id_compra int,
producto varchar(255),
cantidad int, 
precio_total_producto decimal(18,2)
);

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
CREATE TABLE INFORMADOS.BI_productos(
id_producto int,
nombre_producto varchar(255),
movimiento varchar(6) , --Esta columna va a especificar si se trata de la Venta o Compra del producto
periodo varchar(10), --Periodo con formato 'yyyy-MM-dd' del producto 
cantidad_total int, --Cantidad total de compra o venta del producto
monto_total decimal(18,2) --Monto total gastado o ingresado del producto
);
/* 
Esta tabla se utilizará para la segunda Vista, y ademas en la consigna pide como minimo una tabla 
de Producto (me imaginé algo asi como resolucion)
*/