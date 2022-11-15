-----------------------------------------------------------
-- Resumen del mappeo entre TABLA MAESTRA y NUEVO MODELO --
-----------------------------------------------------------
/*
Compra
[COMPRA_NUMERO]
[COMPRA_FECHA]
[COMPRA_MEDIO_PAGO]
[COMPRA_TOTAL]

Proveedor
[PROVEEDOR_RAZON_SOCIAL]
[PROVEEDOR_CUIT]
[PROVEEDOR_DOMICILIO]
[PROVEEDOR_MAIL]
[PROVEEDOR_LOCALIDAD]
[PROVEEDOR_CODIGO_POSTAL]
[PROVEEDOR_PROVINCIA]

Descuento
[DESCUENTO_COMPRA_CODIGO]
[DESCUENTO_COMPRA_VALOR]

Producto
[PRODUCTO_NOMBRE]			--> producto/nombre
[PRODUCTO_DESCRIPCION]		--> producto/descripcion
[PRODUCTO_MATERIAL]			--> producto/material
[PRODUCTO_CODIGO]			--> producto/id_producto
[PRODUCTO_MARCA]			--> producto/marca
[PRODUCTO_CATEGORIA]		--> categoria_producto/nombre
	=> id_categoria --> categoria_producto/id_categoria + producto/id_categoria
[PRODUCTO_VARIANTE_CODIGO]	--> variante/id_variante + producto_por_venta/id_variante (nulleable) + variante_producto/id_variante
[PRODUCTO_VARIANTE]			--> variante/nombre
[PRODUCTO_TIPO_VARIANTE]	--> tipo_variante/tipo
	=> id_tipo_variante -> tipo_variante/id_tipo_variante + variante/id_tipo_variante

Compra
[COMPRA_PRODUCTO_CANTIDAD]	-->
[COMPRA_PRODUCTO_PRECIO]

Venta
[VENTA_CODIGO]				--> venta/id_venta
[VENTA_FECHA]				--> venta/fecha
[VENTA_TOTAL]				--> venta/total
[VENTA_MEDIO_PAGO]			
[VENTA_MEDIO_PAGO_COSTO]	--> TODO
[VENTA_ENVIO_PRECIO]		--> ????
[VENTA_MEDIO_ENVIO]			--> ????
[VENTA_CANAL]				--> canal_venta/nombre
	=> id_canal_venta --> venta/id_canal_venta + canal_venta/id_canal_venta *ver abajo
[VENTA_CANAL_COSTO]			--> canal_venta/costo

Cliente
[CLIENTE_NOMBRE]			--> cliente/nombre
[CLIENTE_APELLIDO]			--> cliente/apellido
[CLIENTE_DNI]				--> cliente/dni
[CLIENTE_DIRECCION]			--> cliente/direccion
[CLIENTE_TELEFONO]			--> cliente/telefono
[CLIENTE_MAIL]				--> cliente/mail
[CLIENTE_FECHA_NAC]			--> cliente/fecha_nacimiento
[CLIENTE_LOCALIDAD]			--> localidad/id_localidad + codigo_postal/id_localidad
[CLIENTE_CODIGO_POSTAL]		--> codigo_postal/id_codigo_postal + cliente/id_codigo_postal
[CLIENTE_PROVINCIA]			--> provincia/id_provincia + localidad/id_provincia

Descuento
[VENTA_DESCUENTO_IMPORTE]	--> descuento/importe
[VENTA_DESCUENTO_CONCEPTO]	--> descuento/concepto (enum)

Cupon
[VENTA_CUPON_IMPORTE]		--> cupon/importe
[VENTA_CUPON_CODIGO]		--> cupon/codigo
[VENTA_CUPON_FECHA_DESDE]	--> cupon/fecha_inicial
[VENTA_CUPON_FECHA_HASTA]	--> cupon/fecha_final
[VENTA_CUPON_VALOR]			--> cupon/valor
[VENTA_CUPON_TIPO]			--> cupon/tipo

Venta/Producto
[VENTA_PRODUCTO_CANTIDAD]	--> producto_por_venta/cantidad
[VENTA_PRODUCTO_PRECIO]		--> producto_por_venta/precio

*/

