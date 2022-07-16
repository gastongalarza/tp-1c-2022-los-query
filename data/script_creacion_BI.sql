USE GD1C2022

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_paradas_circuito')
	DROP TABLE LOS_QUERY.BI_tiempo_paradas_circuito

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_x_vuelta_neumatico')
	DROP TABLE LOS_QUERY.BI_desgaste_x_vuelta_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_x_vuelta_frenos')
	DROP TABLE LOS_QUERY.BI_desgaste_x_vuelta_frenos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_x_vuelta_motor')
	DROP TABLE LOS_QUERY.BI_desgaste_x_vuelta_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_x_vuelta_caja')
	DROP TABLE LOS_QUERY.BI_desgaste_x_vuelta_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_vuelta_escuderia')
	DROP TABLE LOS_QUERY.BI_tiempo_vuelta_escuderia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_consumo_por_circuito')
	DROP TABLE LOS_QUERY.BI_consumo_por_circuito

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_parada_auto')
	DROP TABLE LOS_QUERY.BI_tiempo_parada_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_parada_box')
	DROP TABLE LOS_QUERY.BI_fact_parada_box

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_incidentes')
	DROP TABLE LOS_QUERY.BI_fact_incidentes
	
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_motor')
	DROP TABLE LOS_QUERY.BI_desgaste_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_frenos')
	DROP TABLE LOS_QUERY.BI_desgaste_frenos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_neumatico')
	DROP TABLE LOS_QUERY.BI_desgaste_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_tipo_sector')
	DROP TABLE LOS_QUERY.BI_dim_tipo_sector

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_tipo_neumatico')
	DROP TABLE LOS_QUERY.BI_dim_tipo_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_tipo_incidentes')
	DROP TABLE LOS_QUERY.BI_dim_tipo_incidentes

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_motor')
	DROP TABLE LOS_QUERY.BI_dim_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_freno')
	DROP TABLE LOS_QUERY.BI_dim_freno

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_neumatico')
	DROP TABLE LOS_QUERY.BI_dim_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_piloto')
	DROP TABLE LOS_QUERY.BI_dim_piloto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_velocidades_auto')
	DROP TABLE LOS_QUERY.BI_velocidades_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_incidente')
	DROP TABLE LOS_QUERY.BI_dim_incidente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_sector')
	DROP TABLE LOS_QUERY.BI_dim_sector

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_circuito')
	DROP TABLE LOS_QUERY.BI_dim_circuito

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_tiempos')
	DROP TABLE LOS_QUERY.BI_dim_tiempos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_caja')
	DROP TABLE LOS_QUERY.BI_desgaste_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_auto')
	DROP TABLE LOS_QUERY.BI_dim_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_caja')
	DROP TABLE LOS_QUERY.BI_dim_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_escuderia')
	DROP TABLE LOS_QUERY.BI_dim_escuderia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_carrera')
	DROP TABLE LOS_QUERY.BI_dim_carrera


CREATE TABLE LOS_QUERY.BI_dim_tiempos (
	codigo_tiempo int IDENTITY PRIMARY KEY,
	anio int,
	cuatrimestre int not null
)

CREATE TABLE LOS_QUERY.BI_dim_tipo_sector (
	codigo_tipo_sector int IDENTITY PRIMARY KEY, 
	tipo_sector nvarchar(255),
)

CREATE TABLE LOS_QUERY.BI_dim_tipo_neumatico (
	codigo_tipo_neumatico int IDENTITY PRIMARY KEY, 
	tipo_neumatico nvarchar(255),
)

CREATE TABLE LOS_QUERY.BI_dim_tipo_incidentes (
	codigo_tipo_incidente int IDENTITY PRIMARY KEY, 
	tipo_incidente nvarchar(255),
)

CREATE TABLE LOS_QUERY.BI_dim_caja (
	caja_nro_serie VARCHAR(255) PRIMARY KEY,
	caja_modelo VARCHAR(255)
)

CREATE TABLE LOS_QUERY.BI_dim_escuderia (
	escuderia_nombre VARCHAR(255) PRIMARY KEY,
	escuderia_pais VARCHAR(255)	
)

CREATE TABLE LOS_QUERY.BI_dim_circuito (
	CIRCUITO_CODIGO int PRIMARY KEY,
	CIRCUITO_NOMBRE varchar(255),
	CIRCUITO_PAIS_CODIGO varchar(255)
)

CREATE TABLE LOS_QUERY.BI_dim_sector (
	codigo_sector int PRIMARY KEY,
	sector_distancia decimal not null,
	sector_tipo varchar(255),
	sector_circuito_codigo int,
	FOREIGN KEY (sector_circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
)

CREATE TABLE LOS_QUERY.BI_dim_incidente (
	incidente_codigo int PRIMARY KEY,
	incidente_bandera varchar(255),
	incidente_numero_vuelta decimal not null,
	incidente_tipo varchar(255),
	incidente_codigo_sector int null,
	incidente_codigo_carrera int,
	FOREIGN KEY (incidente_codigo_carrera) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
	FOREIGN KEY (incidente_codigo_sector) REFERENCES LOS_QUERY.BI_dim_sector(CODIGO_SECTOR)
)

CREATE TABLE LOS_QUERY.BI_dim_auto (
	auto_numero int,
	auto_modelo VARCHAR(255),
	escuderia VARCHAR(255),
	PRIMARY KEY (auto_numero, auto_modelo),
	FOREIGN KEY (escuderia) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre)
)

