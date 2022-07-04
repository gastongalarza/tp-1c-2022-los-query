USE GD1C2022

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_motor')
	DROP TABLE LOS_QUERY.BI_desgaste_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_frenos')
	DROP TABLE LOS_QUERY.BI_desgaste_frenos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_neumatico')
	DROP TABLE LOS_QUERY.BI_desgaste_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_motor')
	DROP TABLE LOS_QUERY.BI_dim_motor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_freno')
	DROP TABLE LOS_QUERY.BI_dim_freno

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_neumatico')
	DROP TABLE LOS_QUERY.BI_dim_neumatico

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_piloto')
	DROP TABLE LOS_QUERY.BI_dim_piloto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_incidente')
	DROP TABLE LOS_QUERY.BI_dim_incidente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_circuito')
	DROP TABLE LOS_QUERY.BI_dim_circuito

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_tiempos')
	DROP TABLE LOS_QUERY.BI_dim_tiempos

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_consumo_por_circuito')
	DROP TABLE LOS_QUERY.BI_consumo_por_circuito

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_desgaste_caja')
	DROP TABLE LOS_QUERY.BI_desgaste_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_parada_box')
	DROP TABLE LOS_QUERY.BI_fact_parada_box

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_incidentes_por_escuderia')
	DROP TABLE LOS_QUERY.BI_incidentes_por_escuderia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_parada_auto')
	DROP TABLE LOS_QUERY.BI_tiempo_parada_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_vuelta_escuderia')
	DROP TABLE LOS_QUERY.BI_tiempo_vuelta_escuderia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_velocidades_auto')
	DROP TABLE LOS_QUERY.BI_velocidades_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_auto')
	DROP TABLE LOS_QUERY.BI_dim_auto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_caja')
	DROP TABLE LOS_QUERY.BI_dim_caja

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_escuderia')
	DROP TABLE LOS_QUERY.BI_dim_escuderia

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_dim_sector')
	DROP TABLE LOS_QUERY.BI_dim_sector

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_tiempo_paradas_circuito')
	DROP TABLE LOS_QUERY.BI_tiempo_paradas_circuito

