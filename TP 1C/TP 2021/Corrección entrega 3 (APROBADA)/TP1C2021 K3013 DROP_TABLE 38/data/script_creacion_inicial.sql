USE GD1C2021
GO

PRINT 'Iniciando creación y migración de modelo OLTP'

--DROP PREVENTIVO DE TABLAS-------------------------
--Drop de Tablas OLTP--
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'ventas_pc')
DROP TABLE DROP_TABLE.ventas_pc
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'ventas_accesorio')
DROP TABLE DROP_TABLE.ventas_accesorio
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compras_pc')
DROP TABLE DROP_TABLE.compras_pc
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compras_accesorio')
DROP TABLE DROP_TABLE.compras_accesorio
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'pcs_placas_video')
DROP TABLE DROP_TABLE.pcs_placas_video
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'pcs_memorias_ram')
DROP TABLE DROP_TABLE.pcs_memorias_ram
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'pcs_discos_rigidos')
DROP TABLE DROP_TABLE.pcs_discos_rigidos
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'pcs')
DROP TABLE DROP_TABLE.pcs
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'discos_rigidos')
DROP TABLE DROP_TABLE.discos_rigidos
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'memorias_ram')
DROP TABLE DROP_TABLE.memorias_ram
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'placas_video')
DROP TABLE DROP_TABLE.placas_video
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'microprocesadores')
DROP TABLE DROP_TABLE.microprocesadores
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'clientes')
DROP TABLE DROP_TABLE.clientes 
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'sucursales')
DROP TABLE DROP_TABLE.sucursales
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'accesorios')
DROP TABLE DROP_TABLE.accesorios

--Drop de Tablas BI--
IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_fact_compras_pc')
DROP TABLE  DROP_TABLE.BI_fact_compras_pc

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_fact_ventas_pc')
DROP TABLE  DROP_TABLE.BI_fact_ventas_pc

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_fact_compras_accesorio')
DROP TABLE  DROP_TABLE.BI_fact_compras_accesorio

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_fact_ventas_accesorio')
DROP TABLE  DROP_TABLE.BI_fact_ventas_accesorio

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_bri_pc_discos_rigidos')
DROP TABLE  DROP_TABLE.BI_bri_pc_discos_rigidos

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_bri_pc_placas_video')
DROP TABLE  DROP_TABLE.BI_bri_pc_placas_video

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_bri_pc_memorias_ram')
DROP TABLE  DROP_TABLE.BI_bri_pc_memorias_ram

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_tiempos')
DROP TABLE  DROP_TABLE.BI_dim_tiempos

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_sucursales')
DROP TABLE  DROP_TABLE.BI_dim_sucursales

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_pcs')
DROP TABLE  DROP_TABLE.BI_dim_pcs

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_discos_rigidos')
DROP TABLE  DROP_TABLE.BI_dim_discos_rigidos

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_procesadores')
DROP TABLE  DROP_TABLE.BI_dim_procesadores

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_memorias_ram')
DROP TABLE  DROP_TABLE.BI_dim_memorias_ram

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_placas_video')
DROP TABLE  DROP_TABLE.BI_dim_placas_video

IF EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_dim_accesorios')
DROP TABLE  DROP_TABLE.BI_dim_accesorios

