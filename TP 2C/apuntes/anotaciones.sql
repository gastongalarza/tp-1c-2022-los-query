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
[VENTA_MEDIO_PAGO]			--> canal_venta/nombre
	=> id_canal_venta --> venta/id_canal_venta + canal_venta/id_canal_venta *ver abajo
[VENTA_MEDIO_PAGO_COSTO]	--> TODO
[VENTA_ENVIO_PRECIO]		--> ????
[VENTA_MEDIO_ENVIO]			--> ????

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


venta	- cliente		- zona			- provincia
		- metodo_envio
		- canal_venta

compra	- proveedor		- zona			- provincia


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
	m.VENTA_ENVIO_PRECIO, m.VENTA_MEDIO_ENVIO
from gd_esquema.Maestra m
group by m.VENTA_MEDIO_PAGO, m.VENTA_MEDIO_PAGO_COSTO,
	m.VENTA_ENVIO_PRECIO, m.VENTA_MEDIO_ENVIO

/*
==> venta_medio_pago corresponde al concepto de canal de venta
*/

select m.CLIENTE_CODIGO_POSTAL
from gd_esquema.Maestra m
group by m.CLIENTE_CODIGO_POSTAL