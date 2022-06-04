USE GD1C2022
GO
--------------------------------------------------- 
-- CHEQUEO Y CREACION DE ESQUEMA
---------------------------------------------------
IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'LOS_QUERY')
DROP SCHEMA LOS_QUERY
GO

PRINT 'Creando ESQUEMA LOS_QUERY' 
GO

----------------------------------------------------
-- CREACION DEL ESQUEMA
CREATE SCHEMA LOS_QUERY;
GO

--CREACIÓN DE TABLAS--------------------------------

CREATE TABLE LOS_QUERY.circuito(
CIRCUITO_CODIGO int,
CIRCUITO_NOMBRE varchar(255),
CIRCUITO_PAIS_CODIGO varchar(255),
PRIMARY KEY (CIRCUITO_CODIGO),
);

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
)

CREATE TABLE LOS_QUERY.neumatico
(
neumatico_nro_serie VARCHAR(255),
neumatico_posicion VARCHAR(255),
neumatico_tipo VARCHAR(255),
PRIMARY KEY (neumatico_nro_serie)
)

CREATE TABLE LOS_QUERY.incidente(
INCIDENTE_BANDERA varchar(255),
INCIDENTE_NUMERO_VUELTA decimal not null,
INCIDENTE_TIPO varchar(255),
INCIDENTE_CODIGO_CARRERA int null,
INCIDENTE_CODIGO_SECTOR int null,
PRIMARY KEY (INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO),
FOREIGN KEY (INCIDENTE_CODIGO_CARRERA) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
FOREIGN KEY (INCIDENTE_CODIGO_SECTOR) REFERENCES LOS_QUERY.sector(CODIGO_SECTOR)
);


CREATE TABLE LOS_QUERY.auto
(
auto_numero int,
auto_modelo VARCHAR(255),
auto_escuderia VARCHAR(255),
auto_incidente_tipo VARCHAR(255),
auto_incidente_vuelta decimal(18,0),
auto_incidente_bandera varchar(255),
PRIMARY KEY (auto_numero, auto_modelo),
FOREIGN KEY (auto_incidente_tipo, auto_incidente_vuelta, auto_incidente_bandera) 
REFERENCES LOS_QUERY.incidente(INCIDENTE_TIPO, incidente_numero_vuelta, incidente_bandera),
FOREIGN KEY (auto_escuderia) REFERENCES LOS_QUERY.ESCUDERIA(escuderia_nombre)
)

CREATE TABLE LOS_QUERY.motor
(
motor_nro_serie VARCHAR(255),
motor_modelo VARCHAR(255),
PRIMARY KEY (motor_nro_serie)
)

CREATE TABLE LOS_QUERY.caja
(
caja_nro_serie VARCHAR(255),
caja_modelo VARCHAR(255),
PRIMARY KEY (caja_nro_serie)
)

CREATE TABLE LOS_QUERY.telemetria_auto
(
--PK
tele_auto_codigo decimal(18,0),
--FK auto
tele_auto_numero int,
tele_auto_modelo varchar(255),
tele_codigo_carrera int,		--FK carrera
tele_codigo_circuito int,		--FK carrera!
tele_codigo_sector int,			--FK sector
tele_caja_nro_serie VARCHAR(255),
tele_motor_nro_serie VARCHAR(255),
tele_numero_vuelta decimal(18,0),
tele_distancia_vuelta decimal(18,2),
tele_distancia_carrera decimal(18,6),
tele_auto_posicion decimal(18,0),
tele_tiempo_vuelta decimal(18,10),
tele_auto_velocidad decimal(18,2),
tele_auto_combustible decimal(18,2),
tele_caja_temp_aceite decimal(18,2),
tele_caja_rpm decimal(18,2),
tele_caja_desgaste decimal(18,2),
tele_motor_potencia decimal(18,6),
tele_motor_rpm decimal(18,6),
tele_motor_temp_aceite decimal(18,6),
tele_motor_temo_agua decimal(18,6)
PRIMARY KEY (tele_auto_codigo),
FOREIGN KEY (tele_auto_numero, tele_auto_modelo)
REFERENCES LOS_QUERY.auto(auto_numero, auto_modelo),
FOREIGN KEY (tele_codigo_carrera) REFERENCES LOS_QUERY.carrera(codigo_carrera),
FOREIGN KEY (tele_codigo_sector) REFERENCES LOS_QUERY.SECTOR(codigo_sector),
FOREIGN KEY (tele_caja_nro_serie) REFERENCES LOS_QUERY.CAJA(caja_nro_serie),
FOREIGN KEY (tele_motor_nro_serie) REFERENCES LOS_QUERY.MOTOR(motor_nro_serie)
)

