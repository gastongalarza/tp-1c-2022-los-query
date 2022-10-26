USE GD2C2022
GO

---------------------------------------------------
-- ELIMINACION DE TABLAS EN CASO DE QUE EXISTAN
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_compra')
DROP TABLE INFORMADOS.producto_por_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compra')
DROP TABLE INFORMADOS.compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_venta')
DROP TABLE INFORMADOS.producto_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento')
DROP TABLE INFORMADOS.descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon_por_venta')
DROP TABLE INFORMADOS.cupon_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'venta')
DROP TABLE INFORMADOS.venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cliente')
DROP TABLE INFORMADOS.cliente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'canal')
DROP TABLE INFORMADOS.canal

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'envio')
DROP TABLE INFORMADOS.envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medio_pago')
DROP TABLE INFORMADOS.medio_pago

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'barrio')
DROP TABLE INFORMADOS.barrio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon')
DROP TABLE INFORMADOS.cupon

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto')
DROP TABLE INFORMADOS.producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'categoria')
DROP TABLE INFORMADOS.categoria

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'variante')
DROP TABLE INFORMADOS.variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_variante')
DROP TABLE INFORMADOS.tipo_variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'proveedor')
DROP TABLE INFORMADOS.proveedor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'provincia')
DROP TABLE INFORMADOS.provincia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'localidad')
DROP TABLE INFORMADOS.localidad

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'codigo_postal')
DROP TABLE INFORMADOS.codigo_postal

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
-- CREACIÓN DE TABLAS
---------------------------------------------------

CREATE TABLE INFORMADOS.provincia(
id_provincia int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.localidad(
id_canal int IDENTITY(1,1) PRIMARY KEY,
id_provincia int REFERENCES INFORMADOS.provincia(id_provincia),
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.codigo_postal(
id_codigo_postal decimal(18,0) PRIMARY KEY,
id_localidad int 
);

CREATE TABLE INFORMADOS.cliente(
id_cliente int IDENTITY(1,1) PRIMARY KEY,
dni decimal(18,0),
nombre nvarchar(255),
apellido nvarchar(255),
direccion nvarchar(255),
telefono decimal(18,0),
mail nvarchar(255),
fecha_nacimiento date,
localidad nvarchar(255),
codigo_postal decimal(18,0),
provincia nvarchar(255)
);

CREATE TABLE INFORMADOS.canal(
id_canal int IDENTITY(1,1) PRIMARY KEY,
nombre varchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.envio(
id_envio int IDENTITY(1,1) PRIMARY KEY,
medio nvarchar(255),
precio decimal(18,2)
);

CREATE TABLE INFORMADOS.medio_pago(
id_medio_pago int identity(1,1) PRIMARY KEY,
medio_pago nvarchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.barrio(
id_barrio int identity(1,1) PRIMARY KEY,
codigo_postal decimal(18,0),
localidad nvarchar(255),
provincia nvarchar(255)
);

CREATE TABLE INFORMADOS.venta(
id_venta int identity(1,1) PRIMARY KEY,
codigo_venta decimal(19,0),
fecha date,
id_cliente int,
id_canal int,
id_envio int,
id_medio_pago INT,
total decimal(18,2),
FOREIGN KEY (id_cliente) REFERENCES INFORMADOS.cliente(id_cliente),
FOREIGN KEY (id_canal) REFERENCES INFORMADOS.canal(id_canal),
FOREIGN KEY (id_envio) REFERENCES INFORMADOS.envio(id_envio),
FOREIGN KEY (id_medio_pago) REFERENCES INFORMADOS.medio_pago(id_medio_pago)
);

CREATE TABLE INFORMADOS.descuento(
id_descuento int IDENTITY(1,1) PRIMARY KEY,
concepto nvarchar(255),
codigo decimal(19,0),
importe decimal(18,2),
valor decimal(18,2),
id_venta int,
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta)
);


CREATE TABLE INFORMADOS.cupon(
id_cupon int IDENTITY(1,1) PRIMARY KEY,
codigo nvarchar(255),
tipo nvarchar(50),
valor decimal(18,2),
importe decimal(18,2),
fecha_inicial date,
fecha_final date
);

CREATE TABLE INFORMADOS.cupon_por_venta(
id_venta int,
id_cupon int,
PRIMARY KEY (id_venta, id_cupon),
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta),
FOREIGN KEY (id_cupon) REFERENCES INFORMADOS.cupon(id_cupon)
);

CREATE TABLE INFORMADOS.categoria(
id_categoria int identity(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.tipo_variante(
id_tipo_variante int identity(1,1) PRIMARY KEY,
tipo nvarchar(50)
);

CREATE TABLE INFORMADOS.variante(
id_variante int PRIMARY KEY,
nombre nvarchar(255),
precio decimal(18,6),
id_tipo_variante int,
FOREIGN KEY (id_tipo_variante) REFERENCES INFORMADOS.tipo_variante(id_tipo_variante)
);

CREATE TABLE INFORMADOS.producto(
id_producto nvarchar(50) PRIMARY KEY,
nombre nvarchar(255),
descripcion nvarchar(255),
material nvarchar(255),
marca nvarchar(255),
id_variante int,
id_categoria int,
FOREIGN KEY (id_variante) REFERENCES INFORMADOS.variante(id_variante),
FOREIGN KEY (id_categoria) REFERENCES INFORMADOS.categoria(id_categoria)
);

CREATE TABLE INFORMADOS.producto_por_venta(
id_venta int,
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2),
PRIMARY KEY (id_venta, id_producto),
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta),
FOREIGN KEY (id_producto) REFERENCES INFORMADOS.producto(id_producto)
);

CREATE TABLE INFORMADOS.proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
razon_social nvarchar(255),
domicilio nvarchar(255),
mail nvarchar(255),
localidad nvarchar(255),
codigo_postal decimal(18,0),
provincia nvarchar(255)
);

CREATE TABLE INFORMADOS.compra(
id_compra decimal(19,0) PRIMARY KEY,
id_proveedor nvarchar(50),
fecha date,
medio_pago nvarchar(255),
descuento decimal(18,0),
total decimal(18,2),
FOREIGN KEY (id_proveedor) REFERENCES INFORMADOS.proveedor(id_proveedor)
);

CREATE TABLE INFORMADOS.producto_por_compra(
id_compra decimal(19,0),
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2),
PRIMARY KEY (id_compra, id_producto),
FOREIGN KEY (id_compra) REFERENCES INFORMADOS.compra(id_compra),
FOREIGN KEY (id_producto) REFERENCES INFORMADOS.producto(id_producto)
);

