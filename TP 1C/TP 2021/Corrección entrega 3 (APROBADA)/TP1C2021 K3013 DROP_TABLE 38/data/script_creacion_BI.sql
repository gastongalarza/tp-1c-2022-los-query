USE GD1C2021

PRINT 'Creando y Cargando objetos del Modelo de Business Intelligence'

--DROP PREVENTIVO DE FUNCIONES------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'getAgeRange')
	DROP FUNCTION DROP_TABLE.getAgeRange

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'getAge')
	DROP FUNCTION DROP_TABLE.getAge

--DROP PREVENTIVO DE TABLAS------------------------------------------------------------
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

--DROP PREVENTIVO DE PROCEDURES---------------------------------------------------------------

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
--DROP PREVENTIVO DE VISTAS-------------------------------------------------------------------
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
--CREACIÓN DE FUNCIONES AUXILIARES------------------------------------------------------------
GO

CREATE FUNCTION DROP_TABLE.getAge(@dateofbirth datetime2(3)) --Recibe una fecha de nacimiento por parámetro
RETURNS int													 --Y devuelve la edad actual de la persona.
AS
BEGIN
	DECLARE @age int;
	
IF (MONTH(@dateofbirth)!=MONTH(GETDATE()))
	SET @age = DATEDIFF(MONTH, @dateofbirth, GETDATE())/12;
ELSE IF(DAY(@dateofbirth) > DAY(GETDATE()))
	SET @age = (DATEDIFF(MONTH, @dateofbirth, GETDATE())/12)-1;
ELSE 
BEGIN
	SET @age = DATEDIFF(MONTH, @dateofbirth, GETDATE())/12;
END
	RETURN @age;
END
GO

CREATE FUNCTION DROP_TABLE.getAgeRange (@age int) --Recibe una edad por parámetro y 
RETURNS varchar(10)								  --devuelve el rango de edad al que pertenece.	
AS
BEGIN
	DECLARE @returnvalue varchar(10);
	
IF (@age > 17 AND @age <31)
BEGIN
	SET @returnvalue = '[18 - 30]';
END
ELSE IF (@age > 30 AND @age <51)
BEGIN
	SET @returnvalue = '[31 - 50]';
END
ELSE IF(@age > 50)
BEGIN
	SET @returnvalue = '+50';
END

	RETURN @returnvalue;
END

GO

--CREACIÓN DE TABLAS DIMENSIONALES------------------------------------------------------------

CREATE TABLE  DROP_TABLE.BI_dim_tiempos(
CODIGO_TIEMPO int IDENTITY PRIMARY KEY,
AÑO int,
MES int not null
);

CREATE TABLE  DROP_TABLE.BI_dim_sucursales(
CODIGO_SUCURSAL int PRIMARY KEY,
DIRECCION nvarchar(255) not null,
MAIL nvarchar(255) null,
TELEFONO decimal(18,0) null,
CIUDAD nvarchar(255) null
);

CREATE TABLE  DROP_TABLE.BI_dim_procesadores(
MICROPROCESADOR_CODIGO nvarchar(50) PRIMARY KEY,
CANTIDAD_HILOS decimal(18,0) null,
CACHE nvarchar(50) null,
VELOCIDAD nvarchar(50) null,
FABRICANTE nvarchar(255) not null
);

CREATE TABLE  DROP_TABLE.BI_dim_pcs(
PC_CODIGO nvarchar(50) PRIMARY KEY,
ALTO decimal(18,2) null,
ANCHO decimal(18,2) null,
PROFUNDIDAD decimal(18,2) null,
MICROPROCESADOR_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_procesadores not null
);

CREATE TABLE  DROP_TABLE.BI_dim_discos_rigidos(
DISCO_RIGIDO_CODIGO nvarchar(255) PRIMARY KEY,
TIPO nvarchar(255) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(255) null,
FABRICANTE nvarchar(255) not null
);

CREATE TABLE  DROP_TABLE.BI_dim_memorias_ram(
MEMORIA_RAM_CODIGO nvarchar(255) PRIMARY KEY,
TIPO nvarchar(255) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(255) null,
FABRICANTE nvarchar(255) not null
);