--DROP PREVENTIVO DE PROCEDURES DE BI--
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_discos_rigidos')
DROP PROCEDURE DROP_TABLE.BI_migrar_discos_rigidos

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_memorias_ram')
DROP PROCEDURE DROP_TABLE.BI_migrar_memorias_ram

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_placas_video')
DROP PROCEDURE DROP_TABLE.BI_migrar_placas_video

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_procesadores')
DROP PROCEDURE DROP_TABLE.BI_migrar_procesadores

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_pcs')
DROP PROCEDURE DROP_TABLE.BI_migrar_pcs

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_pcs_discos_rigidos')
DROP PROCEDURE DROP_TABLE.BI_migrar_pcs_discos_rigidos

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_pcs_memorias_ram')
DROP PROCEDURE DROP_TABLE.BI_migrar_pcs_memorias_ram

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_pcs_placas_video')
DROP PROCEDURE DROP_TABLE.BI_migrar_pcs_placas_video

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_accesorios')
DROP PROCEDURE DROP_TABLE.BI_migrar_accesorios

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_sucursales')
DROP PROCEDURE DROP_TABLE.BI_migrar_sucursales

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_tiempos_ventas')
DROP PROCEDURE DROP_TABLE.BI_migrar_tiempos_ventas

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_tiempos_compras_accesorio')
DROP PROCEDURE DROP_TABLE.BI_migrar_tiempos_compras_accesorio

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_tiempos_compras_pc')
DROP PROCEDURE DROP_TABLE.BI_migrar_tiempos_compras_pc

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_tiempos_ventas_pc')
DROP PROCEDURE DROP_TABLE.BI_migrar_tiempos_ventas_pc

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_tiempos_ventas_accesorios')
DROP PROCEDURE DROP_TABLE.BI_migrar_tiempos_ventas_accesorios

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_compras_pc')
DROP PROCEDURE DROP_TABLE.BI_migrar_compras_pc

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_compras_accesorio')
DROP PROCEDURE DROP_TABLE.BI_migrar_compras_accesorio

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_ventas_pc')
DROP PROCEDURE DROP_TABLE.BI_migrar_ventas_pc

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'BI_migrar_ventas_accesorio')
DROP PROCEDURE DROP_TABLE.BI_migrar_ventas_accesorio

--DROP PREVENTIVO DE FUNCIONES DE BI--
IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'getAgeRange')
	DROP FUNCTION DROP_TABLE.getAgeRange

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'getAge')
	DROP FUNCTION DROP_TABLE.getAge

--DROP PREVENTIVO DE VISTAS-------------------------
--Vistas OLTP
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_Sucursales')
DROP VIEW DROP_TABLE.v_Sucursales
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_Clientes')
DROP VIEW DROP_TABLE.v_Clientes
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_Facturas_Sucursal')
DROP VIEW DROP_TABLE.v_Facturas_Sucursal
GO
--Vistas de BI
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_TiempoStockPromedioPC')
DROP VIEW DROP_TABLE.v_TiempoStockPromedioPC
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_PrecioPromedioPC')
DROP VIEW DROP_TABLE.v_PrecioPromedioPC
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_CantidadPCsxsucursalxmes')
DROP VIEW DROP_TABLE.v_CantidadPCsxsucursalxmes
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_GananciasPC') 
DROP VIEW DROP_TABLE.v_GananciasPC
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_PrecioPromedioAcc')
DROP VIEW DROP_TABLE.v_PrecioPromedioAcc
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_GananciasAccesorios') 
DROP VIEW DROP_TABLE.v_GananciasAccesorios
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_TiempoStockPromedioAcc')
DROP VIEW DROP_TABLE.v_TiempoStockPromedioAcc
GO
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'v_MaxStockxSucursalAnualAcc')
DROP VIEW DROP_TABLE.v_MaxStockxSucursalAnualAcc
GO
--DROP PREVENTIVO DE SCHEMA-------------------------
IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'DROP_TABLE')
DROP SCHEMA DROP_TABLE
GO

--CREACIÓN DE SCHEMA--------------------------------
CREATE SCHEMA DROP_TABLE;
GO

--CREACIÓN DE TABLAS--------------------------------
CREATE TABLE DROP_TABLE.sucursales(
CODIGO_SUCURSAL int IDENTITY PRIMARY KEY,
DIRECCION nvarchar(255) not null,
MAIL nvarchar(255) null,
TELEFONO decimal(18,0) null,
CIUDAD nvarchar(255) null
);

CREATE TABLE DROP_TABLE.clientes (
CODIGO_CLIENTE decimal(18,0) IDENTITY PRIMARY KEY,
DNI_CLIENTE decimal(18,0) not null,
APELLIDO nvarchar(255) null,
NOMBRE nvarchar(255) null,
DIRECCION nvarchar(255) null,
FECHA_NACIMIENTO datetime2(3) null,
MAIL nvarchar(255) null,
TELEFONO int null
);

CREATE TABLE DROP_TABLE.accesorios(
CODIGO_ACCESORIO decimal(18,0) PRIMARY KEY,
DESCRIPCION nvarchar(255) not null,
);

CREATE TABLE DROP_TABLE.microprocesadores(
MICROPROCESADOR_CODIGO nvarchar(50) PRIMARY KEY,
CANTIDAD_HILOS decimal(18,0) null,
CACHE nvarchar(50) null,
VELOCIDAD nvarchar(50) null,
FABRICANTE nvarchar(255) not null
)