----------------------------------------------------
-- CREACIÓN DE VISTAS
----------------------------------------------------



---------------------------------------------------
-- CREACION DE INDICES
---------------------------------------------------



---------------------------------------------------
--CREACION DE STORE PROCEDURES
---------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_ubicaciones')
	DROP PROCEDURE sp_migrar_ubicaciones
GO

CREATE PROCEDURE sp_migrar_ubicaciones
AS
BEGIN
	INSERT INTO INFORMADOS.provincia(nombre)
	SELECT DISTINCT CLIENTE_PROVINCIA
	FROM gd_esquema.Maestra

	INSERT INTO INFORMADOS.localidad(nombre, id_provincia)
	SELECT DISTINCT CLIENTE_LOCALIDAD,
		(select p.id_provincia from INFORMADOS.provincia p where p.nombre = CLIENTE_PROVINCIA)
	FROM gd_esquema.Maestra
	where CLIENTE_LOCALIDAD is not null and CLIENTE_PROVINCIA is not null
	group by CLIENTE_LOCALIDAD, CLIENTE_PROVINCIA

	INSERT INTO INFORMADOS.codigo_postal(id_codigo_postal, id_localidad)
	SELECT DISTINCT CLIENTE_CODIGO_POSTAL,
		(select l.id_canal
		from INFORMADOS.localidad l
		inner join INFORMADOS.provincia p on p.id_provincia = l.id_provincia
			where l.nombre = CLIENTE_LOCALIDAD and p.nombre = CLIENTE_PROVINCIA)
	FROM gd_esquema.Maestra
	where CLIENTE_CODIGO_POSTAL is not null and CLIENTE_LOCALIDAD is not null and CLIENTE_PROVINCIA is not null
	group by CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, CLIENTE_PROVINCIA
END
GO


