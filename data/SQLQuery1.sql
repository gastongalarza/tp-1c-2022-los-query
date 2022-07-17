USE GD1C2022

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'BI_fact_sector_vuelta_carrera')
	DROP TABLE LOS_QUERY.BI_fact_sector_vuelta_carrera

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas de hechos para el armado de las vistas --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE LOS_QUERY.BI_fact_sector_vuelta_carrera (
	id int IDENTITY PRIMARY KEY,
	auto_numero int, --FK
	auto_modelo VARCHAR(255), --FK
	escuderia_nombre VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
	vuelta decimal(18,0),
	tiempo_vuelta decimal(18,10),
	velocidad decimal(18,2),
	consumo_combustible int,
	circuito_codigo int FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
	carrera_codigo int,
	sector_codigo int FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector),
	sector_tipo varchar(255),
	codigo_tiempo int FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_tiempos(codigo_tiempo),

	neumatico1_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
	neumatico1_desgaste decimal(18,6),
	neumatico2_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
	neumatico2_desgaste decimal(18,6),
	neumatico3_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
	neumatico3_desgaste decimal(18,6),
	neumatico4_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
	neumatico4_desgaste decimal(18,6),

	freno1_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
	freno1_desgaste decimal(18,6),
	freno2_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
	freno2_desgaste decimal(18,6),
	freno3_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
	freno3_desgaste decimal(18,6),
	freno4_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_freno(FRENO_NRO_SERIE),
	freno4_desgaste decimal(18,6),

	motor_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_motor(motor_nro_serie),
	motor_desgaste decimal(18,6),
	caja_nro_serie VARCHAR(255) FOREIGN KEY REFERENCES LOS_QUERY.BI_dim_caja(caja_nro_serie),
	caja_desgaste decimal(18,6),

	FOREIGN KEY (auto_numero, auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero, auto_modelo)
);


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'sp_migrar_fact_sector_vuelta_carrera')
	DROP PROCEDURE sp_migrar_fact_sector_vuelta_carrera
GO

CREATE PROCEDURE sp_migrar_fact_sector_vuelta_carrera
 AS
  BEGIN
	INSERT INTO LOS_QUERY.BI_fact_sector_vuelta_carrera (
		auto_numero, auto_modelo, escuderia_nombre, vuelta,	tiempo_vuelta, velocidad,
		consumo_combustible, circuito_codigo, carrera_codigo, sector_codigo, SECTOR_TIPO, codigo_tiempo,
		neumatico1_desgaste, neumatico2_desgaste, neumatico3_desgaste, neumatico4_desgaste, freno1_desgaste, freno2_desgaste, 
		freno3_desgaste, freno4_desgaste, motor_desgaste, caja_desgaste
	)
	SELECT
		ta.tele_auto_numero, 
		ta.tele_auto_modelo,
		auto.auto_escuderia, --escuderia_nombre
		ta.tele_numero_vuelta,
		ta.tele_tiempo_vuelta,
		MAX(ta.tele_auto_velocidad),

		MAX(ta.tele_auto_combustible) - MIN(ta.tele_auto_combustible), --consumo_combustible_x_sector
		ca.CARRERA_CIRCUITO_CODIGO,
		ca.CODIGO_CARRERA,
		ta.tele_codigo_sector,
		se.SECTOR_TIPO,
		tiempo.codigo_tiempo,

		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.BI_dim_sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE n.neumatico_posicion = 'Delantero Izquierdo' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, sec.SECTOR_CIRCUITO_CODIGO, sec.CODIGO_SECTOR
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_del_iz,

		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE n.neumatico_posicion = 'Delantero Derecho' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, sec.SECTOR_CIRCUITO_CODIGO, sec.CODIGO_SECTOR
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_del_der,

		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE n.neumatico_posicion = 'Trasero Izquierdo' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, sec.SECTOR_CIRCUITO_CODIGO, sec.CODIGO_SECTOR
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_tras_iz,

		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE n.neumatico_posicion = 'Trasero Derecho' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, sec.SECTOR_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_tras_der,

		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE f.FRENO_POSICION = 'Delantero Izquierdo' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, tas.tele_codigo_sector, sec.SECTOR_CIRCUITO_CODIGO
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_del_iz,

		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE f.FRENO_POSICION = 'Delantero Derecho' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, tas.tele_codigo_sector, sec.SECTOR_CIRCUITO_CODIGO
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_del_der,

		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE f.FRENO_POSICION = 'Trasero Izquierdo' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, tas.tele_codigo_sector, sec.SECTOR_CIRCUITO_CODIGO
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_tras_iz,
		
		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.sector sec ON tas.tele_codigo_sector = sec.CODIGO_SECTOR
			WHERE f.FRENO_POSICION = 'Trasero Derecho' and
				sec.SECTOR_CIRCUITO_CODIGO = ca.CARRERA_CIRCUITO_CODIGO
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo,
				tas.tele_numero_vuelta, tas.tele_codigo_sector, sec.SECTOR_CIRCUITO_CODIGO
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_tras_der,

		MAX(tm.tele_motor_potencia) - MIN(tm.tele_motor_potencia), --desgaste_motor
		MAX(tc.tele_caja_desgaste) - MIN(tc.tele_caja_desgaste) --desgaste_caja

	FROM LOS_QUERY.telemetria_auto ta
		JOIN LOS_QUERY.auto auto ON ta.tele_auto_numero = auto.auto_numero AND ta.tele_auto_modelo = auto.auto_modelo
		JOIN LOS_QUERY.carrera ca ON ca.CODIGO_CARRERA = ta.tele_codigo_carrera
		JOIN LOS_QUERY.BI_dim_sector se ON se.CODIGO_SECTOR = ta.tele_codigo_sector
		JOIN LOS_QUERY.BI_dim_tiempos tiempo ON YEAR(ca.CARRERA_FECHA) = tiempo.anio AND LOS_QUERY.get_cuatrimestre(ca.CARRERA_FECHA) = tiempo.cuatrimestre 
		JOIN LOS_QUERY.telemetria_motor tm ON tm.tele_motor_telemetria = ta.tele_auto_codigo
		JOIN LOS_QUERY.telemetria_caja tc ON tc.tele_caja_codigo = ta.tele_auto_codigo
		WHERE ta.tele_auto_combustible <> 0
		GROUP BY 
			ta.tele_auto_numero, 
			ta.tele_auto_modelo,
			auto.auto_escuderia,
			ta.tele_numero_vuelta,
			ta.tele_tiempo_vuelta,
			ca.CARRERA_CIRCUITO_CODIGO,
			ca.CODIGO_CARRERA,
			ta.tele_codigo_sector,
			se.SECTOR_TIPO,
			tiempo.codigo_tiempo,
			tm.tele_motor_nro_serie,
			tc.tele_caja_nro_serie
  END