CREATE TABLE  DROP_TABLE.BI_dim_placas_video(
PLACA_VIDEO_CODIGO decimal(18,0) PRIMARY KEY,
MODELO_PLACA_VIDEO nvarchar(50) null,
CHIPSET nvarchar(50) null,
CAPACIDAD nvarchar(255) not null,
VELOCIDAD nvarchar(50) null,
FABRICANTE nvarchar(255) not null
);

CREATE TABLE  DROP_TABLE.BI_dim_accesorios(
CODIGO_ACCESORIO decimal(18,0) PRIMARY KEY,
DESCRIPCION nvarchar(255) not null
);

--CREACIÓN DE TABLAS PUENTE (BRIDGE)------------------------------------------------------------

CREATE TABLE  DROP_TABLE.BI_bri_pc_discos_rigidos(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_pcs,
DISCO_RIGIDO_CODIGO nvarchar(255) REFERENCES DROP_TABLE.BI_dim_discos_rigidos,
PRIMARY KEY (PC_CODIGO, DISCO_RIGIDO_CODIGO)
);

CREATE TABLE  DROP_TABLE.BI_bri_pc_placas_video(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_pcs,
PLACA_VIDEO_CODIGO decimal(18,0) REFERENCES DROP_TABLE.BI_dim_placas_video,
PRIMARY KEY (PC_CODIGO, PLACA_VIDEO_CODIGO)
);

CREATE TABLE  DROP_TABLE.BI_bri_pc_memorias_ram(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_pcs,
MEMORIA_RAM_CODIGO nvarchar(255) REFERENCES DROP_TABLE.BI_dim_memorias_ram,
PRIMARY KEY (PC_CODIGO, MEMORIA_RAM_CODIGO)
);

--CREACIÓN DE TABLAS FÁCTICAS------------------------------------------------------------

CREATE TABLE  DROP_TABLE.BI_fact_compras_pc(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_pcs,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.BI_dim_sucursales,
CODIGO_TIEMPO int REFERENCES  DROP_TABLE.BI_dim_tiempos,
CANTIDAD decimal(18,0),
PROMEDIO_PRECIO_COMPRA decimal(18,2),
PRIMARY KEY(PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO)
);

CREATE TABLE  DROP_TABLE.BI_fact_ventas_pc(
PC_CODIGO nvarchar(50) REFERENCES DROP_TABLE.BI_dim_pcs,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.BI_dim_sucursales,
CODIGO_TIEMPO int REFERENCES  DROP_TABLE.BI_dim_tiempos,
CANTIDAD decimal(18,0),
PROMEDIO_PRECIO_VENTA decimal(18,2),
PROMEDIO_DIAS_EN_STOCK decimal(18,2),
RANGO_EDAD_CLIENTES varchar(10),
SEXO_MAYORITARIO_CLIENTES varchar(20),
PRIMARY KEY(PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO)
);

CREATE TABLE  DROP_TABLE.BI_fact_compras_accesorio(
CODIGO_ACCESORIO decimal(18,0) REFERENCES DROP_TABLE.BI_dim_accesorios,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.BI_dim_sucursales,
CODIGO_TIEMPO int REFERENCES  DROP_TABLE.BI_dim_tiempos,
CANTIDAD decimal(18,0),
PROMEDIO_PRECIO_COMPRA decimal(18,2),
PRIMARY KEY(CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO)
);

CREATE TABLE  DROP_TABLE.BI_fact_ventas_accesorio(
CODIGO_ACCESORIO decimal(18,0) REFERENCES DROP_TABLE.BI_dim_accesorios,
CODIGO_SUCURSAL int REFERENCES DROP_TABLE.BI_dim_sucursales,
CODIGO_TIEMPO int REFERENCES  DROP_TABLE.BI_dim_tiempos,
CANTIDAD decimal(18,0),
PROMEDIO_PRECIO_VENTA decimal(18,2),
PROMEDIO_DIAS_EN_STOCK decimal(18,2),
RANGO_EDAD_CLIENTES varchar(10),
SEXO_MAYORITARIO_CLIENTES varchar(20),
PRIMARY KEY(CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO)
);
GO
--CREACION DE VISTAS------------------------------------------------
--PCs
--Promedio de tiempo en stock de cada modelo de Pc.
CREATE VIEW DROP_TABLE.v_TiempoStockPromedioPC AS
	SELECT DISTINCT PC_CODIGO, PROMEDIO_DIAS_EN_STOCK
	FROM DROP_TABLE.BI_fact_ventas_pc 
