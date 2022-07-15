SELECT 
		MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) as desgaste,
		fpm.TELE_FRENO_NRO_SERIE,   
		ta.tele_numero_vuelta,
		ta.tele_codigo_sector,
		ca.CARRERA_CIRCUITO_CODIGO
	FROM LOS_QUERY.frenos_por_medicion fpm
		JOIN LOS_QUERY.telemetria_auto ta on fpm.AUTO_CODIGO = ta.tele_auto_codigo
		JOIN LOS_QUERY.carrera ca on ca.CODIGO_CARRERA = ta.tele_codigo_carrera
		JOIN LOS_QUERY.freno f on f.FRENO_NRO_SERIE = fpm.TELE_FRENO_NRO_SERIE
	WHERE f.FRENO_POSICION = 'Delantero Izquierdo'
	GROUP BY 
		fpm.TELE_FRENO_NRO_SERIE,   
		ta.tele_numero_vuelta,
		ta.tele_codigo_sector,
		ca.CARRERA_CIRCUITO_CODIGO
	HAVING MAX(fpm.TELE_FRENO_GROSOR_PASTILLA) - MIN(fpm.TELE_FRENO_GROSOR_PASTILLA) <> 0