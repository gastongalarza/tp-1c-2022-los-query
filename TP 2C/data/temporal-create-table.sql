--------------------------------------------------- 
-- CREACION DE ESQUEMA
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'INFORMADOS')
DROP SCHEMA INFORMADOS
GO

PRINT 'Creando ESQUEMA INFORMADOS' 
GO

CREATE SCHEMA INFORMADOS;
GO

---------------------------------------------------
-- CREACI�N DE TABLAS
---------------------------------------------------

CREATE TABLE INFORMADOS.provincia(
id_provincia int IDENTITY(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.zona(
id_zona int IDENTITY(1,1) PRIMARY KEY,
id_provincia int REFERENCES INFORMADOS.provincia(id_provincia),
localidad nvarchar(255),
codigo_postal decimal(18,0)
);

CREATE TABLE INFORMADOS.cliente(
id_cliente int IDENTITY(1,1) PRIMARY KEY,
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

CREATE TABLE INFORMADOS.canal(
id_canal int IDENTITY(1,1) PRIMARY KEY,
nombre varchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.envio(
id_envio int IDENTITY(1,1) PRIMARY KEY,
medio nvarchar(255),
precio decimal(18,2)
);

CREATE TABLE INFORMADOS.medio_pago(
id_medio_pago int identity(1,1) PRIMARY KEY,
medio_pago nvarchar(255),
costo decimal(18,2)
);

CREATE TABLE INFORMADOS.barrio(
id_barrio int identity(1,1) PRIMARY KEY,
codigo_postal decimal(18,0),
localidad nvarchar(255),
provincia nvarchar(255)
);

CREATE TABLE INFORMADOS.venta(
id_venta int identity(1,1) PRIMARY KEY,
codigo_venta decimal(19,0),
fecha date,
id_cliente int,
id_canal int,
id_envio int,
id_medio_pago INT,
total decimal(18,2),
FOREIGN KEY (id_cliente) REFERENCES INFORMADOS.cliente(id_cliente),
FOREIGN KEY (id_canal) REFERENCES INFORMADOS.canal(id_canal),
FOREIGN KEY (id_envio) REFERENCES INFORMADOS.envio(id_envio),
FOREIGN KEY (id_medio_pago) REFERENCES INFORMADOS.medio_pago(id_medio_pago)
);

CREATE TABLE INFORMADOS.descuento(
id_descuento int IDENTITY(1,1) PRIMARY KEY,
concepto nvarchar(255),
codigo decimal(19,0),
importe decimal(18,2),
valor decimal(18,2),
id_venta int,
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta)
);

CREATE TABLE INFORMADOS.cupon(
id_cupon int IDENTITY(1,1) PRIMARY KEY,
codigo nvarchar(255),
tipo nvarchar(50),
valor decimal(18,2),
importe decimal(18,2),
fecha_inicial date,
fecha_final date
);

CREATE TABLE INFORMADOS.cupon_por_venta(
id_venta int,
id_cupon int,
PRIMARY KEY (id_venta, id_cupon),
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta),
FOREIGN KEY (id_cupon) REFERENCES INFORMADOS.cupon(id_cupon)
);

CREATE TABLE INFORMADOS.categoria(
id_categoria int identity(1,1) PRIMARY KEY,
nombre nvarchar(255)
);

CREATE TABLE INFORMADOS.tipo_variante(
id_tipo_variante int identity(1,1) PRIMARY KEY,
tipo nvarchar(50)
);

CREATE TABLE INFORMADOS.variante(
id_variante int PRIMARY KEY,
nombre nvarchar(255),
precio decimal(18,6),
id_tipo_variante int,
FOREIGN KEY (id_tipo_variante) REFERENCES INFORMADOS.tipo_variante(id_tipo_variante)
);

CREATE TABLE INFORMADOS.producto(
id_producto nvarchar(50) PRIMARY KEY,
nombre nvarchar(255),
descripcion nvarchar(255),
material nvarchar(255),
marca nvarchar(255),
id_variante int,
id_categoria int,
FOREIGN KEY (id_variante) REFERENCES INFORMADOS.variante(id_variante),
FOREIGN KEY (id_categoria) REFERENCES INFORMADOS.categoria(id_categoria)
);

CREATE TABLE INFORMADOS.producto_por_venta(
id_venta int,
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2),
PRIMARY KEY (id_venta, id_producto),
FOREIGN KEY (id_venta) REFERENCES INFORMADOS.venta(id_venta),
FOREIGN KEY (id_producto) REFERENCES INFORMADOS.producto(id_producto)
);

CREATE TABLE INFORMADOS.proveedor(
id_proveedor nvarchar(50) PRIMARY KEY,
razon_social nvarchar(255),
domicilio nvarchar(255),
mail nvarchar(255),
localidad nvarchar(255),
codigo_postal decimal(18,0),
provincia nvarchar(255)
);

CREATE TABLE INFORMADOS.compra(
id_compra decimal(19,0) PRIMARY KEY,
id_proveedor nvarchar(50),
fecha date,
medio_pago nvarchar(255),
descuento decimal(18,0),
total decimal(18,2),
FOREIGN KEY (id_proveedor) REFERENCES INFORMADOS.proveedor(id_proveedor)
);

CREATE TABLE INFORMADOS.producto_por_compra(
id_compra decimal(19,0),
id_producto nvarchar(50),
cantidad decimal(18,0),
precio decimal(18,2),
PRIMARY KEY (id_compra, id_producto),
FOREIGN KEY (id_compra) REFERENCES INFORMADOS.compra(id_compra),
FOREIGN KEY (id_producto) REFERENCES INFORMADOS.producto(id_producto)
);

----------------------------------------------------
-- CREACI�N DE VISTAS
----------------------------------------------------



---------------------------------------------------
-- CREACION DE INDICES
---------------------------------------------------