CREATE TABLE LOS_QUERY.freno(
TELE_FRENO_NRO_SERIE varchar(255),
TELE_FRENO_POSICION varchar(255) not null,
TELE_FRENO_TAMANIO_DISCO decimal
PRIMARY KEY (TELE_FRENO_NRO_SERIE),
);


CREATE TABLE LOS_QUERY.parada_box(
PARADA_VUELTA int PRIMARY KEY,
PARADA_CODIGO_CARRERA int not null,
PARADA_AUTO_NUMERO int,
PARADA_AUTO_MODELO varchar(255),
PARADA_DURACION decimal null,
FOREIGN KEY (PARADA_CODIGO_CARRERA) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
FOREIGN KEY (PARADA_AUTO_NUMERO, PARADA_AUTO_MODELO) REFERENCES LOS_QUERY.auto(auto_numero,auto_modelo)
);

CREATE TABLE LOS_QUERY.cambio_de_neumatico(
CAMBIO_PARADA int,
CAMBIO_SERIE_NEUMATICO_VIEJO varchar(255),
CAMBIO_SERIE_NEUMATICO_NUEVO varchar(255),
PRIMARY KEY (CAMBIO_PARADA),
FOREIGN KEY (CAMBIO_SERIE_NEUMATICO_VIEJO) REFERENCES LOS_QUERY.neumatico(neumatico_nro_serie),
FOREIGN KEY (CAMBIO_SERIE_NEUMATICO_NUEVO) REFERENCES LOS_QUERY.neumatico(neumatico_nro_serie),
FOREIGN KEY (CAMBIO_PARADA) REFERENCES LOS_QUERY.circuito(circuito_codigo)
);

CREATE TABLE LOS_QUERY.frenos_por_medicion(
AUTO_CODIGO decimal,
TELE_FRENO_NRO_SERIE varchar(255) not null,
TELE_FRENO_TEMPERATURA decimal,
FOREIGN KEY (AUTO_CODIGO) REFERENCES LOS_QUERY.telemetria_auto(tele_auto_codigo),
FOREIGN KEY (TELE_FRENO_NRO_SERIE) REFERENCES LOS_QUERY.freno(tele_freno_nro_serie)
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
)

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
)

--CREACIÓN DE VISTAS--------------------------------


--CREACION DE INDICES-------------------------------


--CREACION DE STORE PROCEDURES-------------------------------
/*
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_memorias_ram')
	DROP PROCEDURE migrar_memorias_ram

No entiendo de donde sacan el name, pero ese if lo hacen siempre para no repetir los procedures
*/

--Segun entiendo, estos procedimientos son como funciones que se ejecutan mas abajo, y lo que hacen es tomar de la tabla principal
-- la informacion que se esta solicitando y que sean siempre distintos con el distinct