CREATE TABLE DROP_TABLE.pcs(
PC_CODIGO nvarchar(50) PRIMARY KEY,
ALTO decimal(18,2) null,
ANCHO decimal(18,2) null,
PROFUNDIDAD decimal(18,2) null,
MICROPROCESADOR_CODIGO nvarchar(50) REFERENCES DROP_TABLE.microprocesadores not null
)

CREATE TABLE DROP_TABLE.ventas_pc(
CODIGO_VENTA_PC decimal(18,0) IDENTITY PRIMARY KEY,
FACTURA_NUMERO decimal(18,0),
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.pcs,
CODIGO_CLIENTE decimal(18,0) REFERENCES DROP_TABLE.clientes,
CANTIDAD decimal(18,0),
PRECIO decimal(18,2),
FECHA datetime2(3),
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.sucursales
)

CREATE TABLE DROP_TABLE.ventas_accesorio(
CODIGO_VENTA_ACCESORIO decimal(18,0) IDENTITY PRIMARY KEY,
FACTURA_NUMERO decimal(18,0),
CODIGO_ACCESORIO decimal(18,0) REFERENCES DROP_TABLE.accesorios,
CODIGO_CLIENTE decimal(18,0) REFERENCES DROP_TABLE.clientes,
CANTIDAD decimal(18,0),
PRECIO decimal(18,2),
FECHA datetime2(3),
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.sucursales
)

CREATE TABLE DROP_TABLE.compras_accesorio(
CODIGO_COMPRA_ACCESORIO decimal(18,0) IDENTITY PRIMARY KEY,
NUMERO decimal(18,0) not null,
CODIGO_ACCESORIO decimal(18,0) REFERENCES DROP_TABLE.accesorios not null,
FECHA datetime2(3) not null,
CANTIDAD decimal(18,0) not null,
PRECIO  decimal(18,2) not null,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.sucursales not  null,
);

CREATE TABLE DROP_TABLE.compras_pc(
CODIGO_COMPRA_PC decimal(18,0) IDENTITY PRIMARY KEY,
NUMERO decimal(18,0) not null,
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.pcs not null,
FECHA datetime2(3) not null,
CANTIDAD decimal(18,0) not null,
PRECIO decimal (18,2) not null,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.sucursales not null
)

CREATE TABLE DROP_TABLE.discos_rigidos(
DISCO_RIGIDO_CODIGO nvarchar(255) PRIMARY KEY,
TIPO nvarchar(255) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(255) null,
FABRICANTE nvarchar(255) not null
)

CREATE TABLE DROP_TABLE.pcs_discos_rigidos(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.pcs,
DISCO_RIGIDO_CODIGO nvarchar(255) REFERENCES DROP_TABLE.discos_rigidos,
PRIMARY KEY (PC_CODIGO, DISCO_RIGIDO_CODIGO)
)

CREATE TABLE DROP_TABLE.memorias_ram(
MEMORIA_RAM_CODIGO nvarchar(255) PRIMARY KEY,
TIPO nvarchar(255) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(255) null,
FABRICANTE nvarchar(255) not null
)

CREATE TABLE DROP_TABLE.pcs_memorias_ram(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.pcs,
MEMORIA_RAM_CODIGO nvarchar(255) REFERENCES DROP_TABLE.memorias_ram,
PRIMARY KEY (PC_CODIGO, MEMORIA_RAM_CODIGO)
)

CREATE TABLE DROP_TABLE.placas_video(
PLACA_VIDEO_CODIGO decimal(18,0) IDENTITY PRIMARY KEY,
MODELO_PLACA_VIDEO nvarchar(50) null,
CHIPSET nvarchar(50) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(50) null,
FABRICANTE nvarchar(255) not null
)

CREATE TABLE DROP_TABLE.pcs_placas_video(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.pcs,
PLACA_VIDEO_CODIGO decimal(18,0) REFERENCES DROP_TABLE.placas_video,
PRIMARY KEY (PC_CODIGO, PLACA_VIDEO_CODIGO)
)

GO

--CREACIÓN DE VISTAS--------------------------------

CREATE VIEW DROP_TABLE.v_Clientes AS
	SELECT [codigo_cliente],[dni_cliente],[apellido],[nombre],[direccion],[fecha_nacimiento],[mail],[telefono] 
	FROM [DROP_TABLE].[clientes]
GO