CREATE TABLE LOS_QUERY.BI_dim_piloto (
	piloto_nombre VARCHAR(50),
	piloto_apellido VARCHAR(50),
	piloto_auto_numero int,
	piloto_auto_modelo VARCHAR(255),
	piloto_nacionalidad VARCHAR(50),
	piloto_fecha_nacimiento date,
	PRIMARY KEY (piloto_nombre, piloto_apellido),
	FOREIGN KEY (piloto_auto_numero, piloto_auto_modelo)
	REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo)
)

CREATE TABLE LOS_QUERY.BI_dim_neumatico (
	neumatico_nro_serie VARCHAR(255) PRIMARY KEY,
	neumatico_posicion VARCHAR(255),
	neumatico_tipo VARCHAR(255)
)

CREATE TABLE LOS_QUERY.BI_dim_freno (
	FRENO_NRO_SERIE varchar(255) PRIMARY KEY,
	FRENO_POSICION varchar(255) not null,
	desgaste decimal(18,6)
)

CREATE TABLE LOS_QUERY.BI_dim_motor (
	motor_nro_serie VARCHAR(255) not null PRIMARY KEY,
	motor_modelo VARCHAR(255) not null
)

CREATE TABLE LOS_QUERY.BI_dim_carrera (
    CODIGO_CARRERA int,
	CARRERA_CIRCUITO_CODIGO int not null,
	PRIMARY KEY (CODIGO_CARRERA),
	FOREIGN KEY (CARRERA_CIRCUITO_CODIGO) REFERENCES LOS_QUERY.circuito(CIRCUITO_CODIGO)
)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas de hechos para el armado de las vistas --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE LOS_QUERY.BI_desgaste_x_vuelta_neumatico (
	neumatico_nro_serie VARCHAR(255),
	auto_numero int,
	auto_modelo VARCHAR(255),
	desgaste decimal(18,6),
	vuelta decimal(18,0),
	circuito_codigo int,
	PRIMARY KEY(neumatico_nro_serie, vuelta, circuito_codigo),
	FOREIGN KEY (neumatico_nro_serie) REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_x_vuelta_frenos (
	freno_nro_serie VARCHAR(255),
	auto_numero int,
	auto_modelo VARCHAR(255),
	desgaste decimal(18,6),
	vuelta decimal(18,0),
	circuito_codigo int,
	PRIMARY KEY(freno_nro_serie, vuelta, circuito_codigo),
	FOREIGN KEY (freno_nro_serie) REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_x_vuelta_motor (
	motor_nro_serie VARCHAR(255),
	auto_numero int,
	auto_modelo VARCHAR(255),
	desgaste decimal(18,6),
	vuelta decimal(18,0),
	circuito_codigo int,
	PRIMARY KEY(motor_nro_serie, vuelta, circuito_codigo),
	FOREIGN KEY (motor_nro_serie) REFERENCES LOS_QUERY.BI_dim_motor(motor_nro_serie),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_x_vuelta_caja (
	caja_nro_serie VARCHAR(255),
	auto_numero int,
	auto_modelo VARCHAR(255),
	desgaste decimal(18,6),
	vuelta decimal(18,0),
	circuito_codigo int,
	PRIMARY KEY(caja_nro_serie, vuelta, circuito_codigo),
	FOREIGN KEY (caja_nro_serie) REFERENCES LOS_QUERY.BI_dim_caja(caja_nro_serie),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);


CREATE TABLE LOS_QUERY.BI_tiempo_vuelta_escuderia (
	escuderia_nombre VARCHAR(255),
	numero_vuelta decimal(18,0),
	tiempo_vuelta decimal(18,10),
	auto_numero int,
	auto_modelo varchar(255),
	CODIGO_CARRERA int,
	CIRCUITO_CODIGO int,
	codigo_tiempo int, 
	PRIMARY KEY(escuderia_nombre, numero_vuelta, circuito_codigo, codigo_tiempo, auto_numero, auto_modelo),
	FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	FOREIGN KEY (codigo_tiempo) REFERENCES LOS_QUERY.BI_dim_tiempos(codigo_tiempo)

);

CREATE TABLE LOS_QUERY.BI_consumo_por_circuito (
	ciruito_codigo int PRIMARY KEY,
	consumo_combustible int, 
	FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);


CREATE TABLE LOS_QUERY.BI_velocidades_auto (
	auto_numero int,
	auto_modelo VARCHAR(255),
	velocidad decimal(18,2), 
	ciruito_codigo int,
	codigo_sector int,
	sector_tipo varchar(255),
	PRIMARY KEY(auto_numero, auto_modelo, ciruito_codigo, codigo_sector),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector)
);

CREATE TABLE LOS_QUERY.BI_tiempo_parada_auto (
	id int IDENTITY(1,1) PRIMARY KEY,
	auto_numero int,
	auto_modelo VARCHAR(255),
	duracion_parada decimal, 
	cuatrimestre int, 
	circuito_codigo int, 
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--HECHO Incidentes
CREATE TABLE LOS_QUERY.BI_fact_incidentes (
    id int NOT NULL IDENTITY PRIMARY KEY,
	circuito_codigo int,
	escuderia_nombre VARCHAR(255),
	codigo_sector int,
	codigo_tiempo int,
	cant_inc int,
    codigo_tipo_incidente int,
	codigo_tipo_sector int,
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
	FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector),
	FOREIGN KEY (codigo_tiempo) REFERENCES LOS_QUERY.BI_dim_tiempos(codigo_tiempo),
	FOREIGN KEY (codigo_tipo_incidente) REFERENCES LOS_QUERY.BI_dim_tipo_incidentes(codigo_tipo_incidente),
	FOREIGN KEY (codigo_tipo_sector) REFERENCES LOS_QUERY.BI_dim_tipo_sector(codigo_tipo_sector)
)

--HECHO Parada_Box
CREATE TABLE LOS_QUERY.BI_fact_parada_box (
    codigo_tiempo int,
	circuito_codigo int,
	escuderia_nombre varchar(255),
	codigo_parada int,
	duracion_parada decimal(18,2),
	FOREIGN KEY (codigo_tiempo) REFERENCES LOS_QUERY.BI_dim_tiempos(codigo_tiempo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre)
);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de Funciones --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'get_cuatrimestre')
	DROP FUNCTION LOS_QUERY.get_cuatrimestre
GO

CREATE FUNCTION LOS_QUERY.get_cuatrimestre(@fecha DATE)
	RETURNS INT
	AS
	BEGIN
		IF(MONTH(@fecha) BETWEEN 1 AND 4)
		BEGIN
			RETURN 1
		END
		IF(MONTH(@fecha) BETWEEN 5 AND 8)
		BEGIN
			RETURN 2
		END
		IF(MONTH(@fecha) BETWEEN 9 AND 12)
		BEGIN
			RETURN 3
		END
			RETURN NULL
	END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de procedimientos --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_motor')
	DROP PROCEDURE sp_bi_dim_motor
GO

CREATE PROCEDURE sp_bi_dim_motor
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_motor (motor_nro_serie, motor_modelo)
	SELECT DISTINCT motor_nro_serie, motor_modelo
	FROM LOS_QUERY.motor
	WHERE motor_nro_serie IS NOT NULL and motor_modelo IS NOT NULL
  END
GO

IF EXISTS (SELECT name FROM sys.procedures WHERE name = 'sp_bi_dim_freno')
	DROP PROCEDURE sp_bi_dim_freno
GO

CREATE PROCEDURE sp_bi_dim_freno
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_freno (freno_nro_serie, FRENO_POSICION)
	SELECT DISTINCT freno_nro_serie, freno_posicion
	FROM LOS_QUERY.freno
	WHERE freno_nro_serie IS NOT NULL and freno_posicion IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_circuito')
	DROP PROCEDURE sp_bi_dim_circuito
GO

CREATE PROCEDURE sp_bi_dim_circuito
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_circuito (CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS_CODIGO)
	SELECT DISTINCT CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS_CODIGO
	FROM LOS_QUERY.circuito
	WHERE CIRCUITO_CODIGO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_neumatico')
	DROP PROCEDURE sp_bi_dim_neumatico
GO

CREATE PROCEDURE sp_bi_dim_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_neumatico (neumatico_nro_serie, neumatico_posicion, neumatico_tipo)
	SELECT DISTINCT neumatico_nro_serie, neumatico_posicion, neumatico_tipo
	FROM LOS_QUERY.neumatico
	WHERE neumatico_nro_serie IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_caja')
	DROP PROCEDURE sp_bi_dim_caja
GO

CREATE PROCEDURE sp_bi_dim_caja
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_caja (caja_nro_serie, caja_modelo)
	SELECT DISTINCT caja_nro_serie, caja_modelo
	FROM LOS_QUERY.caja
	WHERE caja_nro_serie IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_escuderia')
	DROP PROCEDURE sp_bi_dim_escuderia
GO

CREATE PROCEDURE sp_bi_dim_escuderia
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_dim_escuderia (escuderia_nombre, escuderia_pais)
	SELECT DISTINCT escuderia_nombre, escuderia_pais
	FROM LOS_QUERY.escuderia
	WHERE escuderia_nombre IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_sector')
	DROP PROCEDURE sp_bi_dim_sector
GO

CREATE PROCEDURE sp_bi_dim_sector
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_sector (codigo_sector, sector_distancia, sector_tipo, sector_circuito_codigo)
	SELECT DISTINCT CODIGO_SECTOR, SECTOR_DISTANCIA, SECTOR_TIPO, SECTOR_CIRCUITO_CODIGO
	FROM LOS_QUERY.sector
	WHERE CODIGO_SECTOR IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_incidente')
	DROP PROCEDURE sp_bi_dim_incidente
GO

CREATE PROCEDURE sp_bi_dim_incidente
 AS
  BEGIN
    INSERT INTO LOS_QUERY.bi_dim_incidente (incidente_codigo, incidente_bandera, incidente_numero_vuelta, incidente_tipo, incidente_codigo_sector, incidente_codigo_carrera)
	SELECT DISTINCT INCIDENTE_CODIGO, INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, INCIDENTE_CODIGO_SECTOR, INCIDENTE_CODIGO_CARRERA
	FROM LOS_QUERY.incidente
	WHERE INCIDENTE_CODIGO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_auto')
	DROP PROCEDURE sp_bi_dim_auto
GO

CREATE PROCEDURE sp_bi_dim_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_auto (auto_numero, auto_modelo, escuderia)
	SELECT DISTINCT auto_numero, auto_modelo, auto_escuderia
	FROM LOS_QUERY.auto
	WHERE auto_numero IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_piloto')
	DROP PROCEDURE sp_bi_dim_piloto
GO

CREATE PROCEDURE sp_bi_dim_piloto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_dim_piloto (piloto_nombre, piloto_apellido, piloto_auto_numero, piloto_auto_modelo, piloto_nacionalidad, piloto_fecha_nacimiento)
	SELECT DISTINCT piloto_nombre, piloto_apellido, piloto_auto_numero, piloto_auto_modelo, piloto_nacionalidad, piloto_fecha_nacimiento
	FROM LOS_QUERY.piloto
	WHERE piloto_nombre IS NOT NULL AND piloto_apellido IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_x_vuelta_neumatico')
	DROP PROCEDURE sp_migrar_fact_desgaste_x_vuelta_neumatico
GO

CREATE PROCEDURE sp_migrar_fact_desgaste_x_vuelta_neumatico
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_desgaste_x_vuelta_neumatico (neumatico_nro_serie, auto_numero, auto_modelo, desgaste, vuelta, circuito_codigo)
	SELECT 
		mpn.tele_neumatico_nro_serie, 
		ta.tele_auto_numero, 
		ta.tele_auto_modelo, 
		MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) as desgaste, 
		ta.tele_numero_vuelta, 
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.medicion_por_neumatico mpn
		LEFT JOIN LOS_QUERY.telemetria_auto ta on mpn.tele_auto_codigo = ta.tele_auto_codigo
		LEFT JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY mpn.tele_neumatico_nro_serie, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
	HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_x_vuelta_frenos')
	DROP PROCEDURE sp_migrar_fact_desgaste_x_vuelta_frenos
