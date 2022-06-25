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
auto_escuderia VARCHAR(255),
auto_incidente_tipo VARCHAR(255),
auto_incidente_vuelta decimal(18,0),
auto_incidente_bandera varchar(255),
PRIMARY KEY (auto_numero, auto_modelo),
FOREIGN KEY (auto_incidente_tipo, auto_incidente_vuelta, auto_incidente_bandera) 
REFERENCES LOS_QUERY.incidente(INCIDENTE_TIPO, incidente_numero_vuelta, incidente_bandera),
FOREIGN KEY (auto_escuderia) REFERENCES LOS_QUERY.ESCUDERIA(escuderia_nombre)
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

CREATE TABLE LOS_QUERY.BI_dim_piloto (
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
INCIDENTE_BANDERA varchar(255),
INCIDENTE_NUMERO_VUELTA decimal not null,
INCIDENTE_TIPO varchar(255),
INCIDENTE_CODIGO_CARRERA int null,
INCIDENTE_CODIGO_SECTOR int null,
PRIMARY KEY (INCIDENTE_BANDERA, INCIDENTE_NUMERO_VUELTA, INCIDENTE_TIPO),
FOREIGN KEY (INCIDENTE_CODIGO_CARRERA) REFERENCES LOS_QUERY.carrera(CODIGO_CARRERA),
FOREIGN KEY (INCIDENTE_CODIGO_SECTOR) REFERENCES LOS_QUERY.sector(CODIGO_SECTOR)
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
FOREIGN KEY (auto_numero) REFERENCES LOS_QUERY.BI_dim_auto(auto_numero),
FOREIGN KEY (auto_modelo) REFERENCES LOS_QUERY.BI_dim_auto(auto_modelo),
FOREIGN KEY (ciruito_codigo) REFERENCES LOS_QUERY.BI_dim_circuito(CIRCUITO_CODIGO),
FOREIGN KEY (codigo_sector) REFERENCES LOS_QUERY.BI_dim_circuito(codigo_sector)
);