CREATE VIEW DROP_TABLE.v_Facturas_Sucursal AS
	SELECT a.CODIGO_CLIENTE, p.[factura_numero]AS factura_pc,p.[fecha] AS fecha_pc, a.[factura_numero]AS factura_accesorio,a.[fecha] AS fecha_accesorio
	FROM [DROP_TABLE].[ventas_pc] p JOIN [DROP_TABLE].[ventas_accesorio] a ON a.CODIGO_CLIENTE = p.CODIGO_CLIENTE
GO

CREATE VIEW DROP_TABLE.v_Sucursales AS
	SELECT [codigo_sucursal],[direccion],[mail],[telefono],[ciudad]
	FROM [DROP_TABLE].[sucursales]
GO
  
--CREACIÓN DE STORED PROCEDURES PARA MIGRACIÓN-------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_memorias_ram')
	DROP PROCEDURE migrar_memorias_ram
GO

CREATE PROCEDURE migrar_memorias_ram
 AS
  BEGIN
    INSERT INTO DROP_TABLE.memorias_ram (MEMORIA_RAM_CODIGO, TIPO, CAPACIDAD, VELOCIDAD, FABRICANTE)
	SELECT DISTINCT MEMORIA_RAM_CODIGO, MEMORIA_RAM_TIPO, MEMORIA_RAM_CAPACIDAD, MEMORIA_RAM_VELOCIDAD, MEMORIA_RAM_FABRICANTE
	FROM gd_esquema.Maestra
	WHERE MEMORIA_RAM_CODIGO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_discos_rigidos')
	DROP PROCEDURE migrar_discos_rigidos
GO

CREATE PROCEDURE migrar_discos_rigidos
 AS
  BEGIN
    INSERT INTO DROP_TABLE.discos_rigidos(DISCO_RIGIDO_CODIGO, TIPO, CAPACIDAD, VELOCIDAD, FABRICANTE)
	SELECT DISTINCT DISCO_RIGIDO_CODIGO, DISCO_RIGIDO_TIPO, DISCO_RIGIDO_CAPACIDAD, DISCO_RIGIDO_VELOCIDAD, DISCO_RIGIDO_FABRICANTE
	FROM gd_esquema.Maestra
	WHERE DISCO_RIGIDO_CODIGO IS NOT NULL
  END
  
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_placas_video')
	DROP PROCEDURE migrar_placas_video
GO

CREATE PROCEDURE migrar_placas_video
 AS
  BEGIN
    INSERT INTO DROP_TABLE.placas_video(CHIPSET, MODELO_PLACA_VIDEO, CAPACIDAD, VELOCIDAD, FABRICANTE)
	SELECT DISTINCT PLACA_VIDEO_CHIPSET, PLACA_VIDEO_MODELO, PLACA_VIDEO_CAPACIDAD, PLACA_VIDEO_VELOCIDAD, PLACA_VIDEO_FABRICANTE
	FROM gd_esquema.Maestra
	WHERE PLACA_VIDEO_CHIPSET IS NOT NULL AND PLACA_VIDEO_MODELO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_microprocesadores')
	DROP PROCEDURE migrar_microprocesadores
GO

CREATE PROCEDURE migrar_microprocesadores
 AS
  BEGIN
    INSERT INTO DROP_TABLE.microprocesadores (MICROPROCESADOR_CODIGO, CACHE, CANTIDAD_HILOS, FABRICANTE, VELOCIDAD)
	SELECT DISTINCT MICROPROCESADOR_CODIGO, MICROPROCESADOR_CACHE, MICROPROCESADOR_CANT_HILOS, MICROPROCESADOR_FABRICANTE, MICROPROCESADOR_VELOCIDAD
	FROM gd_esquema.Maestra
	WHERE MICROPROCESADOR_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_pcs')
	DROP PROCEDURE migrar_pcs
GO

CREATE PROCEDURE migrar_pcs
 AS
  BEGIN
    INSERT INTO DROP_TABLE.pcs(PC_CODIGO, ALTO, ANCHO, PROFUNDIDAD, MICROPROCESADOR_CODIGO)
	SELECT DISTINCT PC_CODIGO, PC_ALTO, PC_ANCHO, PC_PROFUNDIDAD, MICROPROCESADOR_CODIGO
	FROM gd_esquema.Maestra
	WHERE PC_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_discos_por_pc')
	DROP PROCEDURE migrar_discos_por_pc