GO

--Precio promedio de PCs, vendidos y comprados. 
CREATE VIEW DROP_TABLE.v_PrecioPromedioPC AS
	SELECT DISTINCT v.PC_CODIGO, PROMEDIO_PRECIO_COMPRA, PROMEDIO_PRECIO_VENTA
	FROM DROP_TABLE.BI_fact_ventas_pc v JOIN DROP_TABLE.BI_fact_compras_pc c ON c.PC_CODIGO = v.PC_CODIGO
GO

--Cantidad de PCs, vendidos y comprados x sucursal y mes
CREATE VIEW DROP_TABLE.v_CantidadPCsxsucursalxmes AS
	SELECT DISTINCT v.CODIGO_SUCURSAL, MES, SUM(c.CANTIDAD) AS CANTIDAD_PC_COMPRADOS, SUM(v.CANTIDAD) AS CANTIDAD_PC_VENDIDOS
	FROM DROP_TABLE.BI_fact_ventas_pc v JOIN DROP_TABLE.BI_fact_compras_pc c ON v.CODIGO_SUCURSAL = c.CODIGO_SUCURSAL
										JOIN DROP_TABLE.BI_dim_tiempos t ON t.CODIGO_TIEMPO = v.CODIGO_TIEMPO AND t.CODIGO_TIEMPO = c.CODIGO_TIEMPO
	GROUP BY v.CODIGO_SUCURSAL, MES
GO

--Ganancias (precio de venta – precio de compra) x Sucursal x mes
CREATE VIEW DROP_TABLE.v_GananciasPC AS
	SELECT vp.CODIGO_SUCURSAL,  MES, (SUM(PROMEDIO_PRECIO_VENTA*vp.CANTIDAD)-SUM(PROMEDIO_PRECIO_COMPRA*cp.CANTIDAD)) AS GANANCIAS
	FROM DROP_TABLE.BI_fact_ventas_pc vp JOIN DROP_TABLE.BI_fact_compras_pc cp ON vp.CODIGO_SUCURSAL = cp.CODIGO_SUCURSAL
										 JOIN DROP_TABLE.BI_dim_tiempos t ON t.CODIGO_TIEMPO = vp.CODIGO_TIEMPO AND t.CODIGO_TIEMPO = cp.CODIGO_TIEMPO
	GROUP BY vp.CODIGO_SUCURSAL, MES
GO

--Accesorios
--Precio promedio de cada accesorio, vendido y comprado.
CREATE VIEW DROP_TABLE.v_PrecioPromedioAcc AS
	SELECT DISTINCT v.CODIGO_ACCESORIO, PROMEDIO_PRECIO_COMPRA, PROMEDIO_PRECIO_VENTA
	FROM DROP_TABLE.BI_fact_ventas_accesorio v JOIN DROP_TABLE.BI_fact_compras_accesorio c ON c.CODIGO_ACCESORIO = v.CODIGO_ACCESORIO
GO

--Ganancias (precio de venta – precio de compra) x Sucursal x mes
CREATE VIEW DROP_TABLE.v_GananciasAccesorios AS
	SELECT va.CODIGO_SUCURSAL,  MES, (SUM(PROMEDIO_PRECIO_VENTA*va.CANTIDAD)-SUM(PROMEDIO_PRECIO_COMPRA*ca.CANTIDAD)) AS GANANCIAS
	FROM DROP_TABLE.BI_fact_ventas_accesorio va JOIN DROP_TABLE.BI_fact_compras_accesorio ca ON va.CODIGO_SUCURSAL = ca.CODIGO_SUCURSAL
											    JOIN DROP_TABLE.BI_dim_tiempos t ON t.CODIGO_TIEMPO = va.CODIGO_TIEMPO AND t.CODIGO_TIEMPO = ca.CODIGO_TIEMPO
	GROUP BY va.CODIGO_SUCURSAL, MES
