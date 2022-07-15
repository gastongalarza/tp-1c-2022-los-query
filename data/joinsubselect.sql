USE GD1C2022

SELECT
		ta.tele_auto_numero, 
		ta.tele_auto_modelo,
		auto.auto_escuderia, --escuderia_nombre
		ta.tele_numero_vuelta,
		MAX(ta.tele_tiempo_vuelta),
		MAX(ta.tele_auto_velocidad),
		MAX(ta.tele_auto_combustible) - MIN(ta.tele_auto_combustible), --consumo_combustible_x_sector
		ca.CARRERA_CIRCUITO_CODIGO,
		ca.CODIGO_CARRERA,
		ta.tele_codigo_sector,
		se.SECTOR_TIPO,
		tiempo.codigo_tiempo,

		mn1.tele_neumatico_nro_serie,
		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE mpn.tele_neumatico_nro_serie = mn1.tele_neumatico_nro_serie AND n.neumatico_posicion = 'Delantero Izquierdo' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_del_iz,

		mn2.tele_neumatico_nro_serie,
		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE mpn.tele_neumatico_nro_serie = mn2.tele_neumatico_nro_serie AND n.neumatico_posicion = 'Delantero Derecho' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_del_der,

		mn3.tele_neumatico_nro_serie,
		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE mpn.tele_neumatico_nro_serie = mn3.tele_neumatico_nro_serie AND n.neumatico_posicion = 'Trasero Izquierdo' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_tras_iz,

		mn4.tele_neumatico_nro_serie,
		(
			SELECT TOP 1 MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad)
			FROM LOS_QUERY.medicion_por_neumatico mpn
			JOIN LOS_QUERY.neumatico n ON n.neumatico_nro_serie = mpn.tele_neumatico_nro_serie
			JOIN LOS_QUERY.telemetria_auto tas ON mpn.tele_auto_codigo = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE mpn.tele_neumatico_nro_serie = mn4.tele_neumatico_nro_serie AND n.neumatico_posicion = 'Trasero Derecho' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY mpn.tele_neumatico_nro_serie, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(mpn.tele_neumatico_profundidad) - MIN(mpn.tele_neumatico_profundidad) <> 0
		) as desgaste_neum_tras_der,

		fm1.TELE_FRENO_NRO_SERIE,
		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE fpm.TELE_FRENO_NRO_SERIE = fm1.TELE_FRENO_NRO_SERIE AND f.FRENO_POSICION = 'Delantero Izquierdo' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_del_iz,

		fm2.TELE_FRENO_NRO_SERIE,
		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE fpm.TELE_FRENO_NRO_SERIE = fm2.TELE_FRENO_NRO_SERIE AND f.FRENO_POSICION = 'Delantero Derecho' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_del_der,

		fm3.TELE_FRENO_NRO_SERIE,
		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE fpm.TELE_FRENO_NRO_SERIE = fm3.TELE_FRENO_NRO_SERIE AND f.FRENO_POSICION = 'Trasero Izquierdo' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_tras_iz,
		
		fm4.TELE_FRENO_NRO_SERIE,
		(
			SELECT TOP 1 MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA)
			FROM LOS_QUERY.frenos_por_medicion fpm
			JOIN LOS_QUERY.freno f ON f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
			JOIN LOS_QUERY.telemetria_auto tas ON fpm.AUTO_CODIGO = tas.tele_auto_codigo
			JOIN LOS_QUERY.carrera cas ON cas.CARRERA_CIRCUITO_CODIGO = tas.tele_codigo_carrera
			WHERE fpm.TELE_FRENO_NRO_SERIE = fm4.TELE_FRENO_NRO_SERIE AND f.FRENO_POSICION = 'Trasero Derecho' AND tas.tele_codigo_sector = ta.tele_codigo_sector
			GROUP BY fpm.TELE_FRENO_NRO_SERIE, tas.tele_auto_numero, tas.tele_auto_modelo, tas.tele_numero_vuelta, cas.CARRERA_CIRCUITO_CODIGO, tas.tele_codigo_sector
			HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0
		) as desgaste_freno_tras_der,

		tm.tele_motor_nro_serie,
		MAX(tm.tele_motor_potencia) - MIN(tm.tele_motor_potencia), --desgaste_motor

		tc.tele_caja_nro_serie,
		MAX(tc.tele_caja_desgaste) - MIN(tc.tele_caja_desgaste) --desgaste_caja
	FROM LOS_QUERY.telemetria_auto ta
		JOIN LOS_QUERY.auto auto ON ta.tele_auto_numero = auto.auto_numero AND ta.tele_auto_modelo = auto.auto_modelo
		JOIN LOS_QUERY.carrera ca ON ca.CODIGO_CARRERA = ta.tele_codigo_carrera
		JOIN LOS_QUERY.sector se ON se.CODIGO_SECTOR = ta.tele_codigo_sector
		JOIN LOS_QUERY.BI_dim_tiempos tiempo ON YEAR(ca.CARRERA_FECHA) = tiempo.anio AND LOS_QUERY.get_cuatrimestre(ca.CARRERA_FECHA) = tiempo.cuatrimestre
		
		JOIN LOS_QUERY.medicion_por_neumatico mn1 ON mn1.tele_auto_codigo = ta.tele_auto_codigo
		JOIN LOS_QUERY.medicion_por_neumatico mn2 ON mn2.tele_auto_codigo = ta.tele_auto_codigo
		JOIN LOS_QUERY.medicion_por_neumatico mn3 ON mn3.tele_auto_codigo = ta.tele_auto_codigo
		JOIN LOS_QUERY.medicion_por_neumatico mn4 ON mn4.tele_auto_codigo = ta.tele_auto_codigo 
		
		JOIN LOS_QUERY.frenos_por_medicion fm1 ON fm1.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.frenos_por_medicion fm2 ON fm2.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.frenos_por_medicion fm3 ON fm3.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.frenos_por_medicion fm4 ON fm4.AUTO_CODIGO = ta.tele_auto_codigo

		JOIN LOS_QUERY.telemetria_motor tm ON tm.tele_motor_telemetria = ta.tele_auto_codigo
		JOIN LOS_QUERY.telemetria_caja tc ON tc.tele_caja_codigo = ta.tele_auto_codigo

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
			mn1.tele_neumatico_nro_serie,
			mn2.tele_neumatico_nro_serie,
			mn3.tele_neumatico_nro_serie,
			mn4.tele_neumatico_nro_serie,
			fm1.TELE_FRENO_NRO_SERIE,
			fm2.TELE_FRENO_NRO_SERIE,
			fm3.TELE_FRENO_NRO_SERIE,
			fm4.TELE_FRENO_NRO_SERIE,
			tm.tele_motor_nro_serie,
			tc.tele_caja_nro_serie