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