GO

--Promedio de tiempo en stock de cada modelo de accesorio.
CREATE VIEW DROP_TABLE.v_TiempoStockPromedioAcc AS
	SELECT DISTINCT CODIGO_ACCESORIO, PROMEDIO_DIAS_EN_STOCK
	FROM DROP_TABLE.BI_fact_ventas_accesorio 
GO

--Máxima cantidad de stock por cada sucursal (anual)
CREATE VIEW DROP_TABLE.v_MaxStockxSucursalAnualAcc AS
	SELECT CODIGO_SUCURSAL, AÑO, SUM(CANTIDAD) AS CANTIDAD_STOCK_MAXIMO
	FROM DROP_TABLE.BI_fact_compras_accesorio ca JOIN DROP_TABLE.BI_dim_tiempos t ON t.CODIGO_TIEMPO = ca.CODIGO_TIEMPO
	GROUP BY CODIGO_SUCURSAL, AÑO
GO

--CREACION PROCEDURES DE MIGRACION------------------------------------------------------------
	
	
CREATE PROCEDURE DROP_TABLE.BI_migrar_discos_rigidos
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_discos_rigidos (DISCO_RIGIDO_CODIGO,TIPO, CAPACIDAD, VELOCIDAD,FABRICANTE)
	SELECT DISCO_RIGIDO_CODIGO,TIPO, CAPACIDAD, VELOCIDAD,FABRICANTE
	FROM DROP_TABLE.discos_rigidos
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_memorias_ram
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_memorias_ram (MEMORIA_RAM_CODIGO,TIPO, CAPACIDAD, VELOCIDAD,FABRICANTE)
	SELECT MEMORIA_RAM_CODIGO,TIPO, CAPACIDAD, VELOCIDAD,FABRICANTE
	FROM DROP_TABLE.memorias_ram
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_placas_video
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_placas_video (PLACA_VIDEO_CODIGO, MODELO_PLACA_VIDEO, CHIPSET, CAPACIDAD, VELOCIDAD,FABRICANTE)
	SELECT PLACA_VIDEO_CODIGO, MODELO_PLACA_VIDEO, CHIPSET, CAPACIDAD, VELOCIDAD,FABRICANTE
	FROM DROP_TABLE.placas_video
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_procesadores
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_procesadores (MICROPROCESADOR_CODIGO, CANTIDAD_HILOS, CACHE, VELOCIDAD,FABRICANTE)
	SELECT MICROPROCESADOR_CODIGO, CANTIDAD_HILOS, CACHE, VELOCIDAD,FABRICANTE
	FROM DROP_TABLE.microprocesadores
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_pcs
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_pcs (PC_CODIGO, ALTO, ANCHO, PROFUNDIDAD, MICROPROCESADOR_CODIGO)
	SELECT PC_CODIGO, ALTO, ANCHO, PROFUNDIDAD, MICROPROCESADOR_CODIGO
	FROM DROP_TABLE.pcs
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_pcs_discos_rigidos
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_bri_pc_discos_rigidos (PC_CODIGO, DISCO_RIGIDO_CODIGO)
	SELECT PC_CODIGO, DISCO_RIGIDO_CODIGO
	FROM DROP_TABLE.pcs_discos_rigidos
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_pcs_memorias_ram
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_bri_pc_memorias_ram (PC_CODIGO, MEMORIA_RAM_CODIGO)
	SELECT PC_CODIGO, MEMORIA_RAM_CODIGO
	FROM DROP_TABLE.pcs_memorias_ram
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_pcs_placas_video
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_bri_pc_placas_video (PC_CODIGO, PLACA_VIDEO_CODIGO)
	SELECT PC_CODIGO, PLACA_VIDEO_CODIGO
	FROM DROP_TABLE.pcs_placas_video
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_accesorios
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_accesorios (CODIGO_ACCESORIO, DESCRIPCION)
	SELECT CODIGO_ACCESORIO, DESCRIPCION
	FROM DROP_TABLE.accesorios
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_sucursales
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_dim_sucursales (CODIGO_SUCURSAL, DIRECCION, MAIL, TELEFONO, CIUDAD)
	SELECT CODIGO_SUCURSAL, DIRECCION, MAIL, TELEFONO, CIUDAD
	FROM DROP_TABLE.sucursales
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_tiempos_ventas_pc
AS
BEGIN
	DECLARE date_cursor CURSOR FOR SELECT FECHA FROM DROP_TABLE.ventas_pc
	
	DECLARE @Date datetime2(3)
	DECLARE @Año_c int
	DECLARE @Mes_c int
	

	OPEN date_cursor
	FETCH date_cursor into @Date

	WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @Año_c = YEAR(@Date)
			SET @Mes_c = MONTH(@Date)
			

			IF NOT EXISTS (SELECT 1 FROM DROP_TABLE.BI_dim_tiempos WHERE (AÑO = @Año_c AND MES = @Mes_c))
			INSERT INTO DROP_TABLE.BI_dim_tiempos (AÑO, MES) VALUES (@Año_c, @Mes_c)
			
			FETCH date_cursor into @Date
		END
	CLOSE date_cursor
	DEALLOCATE date_cursor
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_tiempos_ventas_accesorios
AS
BEGIN
	DECLARE date_cursor CURSOR FOR SELECT FECHA FROM DROP_TABLE.ventas_accesorio
	
	DECLARE @Date datetime2(3)
	DECLARE @Año_c int
	DECLARE @Mes_c int
	

	OPEN date_cursor
	FETCH date_cursor into @Date

	WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @Año_c = YEAR(@Date)
			SET @Mes_c = MONTH(@Date)
			

			IF NOT EXISTS (SELECT 1 FROM DROP_TABLE.BI_dim_tiempos WHERE (AÑO = @Año_c AND MES = @Mes_c))
			INSERT INTO DROP_TABLE.BI_dim_tiempos (AÑO, MES) VALUES (@Año_c, @Mes_c)
			
			FETCH date_cursor into @Date
		END
	CLOSE date_cursor
	DEALLOCATE date_cursor
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_tiempos_compras_accesorio
AS
BEGIN
	DECLARE date_cursor CURSOR FOR SELECT FECHA FROM DROP_TABLE.compras_accesorio
	
	DECLARE @Date datetime2(3)
	DECLARE @Año_c int
	DECLARE @Mes_c int
	

	OPEN date_cursor
	FETCH date_cursor into @Date

	WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @Año_c = YEAR(@Date)
			SET @Mes_c = MONTH(@Date)
			

			IF NOT EXISTS (SELECT 1 FROM DROP_TABLE.BI_dim_tiempos WHERE (AÑO = @Año_c AND MES = @Mes_c))
			INSERT INTO DROP_TABLE.BI_dim_tiempos (AÑO, MES) VALUES (@Año_c, @Mes_c)
			
			FETCH date_cursor into @Date
		END
	CLOSE date_cursor
	DEALLOCATE date_cursor
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_tiempos_compras_pc
AS
BEGIN
	DECLARE date_cursor CURSOR FOR SELECT FECHA FROM DROP_TABLE.compras_pc
	
	DECLARE @Date datetime2(3)
	DECLARE @Año_c int
	DECLARE @Mes_c int
	

	OPEN date_cursor
	FETCH date_cursor into @Date

	WHILE(@@FETCH_STATUS = 0)
		BEGIN
			SET @Año_c = YEAR(@Date)
			SET @Mes_c = MONTH(@Date)
			

			IF NOT EXISTS (SELECT 1 FROM DROP_TABLE.BI_dim_tiempos WHERE (AÑO = @Año_c AND MES = @Mes_c))
			INSERT INTO DROP_TABLE.BI_dim_tiempos (AÑO, MES) VALUES (@Año_c, @Mes_c)
			
			FETCH date_cursor into @Date
		END
	CLOSE date_cursor
	DEALLOCATE date_cursor