GO --el go hay que ponerlo siempre para que puedan funcionar los procedures al estar en el mismo archivo
CREATE PROCEDURE migrar_circuito
 AS
  BEGIN
    INSERT INTO LOS_QUERY.circuito (CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS_CODIGO)
	SELECT DISTINCT CIRCUITO_CODIGO, CIRCUITO_NOMBRE, CIRCUITO_PAIS_CODIGO
	FROM gd_esquema.Maestra
	WHERE CIRCUITO_CODIGO IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_carrera
 AS
  BEGIN
    INSERT INTO LOS_QUERY.carrera (CODIGO_CARRERA, CARRERA_CIRCUITO_CODIGO, CARRERA_FECHA, CARRERA_CLIMA, CARRERA_CANT_VUELTAS, CARRERA_TOTAL_CARRERA)
	SELECT DISTINCT CODIGO_CARRERA, CARRERA_CIRCUITO_CODIGO, CARRERA_FECHA, CARRERA_CLIMA, CARRERA_CANT_VUELTAS, CARRERA_TOTAL_CARRERA
	FROM gd_esquema.Maestra
	WHERE CODIGO_CARRERA IS NOT NULL AND CARRERA_CIRCUITO_CODIGO IS NOT NULL --no se con que criterio toman las cosas que no tienen que ser null
  END

GO
CREATE PROCEDURE migrar_sector
 AS
  BEGIN
    INSERT INTO LOS_QUERY.sector (CODIGO_SECTOR, SECTOR_DISTANCIA, SECTOR_TIPO, SECTOR_CIRCUITO_CODIGO, SECTOR_CIRCUITO_NOMBRE)
	SELECT DISTINCT CODIGO_SECTOR, SECTOR_DISTANCIA, SECTOR_TIPO, SECTOR_CIRCUITO_CODIGO, SECTOR_CIRCUITO_NOMBRE
	FROM gd_esquema.Maestra
	WHERE CODIGO_SECTOR IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_escuderia
 AS
  BEGIN
    INSERT INTO LOS_QUERY.ESCUDERIA (escuderia_nombre, escuderia_pais)
	SELECT DISTINCT ESCUDERIA_NOMBRE, ESCUDERIA_NACIONALIDAD
	FROM gd_esquema.Maestra
	WHERE ESCUDERIA_NOMBRE IS NOT NULL
  END
/*
este para mi esta mal, habria que pensar bien como haccerlo debido a que los neumaticos en el nombre tienen un numero y ademas dicen viejo o nuevo
GO
CREATE PROCEDURE migrar_neumatico
 AS
  BEGIN
    INSERT INTO LOS_QUERY.neumatico (neumatico_nro_serie, neumatico_posicion, neumatico_tipo)
	SELECT DISTINCT NEUMATICO_NRO_SERIE, NEUMATICO_POSICION, NEUMATICO_TIPO
	FROM gd_esquema.Maestra
	WHERE NEUMATICO_NRO_SERIE IS NOT NULL
  END
*/
GO
CREATE PROCEDURE migrar_incidente
 AS
  BEGIN
    INSERT INTO LOS_QUERY.incidente (INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, INCIDENTE_CODIGO_CARRERA, INCIDENTE_CODIGO_SECTOR)
	SELECT DISTINCT INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO, INCIDENTE_CODIGO_CARRERA, INCIDENTE_CODIGO_SECTOR
	FROM gd_esquema.Maestra
	WHERE INCIDENTE_BANDERA IS NOT NULL 
		AND INCIDENTE_NUMERO_VUELTA IS NOT NULL 
		AND INCIDENTE_TIPO IS NOT NULL
		AND INCIDENTE_CODIGO_CARRERA IS NOT NULL
		AND INCIDENTE_CODIGO_SECTOR IS NOT NULL --quiero creer que las claves (foraneas o primarias) son las que no tienen que ser null
  END

