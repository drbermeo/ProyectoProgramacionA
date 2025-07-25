-- --------------------------------------------------------
-- 1. Crear la base de datos y seleccionarla
-- --------------------------------------------------------
CREATE DATABASE IF NOT EXISTS importacionesZepelin;
USE importaciones;
-- --------------------------------------------------------
-- 2. Normalización de país de origen: convertir a ISO3
-- --------------------------------------------------------

-- Paso:Agregar columna temporal para código ISO2
ALTER TABLE importacionesData ADD COLUMN ISO2 VARCHAR(5);

-- Paso:Extraer el código ISO2 desde la columna PAIS_ORIGEN (ej. "VN - VIETNAM" → "VN")
UPDATE importacionesData
SET ISO2 = SUBSTRING_INDEX(PAIS_ORIGEN, '-', 1);
select * from importacionesData;
-- --------------------------------------------------------
--  Calcular CARGA_TRIBUTARIA_TOTAL como suma de impuestos
-- --------------------------------------------------------
-- 
ALTER TABLE importacionesData ADD COLUMN CARGA_TRIBUTARIA_TOTAL DOUBLE;
-- alcula el total de los impuestos y contribuciones (carga tributaria) sumando varias columnas:
UPDATE importacionesData
SET CARGA_TRIBUTARIA_TOTAL = 
    IFNULL(FODINFA, 0) + 
    IFNULL(ICE_ADVALOREM, 0) + 
    IFNULL(ICE_ESPECIFICO, 0) + 
    IFNULL(IVA, 0) + 
    IFNULL(ADVALOREM, 0);

-- 5.2 Incorporar PIB_PERCAPITA desde tabla PIB_per_capita
ALTER TABLE importacionesData ADD COLUMN PIB_PERCAPITA DOUBLE;
select * from importacionesData;