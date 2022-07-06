USE GD1C2022
GO

---------------------------------------------------
-- ELIMINACION DE TABLAS EN CASO DE QUE EXISTAN
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cambio_de_neumatico')
DROP TABLE LOS_QUERY.cambio_de_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'parada_box')
DROP TABLE LOS_QUERY.parada_box

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'frenos_por_medicion')
DROP TABLE LOS_QUERY.frenos_por_medicion

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'telemetria_motor')
DROP TABLE LOS_QUERY.telemetria_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'telemetria_caja')
DROP TABLE LOS_QUERY.telemetria_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'piloto')
DROP TABLE LOS_QUERY.piloto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medicion_por_neumatico')
DROP TABLE LOS_QUERY.medicion_por_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'freno')
DROP TABLE LOS_QUERY.freno

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'telemetria_auto')
DROP TABLE LOS_QUERY.telemetria_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'auto_por_incidente')
DROP TABLE LOS_QUERY.auto_por_incidente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'caja')
DROP TABLE LOS_QUERY.caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'motor')
DROP TABLE LOS_QUERY.motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'auto')
DROP TABLE LOS_QUERY.auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'incidente')
DROP TABLE LOS_QUERY.incidente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'neumatico')
DROP TABLE LOS_QUERY.neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'escuderia')
DROP TABLE LOS_QUERY.ESCUDERIA

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'sector')
DROP TABLE LOS_QUERY.sector

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'carrera')
DROP TABLE LOS_QUERY.carrera

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'circuito')
DROP TABLE LOS_QUERY.circuito

---------------------------------------------------
-- ELIMINACION DE VISTAS EN CASO DE QUE EXISTAN
---------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vi_pilotos_por_pais')
	DROP VIEW LOS_QUERY.vi_pilotos_por_pais
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vi_incidentes_por_auto')
	DROP VIEW LOS_QUERY.vi_incidentes_por_auto
GO

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'vi_cambios_por_auto')
	DROP VIEW LOS_QUERY.vi_cambios_por_auto
GO

--------------------------------------------------- 
-- CREACION DE ESQUEMA
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'LOS_QUERY')
DROP SCHEMA LOS_QUERY
GO

PRINT 'Creando ESQUEMA LOS_QUERY' 
GO

CREATE SCHEMA LOS_QUERY;
GO

---------------------------------------------------
-- CREACIÓN DE TABLAS
---------------------------------------------------

CREATE TABLE LOS_QUERY.circuito(
CIRCUITO_CODIGO int,
CIRCUITO_NOMBRE varchar(255),
CIRCUITO_PAIS_CODIGO varchar(255),
PRIMARY KEY (CIRCUITO_CODIGO),
);
GO

