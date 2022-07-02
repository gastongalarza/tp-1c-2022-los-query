USE GD1C2022
GO

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
-----------
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
incidente_codigo int IDENTITY(1,1),
incidente_bandera varchar(255),
incidente_numero_vuelta decimal not null,
incidente_tipo varchar(255),
incidente_codigo_sector int null,
incidente_codigo_carrera int,
PRIMARY KEY (incidente_codigo),
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

--tablas que considero que faltaron en las dimensiones

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
/*
al hacer el procedure para cargar esta tabla, podemos ya ir obteniendo los datos levemente procesados para que en
la vista solo tengamos que hacer el promedio del desgaste agrupando por circuito. Estariamos partiendo el problema
en dos partes
se va a repetir la idea para los frenos y el motor
*/

CREATE TABLE LOS_QUERY.BI_desgaste_neumatico (
neumatico_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6), --este dato lo obtenemos de hacer la resta entre como inicio la vuelta y como inicio la sig. en las telemetrias
circuito_codigo int,
PRIMARY KEY(neumatico_nro_serie, numero_vuelta, circuito_codigo),
FOREIGN KEY (neumatico_nro_serie) REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_frenos (
freno_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6),
ciruito_codigo int,
PRIMARY KEY(freno_nro_serie, numero_vuelta, ciruito_codigo),
FOREIGN KEY (freno_nro_serie) REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_motor (
motor_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6), --mismo calculo que en los neumaticos pero con la potencia del motor en las telemetrias de inicio vuelta 1 y 2
ciruito_codigo int,
PRIMARY KEY(motor_nro_serie, numero_vuelta, ciruito_codigo),
FOREIGN KEY (motor_nro_serie) REFERENCES LOS_QUERY.BI_dim_motor(motor_nro_serie),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_caja (
caja_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6), --este calculo seria la diferencia del desgaste de la caja de la telemetria
ciruito_codigo int,
PRIMARY KEY(caja_nro_serie, numero_vuelta, ciruito_codigo),
FOREIGN KEY (caja_nro_serie) REFERENCES LOS_QUERY.BI_dim_caja(caja_nro_serie),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
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

--apartir de esta tabla habria que hacer el promedio por sector para cada escuderia (entiendo que quieren saber cant de incidentes por año)
CREATE TABLE LOS_QUERY.BI_incidentes_por_escuderia (
--le pondria un id como clave primaria
escuderia_nombre VARCHAR(255),
codigo_sector int,
anio int, --podria ser una fecha (se obtiene de la fecha de la carrera en la que fue ese incidente)
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

--Podria hacerse con un switch case pero solo esta disponible en versiones de sqlserver mas recientes
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

IF EXISTS(SELECT [name] FROM sys.objects WHERE [name] = 'calculo_desgaste')
	DROP FUNCTION LOS_QUERY.calculo_desgaste

GO
CREATE FUNCTION LOS_QUERY.calculo_desgaste(@inicial decimal(18,6), @final decimal(18,6))
	RETURNS decimal(18,6)
	AS
	BEGIN
		RETURN @inicial - @final
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
    INSERT INTO LOS_QUERY.BI_dim_freno (freno_nro_serie, FRENO_POSICION, FRENO_TAMANIO_DISCO)
	SELECT DISTINCT freno_nro_serie, freno_posicion, FRENO_TAMANIO_DISCO
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
	SELECT DISTINCT auto_numero, auto_modelo, escuderia
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

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_desgaste_neumatico')
	DROP PROCEDURE sp_migrar_fact_desgaste_neumatico

GO
CREATE PROCEDURE sp_migrar_fact_desgaste_neumatico
AS
BEGIN
	DECLARE date_cursor CURSOR FOR
	SELECT DISTINCT mpn.tele_neumatico_nro_serie, t.tele_numero_vuelta, c.CARRERA_CIRCUITO_CODIGO, mpn.tele_neumatico_profundidad
		FROM LOS_QUERY.medicion_por_neumatico mpn
		JOIN LOS_QUERY.telemetria_auto t on mpn.tele_auto_codigo = t.tele_auto_codigo
		JOIN LOS_QUERY.carrera c on c.CODIGO_CARRERA = t.tele_codigo_carrera
		JOIN LOS_QUERY.circuito cir on c.CARRERA_CIRCUITO_CODIGO = cir.CIRCUITO_CODIGO
		WHERE t.tele_distancia_vuelta = 0
		-- group by mpn.tele_neumatico_nro_serie, t.tele_numero_vuelta, 2, c.CARRERA_CIRCUITO_CODIGO
		order by mpn.tele_neumatico_nro_serie, t.tele_numero_vuelta
	
	-- DECLARE
	DECLARE @Grosor_inicial decimal(18,6)
	DECLARE @Grosor_final decimal(18,6)
	DECLARE @Desgaste_total decimal(18,6)
	
	OPEN date_cursor
	-- FETCH date_cursor into @Date

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

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_parada_box')
	DROP PROCEDURE sp_migrar_fact_parada_box
GO

CREATE PROCEDURE sp_migrar_fact_parada_box
 AS
  BEGIN
    INSERT INTO LOS_QUERY.BI_fact_parada_box(codigo_tiempo, circuito_codigo, escuderia_nombre, duracion_parada)
	SELECT tiempo.codigo_tiempo, carrera.CARRERA_CIRCUITO_CODIGO, auto.auto_escuderia, PARADA_DURACION
	FROM LOS_QUERY.parada_box
		JOIN LOS_QUERY.carrera ON parada_box.PARADA_CODIGO_CARRERA = carrera.CODIGO_CARRERA
	    JOIN LOS_QUERY.BI_dim_tiempos tiempo ON YEAR(carrera.CARRERA_FECHA) = tiempo.anio
		    AND LOS_QUERY.get_cuatrimestre(carrera.CARRERA_FECHA) = tiempo.cuatrimestre
	    JOIN LOS_QUERY.auto ON parada_box.PARADA_AUTO_NUMERO = auto.auto_numero
		    AND parada_box.PARADA_AUTO_MODELO = auto.auto_modelo
  END
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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ITEM 3
-- "Los 3 de circuitos con mayor consumo de combustible promedio"
CREATE VIEW LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible AS
	SELECT 
		TOP 3 c.ciruito_codigo 
	FROM LOS_QUERY.BI_consumo_por_circuito as c
	order by AVG(c.consumo_combustible)
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

---------------------------------------------------
-- SELECT DE LAS VISTAS --
---------------------------------------------------

--Item 5
SELECT * FROM LOS_QUERY.BI_tiempo_promedio_por_escuderia

--Item 6
SELECT * FROM LOS_QUERY.BI_cant_paradas_x_circuito_x_escuderia_x_anio