GO

CREATE PROCEDURE sp_migrar_fact_desgaste_x_vuelta_frenos
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_desgaste_x_vuelta_frenos(freno_nro_serie, auto_numero, auto_modelo,
	desgaste,
	vuelta, circuito_codigo)
	SELECT 
		fpm.TELE_FRENO_NRO_SERIE, 
		ta.tele_auto_numero, 
		ta.tele_auto_modelo, 
		MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) as desgaste, 
		ta.tele_numero_vuelta, 
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.frenos_por_medicion fpm
		JOIN LOS_QUERY.telemetria_auto ta on fpm.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY fpm.TELE_FRENO_NRO_SERIE, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
	HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_x_vuelta_motor')
	DROP PROCEDURE sp_migrar_fact_desgaste_x_vuelta_motor
GO

CREATE PROCEDURE sp_migrar_fact_desgaste_x_vuelta_motor
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_desgaste_x_vuelta_motor(motor_nro_serie, auto_numero, auto_modelo, desgaste, vuelta, circuito_codigo)
	SELECT 
		tm.tele_motor_nro_serie, 
		ta.tele_auto_numero, 
		ta.tele_auto_modelo, 
		MAX(tm.tele_motor_potencia) - MIN(tm.tele_motor_potencia) as desgaste, 
		ta.tele_numero_vuelta, 
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.telemetria_motor tm 
		JOIN LOS_QUERY.telemetria_auto ta on tm.tele_motor_telemetria = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY tm.tele_motor_nro_serie, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
	HAVING MAX(tm.tele_motor_potencia) - MIN(tm.tele_motor_potencia) <> 0
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_x_vuelta_caja')
	DROP PROCEDURE sp_migrar_fact_desgaste_x_vuelta_caja
