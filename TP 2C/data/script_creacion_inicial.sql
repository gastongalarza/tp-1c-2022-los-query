USE GD2C2022
GO

---------------------------------------------------
-- ELIMINACION DE TABLAS EN CASO DE QUE EXISTAN
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_compra')
DROP TABLE INFORMADOS.producto_por_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compra')
DROP TABLE INFORMADOS.compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon_por_venta')
DROP TABLE INFORMADOS.cupon_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_venta')
DROP TABLE INFORMADOS.producto_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento_venta')
DROP TABLE INFORMADOS.descuento_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_descuento_venta')
DROP TABLE INFORMADOS.tipo_descuento_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'venta')
DROP TABLE INFORMADOS.venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medio_pago_venta')
DROP TABLE INFORMADOS.medio_pago_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'proveedor')
DROP TABLE INFORMADOS.proveedor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento_compra')
DROP TABLE INFORMADOS.descuento_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medio_pago_compra')
DROP TABLE INFORMADOS.medio_pago_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'variante_producto')
DROP TABLE INFORMADOS.variante_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'variante')
DROP TABLE INFORMADOS.variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_variante')
DROP TABLE INFORMADOS.tipo_variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto')
DROP TABLE INFORMADOS.producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'categoria_producto')
DROP TABLE INFORMADOS.categoria_producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon')
DROP TABLE INFORMADOS.cupon

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_cupon')
DROP TABLE INFORMADOS.tipo_cupon

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'canal_venta')
DROP TABLE INFORMADOS.canal_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'envio')
DROP TABLE INFORMADOS.envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'metodo_envio')
DROP TABLE INFORMADOS.metodo_envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cliente')
DROP TABLE INFORMADOS.cliente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'zona')
DROP TABLE INFORMADOS.zona

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'provincia')
DROP TABLE INFORMADOS.provincia

---------------------------------------------------
-- ELIMINACION DE VISTAS EN CASO DE QUE EXISTAN
---------------------------------------------------



--------------------------------------------------- 
-- CREACION DE ESQUEMA
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'INFORMADOS')
DROP SCHEMA INFORMADOS
GO

PRINT 'Creando ESQUEMA INFORMADOS' 
GO

CREATE SCHEMA INFORMADOS;
GO

---------------------------------------------------
-- CREACION DE TABLAS
---------------------------------------------------