CREATE TABLE LOS_QUERY.carrera(
CODIGO_CARRERA int,
CARRERA_CIRCUITO_CODIGO int not null,
CARRERA_FECHA date,
CARRERA_CLIMA varchar(100) null,
CARRERA_CANT_VUELTAS int null,
CARRERA_TOTAL_CARRERA decimal(18,2),
PRIMARY KEY (CODIGO_CARRERA),
FOREIGN KEY (CARRERA_CIRCUITO_CODIGO) REFERENCES LOS_QUERY.circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.sector(
CODIGO_SECTOR int PRIMARY KEY,
SECTOR_DISTANCIA decimal not null,
SECTOR_TIPO varchar(255),
SECTOR_CIRCUITO_CODIGO int null,
SECTOR_CIRCUITO_NOMBRE varchar(255) null
);

CREATE TABLE LOS_QUERY.ESCUDERIA
(
escuderia_nombre VARCHAR(255),
escuderia_pais VARCHAR(255)
PRIMARY KEY (escuderia_nombre)
);

CREATE TABLE LOS_QUERY.neumatico
(
neumatico_nro_serie VARCHAR(255) not null,
neumatico_posicion VARCHAR(255),
neumatico_tipo VARCHAR(255),
PRIMARY KEY (neumatico_nro_serie)
);

CREATE TABLE LOS_QUERY.incidente(
INCIDENTE_CODIGO int IDENTITY(1,1),
INCIDENTE_BANDERA varchar(255),
INCIDENTE_NUMERO_VUELTA decimal(18,0),
INCIDENTE_TIPO varchar(255),
INCIDENTE_CODIGO_CARRERA int,
INCIDENTE_CODIGO_SECTOR int,
PRIMARY KEY (INCIDENTE_CODIGO),
FOREIGN KEY (INCIDENTE_CODIGO_CARRERA) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
FOREIGN KEY (INCIDENTE_CODIGO_SECTOR) REFERENCES LOS_QUERY.sector(CODIGO_SECTOR)
);

CREATE TABLE LOS_QUERY.auto
(
auto_numero int,
auto_modelo VARCHAR(255),
auto_escuderia VARCHAR(255),
PRIMARY KEY (auto_numero, auto_modelo),
FOREIGN KEY (auto_escuderia) REFERENCES LOS_QUERY.ESCUDERIA(escuderia_nombre)
);

CREATE TABLE LOS_QUERY.motor
(
motor_nro_serie VARCHAR(255) not null,
motor_modelo VARCHAR(255) not null,
PRIMARY KEY (motor_nro_serie)
);

CREATE TABLE LOS_QUERY.caja
(
caja_nro_serie VARCHAR(255),
caja_modelo VARCHAR(255),
PRIMARY KEY (caja_nro_serie)
);

CREATE TABLE LOS_QUERY.freno
(
FRENO_NRO_SERIE varchar(255),
FRENO_POSICION varchar(255) not null,
FRENO_TAMANIO_DISCO decimal
PRIMARY KEY (FRENO_NRO_SERIE),
);

CREATE TABLE LOS_QUERY.telemetria_auto
(
tele_auto_codigo decimal(18,0),
tele_auto_numero int,
tele_auto_modelo varchar(255),
tele_codigo_carrera int,
tele_codigo_sector int,
tele_numero_vuelta decimal(18,0),
tele_distancia_vuelta decimal(18,2),
tele_distancia_carrera decimal(18,6),
tele_auto_posicion decimal(18,0),
tele_tiempo_vuelta decimal(18,10),
tele_auto_velocidad decimal(18,2),
tele_auto_combustible decimal(18,2),
PRIMARY KEY (tele_auto_codigo),
FOREIGN KEY (tele_auto_numero, tele_auto_modelo)
REFERENCES LOS_QUERY.auto(auto_numero, auto_modelo),
FOREIGN KEY (tele_codigo_carrera) REFERENCES LOS_QUERY.carrera(codigo_carrera),
FOREIGN KEY (tele_codigo_sector) REFERENCES LOS_QUERY.SECTOR(codigo_sector)
);

CREATE TABLE LOS_QUERY.telemetria_motor
(
tele_motor_telemetria decimal(18,0),
tele_motor_nro_serie varchar(255) not null,
tele_motor_potencia decimal(18,6),
tele_motor_rpm decimal(18,6),
tele_motor_aceite decimal(18,6),
tele_motor_agua decimal(18,6),
PRIMARY KEY (tele_motor_telemetria),
FOREIGN KEY (tele_motor_telemetria)
REFERENCES LOS_QUERY.telemetria_auto(tele_auto_codigo),
FOREIGN KEY (tele_motor_nro_serie)
REFERENCES LOS_QUERY.motor(motor_nro_serie)
);

CREATE TABLE LOS_QUERY.telemetria_caja
(
tele_caja_codigo decimal(18,0),
tele_caja_nro_serie varchar(255),
tele_caja_rpm decimal(18,6),
tele_caja_temp_aceite decimal(18,6),
tele_caja_desgaste decimal(18,6),
PRIMARY KEY (tele_caja_codigo),
FOREIGN KEY (tele_caja_codigo)
REFERENCES LOS_QUERY.telemetria_auto(tele_auto_codigo),
FOREIGN KEY (tele_caja_nro_serie)
REFERENCES LOS_QUERY.caja(caja_nro_serie)
)

CREATE TABLE LOS_QUERY.frenos_por_medicion(
AUTO_CODIGO decimal not null,
TELE_FRENO_NRO_SERIE varchar(255) not null,
TELE_FRENO_TEMPERATURA decimal(18,2),
TELE_FRENO_GROSOR_PASTILLA decimal(18,2),
PRIMARY KEY (AUTO_CODIGO, TELE_FRENO_NRO_SERIE),
FOREIGN KEY (AUTO_CODIGO) REFERENCES LOS_QUERY.telemetria_auto(tele_auto_codigo),
FOREIGN KEY (TELE_FRENO_NRO_SERIE) REFERENCES LOS_QUERY.freno(freno_nro_serie)
);

CREATE TABLE LOS_QUERY.parada_box(
PARADA_CODIGO int IDENTITY(1,1),
PARADA_VUELTA int,
PARADA_CODIGO_CARRERA int not null,
PARADA_AUTO_NUMERO int,
PARADA_AUTO_MODELO varchar(255),
PARADA_DURACION decimal null,
PRIMARY KEY (PARADA_CODIGO),
FOREIGN KEY (PARADA_CODIGO_CARRERA) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
FOREIGN KEY (PARADA_AUTO_NUMERO, PARADA_AUTO_MODELO) REFERENCES LOS_QUERY.auto(auto_numero,auto_modelo)
);

CREATE TABLE LOS_QUERY.cambio_de_neumatico(
CAMBIO_PARADA int,
CAMBIO_SERIE_NEUMATICO_VIEJO varchar(255) not null,
CAMBIO_SERIE_NEUMATICO_NUEVO varchar(255) not null,
CAMBIO_POSICION varchar(255),
PRIMARY KEY (CAMBIO_PARADA, CAMBIO_POSICION),
FOREIGN KEY (CAMBIO_SERIE_NEUMATICO_VIEJO) REFERENCES LOS_QUERY.neumatico(neumatico_nro_serie),
FOREIGN KEY (CAMBIO_SERIE_NEUMATICO_NUEVO) REFERENCES LOS_QUERY.neumatico(neumatico_nro_serie),
FOREIGN KEY (CAMBIO_PARADA) REFERENCES LOS_QUERY.parada_box(parada_codigo)
);

CREATE TABLE LOS_QUERY.piloto
(
piloto_nombre VARCHAR(50),
piloto_apellido VARCHAR(50),
piloto_auto_numero int,
piloto_auto_modelo VARCHAR(255),
piloto_nacionalidad VARCHAR(50),
piloto_fecha_nacimiento date,
PRIMARY KEY (piloto_nombre, piloto_apellido),
FOREIGN KEY (piloto_auto_numero, piloto_auto_modelo)
REFERENCES LOS_QUERY.auto(auto_numero, auto_modelo)
);

CREATE TABLE LOS_QUERY.medicion_por_neumatico
(
tele_auto_codigo decimal(18,0),
tele_neumatico_nro_serie VARCHAR(255),
tele_neumatico_presion decimal(18,6),
tele_neumatico_temperatura decimal(18,6),
tele_neumatico_profundidad decimal(18,6)
PRIMARY KEY (tele_auto_codigo, tele_neumatico_nro_serie),
FOREIGN KEY (tele_auto_codigo) REFERENCES LOS_QUERY.TELEMETRIA_AUTO(tele_auto_codigo),
FOREIGN KEY (tele_neumatico_nro_serie) REFERENCES LOS_QUERY.NEUMATICO(neumatico_nro_serie)
);

CREATE TABLE LOS_QUERY.auto_por_incidente
(
auto_incidente_id int not null,
auto_incidente_numero int,
auto_incidente_modelo varchar(255),
PRIMARY KEY (auto_incidente_id, auto_incidente_numero, auto_incidente_modelo),
FOREIGN KEY (auto_incidente_id)
REFERENCES LOS_QUERY.INCIDENTE(incidente_codigo),
FOREIGN KEY (auto_incidente_numero,auto_incidente_modelo)
REFERENCES LOS_QUERY.auto(auto_numero,auto_modelo)
);

GO

----------------------------------------------------
-- CREACIÓN DE VISTAS
----------------------------------------------------

CREATE VIEW LOS_QUERY.vi_cambios_por_auto AS
SELECT auto_numero, auto_modelo, isnull(count(*), 0) AS cantidad_de_cambios
	FROM [LOS_QUERY].[auto] a
	LEFT JOIN [LOS_QUERY].[parada_box] p ON a.auto_numero = p.PARADA_AUTO_NUMERO and a.auto_modelo = p.PARADA_AUTO_MODELO
	GROUP BY auto_numero, auto_modelo
GO

CREATE VIEW LOS_QUERY.vi_incidentes_por_auto AS
SELECT auto_numero, auto_modelo, isnull(count(*), 0) AS cantidad_de_incidentes
	FROM LOS_QUERY.auto a
	LEFT JOIN LOS_QUERY.auto_por_incidente i ON a.auto_numero = i.auto_incidente_numero and a.auto_modelo = i.auto_incidente_modelo
	GROUP BY auto_numero, auto_modelo
GO

CREATE VIEW LOS_QUERY.vi_pilotos_por_pais AS
	SELECT p.piloto_nacionalidad, isnull(count(*), 0) AS cantidad
	FROM LOS_QUERY.piloto p
	GROUP BY p.piloto_nacionalidad
GO

---------------------------------------------------
-- CREACION DE INDICES
---------------------------------------------------

---------------------------------------------------
--CREACION DE STORE PROCEDURES
---------------------------------------------------

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_circuito')
	DROP PROCEDURE sp_migrar_circuito
GO

CREATE PROCEDURE sp_migrar_circuito
 AS
  BEGIN
    INSERT INTO LOS_QUERY.circuito (CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS_CODIGO)
	SELECT DISTINCT CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS
	FROM gd_esquema.Maestra
	WHERE CIRCUITO_CODIGO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_carrera')
	DROP PROCEDURE sp_migrar_carrera
GO

CREATE PROCEDURE sp_migrar_carrera
 AS
  BEGIN
    INSERT INTO LOS_QUERY.carrera (CODIGO_CARRERA, CARRERA_CIRCUITO_CODIGO, CARRERA_FECHA, CARRERA_CLIMA, CARRERA_CANT_VUELTAS, CARRERA_TOTAL_CARRERA)
	SELECT DISTINCT CODIGO_CARRERA, CIRCUITO_CODIGO, CARRERA_FECHA, CARRERA_CLIMA, CARRERA_CANT_VUELTAS, CARRERA_TOTAL_CARRERA
	FROM gd_esquema.Maestra
	--WHERE CODIGO_CARRERA IS NOT NULL AND CODG IS NOT NULL --no se con que criterio toman las cosas que no tienen que ser null
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_sector')
	DROP PROCEDURE sp_migrar_sector
GO

CREATE PROCEDURE sp_migrar_sector
 AS
  BEGIN
    INSERT INTO LOS_QUERY.sector (CODIGO_SECTOR, SECTOR_DISTANCIA, SECTOR_TIPO, SECTOR_CIRCUITO_CODIGO, SECTOR_CIRCUITO_NOMBRE)
	SELECT DISTINCT CODIGO_SECTOR, SECTOR_DISTANCIA, SECTO_TIPO, CIRCUITO_CODIGO, CIRCUITO_NOMBRE
	FROM gd_esquema.Maestra
	WHERE CODIGO_SECTOR IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_escuderia')
	DROP PROCEDURE sp_migrar_escuderia
GO

CREATE PROCEDURE sp_migrar_escuderia
 AS
  BEGIN
    INSERT INTO LOS_QUERY.ESCUDERIA (escuderia_nombre, escuderia_pais)
	SELECT DISTINCT ESCUDERIA_NOMBRE, ESCUDERIA_NACIONALIDAD
	FROM gd_esquema.Maestra
	WHERE ESCUDERIA_NOMBRE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_incidente')
	DROP PROCEDURE sp_migrar_incidente
GO

--sp_migrar INCIDENTE
CREATE PROCEDURE sp_migrar_incidente
 AS
  BEGIN
    INSERT INTO LOS_QUERY.incidente (INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, INCIDENTE_CODIGO_CARRERA, INCIDENTE_CODIGO_SECTOR)
	SELECT DISTINCT INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, CODIGO_CARRERA, CODIGO_SECTOR
	FROM gd_esquema.Maestra
	WHERE INCIDENTE_BANDERA IS NOT NULL 
		AND INCIDENTE_NUMERO_VUELTA IS NOT NULL 
		AND INCIDENTE_TIPO IS NOT NULL
		AND CODIGO_CARRERA IS NOT NULL
		AND CODIGO_SECTOR IS NOT NULL --quiero creer que las claves (foraneas o primarias) son las que no tienen que ser null
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_auto')
	DROP PROCEDURE sp_migrar_auto
GO

CREATE PROCEDURE sp_migrar_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.auto (auto_numero, auto_modelo, auto_escuderia)
	SELECT DISTINCT AUTO_NUMERO, AUTO_MODELO, ESCUDERIA_NOMBRE
	FROM gd_esquema.Maestra
	WHERE AUTO_NUMERO IS NOT NULL
		AND AUTO_MODELO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_motor')
	DROP PROCEDURE sp_migrar_motor
GO

CREATE PROCEDURE sp_migrar_motor
 AS
  BEGIN
    INSERT INTO LOS_QUERY.motor (motor_nro_serie, motor_modelo)
	SELECT DISTINCT TELE_MOTOR_NRO_SERIE, TELE_MOTOR_MODELO
	FROM gd_esquema.Maestra
	WHERE TELE_MOTOR_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_caja')
	DROP PROCEDURE sp_migrar_caja
GO

--sp_migrar CAJA
CREATE PROCEDURE sp_migrar_caja
 AS
  BEGIN
    INSERT INTO LOS_QUERY.caja (caja_nro_serie, caja_modelo)
	SELECT DISTINCT TELE_CAJA_NRO_SERIE, TELE_CAJA_MODELO
	FROM gd_esquema.Maestra
	WHERE TELE_CAJA_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_telemetria_auto')
	DROP PROCEDURE sp_migrar_telemetria_auto
GO

CREATE PROCEDURE sp_migrar_telemetria_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.telemetria_auto (
		tele_auto_codigo, tele_auto_numero, tele_auto_modelo, tele_codigo_carrera, tele_codigo_sector,
		tele_numero_vuelta, tele_distancia_vuelta, tele_distancia_carrera,
		tele_auto_posicion, tele_tiempo_vuelta, tele_auto_velocidad, tele_auto_combustible)
	SELECT DISTINCT
		TELE_AUTO_CODIGO, AUTO_NUMERO, AUTO_MODELO, CODIGO_CARRERA, CODIGO_SECTOR,
		TELE_AUTO_NUMERO_VUELTA, TELE_AUTO_DISTANCIA_VUELTA, TELE_AUTO_DISTANCIA_CARRERA,
		TELE_AUTO_POSICION, TELE_AUTO_TIEMPO_VUELTA, TELE_AUTO_VELOCIDAD, TELE_AUTO_COMBUSTIBLE
	FROM gd_esquema.Maestra
	WHERE tele_auto_codigo IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_frenos')
	DROP PROCEDURE sp_migrar_frenos
GO

CREATE PROCEDURE sp_migrar_frenos
 AS
  BEGIN
    INSERT INTO LOS_QUERY.freno (FRENO_NRO_SERIE, FRENO_POSICION, FRENO_TAMANIO_DISCO)
	SELECT DISTINCT TELE_FRENO1_NRO_SERIE, TELE_FRENO1_POSICION, TELE_FRENO1_TAMANIO_DISCO
	FROM gd_esquema.Maestra
	WHERE TELE_FRENO1_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_FRENO2_NRO_SERIE, TELE_FRENO2_POSICION, TELE_FRENO2_TAMANIO_DISCO
	FROM gd_esquema.Maestra
	WHERE TELE_FRENO2_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_FRENO3_NRO_SERIE, TELE_FRENO3_POSICION, TELE_FRENO3_TAMANIO_DISCO
	FROM gd_esquema.Maestra
	WHERE TELE_FRENO3_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_FRENO4_NRO_SERIE, TELE_FRENO4_POSICION, TELE_FRENO4_TAMANIO_DISCO
	FROM gd_esquema.Maestra
	WHERE TELE_FRENO4_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_parada_box')
	DROP PROCEDURE sp_migrar_parada_box
GO

CREATE PROCEDURE sp_migrar_parada_box
AS
  BEGIN
    INSERT INTO LOS_QUERY.parada_box (PARADA_VUELTA, PARADA_CODIGO_CARRERA, PARADA_AUTO_NUMERO, PARADA_AUTO_MODELO, PARADA_DURACION)
	SELECT DISTINCT PARADA_BOX_VUELTA, CODIGO_CARRERA, AUTO_NUMERO, AUTO_MODELO, PARADA_BOX_TIEMPO
	FROM gd_esquema.Maestra
	WHERE PARADA_BOX_VUELTA IS NOT NULL AND CODIGO_CARRERA IS NOT NULL AND AUTO_NUMERO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_frenos_por_medicion')
	DROP PROCEDURE sp_migrar_frenos_por_medicion
GO

CREATE PROCEDURE sp_migrar_frenos_por_medicion
 AS
  BEGIN
    INSERT INTO LOS_QUERY.frenos_por_medicion (AUTO_CODIGO, TELE_FRENO_NRO_SERIE, TELE_FRENO_TEMPERATURA, TELE_FRENO_GROSOR_PASTILLA)
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_FRENO1_NRO_SERIE, TELE_FRENO1_TEMPERATURA, TELE_FRENO1_GROSOR_PASTILLA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL and TELE_FRENO1_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_FRENO2_NRO_SERIE, TELE_FRENO2_TEMPERATURA, TELE_FRENO2_GROSOR_PASTILLA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL and TELE_FRENO2_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_FRENO3_NRO_SERIE, TELE_FRENO3_TEMPERATURA, TELE_FRENO3_GROSOR_PASTILLA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL and TELE_FRENO3_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_FRENO4_NRO_SERIE, TELE_FRENO4_TEMPERATURA, TELE_FRENO4_GROSOR_PASTILLA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL and TELE_FRENO4_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_piloto')
	DROP PROCEDURE sp_migrar_piloto
GO

CREATE PROCEDURE sp_migrar_piloto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.piloto (piloto_nombre, piloto_apellido, piloto_auto_numero, piloto_auto_modelo, piloto_nacionalidad, piloto_fecha_nacimiento)
	SELECT DISTINCT PILOTO_NOMBRE, PILOTO_APELLIDO, AUTO_NUMERO, AUTO_MODELO, PILOTO_NACIONALIDAD, PILOTO_FECHA_NACIMIENTO
	FROM gd_esquema.Maestra
	WHERE PILOTO_NOMBRE IS NOT NULL AND AUTO_NUMERO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_neumatico')
	DROP PROCEDURE sp_migrar_neumatico
GO

/*
CREATE PROCEDURE sp_migrar_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.neumatico (neumatico_nro_serie, neumatico_posicion, neumatico_tipo)
	SELECT DISTINCT TELE_NEUMATICO1_NRO_SERIE, TELE_NEUMATICO1_POSICION, TELE_NEUMATICO1_TIPO
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO1_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO2_NRO_SERIE, TELE_NEUMATICO2_POSICION, TELE_NEUMATICO2_TIPO
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO2_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO1_NRO_SERIE, TELE_NEUMATICO1_POSICION, TELE_NEUMATICO3_TIPO
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO3_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO4_NRO_SERIE, TELE_NEUMATICO4_POSICION, TELE_NEUMATICO4_TIPO
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO4_NRO_SERIE IS NOT NULL
  END
GO
*/

CREATE PROCEDURE sp_migrar_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.neumatico (neumatico_nro_serie, neumatico_posicion)
	SELECT DISTINCT TELE_NEUMATICO1_NRO_SERIE, TELE_NEUMATICO1_POSICION
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO1_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO2_NRO_SERIE, TELE_NEUMATICO2_POSICION
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO2_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO3_NRO_SERIE, TELE_NEUMATICO3_POSICION
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO3_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_NEUMATICO4_NRO_SERIE, TELE_NEUMATICO4_POSICION
	FROM gd_esquema.Maestra
	WHERE TELE_NEUMATICO4_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_telemetria_motor')
	DROP PROCEDURE sp_migrar_telemetria_motor
GO

CREATE PROCEDURE sp_migrar_telemetria_motor
 AS
  BEGIN
    INSERT INTO LOS_QUERY.telemetria_motor(tele_motor_telemetria, tele_motor_nro_serie, tele_motor_potencia, tele_motor_rpm, tele_motor_aceite, tele_motor_agua)
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_MOTOR_NRO_SERIE, TELE_MOTOR_POTENCIA, TELE_MOTOR_RPM, TELE_MOTOR_TEMP_ACEITE, TELE_MOTOR_TEMP_AGUA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL AND TELE_MOTOR_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_telemetria_caja')
	DROP PROCEDURE sp_migrar_telemetria_caja
GO

CREATE PROCEDURE sp_migrar_telemetria_caja
 AS
  BEGIN
    INSERT INTO LOS_QUERY.telemetria_caja(tele_caja_codigo, tele_caja_nro_serie, tele_caja_rpm, tele_caja_temp_aceite, tele_caja_desgaste)
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_CAJA_NRO_SERIE, TELE_CAJA_RPM, TELE_CAJA_TEMP_ACEITE, TELE_CAJA_DESGASTE
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL AND TELE_CAJA_NRO_SERIE IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_cambio_de_neumatico')
	DROP PROCEDURE sp_migrar_cambio_de_neumatico
GO

CREATE PROCEDURE sp_migrar_cambio_de_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.cambio_de_neumatico(cambio_parada, CAMBIO_SERIE_NEUMATICO_NUEVO, CAMBIO_SERIE_NEUMATICO_VIEJO, CAMBIO_POSICION)
    SELECT DISTINCT p.PARADA_CODIGO, origen.NEUMATICO1_NRO_SERIE_NUEVO, origen.NEUMATICO1_NRO_SERIE_VIEJO, origen.NEUMATICO1_POSICION_NUEVO
	FROM GD1C2022.gd_esquema.Maestra AS origen
	join LOS_QUERY.parada_box p on origen.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA and
			origen.AUTO_NUMERO = p.PARADA_AUTO_NUMERO and
			origen.AUTO_MODELO = p.PARADA_AUTO_MODELO and
			origen.PARADA_BOX_VUELTA = p.PARADA_VUELTA
	WHERE origen.NEUMATICO1_NRO_SERIE_NUEVO IS NOT NULL and origen.NEUMATICO1_NRO_SERIE_VIEJO IS NOT NULL
	UNION
	SELECT DISTINCT p.PARADA_CODIGO, origen.NEUMATICO2_NRO_SERIE_NUEVO, origen.NEUMATICO2_NRO_SERIE_VIEJO, origen.NEUMATICO2_POSICION_NUEVO
	FROM GD1C2022.gd_esquema.Maestra AS origen
	join LOS_QUERY.parada_box p on origen.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA and
			origen.PARADA_BOX_VUELTA = p.PARADA_VUELTA and
			origen.AUTO_NUMERO = p.PARADA_AUTO_NUMERO and
			origen.AUTO_MODELO = p.PARADA_AUTO_MODELO
	WHERE origen.NEUMATICO2_NRO_SERIE_NUEVO IS NOT NULL and origen.NEUMATICO2_NRO_SERIE_VIEJO IS NOT NULL
	UNION
	SELECT DISTINCT p.PARADA_CODIGO, origen.NEUMATICO3_NRO_SERIE_NUEVO, origen.NEUMATICO3_NRO_SERIE_VIEJO, origen.NEUMATICO3_POSICION_NUEVO
	FROM GD1C2022.gd_esquema.Maestra AS origen
	join LOS_QUERY.parada_box p on origen.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA and
			origen.PARADA_BOX_VUELTA = p.PARADA_VUELTA and
			origen.AUTO_NUMERO = p.PARADA_AUTO_NUMERO and
			origen.AUTO_MODELO = p.PARADA_AUTO_MODELO
	WHERE origen.NEUMATICO3_NRO_SERIE_NUEVO IS NOT NULL and origen.NEUMATICO3_NRO_SERIE_VIEJO IS NOT NULL
	UNION
	SELECT DISTINCT p.PARADA_CODIGO, origen.NEUMATICO1_NRO_SERIE_NUEVO, origen.NEUMATICO1_NRO_SERIE_VIEJO, origen.NEUMATICO4_POSICION_NUEVO
	FROM GD1C2022.gd_esquema.Maestra AS origen
	join LOS_QUERY.parada_box p on origen.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA and
			origen.PARADA_BOX_VUELTA = p.PARADA_VUELTA and
			origen.AUTO_NUMERO = p.PARADA_AUTO_NUMERO and
			origen.AUTO_MODELO = p.PARADA_AUTO_MODELO
	WHERE origen.NEUMATICO4_NRO_SERIE_NUEVO IS NOT NULL and origen.NEUMATICO4_NRO_SERIE_VIEJO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_auto_por_incidente')
	DROP PROCEDURE sp_migrar_auto_por_incidente
GO

CREATE PROCEDURE sp_migrar_auto_por_incidente
 AS
  BEGIN
    INSERT INTO LOS_QUERY.auto_por_incidente(auto_incidente_id, auto_incidente_numero, auto_incidente_modelo)
    SELECT DISTINCT i.INCIDENTE_CODIGO, origen.AUTO_NUMERO, origen.AUTO_MODELO
	FROM GD1C2022.gd_esquema.Maestra AS origen
	join LOS_QUERY.incidente i on origen.INCIDENTE_BANDERA = i.INCIDENTE_BANDERA and
		origen.INCIDENTE_NUMERO_VUELTA = i.INCIDENTE_NUMERO_VUELTA and
		origen.INCIDENTE_TIPO = i.INCIDENTE_TIPO and
		origen.CODIGO_CARRERA = i.INCIDENTE_CODIGO_CARRERA and
		origen.CODIGO_SECTOR = i.INCIDENTE_CODIGO_SECTOR
	WHERE i.INCIDENTE_CODIGO IS NOT NULL
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_medicion_por_neumatico')
	DROP PROCEDURE sp_migrar_medicion_por_neumatico
GO

CREATE PROCEDURE sp_migrar_medicion_por_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.medicion_por_neumatico(tele_auto_codigo, tele_neumatico_nro_serie, tele_neumatico_presion,
		tele_neumatico_profundidad, tele_neumatico_temperatura)
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_NEUMATICO1_NRO_SERIE, TELE_NEUMATICO1_PRESION,
		TELE_NEUMATICO1_PROFUNDIDAD, TELE_NEUMATICO1_TEMPERATURA
	FROM gd_esquema.Maestra
	WHERE tele_auto_codigo IS NOT NULL and TELE_NEUMATICO1_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_NEUMATICO2_NRO_SERIE, TELE_NEUMATICO2_PRESION,
		TELE_NEUMATICO2_PROFUNDIDAD, TELE_NEUMATICO2_TEMPERATURA
	FROM gd_esquema.Maestra
	WHERE tele_auto_codigo IS NOT NULL and TELE_NEUMATICO2_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_NEUMATICO3_NRO_SERIE, TELE_NEUMATICO3_PRESION,
		TELE_NEUMATICO3_PROFUNDIDAD, TELE_NEUMATICO3_TEMPERATURA
	FROM gd_esquema.Maestra
	WHERE tele_auto_codigo IS NOT NULL and TELE_NEUMATICO3_NRO_SERIE IS NOT NULL
	UNION
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_NEUMATICO4_NRO_SERIE, TELE_NEUMATICO4_PRESION,
		TELE_NEUMATICO4_PROFUNDIDAD, TELE_NEUMATICO4_TEMPERATURA
	FROM gd_esquema.Maestra
	WHERE tele_auto_codigo IS NOT NULL and TELE_NEUMATICO4_NRO_SERIE IS NOT NULL
  END
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE sp_migrar_circuito
	EXECUTE sp_migrar_carrera
	EXECUTE sp_migrar_sector
	EXECUTE sp_migrar_escuderia

	EXECUTE sp_migrar_neumatico
	EXECUTE sp_migrar_incidente
	EXECUTE sp_migrar_auto
	EXECUTE sp_migrar_motor
	EXECUTE sp_migrar_caja

	EXECUTE sp_migrar_telemetria_auto
	EXECUTE sp_migrar_frenos
	EXECUTE sp_migrar_parada_box
	EXECUTE sp_migrar_frenos_por_medicion
	EXECUTE sp_migrar_piloto
	
	EXECUTE sp_migrar_telemetria_caja
	EXECUTE sp_migrar_telemetria_motor
	EXECUTE sp_migrar_cambio_de_neumatico
	EXECUTE sp_migrar_medicion_por_neumatico
	EXECUTE sp_migrar_auto_por_incidente
END TRY
BEGIN CATCH
     ROLLBACK TRANSACTION;
	 THROW 50001, 'Error al migrar las tablas.',1;
END CATCH

	IF (EXISTS (SELECT 1 FROM LOS_QUERY.circuito)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.carrera)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.sector)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.ESCUDERIA)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.neumatico)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.incidente)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.auto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.motor)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.caja)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.telemetria_auto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.freno)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.parada_box)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.cambio_de_neumatico)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.frenos_por_medicion)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.piloto)
	AND EXISTS (SELECT 1 FROM LOS_QUERY.medicion_por_neumatico))
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