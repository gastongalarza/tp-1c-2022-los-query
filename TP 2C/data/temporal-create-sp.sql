USE GD2C2022

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
	SELECT DISTINCT CLIENTE_PROVINCIA FROM gd_esquema.Maestra WHERE CLIENTE_PROVINCIA is not null
	UNION
	SELECT DISTINCT PROVEEDOR_PROVINCIA FROM gd_esquema.Maestra WHERE PROVEEDOR_PROVINCIA is not null

	INSERT INTO INFORMADOS.zona(codigo_postal, localidad, id_provincia)
	SELECT DISTINCT CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD,
		(select p.id_provincia from INFORMADOS.provincia p where p.nombre = CLIENTE_PROVINCIA)
	FROM gd_esquema.Maestra
	where CLIENTE_CODIGO_POSTAL is not null and CLIENTE_LOCALIDAD is not null and CLIENTE_PROVINCIA is not null
	group by CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, CLIENTE_PROVINCIA
	UNION
	SELECT DISTINCT PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_LOCALIDAD,
		(select p.id_provincia from INFORMADOS.provincia p where p.nombre = PROVEEDOR_PROVINCIA)
	FROM gd_esquema.Maestra
	where PROVEEDOR_CODIGO_POSTAL is not null and PROVEEDOR_LOCALIDAD is not null and PROVEEDOR_PROVINCIA is not null
	group by PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_LOCALIDAD, PROVEEDOR_PROVINCIA
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_cliente')
	DROP PROCEDURE sp_migrar_cliente
GO

CREATE PROCEDURE sp_migrar_cliente
 AS
  BEGIN
    INSERT INTO INFORMADOS.cliente (dni, nombre, apellido, direccion, telefono,
		mail, fecha_nacimiento, id_zona)
	SELECT DISTINCT CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
		CLIENTE_MAIL, CLIENTE_FECHA_NAC,
		(select top 1 z.id_zona
		from INFORMADOS.zona z
		inner join INFORMADOS.provincia p on p.id_provincia = z.id_provincia
		where z.localidad = CLIENTE_LOCALIDAD and
			z.codigo_postal = CLIENTE_CODIGO_POSTAL and
			p.nombre = CLIENTE_PROVINCIA)
	FROM gd_esquema.Maestra
	WHERE CLIENTE_DNI is not null
	group by CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
		CLIENTE_MAIL, CLIENTE_FECHA_NAC, CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_proveedor')
	DROP PROCEDURE sp_migrar_proveedor
GO

CREATE PROCEDURE sp_migrar_proveedor
 AS
  BEGIN
    INSERT INTO INFORMADOS.proveedor (id_proveedor, razon_social, direccion, mail, id_zona)
	SELECT DISTINCT PROVEEDOR_CUIT, PROVEEDOR_RAZON_SOCIAL, PROVEEDOR_DOMICILIO, PROVEEDOR_MAIL,
		(select top 1 z.id_zona
		from INFORMADOS.zona z
		inner join INFORMADOS.provincia p on p.id_provincia = z.id_provincia
		where z.localidad = PROVEEDOR_LOCALIDAD and
			z.codigo_postal = PROVEEDOR_CODIGO_POSTAL and
			p.nombre = PROVEEDOR_PROVINCIA)
	FROM gd_esquema.Maestra
	WHERE PROVEEDOR_CUIT is not null
	group by PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_CUIT, PROVEEDOR_DOMICILIO, PROVEEDOR_LOCALIDAD,
		PROVEEDOR_MAIL, PROVEEDOR_PROVINCIA, PROVEEDOR_RAZON_SOCIAL
  END
GO

/*
select distinct PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_CUIT, PROVEEDOR_DOMICILIO, PROVEEDOR_LOCALIDAD, PROVEEDOR_MAIL, PROVEEDOR_PROVINCIA, PROVEEDOR_RAZON_SOCIAL
from gd_esquema.Maestra
*/

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_canal')
	DROP PROCEDURE sp_migrar_canal