GO
CREATE PROCEDURE migrar_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.auto (auto_numero, auto_modelo, auto_escuderia, auto_incidente_tipo, auto_incidente_vuelta, auto_incidente_bandera)
	SELECT DISTINCT AUTO_NUMERO, AUTO_MODELO, AUTO_ESCUDERIA, AUTO_INCIDENTE_TIPO, AUTO_INCIDENTE_VUELTA, AUTO_INCIDENTE_BANDERA
	FROM gd_esquema.Maestra
	WHERE AUTO_NUMERO IS NOT NULL 
		AND AUTO_MODELO IS NOT NULL 
		AND AUTO_INCIDENTE_TIPO IS NOT NULL
		AND AUTO_INCIDENTE_VUELTA IS NOT NULL
		AND AUTO_INCIDENTE_BANDERA IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_motor
 AS
  BEGIN
    INSERT INTO LOS_QUERY.motor (motor_nro_serie, motor_modelo)
	SELECT DISTINCT TELE_MOTOR_NRO_SERIE, TELE_MOTOR_MODELO
	FROM gd_esquema.Maestra
	WHERE TELE_MOTOR_NRO_SERIE IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_caja
 AS
  BEGIN
    INSERT INTO LOS_QUERY.caja (caja_nro_serie, caja_modelo)
	SELECT DISTINCT TELE_CAJA_NRO_SERIE, TELE_CAJA_MODELO
	FROM gd_esquema.Maestra
	WHERE TELE_CAJA_NRO_SERIE IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_telemetria_auto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.telemetria_auto (tele_auto_codigo, tele_auto_numero, tele_auto_modelo, tele_codigo_carrera, tele_codigo_circuito, tele_codigo_sector, tele_caja_nro_serie, 
		tele_motor_nro_serie, tele_numero_vuelta, tele_distancia_vuelta, tele_distancia_carrera, tele_auto_posicion, tele_tiempo_vuelta, tele_auto_velocidad, tele_auto_combustible,
		tele_caja_temp_aceite, tele_caja_rpm, tele_caja_desgaste, tele_motor_potencia, tele_motor_rpm, tele_motor_temp_aceite, tele_motor_temo_agua)
	SELECT DISTINCT TELE_AUTO_CODIGO, TELE_AUTO_NUMERO, TELE_AUTO_MODELO, TELE_CODIGO_CARRERA, TELE_CODIGO_CIRCUITO, TELE_CODIGO_SECTOR, TELE_CAJA_NRO_SERIE, 
		TELE_MOTOR_NRO_SERIE, TELE_NUMERO_VUELTA, TELE_DISTANCIA_VUELTA, TELE_DISTANCIA_CARRERA, TELE_AUTO_POSICION, TELE_TIEMPO_VUELTA, TELE_AUTO_VELOCIDAD, TELE_AUTO_COMBUSTIBLE
		TELE_CAJA_TEMP_ACEITE, TELE_CAJA_RPM, TELE_CAJA_DESGASTE, TELE_MOTOR_POTENCIA, TELE_MOTOR_RPM, TELE_MOTOR_TEMP_ACEITE, TELE_MOTOR_TEMP_AGUA
	FROM gd_esquema.Maestra
	WHERE TELE_AUTO_CODIGO IS NOT NULL
  END

/* POR LAS DUDAS NO LE AGREGO LO DE LAS CLAVES NOT NULL EN EL WHERE, SI SABEN QUE ESTA BIEN AGREGENLO UDS
PRIMARY KEY (tele_auto_codigo),
FOREIGN KEY (tele_auto_numero, tele_auto_modelo)
REFERENCES LOS_QUERY.auto(auto_numero, auto_modelo),
FOREIGN KEY (tele_codigo_carrera) REFERENCES LOS_QUERY.carrera(codigo_carrera),
FOREIGN KEY (tele_codigo_sector) REFERENCES LOS_QUERY.SECTOR(codigo_sector),
FOREIGN KEY (tele_caja_nro_serie) REFERENCES LOS_QUERY.CAJA(caja_nro_serie),
FOREIGN KEY (tele_motor_nro_serie) REFERENCES LOS_QUERY.MOTOR(motor_nro_serie)*/

GO
CREATE PROCEDURE migrar_frenos
 AS
  BEGIN
    INSERT INTO LOS_QUERY.freno (TELE_FRENO_NRO_SERIE, TELE_FRENO_POSICION, TELE_FRENO_TAMANIO_DISCO)
	SELECT DISTINCT TELE_FRENO_NRO_SERIE, TELE_FRENO_POSICION, TELE_FRENO_TAMANIO_DISCO
	FROM gd_esquema.Maestra
	WHERE TELE_FRENO_NRO_SERIE IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_parada_box