GO

CREATE PROCEDURE migrar_discos_por_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.pcs_discos_rigidos(PC_CODIGO, DISCO_RIGIDO_CODIGO)
	SELECT DISTINCT PC_CODIGO, DISCO_RIGIDO_CODIGO
	FROM gd_esquema.Maestra
	WHERE PC_CODIGO IS NOT NULL AND DISCO_RIGIDO_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_placas_por_pc')
	DROP PROCEDURE migrar_placas_por_pc
GO

CREATE PROCEDURE migrar_placas_por_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.pcs_placas_video(PC_CODIGO, PLACA_VIDEO_CODIGO)
	SELECT DISTINCT M.PC_CODIGO, Aux.PLACA_VIDEO_CODIGO 
	FROM gd_esquema.Maestra AS M JOIN (SELECT PLACA_VIDEO_CODIGO, MODELO_PLACA_VIDEO, CHIPSET FROM DROP_TABLE.placas_video) as Aux
	                        ON M.PLACA_VIDEO_CHIPSET = Aux.CHIPSET AND M.PLACA_VIDEO_MODELO = Aux.MODELO_PLACA_VIDEO
	WHERE PC_CODIGO IS NOT NULL AND PLACA_VIDEO_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_memorias_por_pc')
	DROP PROCEDURE migrar_memorias_por_pc
GO

CREATE PROCEDURE migrar_memorias_por_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.pcs_memorias_ram(PC_CODIGO, MEMORIA_RAM_CODIGO)
	SELECT DISTINCT PC_CODIGO, MEMORIA_RAM_CODIGO
	FROM gd_esquema.Maestra 
	WHERE PC_CODIGO IS NOT NULL AND MEMORIA_RAM_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_clientes')
	DROP PROCEDURE migrar_clientes
GO

CREATE PROCEDURE migrar_clientes
 AS
  BEGIN
    INSERT INTO DROP_TABLE.clientes(DNI_CLIENTE,NOMBRE,APELLIDO,FECHA_NACIMIENTO,MAIL,DIRECCION,TELEFONO)
	SELECT DISTINCT CLIENTE_DNI, CLIENTE_NOMBRE, CLIENTE_APELLIDO, CLIENTE_FECHA_NACIMIENTO, CLIENTE_MAIL, CLIENTE_DIRECCION, CLIENTE_TELEFONO
	FROM gd_esquema.Maestra 
	WHERE CLIENTE_DNI IS NOT NULL 
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_sucursales')
	DROP PROCEDURE migrar_sucursales
GO

CREATE PROCEDURE migrar_sucursales
 AS
  BEGIN
    INSERT INTO DROP_TABLE.sucursales(CIUDAD,DIRECCION,MAIL,TELEFONO)
	SELECT DISTINCT CIUDAD, SUCURSAL_DIR, SUCURSAL_MAIL, SUCURSAL_TEL
	FROM gd_esquema.Maestra 
	WHERE SUCURSAL_DIR IS NOT NULL 
  END

 GO
 
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_accesorios')
	DROP PROCEDURE migrar_accesorios
GO

CREATE PROCEDURE migrar_accesorios
 AS
  BEGIN
    INSERT INTO DROP_TABLE.accesorios(CODIGO_ACCESORIO,DESCRIPCION)
	SELECT DISTINCT ACCESORIO_CODIGO, AC_DESCRIPCION
	FROM gd_esquema.Maestra 
	WHERE ACCESORIO_CODIGO IS NOT NULL 
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_compras_accesorio')
	DROP PROCEDURE migrar_compras_accesorio
GO

CREATE PROCEDURE migrar_compras_accesorio
 AS
  BEGIN
    INSERT INTO DROP_TABLE.compras_accesorio(CODIGO_ACCESORIO, CODIGO_SUCURSAL, CANTIDAD, FECHA, NUMERO, PRECIO)
	SELECT DISTINCT ACCESORIO_CODIGO, CODIGO_SUCURSAL, COMPRA_CANTIDAD, COMPRA_FECHA, COMPRA_NUMERO, COMPRA_PRECIO
	FROM gd_esquema.Maestra AS M JOIN DROP_TABLE.sucursales AS S
							ON M.SUCURSAL_DIR = S.DIRECCION
							AND M.SUCURSAL_MAIL = SUCURSAL_MAIL
	WHERE ACCESORIO_CODIGO IS NOT NULL AND COMPRA_NUMERO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_compras_pc')
	DROP PROCEDURE migrar_compras_pc