GO

CREATE PROCEDURE sp_migrar_canal
 AS
  BEGIN
    INSERT INTO INFORMADOS.canal (nombre, costo)
	SELECT DISTINCT VENTA_CANAL, VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra
	where VENTA_CANAL is not null and VENTA_CANAL_COSTO is not null
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_producto')
	DROP PROCEDURE sp_migrar_producto
GO

CREATE PROCEDURE sp_migrar_producto
AS
BEGIN
	INSERT INTO INFORMADOS.categoria_producto (nombre)
	SELECT DISTINCT PRODUCTO_CATEGORIA
	FROM gd_esquema.Maestra
	where PRODUCTO_CATEGORIA is not null

	INSERT INTO INFORMADOS.producto(id_producto, nombre, descripcion, material, marca, id_categoria)
	SELECT DISTINCT PRODUCTO_CODIGO, PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_MATERIAL, PRODUCTO_MARCA,
		(select c.id_categoria
		from INFORMADOS.categoria_producto c
		where c.nombre = PRODUCTO_CATEGORIA)
	FROM gd_esquema.Maestra
	where PRODUCTO_CODIGO is not null
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_variante')
	DROP PROCEDURE sp_migrar_variante
GO

CREATE PROCEDURE sp_migrar_variante
AS
BEGIN
	INSERT INTO INFORMADOS.tipo_variante (tipo)
	SELECT DISTINCT PRODUCTO_TIPO_VARIANTE
	FROM gd_esquema.Maestra
	where PRODUCTO_TIPO_VARIANTE is not null

	INSERT INTO INFORMADOS.variante(id_variante, nombre, id_tipo_variante)
	SELECT DISTINCT PRODUCTO_VARIANTE_CODIGO, PRODUCTO_VARIANTE,
		(select tp.id_tipo_variante
		from INFORMADOS.tipo_variante tp
		where tp.tipo = PRODUCTO_TIPO_VARIANTE)
	FROM gd_esquema.Maestra
	where PRODUCTO_VARIANTE_CODIGO is not null and PRODUCTO_VARIANTE is not null
END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_envio')
	DROP PROCEDURE sp_migrar_envio
GO

CREATE PROCEDURE sp_migrar_envio
AS
BEGIN
	INSERT INTO INFORMADOS.metodo_envio (nombre)
	SELECT DISTINCT VENTA_MEDIO_ENVIO
	FROM gd_esquema.Maestra
	where VENTA_MEDIO_ENVIO is not null

	INSERT INTO INFORMADOS.envio(id_metodo_envio, id_zona, precio)
	SELECT DISTINCT m.id_metodo_envio, z.id_zona, VENTA_ENVIO_PRECIO
	FROM gd_esquema.Maestra ma
	inner join INFORMADOS.metodo_envio m on m.nombre = ma.VENTA_MEDIO_ENVIO
	inner join INFORMADOS.zona z on z.codigo_postal = CLIENTE_CODIGO_POSTAL and
		z.localidad = CLIENTE_LOCALIDAD
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_envio')
	DROP PROCEDURE sp_migrar_envio
GO

CREATE PROCEDURE sp_migrar_envio
AS
BEGIN
	INSERT INTO INFORMADOS.metodo_envio (nombre)
	SELECT DISTINCT VENTA_MEDIO_ENVIO
	FROM gd_esquema.Maestra
	where VENTA_MEDIO_ENVIO is not null

	INSERT INTO INFORMADOS.envio(id_metodo_envio, id_zona, precio)
	SELECT DISTINCT m.id_metodo_envio, z.id_zona, VENTA_ENVIO_PRECIO
	FROM gd_esquema.Maestra ma
	inner join INFORMADOS.metodo_envio m on m.nombre = ma.VENTA_MEDIO_ENVIO
	inner join INFORMADOS.zona z on z.codigo_postal = CLIENTE_CODIGO_POSTAL and
		z.localidad = CLIENTE_LOCALIDAD
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medio_pago_venta')
	DROP PROCEDURE sp_migrar_medio_pago_venta