-----------------------------------------------------------
----------- Orden para ejecutar las migraciones -----------
-----------------------------------------------------------

-- De hojas a raíces. Una entidad se puede migrar si todas las entidades que conoce ya están
-- migradas o la migración se hace al mismo tiempo

/*
hojas
- canal_de_venta
- cupon
- provincia/zona
- categoria_producto

segundo nivel
- cliente
- proveedor
- producto

Arbol de dependencias

venta			- cliente		- envio			- metodo_envio
				- zona ...						- zona			- provincia
				- canal_venta
				- medio_pago

compra			- proveedor		- zona			- provincia

producto_		- compra...
por_compra		- variante_		- variante...
				  producto		- producto...

producto_		- venta...
por_venta		- variante_		- variante...
				  producto		- producto...

*/

-----------------------------------------------------------
------------------ Análisis de los datos ------------------
-----------------------------------------------------------

-- Cupon tipo, cupon valor y cupon importe

select m.VENTA_CUPON_TIPO, m.VENTA_CUPON_VALOR, m.VENTA_CUPON_IMPORTE
from gd_esquema.Maestra m
where m.VENTA_CUPON_VALOR is not null and m.VENTA_CUPON_IMPORTE is not null

/*
--> valor puede ser un porcentaje o un importe de acuerdo al venta_cupon_tipo

==> importe no es un valor del cupon, es un valor del cupon por venta
*/

-- Canales de venta

select m.VENTA_MEDIO_PAGO
from gd_esquema.Maestra m
group by m.VENTA_MEDIO_PAGO

select m.VENTA_MEDIO_ENVIO
from gd_esquema.Maestra m
group by m.VENTA_MEDIO_ENVIO

select m.VENTA_MEDIO_PAGO, m.VENTA_MEDIO_PAGO_COSTO,
	m.VENTA_ENVIO_PRECIO, m.VENTA_MEDIO_ENVIO, m.VENTA_CANAL, m.VENTA_CANAL_COSTO
from gd_esquema.Maestra m
group by m.VENTA_MEDIO_PAGO, m.VENTA_MEDIO_PAGO_COSTO,
	m.VENTA_ENVIO_PRECIO, m.VENTA_MEDIO_ENVIO, m.VENTA_CANAL, m.VENTA_CANAL_COSTO

/*
==> venta_medio_pago corresponde al concepto de canal de venta
*/

select m.CLIENTE_CODIGO_POSTAL
from gd_esquema.Maestra m
group by m.CLIENTE_CODIGO_POSTAL

-----------
-- Medio de pago
-----------

/*
Cada medio de pago tiene un solo costo asociado
*/


select VENTA_MEDIO_PAGO, count(distinct VENTA_MEDIO_PAGO_COSTO)
from gd_esquema.Maestra
where VENTA_MEDIO_PAGO is not null
group by VENTA_MEDIO_PAGO















-----------------------------------------
--borrador
-----------------------------------------

select [PRODUCTO_VARIANTE_CODIGO]
	,[PRODUCTO_NOMBRE]
    ,[PRODUCTO_DESCRIPCION]
    ,[PRODUCTO_MATERIAL]
    ,[PRODUCTO_CODIGO]
    ,[PRODUCTO_MARCA]
    ,[PRODUCTO_CATEGORIA]
    ,[PRODUCTO_TIPO_VARIANTE]
    ,[PRODUCTO_VARIANTE]
from gd_esquema.Maestra
group by [PRODUCTO_VARIANTE_CODIGO]
	,[PRODUCTO_NOMBRE]
    ,[PRODUCTO_DESCRIPCION]
    ,[PRODUCTO_MATERIAL]
    ,[PRODUCTO_CODIGO]
    ,[PRODUCTO_MARCA]
    ,[PRODUCTO_CATEGORIA]
    ,[PRODUCTO_TIPO_VARIANTE]
    ,[PRODUCTO_VARIANTE]