CREATE TABLE INFORMADOS.provincia(
id_provincia int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.localidad(
id_canal int IDENTITY(1,1) PRIMARY KEY,
id_provincia int REFERENCES INFORMADOS.provincia(id_provincia),
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.codigo_postal(
id_codigo_postal decimal(18,0) PRIMARY KEY,
id_localidad int 
);

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_cliente')
	DROP PROCEDURE sp_migrar_cliente
GO

CREATE PROCEDURE sp_migrar_cliente
 AS
  BEGIN
    INSERT INTO INFORMADOS.cliente (dni, nombre, apellido, direccion, telefono, mail, fecha_nacimiento, localidad, codigo_postal, provincia)
	SELECT DISTINCT CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO, CLIENTE_MAIL, CLIENTE_FECHA_NAC, CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA
	FROM gd_esquema.Maestra
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_canal')
	DROP PROCEDURE sp_migrar_canal
GO

CREATE PROCEDURE sp_migrar_canal
 AS
  BEGIN
    INSERT INTO INFORMADOS.canal (nombre, costo)
	SELECT DISTINCT VENTA_CANAL, VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_envio')
	DROP PROCEDURE sp_migrar_envio
GO

CREATE PROCEDURE sp_migrar_envio
 AS
  BEGIN
    INSERT INTO INFORMADOS.envio (medio, precio)
	SELECT DISTINCT VENTA_MEDIO_ENVIO, VENTA_ENVIO_PRECIO
	FROM gd_esquema.Maestra
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medio_pago')
	DROP PROCEDURE sp_migrar_medio_pago
GO

CREATE PROCEDURE sp_migrar_medio_pago
 AS
  BEGIN
    INSERT INTO INFORMADOS.medio_pago(medio_pago, costo)
	SELECT DISTINCT VENTA_MEDIO_PAGO, VENTA_MEDIO_PAGO_COSTO
	FROM gd_esquema.Maestra
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_barrio')
	DROP PROCEDURE sp_migrar_barrio
GO


CREATE PROCEDURE sp_migrar_barrio
 AS
  BEGIN
    INSERT INTO INFORMADOS.barrio(codigo_postal, localidad, provincia)
	SELECT DISTINCT CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, CLIENTE_PROVINCIA
	FROM gd_esquema.Maestra
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_venta')
	DROP PROCEDURE sp_migrar_venta
GO

CREATE PROCEDURE sp_migrar_venta
 AS
  BEGIN
    INSERT INTO INFORMADOS.venta(codigo_venta, fecha,id_cliente, id_canal, id_envio, id_medio_pago, total)
    SELECT DISTINCT origen.VENTA_CODIGO, origen.VENTA_FECHA, cliente.id_cliente, canal.id_canal, envio.id_envio, mediopago.id_medio_pago, origen.VENTA_TOTAL
	FROM gd_esquema.Maestra AS origen
	join INFORMADOS.cliente cliente on origen.CLIENTE_NOMBRE = cliente.nombre and
		origen.CLIENTE_APELLIDO = cliente.apellido and
		origen.CLIENTE_DNI = cliente.dni and
		origen.CLIENTE_DIRECCION = cliente.direccion and
		origen.CLIENTE_TELEFONO = cliente.telefono and
		origen.CLIENTE_FECHA_NAC = cliente.fecha_nacimiento and
		origen.CLIENTE_MAIL = cliente.mail 
	join INFORMADOS.canal canal on origen.VENTA_CANAL = canal.nombre and
	    origen.VENTA_CANAL_COSTO = canal.costo
	join INFORMADOS.envio envio on origen.VENTA_MEDIO_ENVIO = envio.medio and 
	    origen.VENTA_ENVIO_PRECIO = envio.precio
	join INFORMADOS.medio_pago mediopago on origen.VENTA_MEDIO_PAGO = mediopago.id_medio_pago and
	    origen.VENTA_MEDIO_PAGO_COSTO = mediopago.costo
	WHERE cliente.id_cliente IS NOT NULL and canal.id_canal IS NOT NULL and envio.id_envio IS NOT NULL and mediopago.id_medio_pago IS NOT NULL
  END
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE sp_migrar_cliente
	EXECUTE sp_migrar_canal
	EXECUTE sp_migrar_envio
	EXECUTE sp_migrar_medio_pago

	EXECUTE sp_migrar_barrio
--	EXECUTE sp_migrar_venta

END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM INFORMADOS.cliente)
	AND EXISTS (SELECT 1 FROM INFORMADOS.canal)
	AND EXISTS (SELECT 1 FROM INFORMADOS.envio)
	AND EXISTS (SELECT 1 FROM INFORMADOS.medio_pago)
	AND EXISTS (SELECT 1 FROM INFORMADOS.barrio)
--	AND EXISTS (SELECT 1 FROM INFORMADOS.venta)
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