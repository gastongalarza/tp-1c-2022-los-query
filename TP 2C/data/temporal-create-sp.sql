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

	INSERT INTO INFORMADOS.zona(codigo_postal, localidad, id_provincia)
	SELECT DISTINCT CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD,
		(select p.id_provincia
		from INFORMADOS.provincia p
		where p.nombre = CLIENTE_PROVINCIA)
	FROM gd_esquema.Maestra
	where CLIENTE_CODIGO_POSTAL is not null and CLIENTE_LOCALIDAD is not null and CLIENTE_PROVINCIA is not null
	group by CLIENTE_CODIGO_POSTAL, CLIENTE_LOCALIDAD, CLIENTE_PROVINCIA
END
GO

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