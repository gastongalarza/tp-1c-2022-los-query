USE GD1C2022
GO
--------------------------------------------------- 
-- CHEQUEO Y CREACION DE ESQUEMA
---------------------------------------------------
IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'LOS_QUERY')
DROP SCHEMA LOS_QUERY
GO

PRINT 'Creando ESQUEMA LOS_QUERY' 
GO

----------------------------------------------------
-- CREACION DEL ESQUEMA
CREATE SCHEMA LOS_QUERY;
GO

--CREACI�N DE TABLAS--------------------------------


--CREACI�N DE VISTAS--------------------------------


--CREACION DE INDICES-------------------------------




