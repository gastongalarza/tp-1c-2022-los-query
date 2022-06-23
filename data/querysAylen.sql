
/*
Q1
Desgaste promedio de cada componente de cada auto por vuelta por
circuito.
Tener en cuenta que, para el cálculo del desgaste de los neumáticos, se
toma la diferencia de mm del mismo entre la medición inicial y final de
cada vuelta. Lo mismo aplica para el desgaste de frenos.
Para el cálculo del desgaste del motor se toma en cuenta la perdida de
potencia. */

/*
Q2
Mejor tiempo de vuelta de cada escudería por circuito por año.
El mejor tiempo está dado por el mínimo tiempo en que un auto logra
realizar una vuelta de un circuito. 
*/

--CREATE VIEW mejor_tiempo_vuelta_escuderia AS
--Este fue solo un intento, no entiendo muy bien el min de cada grupo, faltaria filtrar por año
SELECT MIN(t.tele_tiempo_vuelta), escuderia_nombre, CIRCUITO_CODIGO, YEAR(CARRERA_FECHA) as anio 
			FROM LOS_QUERY.telemetria_auto t 
			JOIN LOS_QUERY.carrera car ON t.tele_codigo_carrera = car.CODIGO_CARRERA
			JOIN LOS_QUERY.auto a ON (t.tele_auto_numero = a.auto_numero AND t.tele_auto_modelo = a.auto_modelo)
			JOIN LOS_QUERY.ESCUDERIA e on a.auto_escuderia = e.escuderia_nombre
			JOIN LOS_QUERY.circuito cir on CIRCUITO_CODIGO = car.CARRERA_CIRCUITO_CODIGO
group by e.escuderia_nombre, cir.CIRCUITO_CODIGO, YEAR(car.CARRERA_FECHA) 
order by escuderia_nombre asc



/* Q3. Los 3 de circuitos con mayor consumo de combustible promedio.*/SELECT TOP 3 cir.CIRCUITO_CODIGO,cir.CIRCUITO_NOMBRE, AVG(t.tele_auto_combustible) as Consumo_prom			FROM LOS_QUERY.telemetria_auto t 			JOIN LOS_QUERY.carrera car ON t.tele_codigo_carrera = car.CODIGO_CARRERA			JOIN LOS_QUERY.circuito cir ON CIRCUITO_CODIGO = car.CARRERA_CIRCUITO_CODIGOgroup by cir.CIRCUITO_CODIGO, cir.CIRCUITO_NOMBREorder by AVG(t.tele_auto_combustible) desc/* Q4. Máxima velocidad alcanzada por cada auto en cada tipo de sector de cada
circuito. *//* Q5. Tiempo promedio que tardó cada escudería en las paradas por cuatrimestre. */

/* Q6. Cantidad de paradas por circuito por escudería por año. */

/* Q7. Los 3 circuitos donde se consume mayor cantidad en tiempo de paradas en
boxes. */

--CREATE VIEW circuitos_mayor_tiempo_en_parada AS
SELECT TOP 3 c.CARRERA_CIRCUITO_CODIGO, SUM(p.PARADA_DURACION)
	FROM LOS_QUERY.parada_box p 
	JOIN LOS_QUERY.carrera c ON c.CODIGO_CARRERA = p.PARADA_CODIGO_CARRERA
group by c.CARRERA_CIRCUITO_CODIGO  
order by sum(p.PARADA_DURACION) desc

/* Q8. Los 3 circuitos más peligrosos del año, en función mayor cantidad de
incidentes.*/

/* Q9. Promedio de incidentes que presenta cada escudería por año en los
distintos tipo de sectores. */