END
	GO
	
CREATE PROCEDURE DROP_TABLE.BI_migrar_compras_pc
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_fact_compras_pc (PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO, PROMEDIO_PRECIO_COMPRA, CANTIDAD)
	SELECT PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO, AVG(PRECIO), SUM(CANTIDAD)
	FROM DROP_TABLE.compras_pc cp JOIN DROP_TABLE.BI_dim_tiempos t ON YEAR(cp.FECHA) = t.AÑO AND MONTH(cp.FECHA) = t.MES
	GROUP BY PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_compras_accesorio
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_fact_compras_accesorio (CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO, PROMEDIO_PRECIO_COMPRA, CANTIDAD)
	SELECT CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO, AVG(PRECIO), SUM(CANTIDAD)
	FROM DROP_TABLE.compras_accesorio ca JOIN DROP_TABLE.BI_dim_tiempos t ON YEAR(ca.FECHA) = t.AÑO AND MONTH(ca.FECHA) = t.MES
	GROUP BY CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO
END
	GO

CREATE PROCEDURE DROP_TABLE.BI_migrar_ventas_pc
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_fact_ventas_pc (PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO, PROMEDIO_PRECIO_VENTA, CANTIDAD, RANGO_EDAD_CLIENTES, SEXO_MAYORITARIO_CLIENTES, PROMEDIO_DIAS_EN_STOCK)
	SELECT PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO, AVG(PRECIO), SUM(CANTIDAD), DROP_TABLE.getAgeRange(AVG(DROP_TABLE.getAge(c.FECHA_NACIMIENTO))), 'No Definido', 
	((SELECT AVG(CAST(DATEDIFF(DAY,'01-01-1900',DROP_TABLE.ventas_pc.FECHA) AS decimal(18,2))) FROM DROP_TABLE.ventas_pc
    WHERE DROP_TABLE.ventas_pc.PC_CODIGO = vp.PC_CODIGO
    GROUP BY DROP_TABLE.ventas_pc.PC_CODIGO)-
   (SELECT AVG(CAST(DATEDIFF(DAY,'01-01-1900',DROP_TABLE.compras_pc.FECHA) AS decimal(18,2))) FROM DROP_TABLE.compras_pc
         WHERE DROP_TABLE.compras_pc.PC_CODIGO = vp.PC_CODIGO
    GROUP BY DROP_TABLE.compras_pc.PC_CODIGO))

    FROM DROP_TABLE.ventas_pc vp JOIN DROP_TABLE.BI_dim_tiempos t ON YEAR(vp.FECHA) = t.AÑO AND MONTH(vp.FECHA) = t.MES 
								 JOIN DROP_TABLE.clientes c ON c.CODIGO_CLIENTE = vp.CODIGO_CLIENTE
	GROUP BY PC_CODIGO, CODIGO_SUCURSAL, CODIGO_TIEMPO