CREATE TABLE LOS_QUERY.BI_dim_tiempos (
	codigo_tiempo int IDENTITY PRIMARY KEY,
	anio int,
	cuatrimestre int not null
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
	incidente_codigo int IDENTITY(1,1) PRIMARY KEY,
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

-- para mi esta re al pedo pq no lo usamos nunca en las vistas pero bueno, lo pide ahi
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

--tablas dimensionales extra

CREATE TABLE LOS_QUERY.BI_dim_freno (
	FRENO_NRO_SERIE varchar(255) PRIMARY KEY,
	FRENO_POSICION varchar(255) not null,
	desgaste decimal(18,6)
)

CREATE TABLE LOS_QUERY.BI_dim_motor (
	motor_nro_serie VARCHAR(255) not null PRIMARY KEY,
	motor_modelo VARCHAR(255) not null
)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas facilitadoras para el armado de las vistas --
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

--misma logica que antes, hacer una tabla con los datos necesarios y despues solamente habria que agrupar por escuderia y año y obtener el mejor tiempo
CREATE TABLE LOS_QUERY.BI_tiempo_vuelta_escuderia (
	escuderia_nombre VARCHAR(255),
	numero_vuelta int,
	ciruito_codigo int,
	anio int, --podria ser una referencia a la tabla de tiempo y obtener el año de ahi, pero seria mas complicado obtenerlo desp al pedo
	PRIMARY KEY(escuderia_nombre, numero_vuelta, ciruito_codigo),
	FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
	FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--lo ideal seria tener esta tabla asi, ordenarla y obtener los primeros 3
CREATE TABLE LOS_QUERY.BI_consumo_por_circuito (
	ciruito_codigo int PRIMARY KEY,
	consumo_combustible int, --si no cambie este comentario es pq no se me ocurrio como obtenerlo (tal vez falten datos)
	FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--se agrupa por auto, circuito y sector y se muestra la que tiene la velocidad maxima
CREATE TABLE LOS_QUERY.BI_velocidades_auto (
	auto_numero int,
	auto_modelo VARCHAR(255),
	velocidad decimal(18,2), --se obtienen todas las velocidades haciendo un group_by de auto, circuito y sector de cada telemetria para obtener todas las velocidades
	ciruito_codigo int,
	codigo_sector int,
	sector_tipo varchar(255),
	PRIMARY KEY(auto_numero, auto_modelo, ciruito_codigo, codigo_sector),
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector)
);

/*
esta tabla contendria el tiempo de todas las paradas que hizo un auto, habria que despues calcularle el promedio 
al auto y desp para obtener el promedio de la escuderia habria que hacer el promedio de todos los autos que 
pertenezcan a la misma
seguro se pueda implementar mejor, esta es solo una idea
desp se me ocurrio agregarle el circuito a esta tabla para poder a partir de esta tabla contar la cantidad de 
paradas por escuderia en cada circuito
tb desp a partir de esta tabla se puede ordenar por tiempo y obtener los circuitos donde hay paradas mas largas
*/
CREATE TABLE LOS_QUERY.BI_tiempo_parada_auto (
	--no se cual seria la clave primaria de la parada en el otro script
	auto_numero int,
	auto_modelo VARCHAR(255),
	duracion_parada decimal, --se obtiene a partir de la tabla parada box del script inicial
	cuatrimestre int, --se obtiene haciendo un join con la tabla de carrera ya que ahi esta la fecha de la misma, podemos hacer una funcion para obtener el cuatri
	circuito_codigo int, --tb se obtiene de la carrera
	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo),
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--creo esta para el item 7 porque no entendi como funciona lo de la tabla de arriba con cuatrimestres
CREATE TABLE LOS_QUERY.BI_tiempo_paradas_circuito (
	circuito_codigo int,
	tiempo_parada_box decimal
	FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--apartir de esta tabla habria que hacer el promedio por sector para cada escuderia (entiendo que quieren saber cant de incidentes por año)
CREATE TABLE LOS_QUERY.BI_incidentes_por_escuderia (
	--le pondria un id como clave primaria
	escuderia_nombre VARCHAR(255),
	codigo_sector int,
	anio int, --podria ser una fecha (se obtiene de la fecha de la carrera en la que fue ese incidente)
	cant_inc int,
	tipo_sector varchar(255),
	FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
	FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector)
);

--Vista 5 y 6
CREATE TABLE LOS_QUERY.BI_fact_parada_box (
    codigo_tiempo int,
	circuito_codigo int,
	escuderia_nombre varchar(255),
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

--Podria hacerse con un switch case pero solo esta disponible en versiones de sqlserver mas recientes
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
    INSERT INTO LOS_QUERY.bi_dim_incidente (incidente_codigo, incidente_bandera, incidente_numero_vuelta, incidente_tipo, incidente_codigo_sector)
	SELECT DISTINCT INCIDENTE_CODIGO, INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, INCIDENTE_CODIGO_SECTOR
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
		JOIN LOS_QUERY.telemetria_auto ta on mpn.tele_auto_codigo = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY mpn.tele_neumatico_nro_serie, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_x_vuelta_frenos')
	DROP PROCEDURE sp_migrar_fact_desgaste_x_vuelta_frenos
GO

CREATE PROCEDURE sp_migrar_fact_desgaste_x_vuelta_frenos
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_desgaste_x_vuelta_frenos(freno_nro_serie, auto_numero, auto_modelo, desgaste, vuelta, circuito_codigo)
	SELECT 
		fpm.TELE_FRENO_NRO_SERIE, 
		ta.tele_auto_numero, 
		ta.tele_auto_modelo, 
		MAX(fpm.TELE_FRENO_GROSOR) - MIN(fpm.TELE_FRENO_GROSOR) as desgaste, 
		ta.tele_numero_vuelta, 
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.frenos_por_medicion fpm
		JOIN LOS_QUERY.telemetria_auto ta on fpm.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
	GROUP BY fpm.TELE_FRENO_NRO_SERIE, ta.tele_auto_numero, ta.tele_auto_modelo, ta.tele_numero_vuelta, ca.CARRERA_CIRCUITO_CODIGO
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
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_parada_box')
	DROP PROCEDURE sp_migrar_fact_parada_box
GO

CREATE PROCEDURE sp_migrar_fact_parada_box
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_fact_parada_box(codigo_tiempo, circuito_codigo, escuderia_nombre, duracion_parada)
	SELECT 
		tiempo.codigo_tiempo, 
		carrera.CARRERA_CIRCUITO_CODIGO, 
		auto.auto_escuderia, 
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
	SELECT cir.CIRCUITO_CODIGO, AVG(t.tele_auto_combustible)
	FROM LOS_QUERY.telemetria_auto t 
		JOIN LOS_QUERY.carrera car ON t.tele_codigo_carrera = car.CODIGO_CARRERA
		JOIN LOS_QUERY.circuito cir ON CIRCUITO_CODIGO = car.CARRERA_CIRCUITO_CODIGO
	group by cir.CIRCUITO_CODIGO, cir.CIRCUITO_NOMBRE
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_tiempo_paradas_circuito')
	DROP PROCEDURE sp_migrar_tiempo_paradas_circuito
GO

CREATE PROCEDURE sp_tiempo_paradas_circuito
  AS
    BEGIN
	  INSERT INTO LOS_QUERY.BI_tiempo_paradas_circuito(circuito_codigo, tiempo_parada_box)
		SELECT
			c.CARRERA_CIRCUITO_CODIGO, 
			SUM(p.PARADA_DURACION)
		FROM LOS_QUERY.parada_box p 
			JOIN LOS_QUERY.carrera c ON c.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA
		GROUP BY c.CARRERA_CIRCUITO_CODIGO  
	END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_incidentes_por_escuderia')
	DROP PROCEDURE sp_migrar_incidentes_por_escuderia
GO


CREATE PROCEDURE sp_migrar_incidentes_por_escuderia
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_incidentes_por_escuderia(escuderia_nombre, codigo_sector, anio, cant_inc, tipo_sector)
		SELECT
			a.auto_escuderia as Escuderia, 
			i.INCIDENTE_CODIGO_SECTOR as Sector_Incidente, 
			YEAR(c.CARRERA_FECHA) as Anio_Incidente,
			COUNT(i.INCIDENTE_CODIGO) as Cant_Inc, --cuenta cuantos incidentes hubo en ese tipo de sector
			s.SECTOR_TIPO as Tipo_Sector
		FROM LOS_QUERY.auto_por_incidente api 
			JOIN LOS_QUERY.incidente i ON api.auto_incidente_id = i.INCIDENTE_CODIGO
			JOIN LOS_QUERY.auto a ON  api.auto_incidente_numero = a.auto_numero and api.auto_incidente_modelo =  a.auto_modelo
			JOIN LOS_QUERY.carrera c ON i.INCIDENTE_CODIGO_CARRERA = c.CODIGO_CARRERA
			JOIN LOS_QUERY.sector s ON i.INCIDENTE_CODIGO_SECTOR = s.CODIGO_SECTOR
		GROUP BY a.auto_escuderia, i.INCIDENTE_CODIGO_SECTOR, s.SECTOR_TIPO, YEAR(c.CARRERA_FECHA)
		ORDER BY 1,3
  END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_dim_tiempos')
	DROP PROCEDURE sp_migrar_dim_tiempos
GO

CREATE PROCEDURE sp_migrar_dim_tiempos AS
    BEGIN
        INSERT INTO LOS_QUERY.BI_dim_tiempos(anio, cuatrimestre)
           SELECT distinct YEAR(c.CARRERA_FECHA), LOS_QUERY.get_cuatrimestre(CARRERA_FECHA) 
		   FROM LOS_QUERY.carrera c
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
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEM 1
-- "Desgaste promedio de cada componente de cada auto por vuelta por circuito"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_tiempo_promedio_por_escuderia
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
-- "Maxima velocidad alcanzada por cada auto en cada tipo de sector de cada circuito"

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
		AVG(p_box.duracion_parada) AS 'Tiempo promedio tardado en paradas'
	FROM LOS_QUERY.BI_fact_parada_box p_box
		JOIN LOS_QUERY.BI_dim_escuderia e ON e.escuderia_nombre = p_box.escuderia_nombre
		JOIN LOS_QUERY.BI_dim_tiempos t   ON t.codigo_tiempo    = p_box.codigo_tiempo
	GROUP BY e.escuderia_nombre, t.cuatrimestre
GO

--ITEM 6
-- "Cantidad de paradas por circuito por escudería por año"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_cant_paradas_x_circuito_x_escuderia_x_anio')
	DROP VIEW LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio
GO

CREATE VIEW LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio AS
	SELECT
		c.CIRCUITO_NOMBRE AS 'Circuito',
		e.escuderia_nombre AS 'Escuderia',
		t.anio AS 'Año',
		count(*) AS 'Cantidad de Paradas'
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
	SELECT
		TOP 3 c.circuito_codigo AS 'Circuito',
		c.tiempo_parada_box as 'Tiempo en Parada Box'
	FROM LOS_QUERY.BI_tiempo_paradas_circuito c
	ORDER BY 2 DESC
GO

--ITEM 9
--"Promedio de incidentes que presenta cada escudería por año en los distintos tipo de sectores."
IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_prom_incidentes_escuderia_x_anio_x_tipo_sector')
	DROP VIEW LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector
GO

CREATE VIEW LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector AS
	SELECT 
	  ixe.escuderia_nombre as 'Escuderia',
	  ixe.anio as 'Anio_Incidente',
	  s.sector_tipo as 'Tipo_Sector', 
	  AVG(ixe.cant_inc) as 'Promedio'
	FROM LOS_QUERY.BI_dim_sector s 
		JOIN LOS_QUERY.BI_incidentes_por_escuderia ixe ON s.codigo_sector = ixe.codigo_sector
	GROUP BY ixe.escuderia_nombre, s.SECTOR_TIPO, ixe.anio
GO

---------------------------------------------------
-- SELECT DE LAS VISTAS --
---------------------------------------------------
--Item 1
SELECT * FROM LOS_QUERY.BI_desgaste_promedio_neumatico_x_auto_x_vuelta_x_circuito
SELECT * FROM LOS_QUERY.BI_desgaste_promedio_frenos_x_auto_x_vuelta_x_circuito
SELECT * FROM LOS_QUERY.BI_desgaste_promedio_caja_x_auto_x_vuelta_x_circuito
SELECT * FROM LOS_QUERY.BI_desgaste_promedio_motor_x_auto_x_vuelta_x_circuito

--Item 3
SELECT * FROM LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible

--Item 4
SELECT * FROM LOS_QUERY.BI_max_vel_x_auto_x_tipo_sector_x_circuito

--Item 5
SELECT * FROM LOS_QUERY.BI_tiempo_promedio_por_escuderia

--Item 6
SELECT * FROM LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio

--Item 7
SELECT * FROM LOS_QUERY.BI_circuitos_mayor_tiempo_en_paradas_box

--Item 9
SELECT * FROM LOS_QUERY.BI_prom_incidentes_escuderia_x_anio_x_tipo_sector