GO

CREATE PROCEDURE sp_migrar_medio_pago_venta
AS
BEGIN
	INSERT INTO INFORMADOS.medio_pago_venta(nombre, costo)
	SELECT DISTINCT VENTA_MEDIO_PAGO, VENTA_MEDIO_PAGO_COSTO
	FROM gd_esquema.Maestra
	where VENTA_MEDIO_PAGO is not null and VENTA_MEDIO_PAGO_COSTO is not null
	group by VENTA_MEDIO_PAGO, VENTA_MEDIO_PAGO_COSTO
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medio_pago_compra')
	DROP PROCEDURE sp_migrar_medio_pago_compra
GO

CREATE PROCEDURE sp_migrar_medio_pago_compra
AS
BEGIN
	INSERT INTO INFORMADOS.medio_pago_compra(nombre)
	SELECT DISTINCT COMPRA_MEDIO_PAGO
	FROM gd_esquema.Maestra
	where COMPRA_MEDIO_PAGO is not null 
	group by COMPRA_MEDIO_PAGO
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_descuento_compra')
	DROP PROCEDURE sp_migrar_descuento_compra
GO

CREATE PROCEDURE sp_migrar_descuento_compra
AS
BEGIN
	INSERT INTO INFORMADOS.descuento_compra(id_descuento_compra, valor)
	SELECT DISTINCT DESCUENTO_COMPRA_CODIGO, DESCUENTO_COMPRA_VALOR
	FROM gd_esquema.Maestra
	where DESCUENTO_COMPRA_CODIGO is not null and DESCUENTO_COMPRA_VALOR is not null
	group by DESCUENTO_COMPRA_CODIGO, DESCUENTO_COMPRA_VALOR
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_variante_producto')
	DROP PROCEDURE sp_migrar_variante_producto
GO

CREATE PROCEDURE sp_migrar_variante_producto
AS
BEGIN
	INSERT INTO INFORMADOS.variante_producto (id_variante, id_producto)
	SELECT DISTINCT 
		(select variante.id_variante
		from INFORMADOS.variante variante
		where variante.id_variante = PRODUCTO_VARIANTE_CODIGO),
		(select prod.id_producto
		from INFORMADOS.producto prod
		where prod.id_producto = PRODUCTO_CODIGO)
	FROM gd_esquema.Maestra
	where PRODUCTO_VARIANTE_CODIGO is not null and PRODUCTO_CODIGO is not null 
	GROUP BY PRODUCTO_VARIANTE_CODIGO, PRODUCTO_CODIGO
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_compra')
	DROP PROCEDURE sp_migrar_compra
GO

CREATE PROCEDURE sp_migrar_compra
AS
BEGIN
	INSERT INTO INFORMADOS.compra (id_compra, id_proveedor, fecha, id_medio_pago, id_descuento, total)
	SELECT DISTINCT COMPRA_NUMERO, (select prov.id_proveedor from INFORMADOS.proveedor prov where prov.id_proveedor = PROVEEDOR_CUIT), COMPRA_FECHA, 		(select mpc.id_medio_pago_compra from INFORMADOS.medio_pago_compra mpc where mpc.nombre = COMPRA_MEDIO_PAGO), (select dc.id_descuento_compra from INFORMADOS.descuento_compra dc where dc.id_descuento_compra = DESCUENTO_COMPRA_CODIGO), COMPRA_TOTAL
	FROM gd_esquema.Maestra
	where COMPRA_NUMERO is not null and PROVEEDOR_CUIT is not null and COMPRA_FECHA is not null and COMPRA_MEDIO_PAGO is not null and DESCUENTO_COMPRA_CODIGO is not null and COMPRA_TOTAL is not null
	GROUP BY COMPRA_NUMERO, PROVEEDOR_CUIT, COMPRA_FECHA, COMPRA_MEDIO_PAGO, DESCUENTO_COMPRA_CODIGO, COMPRA_TOTAL