GO

CREATE PROCEDURE sp_migrar_fact_desgaste_x_vuelta_caja
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_desgaste_x_vuelta_caja(caja_nro_serie, auto_numero, auto_modelo, desgaste, vuelta, circuito_codigo)
	SELECT 
		tc.tele_caja_nro_serie, 
		ta.tele_auto_numero, 
		ta.tele_auto_modelo, 
		MAX(tc.tele_caja_desgaste) - MIN(tc.tele_caja_desgaste) as desgaste, 
		ta.tele_numero_vuelta, 
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.telemetria_caja tc
		JOIN LOS_QUERY.telemetria_auto ta on tc.tele_caja_codigo = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY tc.tele_caja_nro_serie, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
	HAVING MAX(tc.tele_caja_desgaste) - MIN(tc.tele_caja_desgaste) <> 0
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_BI_tiempo_vuelta_escuderia')
	DROP PROCEDURE sp_migrar_BI_tiempo_vuelta_escuderia
GO

CREATE PROCEDURE sp_migrar_BI_tiempo_vuelta_escuderia
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_tiempo_vuelta_escuderia(escuderia_nombre, auto_numero, auto_modelo,
			CODIGO_CARRERA, CIRCUITO_CODIGO, codigo_tiempo, numero_vuelta, tiempo_vuelta)
	SELECT esc.escuderia_nombre, au.auto_numero, au.auto_modelo,
			car.CODIGO_CARRERA, circ.CIRCUITO_CODIGO, tiempo.codigo_tiempo,
			tele.tele_numero_vuelta, MAX(tele.tele_tiempo_vuelta) as 'Tiempo vuelta'
	FROM LOS_QUERY.telemetria_auto tele
			JOIN LOS_QUERY.auto au on tele.tele_auto_numero = au.auto_numero and
									  tele.tele_auto_modelo = au.auto_modelo
			JOIN LOS_QUERY.ESCUDERIA esc on au.auto_escuderia = esc.escuderia_nombre
			JOIN LOS_QUERY.carrera car ON tele.tele_codigo_carrera = car.CODIGO_CARRERA
			JOIN LOS_QUERY.circuito circ on circ.CIRCUITO_CODIGO = car.CARRERA_CIRCUITO_CODIGO
		    JOIN LOS_QUERY.BI_dim_tiempos tiempo ON YEAR(car.CARRERA_FECHA) = tiempo.anio AND
			 						  LOS_QUERY.get_cuatrimestre(car.CARRERA_FECHA) = tiempo.cuatrimestre
	WHERE tele.tele_tiempo_vuelta != 0
	GROUP BY esc.escuderia_nombre, au.auto_numero, au.auto_modelo, car.CODIGO_CARRERA,
			tele.tele_numero_vuelta, circ.CIRCUITO_CODIGO, tiempo.codigo_tiempo
	ORDER BY 1,2,3,4,7
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_tiempo_parada_auto')
	DROP PROCEDURE sp_migrar_tiempo_parada_auto