END
	GO
			
CREATE PROCEDURE DROP_TABLE.BI_migrar_ventas_accesorio
AS
BEGIN
	INSERT INTO DROP_TABLE.BI_fact_ventas_accesorio (CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO, PROMEDIO_PRECIO_VENTA, CANTIDAD, RANGO_EDAD_CLIENTES, SEXO_MAYORITARIO_CLIENTES, PROMEDIO_DIAS_EN_STOCK)
	SELECT CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO, AVG(PRECIO), SUM(CANTIDAD), DROP_TABLE.getAgeRange(AVG(DROP_TABLE.getAge(c.FECHA_NACIMIENTO))), 'No Definido', 
	((SELECT AVG(CAST(DATEDIFF(DAY,'01-01-1900',DROP_TABLE.ventas_accesorio.FECHA) AS decimal(18,2))) FROM DROP_TABLE.ventas_accesorio
    WHERE DROP_TABLE.ventas_accesorio.CODIGO_ACCESORIO = va.CODIGO_ACCESORIO
    GROUP BY DROP_TABLE.ventas_accesorio.CODIGO_ACCESORIO)-
   (SELECT AVG(CAST(DATEDIFF(DAY,'01-01-1900',DROP_TABLE.compras_accesorio.FECHA) AS decimal(18,2))) FROM DROP_TABLE.compras_accesorio
         WHERE DROP_TABLE.compras_accesorio.CODIGO_ACCESORIO = va.CODIGO_ACCESORIO
    GROUP BY DROP_TABLE.compras_accesorio.CODIGO_ACCESORIO))
	FROM DROP_TABLE.ventas_accesorio va JOIN DROP_TABLE.BI_dim_tiempos t ON YEAR(va.FECHA) = t.AÑO AND MONTH(va.FECHA) = t.MES 
								 JOIN DROP_TABLE.clientes c ON c.CODIGO_CLIENTE = va.CODIGO_CLIENTE
	GROUP BY CODIGO_ACCESORIO, CODIGO_SUCURSAL, CODIGO_TIEMPO
