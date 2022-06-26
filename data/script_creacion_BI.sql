--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creacion de tablas dimensionales --
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE  LOS_QUERY.BI_dim_tiempos (
codigo_tiempo int IDENTITY PRIMARY KEY,
anio int,
cuatrimestre int not null
);

CREATE TABLE LOS_QUERY.BI_dim_auto (
auto_numero int,
auto_modelo VARCHAR(255),
escuderia VARCHAR(255),
incidente_tipo VARCHAR(255),
incidente_vuelta decimal(18,0),
incidente_bandera varchar(255),
PRIMARY KEY (auto_numero, auto_modelo),
FOREIGN KEY (incidente_tipo, incidente_vuelta, incidente_bandera) 
REFERENCES LOS_QUERY.BI_dim_incidente(tipo, nro_vuelta, bandera),
FOREIGN KEY (escuderia) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre)
)

CREATE TABLE LOS_QUERY.BI_dim_escuderia (
escuderia_nombre VARCHAR(255) PRIMARY KEY,
escuderia_pais VARCHAR(255)
)

CREATE TABLE LOS_QUERY.BI_dim_circuito (
CIRCUITO_CODIGO int PRIMARY KEY,
CIRCUITO_NOMBRE varchar(255),
CIRCUITO_PAIS_CODIGO varchar(255)
);

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

CREATE TABLE LOS_QUERY.BI_dim_sector(
codigo_sector int PRIMARY KEY,
distancia decimal not null,
tipo varchar(255),
circuito_codigo int,
FOREIGN KEY (circuito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CODIGO_SECTOR)
);

CREATE TABLE LOS_QUERY.BI_dim_neumatico (
neumatico_nro_serie VARCHAR(255) PRIMARY KEY,
neumatico_posicion VARCHAR(255),
neumatico_tipo VARCHAR(255)
)

CREATE TABLE LOS_QUERY.BI_dim_incidente (
bandera varchar(255),
nro_vuelta decimal not null,
tipo varchar(255),
codigo_sector int null,
PRIMARY KEY (bandera, nro_vuelta, tipo),
FOREIGN KEY (INCIDENTE_CODIGO_SECTOR) REFERENCES LOS_QUERY.BI_dim_sector(codigo_sector)
);

--tablas que considero que faltaron en las dimensiones

CREATE TABLE LOS_QUERY.BI_dim_freno (
FRENO_NRO_SERIE varchar(255) PRIMARY KEY,
FRENO_POSICION varchar(255) not null,
FRENO_TAMANIO_DISCO decimal --si lo que hay que considerar para el calculo del desgaste es el tamaño creo que hay que sacarlo de esta tabla, sino no se de donde sacar el desgaste
);

CREATE TABLE LOS_QUERY.BI_dim_motor (
motor_nro_serie VARCHAR(255) PRIMARY KEY,
motor_modelo VARCHAR(255)
);

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
ciruito_codigo int,
PRIMARY KEY(neumatico_nro_serie, numero_vuelta, ciruito_codigo),
FOREIGN KEY (neumatico_nro_serie) REFERENCES LOS_QUERY.BI_dim_neumatico(neumatico_nro_serie),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

CREATE TABLE LOS_QUERY.BI_desgaste_frenos (
freno_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6), --no se que seria lo que hay que considerar para el calculo
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

/*
no estoy seguro si tendria que ir (habria que agregar tb la dimension caja) pero seria asi
CREATE TABLE LOS_QUERY.BI_desgaste_caja (
caja_nro_serie VARCHAR(255),
numero_vuelta int,
desgaste decimal(18,6), --este calculo seria la diferencia del desgaste de la caja de la telemetria
ciruito_codigo int,
PRIMARY KEY(caja_nro_serie, numero_vuelta, ciruito_codigo),
FOREIGN KEY (caja_nro_serie) REFERENCES LOS_QUERY.BI_dim_caja(caja_nro_serie),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);
*/

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
FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_circuito(codigo_sector)
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
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO)
);

--apartir de esta tabla habria que hacer el promedio por sector para cada escuderia (entiendo que quieren saber cant de incidentes por año)
CREATE TABLE LOS_QUERY.BI_incidentes_por_escuderia (
--le pondria un id como clave primaria
escuderia_nombre VARCHAR(255),
codigo_sector int,
anio int, --podria ser una fecha (se obtiene de la fecha de la carrera en la que fue ese incidente)
FOREIGN KEY (escuderia_nombre) REFERENCES LOS_QUERY.BI_dim_escuderia(escuderia_nombre),
FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_circuito(codigo_sector)
);