GO

---------------------------------------------------
-- MIGRACION A TRAVES DE PROCEDIMIENTOS
---------------------------------------------------

EXECUTE	sp_migrar_fact_sector_vuelta_carrera

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREACION DE VISTAS --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEM 1
-- "Desgaste promedio de cada componente de cada auto por vuelta por circuito"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_vi_desgaste_promedio_auto_x_vuelta_x_circuito')
	DROP VIEW LOS_QUERY.BI_vi_desgaste_promedio_auto_x_vuelta_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_vi_desgaste_promedio_auto_x_vuelta_x_circuito AS
	SELECT
		fact.auto_numero AS 'Auto Numero',
		fact.auto_modelo AS 'Auto Modelo',
		fact.circuito_codigo AS 'Circuito',
		fact.vuelta AS 'Numero Vuelta',
		AVG(fact.caja_desgaste) AS 'Desgaste caja',
		AVG(fact.motor_desgaste) AS 'Desgaste motor',
		AVG(fact.freno1_desgaste) AS 'Desgaste freno DD',
		AVG(fact.freno2_desgaste) AS 'Desgaste freno DI',
		AVG(fact.freno3_desgaste) AS 'Desgaste freno TD',
		AVG(fact.freno4_desgaste) AS 'Desgaste freno TI',
		AVG(fact.neumatico1_desgaste) AS 'Desgaste neumatico DD',
		AVG(fact.neumatico2_desgaste) AS 'Desgaste neumatico DI',
		AVG(fact.neumatico3_desgaste) AS 'Desgaste neumatico TD',
		AVG(fact.neumatico4_desgaste) AS 'Desgaste neumatico TI'

	FROM LOS_QUERY.BI_fact_sector_vuelta_carrera fact
	GROUP BY fact.auto_numero, fact.auto_modelo, fact.circuito_codigo, fact.vuelta
GO

-- ITEM 2
-- "Mejor tiempo de vuelta de cada escudería por circuito por año"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_vi_mejor_tiempo_vuelta')
	DROP VIEW LOS_QUERY.BI_vi_mejor_tiempo_vuelta
GO

CREATE VIEW LOS_QUERY.BI_vi_mejor_tiempo_vuelta AS
	SELECT
		fact.escuderia_nombre AS 'Escuderia',
		fact.circuito_codigo AS 'Circuito',
		t.codigo_tiempo AS 'Año',
		MIN(fact.tiempo_vuelta) AS 'Mejor Tiempo'
	FROM LOS_QUERY.BI_fact_sector_vuelta_carrera fact
	    JOIN LOS_QUERY.BI_dim_tiempos t ON t.codigo_tiempo = fact.codigo_tiempo
	WHERE fact.tiempo_vuelta <> 0
	GROUP BY fact.escuderia_nombre, fact.circuito_codigo, t.codigo_tiempo
GO

SELECT * FROM LOS_QUERY.BI_vi_mejor_tiempo_vuelta

-- ITEM 3
-- "Los 3 de circuitos con mayor consumo de combustible promedio"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_circuitos_con_mayor_consumo_combustible')
	DROP VIEW LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible
GO

CREATE VIEW LOS_QUERY.BI_circuitos_con_mayor_consumo_combustible AS
	SELECT 
		TOP 3 fact.circuito_codigo, AVG(fact.consumo_combustible) AS promedio
	FROM LOS_QUERY.BI_fact_sector_vuelta_carrera AS fact
	
	WHERE fact.consumo_combustible <> 0
	GROUP BY fact.circuito_codigo
	order by AVG(fact.consumo_combustible) desc
GO

-- ITEM 4
-- " Máxima velocidad alcanzada por cada auto en cada tipo de sector de cada circuito"

IF EXISTS(SELECT [name] FROM sys.views WHERE [name] = 'BI_vi_max_vel_x_auto_x_tipo_sector_x_circuito')
	DROP VIEW LOS_QUERY.BI_vi_max_vel_x_auto_x_tipo_sector_x_circuito
GO

CREATE VIEW LOS_QUERY.BI_vi_max_vel_x_auto_x_tipo_sector_x_circuito AS
	SELECT
	fact.auto_numero,
	fact.auto_modelo,
	fact.circuito_codigo,
	fact.SECTOR_TIPO,
	MAX(fact.velocidad) as Max_Velocidad
	FROM 	  
		LOS_QUERY.BI_fact_sector_vuelta_carrera as fact
	GROUP BY fact.auto_numero, fact.auto_modelo, fact.circuito_codigo, fact.SECTOR_TIPO
GO