END
	GO

--EJECUCIÓN DE PROCEDURES: MIGRACIÓN DE MODELO OLTP A MODELO BI

 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE DROP_TABLE.BI_migrar_discos_rigidos
	EXECUTE DROP_TABLE.BI_migrar_memorias_ram
	EXECUTE DROP_TABLE.BI_migrar_placas_video
	EXECUTE DROP_TABLE.BI_migrar_procesadores
	EXECUTE DROP_TABLE.BI_migrar_pcs
	EXECUTE DROP_TABLE.BI_migrar_pcs_discos_rigidos
	EXECUTE DROP_TABLE.BI_migrar_pcs_memorias_ram
	EXECUTE DROP_TABLE.BI_migrar_pcs_placas_video
	EXECUTE DROP_TABLE.BI_migrar_accesorios
	EXECUTE DROP_TABLE.BI_migrar_sucursales
	EXECUTE DROP_TABLE.BI_migrar_tiempos_ventas_pc
	EXECUTE DROP_TABLE.BI_migrar_tiempos_ventas_accesorios
	EXECUTE DROP_TABLE.BI_migrar_tiempos_compras_accesorio
	EXECUTE DROP_TABLE.BI_migrar_tiempos_compras_pc
	EXECUTE DROP_TABLE.BI_migrar_compras_pc
	EXECUTE DROP_TABLE.BI_migrar_compras_accesorio
	EXECUTE DROP_TABLE.BI_migrar_ventas_pc
	EXECUTE DROP_TABLE.BI_migrar_ventas_accesorio
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
	THROW 50001, 'Error al cargar el modelo de BI, ninguna tabla fue cargada',1;
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
	PRINT 'Modelo de BI creado y cargado correctamente.';
	COMMIT TRANSACTION;
   END
	 ELSE
   BEGIN
    ROLLBACK TRANSACTION;
	THROW 50002, 'Hubo un error al cargar una o más tablas. Todos los cambios fueron deshechos, ninguna tabla fue cargada en la base.',1;
   END
   
GO


/*
--SELECTS DE PRUEBA------------------------------------------------------------
SELECT * FROM DROP_TABLE.BI_dim_discos_rigidos
SELECT * FROM DROP_TABLE.BI_dim_memorias_ram
SELECT * FROM DROP_TABLE.BI_dim_placas_video
SELECT * FROM DROP_TABLE.BI_dim_procesadores
SELECT * FROM DROP_TABLE.BI_dim_pcs
SELECT * FROM DROP_TABLE.BI_bri_pc_discos_rigidos
SELECT * FROM DROP_TABLE.BI_bri_pc_placas_video
SELECT * FROM DROP_TABLE.BI_bri_pc_memorias_ram
SELECT * FROM DROP_TABLE.BI_dim_accesorios
SELECT * FROM DROP_TABLE.BI_dim_sucursales
SELECT * FROM DROP_TABLE.BI_dim_tiempos
SELECT * FROM DROP_TABLE.BI_fact_compras_pc
SELECT * FROM DROP_TABLE.BI_fact_compras_accesorio
SELECT * FROM DROP_TABLE.BI_fact_ventas_pc
SELECT * FROM DROP_TABLE.BI_fact_ventas_accesorio
*/