GO

CREATE PROCEDURE sp_migrar_tiempo_parada_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_tiempo_parada_auto(
		auto_numero, auto_modelo, duracion_parada, cuatrimestre, circuito_codigo)
	SELECT 
		p.PARADA_AUTO_NUMERO,
		p.PARADA_AUTO_MODELO,
		p.PARADA_DURACION,
		LOS_QUERY.get_cuatrimestre(car.CARRERA_FECHA),
		car.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.parada_box p
		JOIN LOS_QUERY.auto au on au.auto_numero = p.PARADA_AUTO_NUMERO
							  and au.auto_modelo = p.PARADA_AUTO_MODELO
		JOIN LOS_QUERY.carrera car ON car.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA
	GROUP BY p.PARADA_AUTO_NUMERO, p.PARADA_AUTO_MODELO, p.PARADA_DURACION, car.CARRERA_CIRCUITO_CODIGO,
		LOS_QUERY.get_cuatrimestre(car.CARRERA_FECHA)
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_parada_box')
	DROP PROCEDURE sp_migrar_fact_parada_box
GO

CREATE PROCEDURE sp_migrar_fact_parada_box
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_fact_parada_box(codigo_tiempo, circuito_codigo, escuderia_nombre,codigo_parada, duracion_parada)
	SELECT 
		tiempo.codigo_tiempo, 
		carrera.CARRERA_CIRCUITO_CODIGO, 
		auto.auto_escuderia,
		PARADA_CODIGO, 
		PARADA_DURACION
	FROM LOS_QUERY.parada_box
		JOIN LOS_QUERY.carrera ON parada_box.PARADA_CODIGO_CARRERA = carrera.CODIGO_CARRERA
	    JOIN LOS_QUERY.BI_dim_tiempos tiempo ON YEAR(carrera.CARRERA_FECHA) = tiempo.anio
		    AND LOS_QUERY.get_cuatrimestre(carrera.CARRERA_FECHA) = tiempo.cuatrimestre
	    JOIN LOS_QUERY.auto ON parada_box.PARADA_AUTO_NUMERO = auto.auto_numero
		    AND parada_box.PARADA_AUTO_MODELO = auto.auto_modelo
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_consumo_por_circuito')
	DROP PROCEDURE sp_migrar_consumo_por_circuito
GO

CREATE PROCEDURE sp_migrar_consumo_por_circuito
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_consumo_por_circuito(ciruito_codigo, consumo_combustible)
	SELECT cir.CIRCUITO_CODIGO, SUM(t.tele_auto_combustible)
	FROM LOS_QUERY.telemetria_auto t 
		JOIN LOS_QUERY.carrera car ON t.tele_codigo_carrera = car.CODIGO_CARRERA
		JOIN LOS_QUERY.circuito cir ON CIRCUITO_CODIGO = car.CARRERA_CIRCUITO_CODIGO
	group by cir.CIRCUITO_CODIGO, cir.CIRCUITO_NOMBRE
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_dim_tiempos')
	DROP PROCEDURE sp_migrar_dim_tiempos
GO

CREATE PROCEDURE sp_migrar_dim_tiempos AS
    BEGIN
        INSERT INTO LOS_QUERY.BI_dim_tiempos(anio, cuatrimestre)
           SELECT DISTINCT YEAR(c.CARRERA_FECHA), LOS_QUERY.get_cuatrimestre(CARRERA_FECHA)
		   FROM LOS_QUERY.carrera c
		   ORDER BY 1,2
    END
GO