GO

CREATE PROCEDURE migrar_compras_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.compras_pc(PC_CODIGO, CODIGO_SUCURSAL, CANTIDAD, FECHA, NUMERO, PRECIO)
	SELECT PC_CODIGO, CODIGO_SUCURSAL, COMPRA_CANTIDAD, COMPRA_FECHA, COMPRA_NUMERO, COMPRA_PRECIO
	FROM gd_esquema.Maestra AS M JOIN DROP_TABLE.sucursales AS S
							ON M.SUCURSAL_DIR = S.DIRECCION
							AND M.SUCURSAL_MAIL = SUCURSAL_MAIL
	WHERE PC_CODIGO IS NOT NULL AND COMPRA_NUMERO  IS NOT NULL
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_placas_por_pc')
	DROP PROCEDURE migrar_placas_por_pc
GO

CREATE PROCEDURE migrar_placas_por_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.pcs_placas_video(PC_CODIGO, PLACA_VIDEO_CODIGO)
	SELECT DISTINCT M.PC_CODIGO, Aux.PLACA_VIDEO_CODIGO 
	FROM gd_esquema.Maestra AS M JOIN (SELECT PLACA_VIDEO_CODIGO, MODELO_PLACA_VIDEO, CHIPSET FROM DROP_TABLE.placas_video) as Aux
	                        ON M.PLACA_VIDEO_CHIPSET = Aux.CHIPSET AND M.PLACA_VIDEO_MODELO = Aux.MODELO_PLACA_VIDEO
	WHERE PC_CODIGO IS NOT NULL AND PLACA_VIDEO_CODIGO IS NOT NULL
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_ventas_pc')
	DROP PROCEDURE migrar_ventas_pc
GO

CREATE PROCEDURE migrar_ventas_pc
 AS
  BEGIN
    INSERT INTO DROP_TABLE.ventas_pc(FACTURA_NUMERO, PC_CODIGO, CODIGO_CLIENTE, CANTIDAD, PRECIO, FECHA, CODIGO_SUCURSAL)
	SELECT FACTURA_NUMERO, PC_CODIGO, CODIGO_CLIENTE, Count(PC_CODIGO) AS CANTIDAD, (SELECT TOP 1 COMPRA_PRECIO FROM gd_esquema.Maestra c WHERE c.PC_CODIGO = a.PC_CODIGO)*1.2 AS PRECIO_VENTA, FACTURA_FECHA, CODIGO_SUCURSAL
	FROM gd_esquema.Maestra a JOIN DROP_TABLE.clientes b ON a.CLIENTE_DNI = b.DNI_CLIENTE AND a.CLIENTE_DIRECCION = b.DIRECCION
							  JOIN DROP_TABLE.sucursales s ON a.SUCURSAL_MAIL = s.MAIL
	WHERE PC_CODIGO IS NOT NULL 
	GROUP BY FACTURA_NUMERO, PC_CODIGO, CODIGO_CLIENTE, FACTURA_FECHA, CODIGO_SUCURSAL, COMPRA_PRECIO 
  END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_ventas_accesorio')
	DROP PROCEDURE migrar_ventas_accesorio
GO

CREATE PROCEDURE migrar_ventas_accesorio
 AS
  BEGIN
    INSERT INTO DROP_TABLE.ventas_accesorio(FACTURA_NUMERO, CODIGO_ACCESORIO, CODIGO_CLIENTE, CANTIDAD, PRECIO, FECHA, CODIGO_SUCURSAL)
	SELECT FACTURA_NUMERO, ACCESORIO_CODIGO, CODIGO_CLIENTE, Count(ACCESORIO_CODIGO) AS CANTIDAD, ((SELECT TOP 1 COMPRA_PRECIO FROM gd_esquema.Maestra c WHERE c.ACCESORIO_CODIGO = a.ACCESORIO_CODIGO)*1.2) AS PRECIO_VENTA, FACTURA_FECHA, CODIGO_SUCURSAL
	FROM gd_esquema.Maestra a JOIN DROP_TABLE.clientes b ON a.CLIENTE_DNI = b.DNI_CLIENTE AND a.CLIENTE_DIRECCION = b.DIRECCION
							  JOIN DROP_TABLE.sucursales s ON a.SUCURSAL_MAIL = s.MAIL
	WHERE ACCESORIO_CODIGO IS NOT NULL 
	GROUP BY FACTURA_NUMERO, ACCESORIO_CODIGO, CODIGO_CLIENTE, FACTURA_FECHA, CODIGO_SUCURSAL, COMPRA_PRECIO 
  END