AS
  BEGIN
    INSERT INTO LOS_QUERY.parada_box (PARADA_VUELTA, PARADA_CODIGO_CARRERA, PARADA_AUTO_NUMERO, PARADA_AUTO_MODELO, PARADA_DURACION)
	SELECT DISTINCT PARADA_VUELTA, PARADA_CODIGO_CARRERA, PARADA_AUTO_NUMERO, PARADA_AUTO_MODELO, PARADA_DURACION
	FROM gd_esquema.Maestra
	WHERE PARADA_VUELTA IS NOT NULL AND PARADA_CODIGO_CARRERA IS NOT NULL AND PARADA_AUTO_NUMERO IS NOT NULL
  END

/* mismo problema que con los neumaticos, hay que revisar como lo podemos hacer
tb hay que agregar medicion por neumatico que tendria el mismo problema
GO
CREATE PROCEDURE migrar_cambio_de_neumatico
AS
  BEGIN
    INSERT INTO LOS_QUERY.cambio_de_neumatico (CAMBIO_PARADA, CAMBIO_SERIE_NEUMATICO_VIEJO, CAMBIO_SERIE_NEUMATICO_NUEVO)
	SELECT DISTINCT CAMBIO_PARADA, CAMBIO_SERIE_NEUMATICO_VIEJO, CAMBIO_SERIE_NEUMATICO_NUEVO
	FROM gd_esquema.Maestra
	WHERE CAMBIO_PARADA IS NOT NULL
  END*/

GO --creo que aca pasaria lo mismo que con los neumaticos
CREATE PROCEDURE migrar_frenos_por_medicion
 AS
  BEGIN
    INSERT INTO LOS_QUERY.frenos_por_medicion (AUTO_CODIGO, TELE_FRENO_NRO_SERIE, TELE_FRENO_TEMPERATURA)
	SELECT DISTINCT AUTO_CODIGO, TELE_FRENO_NRO_SERIE, TELE_FRENO_TEMPERATURA
	FROM gd_esquema.Maestra
	WHERE AUTO_CODIGO IS NOT NULL
  END

GO
CREATE PROCEDURE migrar_piloto
 AS
  BEGIN
    INSERT INTO LOS_QUERY.frenos_por_medicion (piloto_nombre, piloto_apellido, piloto_auto_numero, piloto_auto_modelo, piloto_nacionalidad, piloto_fecha_nacimiento)
	SELECT DISTINCT PILOTO_NOMBRE, PILOTO_APELLIDO, PILOTO_AUTO_NUMERO, PILOTO_AUTO_MODELO, PILOTO_NACIONALIDAD, PILOTO_FECHA_NACIMIENTO
	FROM gd_esquema.Maestra
	WHERE PILOTO_NOMBRE IS NOT NULL AND PILOTO_AUTO_NUMERO IS NOT NULL
  END

--EJECUCION DE PROCEDIMIENTOS--------------------------------
 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE migrar_circuito
	EXECUTE migrar_carrera
	EXECUTE migrar_sector
	EXECUTE migrar_escuderia
	EXECUTE migrar_neumatico
	EXECUTE migrar_incidente
	EXECUTE migrar_auto
	EXECUTE migrar_motor
	EXECUTE migrar_caja
	EXECUTE migrar_telemetria_auto
	EXECUTE migrar_frenos
	EXECUTE migrar_parada_box
	EXECUTE migrar_cambio_de_neumatico
	EXECUTE migrar_medicion_por_neumatico
	EXECUTE migrar_frenos_por_medicion
	EXECUTE migrar_piloto
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
	THROW 50001, 'Error al migrar las tablas, verifique que las nuevas tablas se encuentren vacías o bien ejecute un DROP de todas las nuevas tablas y vuelva a intentarlo.',1;
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
	THROW 50002, 'Hubo un error al migrar una o más tablas. Todos los cambios fueron deshechos, ninguna tabla fue cargada en la base.',1;
   END