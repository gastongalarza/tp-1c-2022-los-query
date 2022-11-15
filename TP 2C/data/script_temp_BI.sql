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
Hasta ac� estas tablas se usarian para realizar la primer Vista solicitada, y a su vez vienen a ser algunas dimensiones MINIMAS
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
Estas tablas se utilizar�n para la segunda Vista, y adem�s en la consigna pide como minimo una tabla 
de Producto, categoria de producto. La tabla BI_productos_por_periodo me parece util para tener una tabla donde se tenga registrado por mes los productos
vendidos y comprados con el monto ingresado o gastado. BI_productos_por_periodo servir� para hacer la segunda vista
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
BI_categoria_producto, si bien la piden como requisito minimo en la consigna, no veo sentido q replique lo que est� en el transaccional, pero se necesita 
para armar la 3era vista. Lo mismo que la tabla BI_productos
*/