GO 
		
--EJECUCIÓN DE STORED PROCEDURES: MIGRACIÓN-----------------------------

 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE migrar_memorias_ram
	EXECUTE migrar_discos_rigidos
	EXECUTE migrar_placas_video
	EXECUTE migrar_microprocesadores
	EXECUTE migrar_pcs
	EXECUTE migrar_discos_por_pc
	EXECUTE migrar_placas_por_pc
	EXECUTE migrar_memorias_por_pc
	EXECUTE migrar_clientes
	EXECUTE migrar_sucursales
	EXECUTE migrar_accesorios
	EXECUTE migrar_compras_accesorio
    EXECUTE migrar_compras_pc
	EXECUTE migrar_ventas_pc
	EXECUTE migrar_ventas_accesorio
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
	THROW 50001, 'Error al migrar las tablas, verifique que las nuevas tablas se encuentren vacías o bien ejecute un DROP de todas las nuevas tablas y vuelva a intentarlo.',1;
END CATCH

   IF (EXISTS (SELECT 1 FROM DROP_TABLE.memorias_ram)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.accesorios)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.clientes)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.compras_accesorio)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.compras_pc)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.discos_rigidos)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.microprocesadores)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.pcs)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.pcs_discos_rigidos)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.pcs_memorias_ram)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.pcs_placas_video)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.placas_video)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.sucursales))
   AND EXISTS (SELECT 1 FROM DROP_TABLE.ventas_pc)
   AND EXISTS (SELECT 1 FROM DROP_TABLE.ventas_accesorio)
   
   BEGIN
	PRINT 'Tablas migradas correctamente.';
	COMMIT TRANSACTION;
   END
	 ELSE
   BEGIN
    ROLLBACK TRANSACTION;
	THROW 50002, 'Hubo un error al migrar una o más tablas. Todos los cambios fueron deshechos, ninguna tabla fue cargada en la base.',1;
   END
   
GO


--CREACIÓN DE INDICES-----------------

CREATE INDEX idx_clienteventapc
ON DROP_TABLE.ventas_pc(CODIGO_CLIENTE,CODIGO_VENTA_PC);

CREATE INDEX idx_clienteventaaccesorio
ON DROP_TABLE.ventas_accesorio(CODIGO_CLIENTE,CODIGO_VENTA_ACCESORIO);

CREATE INDEX idx_compraaccesoriosucursal
ON DROP_TABLE.compras_accesorio(CODIGO_COMPRA_ACCESORIO,CODIGO_SUCURSAL);

CREATE INDEX idx_comprapcsucursal
ON DROP_TABLE.compras_pc(CODIGO_COMPRA_PC,CODIGO_SUCURSAL);

CREATE UNIQUE INDEX idx_pcsdiscosrigidos
ON DROP_TABLE.pcs_discos_rigidos(PC_CODIGO,DISCO_RIGIDO_CODIGO);

CREATE UNIQUE INDEX idx_pcsmemoriasram
ON DROP_TABLE.pcs_memorias_ram(PC_CODIGO,MEMORIA_RAM_CODIGO);

CREATE UNIQUE INDEX idx_pcsplacasvideo
ON DROP_TABLE.pcs_placas_video(PC_CODIGO,PLACA_VIDEO_CODIGO);

CREATE INDEX idx_pccompraspc
ON DROP_TABLE.compras_pc(PC_CODIGO,CODIGO_COMPRA_PC);

CREATE INDEX idx_pcventaspc
ON DROP_TABLE.ventas_pc(CODIGO_VENTA_PC,PC_CODIGO);

CREATE INDEX idx_accesorioscomprasaccesorio
ON DROP_TABLE.compras_accesorio(CODIGO_COMPRA_ACCESORIO,CODIGO_ACCESORIO);

CREATE INDEX idx_accesoriosventasaccesorio
ON DROP_TABLE.ventas_accesorio(CODIGO_VENTA_ACCESORIO,CODIGO_ACCESORIO);

CREATE INDEX idx_fechascomprasacc
ON DROP_TABLE.compras_accesorio(fecha DESC);