END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_producto_por_compra')
	DROP PROCEDURE sp_migrar_producto_por_compra
GO

CREATE PROCEDURE sp_migrar_producto_por_compra
AS
BEGIN
	INSERT INTO INFORMADOS.producto_por_compra (id_compra, id_producto, cantidad, precio)
	SELECT DISTINCT comp.id_compra, p.id_producto, ma.COMPRA_PRODUCTO_CANTIDAD, ma.COMPRA_PRODUCTO_PRECIO
	FROM gd_esquema.Maestra ma
	join INFORMADOS.compra comp
	    on comp.id_compra = ma.COMPRA_NUMERO
	join INFORMADOS.producto p
	   on p.id_producto = ma.PRODUCTO_CODIGO
	WHERE ma.DESCUENTO_COMPRA_CODIGO is not null and  ma.PRODUCTO_VARIANTE_CODIGO is not null and ma.PRODUCTO_CODIGO is not null
END
GO

CREATE PROCEDURE sp_migrar_tipo_descuento_venta
 AS
  BEGIN
    INSERT INTO INFORMADOS.tipo_descuento_venta (concepto_descuento)
		select distinct VENTA_DESCUENTO_CONCEPTO 
		from gd_esquema.Maestra where VENTA_DESCUENTO_CONCEPTO is not null
END
GO

CREATE PROCEDURE sp_migrar_descuento_venta
 AS
  BEGIN

  	INSERT INTO INFORMADOS.descuento_venta(id_medio_pago_venta,id_tipo_descuento_venta,importe_descuento)
		select tt.id_medio_pago,tt.id_tipo_descuento_venta,VENTA_DESCUENTO_IMPORTE
		from (SELECT distinct VENTA_CODIGO,mp.id_medio_pago,td.id_tipo_descuento_venta,VENTA_DESCUENTO_IMPORTE
				FROM gd_esquema.Maestra m1
				left join INFORMADOS.medio_pago_venta mp
				on m1.VENTA_DESCUENTO_CONCEPTO = mp.medio_pago
				left join INFORMADOS.tipo_descuento_venta td
				on m1.VENTA_DESCUENTO_CONCEPTO=td.concepto_descuento
				where m1.VENTA_DESCUENTO_CONCEPTO is not null ) tt

    INSERT INTO INFORMADOS.descuento_por_venta(id_descuento_venta,id_venta)
		select distinct dd.id_descuento_venta,m1.VENTA_CODIGO
		from INFORMADOS.descuento_venta dd
		join INFORMADOS.tipo_descuento_venta td
		on dd.id_tipo_descuento_venta = td.id_tipo_descuento_venta
		join (select distinct VENTA_CODIGO,VENTA_DESCUENTO_IMPORTE,VENTA_DESCUENTO_CONCEPTO 		from gd_esquema.Maestra where VENTA_DESCUENTO_IMPORTE is not null) m1
		on dd.importe_descuento  = m1.VENTA_DESCUENTO_IMPORTE and td.concepto_descuento = 		m1.VENTA_DESCUENTO_CONCEPTO

END
GO


---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

EXECUTE sp_migrar_ubicaciones
EXECUTE sp_migrar_producto
EXECUTE sp_migrar_cliente
EXECUTE sp_migrar_variante
EXECUTE sp_migrar_envio
EXECUTE sp_migrar_medio_pago_venta
EXECUTE sp_migrar_proveedor
EXECUTE sp_migrar_medio_pago_compra
EXECUTE sp_migrar_descuento_compra
EXECUTE sp_migrar_variante_producto
EXECUTE sp_migrar_compra
EXECUTE sp_migrar_producto_por_compra

/*
 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE sp_migrar_ubicaciones
	EXECUTE sp_migrar_producto
	EXECUTE sp_migrar_cliente
	EXECUTE sp_migrar_canal
	EXECUTE sp_migrar_envio

	EXECUTE sp_migrar_medio_pago

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
*/