CREATE TABLE INFORMADOS.provincia(
id_provincia int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.zona(
id_zona int IDENTITY(1,1) PRIMARY KEY,
id_provincia int REFERENCES INFORMADOS.provincia(id_provincia),
localidad nvarchar(255),
codigo_postal int
);

CREATE TABLE INFORMADOS.cliente(
id_cliente int IDENTITY(1,1) PRIMARY KEY,
id_zona int REFERENCES INFORMADOS.zona(id_zona),
dni bigint,
nombre nvarchar(255),
apellido nvarchar(255),
direccion nvarchar(255),
telefono bigint,
mail nvarchar(255),
fecha_nacimiento date
);

CREATE TABLE INFORMADOS.metodo_envio(
id_metodo_envio int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.envio(
id_envio int IDENTITY(1,1) PRIMARY KEY,
id_metodo_envio int REFERENCES INFORMADOS.metodo_envio(id_metodo_envio),
id_zona int REFERENCES INFORMADOS.zona(id_zona),
precio decimal(18,2)
);

CREATE TABLE INFORMADOS.canal_venta(
id_canal_venta int IDENTITY(1,1) PRIMARY KEY,
nombre varchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.medio_pago_venta(
id_medio_pago_venta int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.venta(
id_venta bigint PRIMARY KEY,
id_cliente int REFERENCES INFORMADOS.cliente(id_cliente),
id_canal int REFERENCES INFORMADOS.canal_venta(id_canal_venta),
id_envio int REFERENCES INFORMADOS.envio(id_envio),
id_medio_pago_venta INT REFERENCES INFORMADOS.medio_pago_venta(id_medio_pago_venta),
fecha date,
total decimal(18,2)
);

CREATE TABLE INFORMADOS.tipo_descuento_venta(
id_tipo_descuento_venta int IDENTITY(1,1) PRIMARY KEY,
concepto_descuento nvarchar(255)
);

CREATE TABLE INFORMADOS.descuento_venta(
id_descuento_venta int IDENTITY(2000,1) PRIMARY KEY,
id_venta bigint REFERENCES INFORMADOS.venta(id_venta),
id_tipo_descuento_venta int REFERENCES INFORMADOS.tipo_descuento_venta(id_tipo_descuento_venta),
importe_descuento decimal(18,2)
);

CREATE TABLE INFORMADOS.tipo_cupon(
id_tipo_cupon int IDENTITY(1,1) PRIMARY KEY,
cupon_tipo nvarchar(50),
);

CREATE TABLE INFORMADOS.cupon(
id_cupon nvarchar(255) PRIMARY KEY,
id_tipo_cupon int REFERENCES INFORMADOS.tipo_cupon(id_tipo_cupon),
valor decimal(18,2),
fecha_inicial date,
fecha_final date
);

CREATE TABLE INFORMADOS.cupon_por_venta(
id_venta bigint REFERENCES INFORMADOS.venta(id_venta),
id_cupon nvarchar(255) REFERENCES INFORMADOS.cupon(id_cupon),
importe_cupon decimal(18,2)
);

CREATE TABLE INFORMADOS.categoria_producto(
id_categoria int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.producto(
id_producto nvarchar(50) PRIMARY KEY,
id_categoria int REFERENCES INFORMADOS.categoria_producto(id_categoria),
nombre nvarchar(255),
descripcion nvarchar(255),
material nvarchar(255),
marca nvarchar(255)
);

CREATE TABLE INFORMADOS.tipo_variante(
id_tipo_variante int IDENTITY(1,1) PRIMARY KEY,
tipo nvarchar(50)
);

CREATE TABLE INFORMADOS.variante(
id_variante int IDENTITY(1,1) PRIMARY KEY,
id_tipo_variante int REFERENCES INFORMADOS.tipo_variante(id_tipo_variante),
nombre nvarchar(50)
);

CREATE TABLE INFORMADOS.variante_producto(
id_variante_producto nvarchar(50) PRIMARY KEY,
id_variante int REFERENCES INFORMADOS.variante(id_variante),
id_producto nvarchar(50) REFERENCES INFORMADOS.producto(id_producto),
);

CREATE TABLE INFORMADOS.producto_por_venta(
id_venta bigint REFERENCES INFORMADOS.venta(id_venta),
id_variante_producto nvarchar(50) REFERENCES INFORMADOS.variante_producto(id_variante_producto),
cantidad int,
precio_unidad decimal(18,2)
);

CREATE TABLE INFORMADOS.medio_pago_compra(
id_medio_pago_compra int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255),
);

CREATE TABLE INFORMADOS.descuento_compra(
id_descuento_compra decimal(19,0) PRIMARY KEY,
valor decimal(18,2)
);

CREATE TABLE INFORMADOS.proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
id_zona int REFERENCES INFORMADOS.zona(id_zona),
razon_social nvarchar(255),
direccion nvarchar(255),
mail nvarchar(255)
);

CREATE TABLE INFORMADOS.compra(
id_compra int PRIMARY KEY,
id_proveedor nvarchar(50) REFERENCES INFORMADOS.proveedor(id_proveedor),
id_medio_pago int REFERENCES INFORMADOS.medio_pago_compra(id_medio_pago_compra),
id_descuento decimal(19,0) REFERENCES INFORMADOS.descuento_compra(id_descuento_compra),
fecha date,
total decimal(18,2),
);

CREATE TABLE INFORMADOS.producto_por_compra(
id_compra int REFERENCES INFORMADOS.compra(id_compra),
id_variante_producto nvarchar(50) REFERENCES INFORMADOS.variante_producto(id_variante_producto),
cantidad int,
precio_unidad decimal(18,2)
);


----------------------------------------------------
-- CREACION DE VISTAS
----------------------------------------------------



---------------------------------------------------
-- CREACION DE INDICES
---------------------------------------------------



---------------------------------------------------
--CREACION DE STORE PROCEDURES
---------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_ubicacion')
	DROP PROCEDURE sp_migrar_ubicacion
GO

CREATE PROCEDURE sp_migrar_ubicacion
AS
BEGIN
	PRINT 'Migracion de provincias'
	INSERT INTO INFORMADOS.provincia(nombre)
	SELECT DISTINCT CLIENTE_PROVINCIA FROM gd_esquema.Maestra WHERE CLIENTE_PROVINCIA IS NOT NULL
	UNION
	SELECT DISTINCT PROVEEDOR_PROVINCIA FROM gd_esquema.Maestra WHERE PROVEEDOR_PROVINCIA IS NOT NULL

	PRINT 'Migracion de zonas'
	INSERT INTO INFORMADOS.zona(codigo_postal, localidad, id_provincia)
	SELECT CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, p.id_provincia
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.provincia p ON p.nombre = CLIENTE_PROVINCIA
	WHERE CLIENTE_CODIGO_POSTAL IS NOT NULL AND CLIENTE_LOCALIDAD IS NOT NULL AND CLIENTE_PROVINCIA IS NOT NULL
	GROUP BY CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, p.id_provincia
	UNION
	SELECT PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_LOCALIDAD, p.id_provincia
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.provincia p ON p.nombre = PROVEEDOR_PROVINCIA
	WHERE PROVEEDOR_CODIGO_POSTAL IS NOT NULL AND PROVEEDOR_LOCALIDAD IS NOT NULL AND PROVEEDOR_PROVINCIA IS NOT NULL
	GROUP BY PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_LOCALIDAD, p.id_provincia
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_cliente')
	DROP PROCEDURE sp_migrar_cliente
GO

CREATE PROCEDURE sp_migrar_cliente
AS
BEGIN
	PRINT 'Migracion de clientes'
    INSERT INTO INFORMADOS.cliente (dni, nombre, apellido, direccion, telefono, mail, fecha_nacimiento, id_zona)
	SELECT DISTINCT CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO, CLIENTE_MAIL, CLIENTE_FECHA_NAC, z.id_zona
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.provincia p ON p.nombre = CLIENTE_PROVINCIA
	JOIN INFORMADOS.zona z ON z.localidad = CLIENTE_LOCALIDAD
		and z.codigo_postal = CLIENTE_CODIGO_POSTAL
		and z.id_provincia = p.id_provincia
	WHERE CLIENTE_DNI IS NOT NULL
	GROUP BY CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
		CLIENTE_MAIL, CLIENTE_FECHA_NAC, CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA, z.id_zona
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_proveedor')
	DROP PROCEDURE sp_migrar_proveedor
GO

CREATE PROCEDURE sp_migrar_proveedor
AS
BEGIN
	PRINT 'Migracion de proveedores'
	INSERT INTO INFORMADOS.proveedor (id_proveedor, razon_social, direccion, mail, id_zona)
	SELECT DISTINCT PROVEEDOR_CUIT, PROVEEDOR_RAZON_SOCIAL, PROVEEDOR_DOMICILIO, PROVEEDOR_MAIL, z.id_zona
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.provincia p ON p.nombre = PROVEEDOR_PROVINCIA
	JOIN INFORMADOS.zona z ON z.localidad = PROVEEDOR_LOCALIDAD
		and z.codigo_postal = PROVEEDOR_CODIGO_POSTAL
		and z.id_provincia = p.id_provincia
	WHERE PROVEEDOR_CUIT IS NOT NULL
	GROUP BY PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_CUIT, PROVEEDOR_DOMICILIO, PROVEEDOR_LOCALIDAD,
		PROVEEDOR_MAIL, PROVEEDOR_PROVINCIA, PROVEEDOR_RAZON_SOCIAL, z.id_zona
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_canal')
	DROP PROCEDURE sp_migrar_canal
GO

CREATE PROCEDURE sp_migrar_canal
AS
BEGIN
	PRINT 'Migracion de canales de venta'
    INSERT INTO INFORMADOS.canal_venta (nombre, costo)
	SELECT DISTINCT VENTA_CANAL, VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra
	WHERE VENTA_CANAL IS NOT NULL AND VENTA_CANAL_COSTO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_producto')
	DROP PROCEDURE sp_migrar_producto
GO

CREATE PROCEDURE sp_migrar_producto
AS
BEGIN
	PRINT 'Migracion de categorias de producto'
	INSERT INTO INFORMADOS.categoria_producto (nombre)
	SELECT DISTINCT PRODUCTO_CATEGORIA
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_CATEGORIA IS NOT NULL

	PRINT 'Migracion de productos'
	INSERT INTO INFORMADOS.producto(id_producto, nombre, descripcion, material, marca, id_categoria)
	SELECT DISTINCT PRODUCTO_CODIGO, PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_MATERIAL, PRODUCTO_MARCA, c.id_categoria
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.categoria_producto c ON c.nombre = PRODUCTO_CATEGORIA
	WHERE PRODUCTO_CODIGO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_variante')
	DROP PROCEDURE sp_migrar_variante
GO

CREATE PROCEDURE sp_migrar_variante
AS
BEGIN
	PRINT 'Migracion de tipos de variante'
	INSERT INTO INFORMADOS.tipo_variante (tipo)
	SELECT DISTINCT PRODUCTO_TIPO_VARIANTE
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_TIPO_VARIANTE IS NOT NULL

	PRINT 'Migracion de variantes'
	INSERT INTO INFORMADOS.variante(nombre, id_tipo_variante)
	SELECT DISTINCT PRODUCTO_VARIANTE, tp.id_tipo_variante
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.tipo_variante tp ON tp.tipo = PRODUCTO_TIPO_VARIANTE
	WHERE PRODUCTO_VARIANTE IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_envio')
	DROP PROCEDURE sp_migrar_envio
GO

CREATE PROCEDURE sp_migrar_envio
AS
BEGIN
	PRINT 'Migracion de metodos de envio'
	INSERT INTO INFORMADOS.metodo_envio (nombre)
	SELECT DISTINCT VENTA_MEDIO_ENVIO
	FROM gd_esquema.Maestra
	WHERE VENTA_MEDIO_ENVIO IS NOT NULL

	PRINT 'Migracion de envios'
	INSERT INTO INFORMADOS.envio(id_metodo_envio, id_zona, precio)
	SELECT DISTINCT m.id_metodo_envio, z.id_zona, VENTA_ENVIO_PRECIO
	FROM gd_esquema.Maestra ma
	JOIN INFORMADOS.metodo_envio m ON m.nombre = ma.VENTA_MEDIO_ENVIO
	JOIN INFORMADOS.zona z ON z.codigo_postal = CLIENTE_CODIGO_POSTAL
		and z.localidad = CLIENTE_LOCALIDAD
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medio_pago_venta')
	DROP PROCEDURE sp_migrar_medio_pago_venta
GO

CREATE PROCEDURE sp_migrar_medio_pago_venta
AS
BEGIN
	PRINT 'Migracion de medios de pago para ventas'
	INSERT INTO INFORMADOS.medio_pago_venta(nombre, costo)
	SELECT DISTINCT VENTA_MEDIO_PAGO, VENTA_MEDIO_PAGO_COSTO
	FROM gd_esquema.Maestra
	WHERE VENTA_MEDIO_PAGO IS NOT NULL AND VENTA_MEDIO_PAGO_COSTO IS NOT NULL
	GROUP BY VENTA_MEDIO_PAGO, VENTA_MEDIO_PAGO_COSTO
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_venta')
	DROP PROCEDURE sp_migrar_venta
GO

CREATE PROCEDURE sp_migrar_venta
AS
BEGIN
	PRINT 'Migracion de ventas'
	INSERT INTO INFORMADOS.venta(id_venta, id_cliente, id_canal, id_envio, id_medio_pago_venta, fecha,total)
    SELECT DISTINCT 
	origen.VENTA_CODIGO,
	cliente.id_cliente,
	canal.id_canal_venta,
	envio.id_envio,
	mediopago.id_medio_pago_venta,
	origen.VENTA_FECHA,
	origen.VENTA_TOTAL
	FROM (SELECT DISTINCT VENTA_CODIGO, VENTA_FECHA, VENTA_CANAL, CLIENTE_PROVINCIA, VENTA_ENVIO_PRECIO, VENTA_MEDIO_ENVIO,
		VENTA_MEDIO_PAGO, CLIENTE_DNI, CLIENTE_NOMBRE, VENTA_TOTAL, CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD
		FROM gd_esquema.Maestra WHERE venta_codigo IS NOT NULL) AS origen
	JOIN INFORMADOS.cliente cliente on	origen.CLIENTE_DNI = cliente.dni AND origen.CLIENTE_NOMBRE = cliente.nombre
	JOIN INFORMADOS.canal_venta canal on origen.VENTA_CANAL = canal.nombre
	JOIN INFORMADOS.medio_pago_venta mediopago on origen.VENTA_MEDIO_PAGO = mediopago.nombre
	JOIN (SELECT env.*, me.nombre, zon.localidad, zon.codigo_postal
		FROM INFORMADOS.envio env 
		JOIN INFORMADOS.metodo_envio me on env.id_metodo_envio = me.id_metodo_envio
		JOIN INFORMADOS.zona zon on env.id_zona=zon.id_zona) AS envio 
	on origen.VENTA_MEDIO_ENVIO = envio.nombre AND origen.CLIENTE_CODIGO_POSTAL = envio.codigo_postal and
		origen.CLIENTE_LOCALIDAD = envio.localidad AND origen.VENTA_ENVIO_PRECIO = envio.precio
	WHERE origen.VENTA_CODIGO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medio_pago_compra')
	DROP PROCEDURE sp_migrar_medio_pago_compra
GO

CREATE PROCEDURE sp_migrar_medio_pago_compra
AS
BEGIN
	PRINT 'Migracion de medios de pago para compras'
	INSERT INTO INFORMADOS.medio_pago_compra(nombre)
	SELECT DISTINCT COMPRA_MEDIO_PAGO
	FROM gd_esquema.Maestra
	WHERE COMPRA_MEDIO_PAGO IS NOT NULL 
	GROUP BY COMPRA_MEDIO_PAGO
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_descuento_compra')
	DROP PROCEDURE sp_migrar_descuento_compra
GO

CREATE PROCEDURE sp_migrar_descuento_compra
AS
BEGIN
	PRINT 'Migracion de descuentos para compras'
	INSERT INTO INFORMADOS.descuento_compra(id_descuento_compra, valor)
	SELECT DISTINCT DESCUENTO_COMPRA_CODIGO, DESCUENTO_COMPRA_VALOR
	FROM gd_esquema.Maestra
	WHERE DESCUENTO_COMPRA_CODIGO IS NOT NULL AND DESCUENTO_COMPRA_VALOR IS NOT NULL
	GROUP BY DESCUENTO_COMPRA_CODIGO, DESCUENTO_COMPRA_VALOR
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_variante_producto')
	DROP PROCEDURE sp_migrar_variante_producto
GO

CREATE PROCEDURE sp_migrar_variante_producto
AS
BEGIN
	PRINT 'Migracion de variantes de producto'
	INSERT INTO INFORMADOS.variante_producto (id_variante_producto, id_variante, id_producto)
	SELECT DISTINCT PRODUCTO_VARIANTE_CODIGO, v.id_variante, PRODUCTO_CODIGO
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.producto p ON p.id_producto = PRODUCTO_CODIGO
	JOIN INFORMADOS.variante v ON v.nombre = PRODUCTO_VARIANTE
	WHERE PRODUCTO_VARIANTE_CODIGO IS NOT NULL AND PRODUCTO_CODIGO IS NOT NULL AND PRODUCTO_VARIANTE IS NOT NULL
	GROUP BY PRODUCTO_VARIANTE_CODIGO, PRODUCTO_VARIANTE, PRODUCTO_CODIGO, v.id_variante
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_producto_por_venta')
	DROP PROCEDURE sp_migrar_producto_por_venta
GO

CREATE PROCEDURE sp_migrar_producto_por_venta
AS
BEGIN
	PRINT 'Migracion de productos por venta'
	INSERT INTO INFORMADOS.producto_por_venta(id_venta, id_variante_producto, cantidad, precio_unidad)
	SELECT VENTA_CODIGO, PRODUCTO_VARIANTE_CODIGO, VENTA_PRODUCTO_CANTIDAD, VENTA_PRODUCTO_PRECIO
	FROM gd_esquema.Maestra ma
	WHERE VENTA_CODIGO IS NOT NULL AND PRODUCTO_VARIANTE_CODIGO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_compra')
	DROP PROCEDURE sp_migrar_compra
GO

CREATE PROCEDURE sp_migrar_compra
AS
BEGIN
	PRINT 'Migracion de compras'
	INSERT INTO INFORMADOS.compra (id_compra, id_proveedor, fecha, id_medio_pago, id_descuento, total)
	SELECT DISTINCT COMPRA_NUMERO, prov.id_proveedor, COMPRA_FECHA, mpc.id_medio_pago_compra, dc.id_descuento_compra, COMPRA_TOTAL
	FROM gd_esquema.Maestra
	JOIN INFORMADOS.proveedor prov ON prov.id_proveedor = PROVEEDOR_CUIT
	JOIN INFORMADOS.medio_pago_compra mpc ON mpc.nombre = COMPRA_MEDIO_PAGO
	JOIN INFORMADOS.descuento_compra dc ON dc.id_descuento_compra = DESCUENTO_COMPRA_CODIGO
	WHERE COMPRA_NUMERO IS NOT NULL AND PROVEEDOR_CUIT IS NOT NULL AND COMPRA_FECHA IS NOT NULL and
		COMPRA_MEDIO_PAGO IS NOT NULL AND DESCUENTO_COMPRA_CODIGO IS NOT NULL AND COMPRA_TOTAL IS NOT NULL
	GROUP BY COMPRA_NUMERO, PROVEEDOR_CUIT, COMPRA_FECHA, COMPRA_MEDIO_PAGO, DESCUENTO_COMPRA_CODIGO, COMPRA_TOTAL,
		prov.id_proveedor, mpc.id_medio_pago_compra, dc.id_descuento_compra
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_producto_por_compra')
	DROP PROCEDURE sp_migrar_producto_por_compra
GO

CREATE PROCEDURE sp_migrar_producto_por_compra
AS
BEGIN
	PRINT 'Migracion de productos por compra'
	INSERT INTO INFORMADOS.producto_por_compra(id_compra, id_variante_producto, cantidad, precio_unidad)
	SELECT COMPRA_NUMERO, PRODUCTO_VARIANTE_CODIGO, COMPRA_PRODUCTO_CANTIDAD, COMPRA_PRODUCTO_PRECIO
	FROM gd_esquema.Maestra ma
	WHERE COMPRA_NUMERO IS NOT NULL AND PRODUCTO_VARIANTE_CODIGO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_tipo_descuento_venta')
	DROP PROCEDURE sp_migrar_tipo_descuento_venta
GO

CREATE PROCEDURE sp_migrar_tipo_descuento_venta
AS
BEGIN
	PRINT 'Migracion de tipos de descuento para ventas'
    INSERT INTO INFORMADOS.tipo_descuento_venta (concepto_descuento)
	SELECT DISTINCT VENTA_DESCUENTO_CONCEPTO 
	FROM gd_esquema.Maestra WHERE VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_descuento_venta')
	DROP PROCEDURE sp_migrar_descuento_venta
GO

CREATE PROCEDURE sp_migrar_descuento_venta
AS
BEGIN
	PRINT 'Migracion de descuentos para ventas'
  	INSERT INTO INFORMADOS.descuento_venta(id_venta, id_tipo_descuento_venta, importe_descuento)
	SELECT DISTINCT v.id_venta, td.id_tipo_descuento_venta, VENTA_DESCUENTO_IMPORTE
	FROM gd_esquema.Maestra m1
	LEFT JOIN INFORMADOS.venta v on m1.VENTA_CODIGO = v.id_venta
	LEFT JOIN INFORMADOS.tipo_descuento_venta td on m1.VENTA_DESCUENTO_CONCEPTO = td.concepto_descuento
	WHERE m1.VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_tipo_cupon')
	DROP PROCEDURE sp_migrar_tipo_cupon
GO

CREATE PROCEDURE sp_migrar_tipo_cupon
AS
BEGIN
	PRINT 'Migracion de tipos de cupon'
  	INSERT INTO INFORMADOS.tipo_cupon(cupon_tipo)
	SELECT DISTINCT VENTA_CUPON_TIPO
	FROM gd_esquema.Maestra WHERE VENTA_CUPON_TIPO IS NOT NULL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_cupon')
	DROP PROCEDURE sp_migrar_cupon
GO

CREATE PROCEDURE sp_migrar_cupon
AS
BEGIN
	PRINT 'Migracion de cupones'
  	INSERT INTO INFORMADOS.cupon(id_cupon, valor, fecha_inicial, fecha_final, id_tipo_cupon)
	SELECT DISTINCT VENTA_CUPON_CODIGO, VENTA_CUPON_VALOR, VENTA_CUPON_FECHA_DESDE, VENTA_CUPON_FECHA_HASTA, tc.id_tipo_cupon
	FROM gd_esquema.Maestra 
	JOIN INFORMADOS.tipo_cupon tc ON VENTA_CUPON_TIPO = tc.cupon_tipo
	WHERE VENTA_CUPON_CODIGO IS NOT NULL AND VENTA_CUPON_TIPO IS NOT NULL and
		VENTA_CUPON_VALOR IS NOT NULL AND VENTA_CUPON_FECHA_DESDE IS NOT NULL AND VENTA_CUPON_FECHA_HASTA IS NOT NULL
	GROUP BY VENTA_CUPON_CODIGO, VENTA_CUPON_TIPO, VENTA_CUPON_VALOR, VENTA_CUPON_FECHA_DESDE, VENTA_CUPON_FECHA_HASTA, tc.id_tipo_cupon

	PRINT 'Migracion de cupones por venta'
	INSERT INTO INFORMADOS.cupon_por_venta(id_venta, id_cupon, importe_cupon)
	SELECT VENTA_CODIGO, VENTA_CUPON_CODIGO, VENTA_CUPON_IMPORTE
	FROM gd_esquema.Maestra
	WHERE VENTA_CODIGO IS NOT NULL AND VENTA_CUPON_CODIGO IS NOT NULL
END
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

 BEGIN TRANSACTION
 BEGIN TRY
    EXECUTE sp_migrar_canal
	EXECUTE sp_migrar_ubicacion
	EXECUTE sp_migrar_producto
	EXECUTE sp_migrar_cliente
	EXECUTE sp_migrar_variante
	EXECUTE sp_migrar_envio
	EXECUTE sp_migrar_medio_pago_venta
	EXECUTE sp_migrar_venta
	EXECUTE sp_migrar_proveedor
	EXECUTE sp_migrar_medio_pago_compra
	EXECUTE sp_migrar_descuento_compra
	EXECUTE sp_migrar_variante_producto
	EXECUTE sp_migrar_producto_por_venta
	EXECUTE sp_migrar_compra
	EXECUTE sp_migrar_producto_por_compra
	EXECUTE sp_migrar_tipo_descuento_venta
	EXECUTE sp_migrar_descuento_venta
	EXECUTE sp_migrar_tipo_cupon
	EXECUTE sp_migrar_cupon
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM INFORMADOS.canal_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.provincia)
	AND EXISTS (SELECT 1 FROM INFORMADOS.zona)
	AND EXISTS (SELECT 1 FROM INFORMADOS.categoria_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.cliente)
	AND EXISTS (SELECT 1 FROM INFORMADOS.tipo_variante)
	AND EXISTS (SELECT 1 FROM INFORMADOS.variante)
	AND EXISTS (SELECT 1 FROM INFORMADOS.metodo_envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.medio_pago_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.proveedor)
	AND EXISTS (SELECT 1 FROM INFORMADOS.medio_pago_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.descuento_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.variante_producto)
	AND EXISTS (SELECT 1 FROM INFORMADOS.producto_por_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.producto_por_compra)
	AND EXISTS (SELECT 1 FROM INFORMADOS.tipo_descuento_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.descuento_venta)
	AND EXISTS (SELECT 1 FROM INFORMADOS.tipo_cupon)
	AND EXISTS (SELECT 1 FROM INFORMADOS.cupon)
	AND EXISTS (SELECT 1 FROM INFORMADOS.cupon_por_venta)
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