select PRODUCTO_VARIANTE_CODIGO, PRODUCTO_NOMBRE
from gd_esquema.Maestra
group by PRODUCTO_VARIANTE_CODIGO, PRODUCTO_NOMBRE

select count(distinct PRODUCTO_NOMBRE)
from gd_esquema.Maestra
group by PRODUCTO_VARIANTE_CODIGO
having count(distinct PRODUCTO_NOMBRE) > 1

select count(distinct VENTA_CODIGO)
from gd_esquema.Maestra
where PRODUCTO_VARIANTE_CODIGO is not null and VENTA_CODIGO is not null
group by PRODUCTO_VARIANTE_CODIGO
having count(distinct VENTA_CODIGO) > 1

select count(distinct PRODUCTO_VARIANTE)
from gd_esquema.Maestra
where PRODUCTO_NOMBRE is not null
group by PRODUCTO_NOMBRE
having count(distinct PRODUCTO_VARIANTE) > 1

select count(distinct PRODUCTO_VARIANTE_CODIGO)
from gd_esquema.Maestra
where PRODUCTO_CODIGO is not null
group by PRODUCTO_CODIGO
having count(distinct PRODUCTO_NOMBRE) > 1

-- 1 producto			--> 1 solo variante codigo
-- 1 variante codigo	--> 1 producto
-- 1 variante codigo	--> muchas venta codigo
-- 1 producto			--> 1 producto variante


select PRODUCTO_VARIANTE, PRODUCTO_VARIANTE_CODIGO, PRODUCTO_TIPO_VARIANTE
from gd_esquema.Maestra
where PRODUCTO_NOMBRE is not null
group by PRODUCTO_VARIANTE, PRODUCTO_VARIANTE_CODIGO, PRODUCTO_TIPO_VARIANTE

select PRODUCTO_VARIANTE_CODIGO, count(distinct PRODUCTO_CODIGO), count(distinct PRODUCTO_VARIANTE), count(distinct PRODUCTO_TIPO_VARIANTE)
from gd_esquema.Maestra
where PRODUCTO_VARIANTE_CODIGO is not null
group by PRODUCTO_VARIANTE_CODIGO
having count(distinct PRODUCTO_VARIANTE) > 1 or count(distinct PRODUCTO_TIPO_VARIANTE) > 1 or count(distinct PRODUCTO_CODIGO) > 1

select PRODUCTO_NOMBRE, count(distinct PRODUCTO_VARIANTE_CODIGO), count(distinct VENTA_PRODUCTO_PRECIO), count(distinct VENTA_CODIGO)
from gd_esquema.Maestra
where PRODUCTO_NOMBRE is not null
group by PRODUCTO_NOMBRE
having count(distinct PRODUCTO_VARIANTE) > 1 or count(distinct PRODUCTO_TIPO_VARIANTE) > 1

select PRODUCTO_VARIANTE, count(distinct PRODUCTO_CODIGO), count(distinct PRODUCTO_VARIANTE_CODIGO)
from gd_esquema.Maestra
where PRODUCTO_VARIANTE is not null
group by PRODUCTO_VARIANTE

select VENTA_CODIGO, count(distinct VENTA_DESCUENTO_CONCEPTO)
from gd_esquema.Maestra
where VENTA_CODIGO is not null
group by VENTA_CODIGO

select VENTA_DESCUENTO_CONCEPTO, count(distinct VENTA_CODIGO)
from gd_esquema.Maestra
where VENTA_DESCUENTO_CONCEPTO is not null
group by VENTA_DESCUENTO_CONCEPTO

select *
from gd_esquema.Maestra
where VENTA_DESCUENTO_IMPORTE = VENTA_ENVIO_PRECIO

select DISTINCT CLIENTE_NOMBRE, CLIENTE_APELLIDO
from gd_esquema.Maestra

select DISTINCT CLIENTE_DNI
from gd_esquema.Maestra

select DISTINCT *
from INFORMADOS.variante

select DISTINCT *
from INFORMADOS.producto

select DISTINCT count(distinct id_variante)
from INFORMADOS.variante_producto
group by id_variante_producto

select DISTINCT PRODUCTO_VARIANTE
from gd_esquema.Maestra


