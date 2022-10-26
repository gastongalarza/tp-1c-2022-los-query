
---------------------------------------------------
-- ELIMINACION DE TABLAS EN CASO DE QUE EXISTAN
---------------------------------------------------

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_compra')
DROP TABLE INFORMADOS.producto_por_compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compra')
DROP TABLE INFORMADOS.compra

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_por_venta')
DROP TABLE INFORMADOS.producto_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento')
DROP TABLE INFORMADOS.descuento

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon_por_venta')
DROP TABLE INFORMADOS.cupon_por_venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'venta')
DROP TABLE INFORMADOS.venta

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cliente')
DROP TABLE INFORMADOS.cliente

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'canal')
DROP TABLE INFORMADOS.canal

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'envio')
DROP TABLE INFORMADOS.envio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medio_pago')
DROP TABLE INFORMADOS.medio_pago

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'barrio')
DROP TABLE INFORMADOS.barrio

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon')
DROP TABLE INFORMADOS.cupon

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto')
DROP TABLE INFORMADOS.producto

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'categoria')
DROP TABLE INFORMADOS.categoria

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'variante')
DROP TABLE INFORMADOS.variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_variante')
DROP TABLE INFORMADOS.tipo_variante

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'proveedor')
DROP TABLE INFORMADOS.proveedor

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'zona')
DROP TABLE INFORMADOS.zona

IF EXISTS (SELECT name FROM sys.tables WHERE name = 'provincia')
DROP TABLE INFORMADOS.provincia

---------------------------------------------------
-- ELIMINACION DE VISTAS EN CASO DE QUE EXISTAN
---------------------------------------------------