CREATE INDEX idx_fechascompraspc
ON DROP_TABLE.compras_pc(fecha DESC);


GO



--DROP DE TABLAS-----------------
/*
DROP TABLE DROP_TABLE.ventas_pc
DROP TABLE DROP_TABLE.ventas_accesorio
DROP TABLE DROP_TABLE.compras_pc
DROP TABLE DROP_TABLE.compras_accesorio
DROP TABLE DROP_TABLE.pcs_placas_video
DROP TABLE DROP_TABLE.pcs_memorias_ram
DROP TABLE DROP_TABLE.pcs_discos_rigidos
DROP TABLE DROP_TABLE.pcs
DROP TABLE DROP_TABLE.discos_rigidos
DROP TABLE DROP_TABLE.memorias_ram
DROP TABLE DROP_TABLE.placas_video
DROP TABLE DROP_TABLE.microprocesadores
DROP TABLE DROP_TABLE.clientes 
DROP TABLE DROP_TABLE.sucursales
DROP TABLE DROP_TABLE.accesorios

--DROP DE PROCEDURES-------------
DROP PROCEDURE migrar_memorias_ram
DROP PROCEDURE migrar_discos_rigidos
DROP PROCEDURE migrar_placas_video
DROP PROCEDURE migrar_microprocesadores
DROP PROCEDURE migrar_pcs
DROP PROCEDURE migrar_discos_por_pc
DROP PROCEDURE migrar_placas_por_pc
DROP PROCEDURE migrar_memorias_por_pc
DROP PROCEDURE migrar_clientes
DROP PROCEDURE migrar_sucursales
DROP PROCEDURE migrar_accesorios
DROP PROCEDURE migrar_compras_accesorio
DROP PROCEDURE migrar_compras_pc
*/

--DROP DE VISTAS-----------------
/*
DROP VIEW DROP_TABLE.v_Clientes;
DROP VIEW DROP_TABLE.v_Sucursales;
*/



--DROP DE INDICES-------------
/*
DROP INDEX DROP_TABLE.ventas_pc.idx_clienteventapc;
DROP INDEX DROP_TABLE.ventas_accesorio.idx_clienteventaaccesorio;
DROP INDEX DROP_TABLE.compras_pc.idx_pccompraspc;
DROP INDEX DROP_TABLE.compras_accesorio.idx_accesorioscomprasaccesorio;
DROP INDEX DROP_TABLE.ventas_accesorio.idx_accesoriosventasaccesorio;
DROP INDEX DROP_TABLE.cliente_factura.idx_clientefactura;
DROP INDEX DROP_TABLE.compras_accesorio.idx_compraaccesoriosucursal;
DROP INDEX DROP_TABLE.compras_pc.idx_comprapcsucursal;
DROP INDEX DROP_TABLE.pcs_discos_rigidos.idx_pcsdiscosrigidos;
DROP INDEX DROP_TABLE.pcs_memorias_ram.idx_pcsmemoriasram;
DROP INDEX DROP_TABLE.pcs_placas_video.idx_pcsplacasvideo;
DROP INDEX DROP_TABLE.facturas.idx_fechasfacturas;
DROP INDEX DROP_TABLE.compras_accesorio.idx_fechascomprasacc;
DROP INDEX DROP_TABLE.compras_pc.idx_fechascompraspc;
*/


--SELECTS PARA PRUEBA DE CREACIÓN/MIGRACIÓN---------------
/*
SELECT * FROM DROP_TABLE.accesorios
SELECT * FROM DROP_TABLE.clientes
SELECT * FROM DROP_TABLE.compras_accesorio
SELECT * FROM DROP_TABLE.compras_pc
SELECT * FROM DROP_TABLE.discos_rigidos
SELECT * FROM DROP_TABLE.memorias_ram
SELECT * FROM DROP_TABLE.microprocesadores
SELECT * FROM DROP_TABLE.pcs
SELECT * FROM DROP_TABLE.pcs_discos_rigidos
SELECT * FROM DROP_TABLE.pcs_memorias_ram
SELECT * FROM DROP_TABLE.pcs_placas_video
SELECT * FROM DROP_TABLE.placas_video
SELECT * FROM DROP_TABLE.sucursales  
SELECT * FROM DROP_TABLE.ventas_pc
SELECT * FROM DROP_TABLE.ventas_accesorio
*/