IF EXISTS (SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_tipo_sector')
	DROP PROCEDURE sp_bi_dim_tipo_sector
GO

CREATE PROCEDURE sp_bi_dim_tipo_sector
 AS
  BEGIN
   INSERT INTO LOS_QUERY.BI_dim_tipo_sector (tipo_sector)
	SELECT DISTINCT SECTOR_TIPO
	FROM LOS_QUERY.sector
  END
GO

IF EXISTS (SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_tipo_incidentes')
	DROP PROCEDURE sp_bi_dim_tipo_incidentes
GO

CREATE PROCEDURE sp_bi_dim_tipo_incidentes
 AS
  BEGIN
   INSERT INTO LOS_QUERY.BI_dim_tipo_incidentes (tipo_incidente)
	SELECT DISTINCT INCIDENTE_TIPO
	FROM LOS_QUERY.incidente
  END
GO

IF EXISTS (SELECT [name] FROM sys.procedures WHERE [name] = 'sp_bi_dim_tipo_neumatico')
	DROP PROCEDURE sp_bi_dim_tipo_neumatico
GO

CREATE PROCEDURE sp_bi_dim_tipo_neumatico
 AS
  BEGIN
   INSERT INTO LOS_QUERY.BI_dim_tipo_neumatico (tipo_neumatico)
	SELECT DISTINCT neumatico_tipo
	FROM LOS_QUERY.neumatico
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_velocidades_auto')
	DROP PROCEDURE sp_migrar_velocidades_auto
GO

CREATE PROCEDURE sp_migrar_velocidades_auto
  AS
    BEGIN
	  INSERT INTO LOS_QUERY.BI_velocidades_auto(auto_numero, auto_modelo, velocidad, ciruito_codigo, codigo_sector, sector_tipo)
		SELECT
			t.tele_auto_numero as auto_numero,
			t.tele_auto_modelo as auto_modelo,
			MAX(t.tele_auto_velocidad) as max_vel,
			c.CIRCUITO_CODIGO as ciruito_codigo,
			s.CODIGO_SECTOR, -- solo traigo el sector para poder matchear con la dim sector en la view, ni idea si essta bien
			s.SECTOR_TIPO
		FROM LOS_QUERY.telemetria_auto t
		JOIN LOS_QUERY.sector s ON t.tele_codigo_sector = s.CODIGO_SECTOR
		JOIN LOS_QUERY.circuito c ON s.SECTOR_CIRCUITO_CODIGO = c.CIRCUITO_CODIGO
		GROUP BY t.tele_auto_numero, t.tele_auto_modelo, s.CODIGO_SECTOR, s.SECTOR_TIPO, c.CIRCUITO_CODIGO
	END
  GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_incidentes')
	DROP PROCEDURE sp_migrar_fact_incidentes
GO

CREATE PROCEDURE sp_migrar_fact_incidentes
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_fact_incidentes(circuito_codigo, escuderia_nombre, codigo_sector, codigo_tiempo, cant_inc, codigo_tipo_incidente, codigo_tipo_sector)
		SELECT
		    cir.CIRCUITO_CODIGO,
			a.auto_escuderia as Escuderia, 
			i.INCIDENTE_CODIGO_SECTOR as Sector_Incidente, 
			t.codigo_tiempo as Codigo_Tiempo,
			COUNT(i.INCIDENTE_CODIGO) as Cant_Inc, --cuenta cuantos incidentes hubo en ese tipo de sector
			ti.codigo_tipo_incidente as Tipo_Incidente,
			ts.codigo_tipo_sector as Tipo_Sector
		FROM LOS_QUERY.auto_por_incidente api
		    JOIN LOS_QUERY.incidente i ON api.auto_incidente_id = i.INCIDENTE_CODIGO
			JOIN LOS_QUERY.carrera c ON i.INCIDENTE_CODIGO_CARRERA = c.CODIGO_CARRERA
			JOIN LOS_QUERY.BI_dim_circuito cir ON cir.CIRCUITO_CODIGO = c.CARRERA_CIRCUITO_CODIGO 	
			JOIN LOS_QUERY.auto a ON  api.auto_incidente_numero = a.auto_numero and api.auto_incidente_modelo =  a.auto_modelo
			JOIN LOS_QUERY.BI_dim_tiempos t ON YEAR(c.CARRERA_FECHA) = t.anio AND LOS_QUERY.get_cuatrimestre(c.CARRERA_FECHA) = t.cuatrimestre
			JOIN LOS_QUERY.sector s ON i.INCIDENTE_CODIGO_SECTOR = s.CODIGO_SECTOR
			JOIN LOS_QUERY.BI_dim_tipo_sector ts ON ts.tipo_sector = s.SECTOR_TIPO
			JOIN LOS_QUERY.BI_dim_tipo_incidentes ti ON ti.tipo_incidente = i.INCIDENTE_TIPO
		GROUP BY cir.CIRCUITO_CODIGO, a.auto_escuderia, i.INCIDENTE_CODIGO_SECTOR, t.codigo_tiempo, ti.codigo_tipo_incidente, ts.codigo_tipo_sector
		ORDER BY 1,3
  END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEM 1
-- "Desgaste promedio de cada componente de cada auto por vuelta por circuito"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito AS
	SELECT
		dxv.auto_numero AS 'Auto Numero',
		dxv.auto_modelo AS 'Auto Modelo',
		dxv.circuito_codigo AS 'Circuito',
		AVG(dxv.desgaste) AS 'Desgaste promedio por vuelta'
	FROM LOS_QUERY.BI_desgaste_x_vuelta_neumatico dxv
	GROUP BY dxv.auto_numero, dxv.auto_modelo, dxv.circuito_codigo
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito AS
	SELECT
		dxv.auto_numero AS 'Auto Numero',
		dxv.auto_modelo AS 'Auto Modelo',
		dxv.circuito_codigo AS 'Circuito',
		AVG(dxv.desgaste) AS 'Desgaste promedio por vuelta'
	FROM LOS_QUERY.BI_desgaste_x_vuelta_frenos dxv
	GROUP BY dxv.auto_numero, dxv.auto_modelo, dxv.circuito_codigo
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito AS
	SELECT
		dxv.auto_numero AS 'Auto Numero',
		dxv.auto_modelo AS 'Auto Modelo',
		dxv.circuito_codigo AS 'Circuito',
		AVG(dxv.desgaste) AS 'Desgaste promedio por vuelta'
	FROM LOS_QUERY.BI_desgaste_x_vuelta_motor dxv
	GROUP BY dxv.auto_numero, dxv.auto_modelo, dxv.circuito_codigo
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito AS
	SELECT
		dxv.auto_numero AS 'Auto Numero',
		dxv.auto_modelo AS 'Auto Modelo',
		dxv.circuito_codigo AS 'Circuito',
		AVG(dxv.desgaste) AS 'Desgaste promedio por vuelta'
	FROM LOS_QUERY.BI_desgaste_x_vuelta_caja dxv
	GROUP BY dxv.auto_numero, dxv.auto_modelo, dxv.circuito_codigo
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_auto_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_desgaste_promedio_auto_x_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_desgaste_promedio_auto_x_auto_x_vuelta_x_circuito AS
	SELECT
		ca.[Auto Numero] AS 'Auto Numero',
		ca.[Auto Modelo] AS 'Auto Modelo',
		ca.Circuito AS 'Circuito',
		AVG(ca.[Desgaste promedio por vuelta]) AS 'Desgaste caja',
		AVG(fr.[Desgaste promedio por vuelta]) AS 'Desgaste frenos',
		AVG(mo.[Desgaste promedio por vuelta]) AS 'Desgaste motor',
		AVG(ne.[Desgaste promedio por vuelta]) AS 'Desgaste neumaticos'

	FROM LOS_QUERY.BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito ca
	JOIN LOS_QUERY.BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito fr on
		fr.[Auto Modelo] = ca.[Auto Modelo] and
		fr.[Auto Numero] = ca.[Auto Numero] and
		fr.Circuito = ca.Circuito
	JOIN LOS_QUERY.BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito mo on
		mo.[Auto Modelo] = ca.[Auto Modelo] and
		mo.[Auto Numero] = ca.[Auto Numero] and
		mo.Circuito = ca.Circuito
	JOIN LOS_QUERY.BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito ne on
		ne.[Auto Modelo] = ca.[Auto Modelo] and
		ne.[Auto Numero] = ca.[Auto Numero] and
		ne.Circuito = ca.Circuito
	GROUP BY ca.[Auto Modelo], ca.[Auto Numero], ca.Circuito
GO

-- ITEM 2
-- "Mejor tiempo de vuelta de cada escudería por circuito por año"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_vi_mejor_tiempo_vuelta')
	DROP VIEW LOS_QUERY.BI_vi_mejor_tiempo_vuelta
GO

CREATE VIEW LOS_QUERY.BI_vi_mejor_tiempo_vuelta AS
	SELECT
		mte.escuderia_nombre AS 'Escuderia',
		mte.CIRCUITO_CODIGO AS 'Circuito',
		t.anio AS 'Año',
		MIN(mte.tiempo_vuelta) AS 'Mejor Tiempo'
	FROM LOS_QUERY.BI_tiempo_vuelta_escuderia mte
	    JOIN LOS_QUERY.BI_dim_tiempos t ON t.codigo_tiempo = mte.codigo_tiempo
	GROUP BY mte.escuderia_nombre,
	mte.CIRCUITO_CODIGO,
	t.anio
GO


-- ITEM 3
-- "Los 3 de circuitos con mayor consumo de combustible promedio"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_circuitos_con_mayor_consumo_combustible')
	DROP VIEW LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible
GO

CREATE VIEW LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible AS
	SELECT 
		TOP 3 c.ciruito_codigo, c.consumo_combustible AS promedio
	FROM LOS_QUERY.BI_consumo_por_circuito AS c
	order by c.consumo_combustible
GO

-- ITEM 4
-- " Máxima velocidad alcanzada por cada auto en cada tipo de sector de cada circuito"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_max_vel_x_auto_x_tipo_sector_x_circuito')
	DROP VIEW LOS_QUERY.BI_max_vel_x_auto_x_tipo_sector_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_max_vel_x_auto_x_tipo_sector_x_circuito AS
	SELECT
	v.auto_numero,
	v.auto_modelo,
	v.ciruito_codigo,
	v.SECTOR_TIPO,
	MAX(v.velocidad) as Max_Velocidad
	FROM 	  
		LOS_QUERY.BI_velocidades_auto as v
	GROUP BY v.auto_numero, v.auto_modelo, v.ciruito_codigo, v.SECTOR_TIPO
GO

-- ITEM 5
-- "Tiempo promedio que tardo cada escuderia en las paradas por cuatrimestre"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_tiempo_promedio_por_escuderia')
	DROP VIEW LOS_QUERY.BI_tiempo_promedio_por_escuderia
GO

CREATE VIEW LOS_QUERY.BI_tiempo_promedio_por_escuderia AS
	SELECT
		e.escuderia_nombre AS 'Escuderia',
		t.cuatrimestre AS 'Cuatrimestre',
		t.anio AS 'Año',
		AVG(p_box.duracion_parada) AS 'Tiempo promedio tardado en paradas'
	FROM LOS_QUERY.BI_fact_parada_box p_box
		JOIN LOS_QUERY.BI_dim_escuderia e ON e.escuderia_nombre = p_box.escuderia_nombre
		JOIN LOS_QUERY.BI_dim_tiempos t   ON t.codigo_tiempo    = p_box.codigo_tiempo
	GROUP BY e.escuderia_nombre, t.cuatrimestre, t.anio
GO

--ITEM 6
-- "Cantidad de paradas por circuito por escudería por año"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_cant_paradas_x_circuito_x_escuderia_x_anio')
	DROP VIEW LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio
GO

CREATE VIEW LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio AS
	SELECT
		t.anio AS 'Año',
		c.CIRCUITO_NOMBRE AS 'Circuito',
		e.escuderia_nombre AS 'Escuderia',
		count(p_box.codigo_parada) AS 'Cantidad de Paradas'
	FROM LOS_QUERY.BI_fact_parada_box p_box
		JOIN LOS_QUERY.BI_dim_circuito c  ON c.CIRCUITO_CODIGO  = p_box.circuito_codigo
		JOIN LOS_QUERY.BI_dim_escuderia e ON e.escuderia_nombre = p_box.escuderia_nombre
		JOIN LOS_QUERY.BI_dim_tiempos t   ON t.codigo_tiempo    = p_box.codigo_tiempo
	GROUP BY c.CIRCUITO_NOMBRE , e.escuderia_nombre, t.anio
GO

--ITEM 7
--"Los 3 circuitos donde se consume mayor cantidad en tiempo de paradas en boxes."

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_circuitos_mayor_tiempo_en_paradas_box')
	DROP VIEW LOS_QUERY.BI_circuitos_mayor_tiempo_en_paradas_box
GO

CREATE VIEW LOS_QUERY.BI_circuitos_mayor_tiempo_en_paradas_box AS
	SELECT TOP 3
		p_box.circuito_codigo AS 'Circuito',
		SUM(p_box.duracion_parada) as 'Tiempo en Parada Box'
	FROM LOS_QUERY.BI_fact_parada_box p_box
	GROUP BY p_box.circuito_codigo
GO

--ITEM 8 
--"Los 3 circuitos más peligrosos del año, en función mayor cantidad de incidentes"
IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_circuitos_mas_peligrosos')
	DROP VIEW LOS_QUERY.BI_circuitos_mas_peligrosos
GO

CREATE VIEW LOS_QUERY.BI_circuitos_mas_peligrosos AS
WITH Circuitos_mas_peligrosos_del_anio AS(
    SELECT
	    t.anio Año,
		MAX(hi.cant_inc) Maxima_cantidad_incidentes,
		hi.circuito_codigo Codigo_Circuito, ROW_NUMBER() OVER (PARTITION BY t.anio ORDER BY t.anio) AS Fila 
	FROM LOS_QUERY.BI_fact_incidentes hi
	JOIN LOS_QUERY.carrera ca on ca.CARRERA_CIRCUITO_CODIGO = hi.CIRCUITO_CODIGO 
	JOIN LOS_QUERY.BI_dim_incidente inc on inc.incidente_codigo_carrera = ca.CARRERA_CIRCUITO_CODIGO
	JOIN LOS_QUERY.BI_dim_tiempos t   ON t.codigo_tiempo    =  hi.codigo_tiempo
	GROUP BY t.anio, hi.circuito_codigo
)
SELECT Año, Codigo_Circuito, Maxima_cantidad_incidentes
FROM Circuitos_mas_peligrosos_del_anio
WHERE Fila <= 3
GO


--ITEM 9 
--"Promedio de incidentes que presenta cada escudería por año en los distintos tipo de sectores."
IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_prom_incidentes_escuderia_x_anio_x_tipo_sector')
	DROP VIEW LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector
GO

CREATE VIEW LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector AS
	SELECT 
	  hi.escuderia_nombre as 'Escuderia',
	  t.anio as 'Anio_Incidente',
	  s.tipo_sector as 'Tipo_Sector', 
	  AVG(hi.cant_inc) as 'Promedio'
	FROM LOS_QUERY.BI_fact_incidentes hi
		JOIN LOS_QUERY.BI_dim_tiempos t   ON t.codigo_tiempo    =  hi.codigo_tiempo
		JOIN LOS_QUERY.BI_dim_tipo_sector s   ON s.codigo_tipo_sector  = hi.codigo_tipo_sector
	GROUP BY hi.escuderia_nombre, s.tipo_sector, t.anio
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE	sp_bi_dim_motor
	EXECUTE sp_bi_dim_freno
	EXECUTE sp_bi_dim_circuito
	EXECUTE sp_bi_dim_neumatico
	EXECUTE sp_bi_dim_caja
	EXECUTE sp_bi_dim_escuderia
	EXECUTE sp_bi_dim_sector
	EXECUTE sp_bi_dim_incidente
	EXECUTE sp_bi_dim_auto
	EXECUTE sp_bi_dim_piloto
	EXECUTE sp_migrar_dim_tiempos
	EXECUTE sp_bi_dim_tipo_sector
	EXECUTE sp_bi_dim_tipo_incidentes
	EXECUTE sp_bi_dim_tipo_neumatico
	
	EXECUTE sp_migrar_fact_desgaste_x_vuelta_neumatico
	EXECUTE sp_migrar_fact_desgaste_x_vuelta_frenos
	EXECUTE sp_migrar_fact_desgaste_x_vuelta_motor
	EXECUTE sp_migrar_fact_desgaste_x_vuelta_caja
	EXECUTE sp_migrar_velocidades_auto
	EXECUTE sp_migrar_consumo_por_circuito
	EXECUTE sp_migrar_tiempo_parada_auto
	EXECUTE sp_migrar_fact_parada_box 
	EXECUTE sp_migrar_fact_incidentes
	EXECUTE sp_migrar_BI_tiempo_vuelta_escuderia
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM LOS_QUERY.BI_consumo_por_circuito)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_desgaste_x_vuelta_caja)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_desgaste_x_vuelta_frenos)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_desgaste_x_vuelta_motor)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_desgaste_x_vuelta_neumatico)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_auto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_caja)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_circuito)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_incidente)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_escuderia)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_freno)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_motor)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_neumatico)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_piloto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_sector)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_tiempos)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_tipo_sector)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_tipo_incidentes)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_dim_tipo_neumatico)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_fact_parada_box)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_fact_incidentes)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_tiempo_parada_auto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.BI_velocidades_auto)

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

---------------------------------------------------
-- SELECT DE LAS VISTAS --
---------------------------------------------------
--Item 1
-- SELECT * FROM LOS_QUERY.BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito
-- SELECT * FROM LOS_QUERY.BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito
-- SELECT * FROM LOS_QUERY.BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito
-- SELECT * FROM LOS_QUERY.BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito

--Item 2
-- SELECT * FROM LOS_QUERY.BI_vi_mejor_tiempo_vuelta

--Item 3
--SELECT * FROM LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible

--Item 5
 --SELECT * FROM LOS_QUERY.BI_tiempo_promedio_por_escuderia


--Item 6
-- SELECT * FROM LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio

--Item 7
--SELECT * FROM LOS_QUERY.BI_circuitos_mayor_tiempo_en_paradas_box

--Item 8
--SELECT * FROM LOS_QUERY.BI_circuitos_mas_peligrosos

--Item 9
--SELECT * FROM LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector

