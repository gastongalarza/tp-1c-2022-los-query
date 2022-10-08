--USE GD1C2022 --cambiar por la tabla de este TP
GO

--------------------------------------------------- 
-- CREACION DE ESQUEMA
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'APROBADOS')
DROP SCHEMA APROBADOS
GO

PRINT 'Creando ESQUEMA APROBADOS' 
GO

CREATE SCHEMA APROBADOS;
GO

---------------------------------------------------
-- CREACIÓN DE TABLAS
---------------------------------------------------

CREATE TABLE APROBADOS.cliente(
id_cliente int PRIMARY KEY,
dni decimal(18,0),
nombre nvarchar(255),
apellido nvarchar(255),
direccion nvarchar(255),
telefono decimal(18,0),
mail nvarchar(255),
fecha_nacimiento date,
localidad nvarchar(255),
codigo_postal decimal(18,0),
provincia nvarchar(255)
);

CREATE TABLE APROBADOS.canal(
id_canal int PRIMARY KEY,
nombre varchar(255),
costo decimal(18,2)
);

CREATE TABLE APROBADOS.envio(
id_envio int PRIMARY KEY,
precio decimal(18,2),
medio nvarchar(255)
);

CREATE TABLE APROBADOS.medio_pago(
id_medio_pago nvarchar(255) PRIMARY KEY,
costo decimal(18,2)
);

CREATE TABLE APROBADOS.venta(
id_venta varchar(50) PRIMARY KEY,
fecha date,
id_cliente int,
id_canal int,
id_envio int,
id_medio_pago nvarchar(255),
total decimal(18,2)
FOREIGN KEY (id_cliente) REFERENCES APROBADOS.cliente(id_cliente),
FOREIGN KEY (id_canal) REFERENCES APROBADOS.canal(id_canal),
FOREIGN KEY (id_envio) REFERENCES APROBADOS.envio(id_envio),
FOREIGN KEY (id_medio_pago) REFERENCES APROBADOS.medio_pago(id_medio_pago)
);

CREATE TABLE APROBADOS.descuento(
id_descuento int PRIMARY KEY,
concepto nvarchar(255),
codigo decimal(19,0),
importe decimal(18,2),
valor decimal(18,2),
id_venta varchar(50)
FOREIGN KEY (id_venta) REFERENCES APROBADOS.venta(id_venta)
);

CREATE TABLE APROBADOS.cupon(
id_cupon int PRIMARY KEY,
codigo nvarchar(255),
tipo nvarchar(50),
valor decimal(18,2),
importe decimal(18,2),
fecha_inicial date,
fecha_final date
);

CREATE TABLE APROBADOS.cupon_por_venta(
id_venta varchar(50),
id_cupon int
PRIMARY KEY (id_venta, id_cupon)
FOREIGN KEY (id_venta) REFERENCES APROBADOS.venta(id_venta),
FOREIGN KEY (id_cupon) REFERENCES APROBADOS.cupon(id_cupon)
);

CREATE TABLE APROBADOS.categoria(
id_categoria int PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE APROBADOS.tipo_variante(
id_tipo_variante int PRIMARY KEY,
tipo nvarchar(50)
);

CREATE TABLE APROBADOS.variante(
id_variante int PRIMARY KEY,
nombre nvarchar(255),
precio decimal(18,6),
id_tipo_variante int
FOREIGN KEY (id_tipo_variante) REFERENCES APROBADOS.tipo_variante(id_tipo_variante)
);

CREATE TABLE APROBADOS.producto(
id_producto nvarchar(50) PRIMARY KEY,
nombre nvarchar(255),
descripcion nvarchar(255),
material nvarchar(255),
marca nvarchar(255),
id_variante int,
id_categoria int
FOREIGN KEY (id_variante) REFERENCES APROBADOS.variante(id_variante),
FOREIGN KEY (id_categoria) REFERENCES APROBADOS.categoria(id_categoria)
);

CREATE TABLE APROBADOS.producto_por_venta(
id_venta varchar(50),
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2)
PRIMARY KEY (id_venta, id_producto)
FOREIGN KEY (id_venta) REFERENCES APROBADOS.venta(id_venta),
FOREIGN KEY (id_producto) REFERENCES APROBADOS.producto(id_producto)
);

CREATE TABLE APROBADOS.proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
razon_social nvarchar(255),
domicilio nvarchar(255),
mail nvarchar(255),
localidad nvarchar(255),
codigo_postal decimal(18,0),
provincia nvarchar(255)
);

CREATE TABLE APROBADOS.compra(
id_compra decimal(19,0) PRIMARY KEY,
id_proveedor nvarchar(50),
fecha date,
medio_pago nvarchar(255),
descuento decimal(18,0),
total decimal(18,2)
FOREIGN KEY (id_proveedor) REFERENCES APROBADOS.proveedor(id_proveedor)
);

CREATE TABLE APROBADOS.producto_por_compra(
id_compra decimal(19,0),
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2)
PRIMARY KEY (id_compra, id_producto)
FOREIGN KEY (id_compra) REFERENCES APROBADOS.compra(id_compra),
FOREIGN KEY (id_producto) REFERENCES APROBADOS.producto(id_producto)
);