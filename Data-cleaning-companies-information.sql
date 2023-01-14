--FUNCIONES UTILIZADAS PARA LA LIMPIEZA DE LOS DATOS


--FUNCION nulos
CREATE OR ALTER FUNCTION [GABP].[fnLimpiarnulos] (@texto AS VARCHAR(500))
RETURNS VARCHAR(500) AS
BEGIN
	DECLARE @dev VARCHAR(500)
	SET @dev = @texto
	SET @dev = IIF(@dev = 'N/A', NULL, @dev)

	RETURN @dev
END
GO

--FUNCION fechas-coma
CREATE OR ALTER FUNCTION [GABP].[fnFechasComa] (@fechac AS VARCHAR(15))
RETURNS VARCHAR(15) AS
BEGIN
	DECLARE @dev VARCHAR(15)
	SET @dev = @fechac
	SET @dev = (LEFT(REPLACE(@fechac,',',''),4) +'-'+ SUBSTRING(REPLACE(@fechac,',',''),5,2) +'-'+ RIGHT(REPLACE(@fechac,',',''),2))

	RETURN @dev
END
GO

--FUNCION año
CREATE OR ALTER FUNCTION [GABP].[fnYear] (@year AS FLOAT)
RETURNS FLOAT AS
BEGIN
	DECLARE @dev FLOAT
	SET @dev = @year
	SET @dev = CASE
	   WHEN @year= 0 THEN NULL
	   WHEN REPLACE(@year,'.','')=2 THEN CAST(STR(REPLACE(@year,'.',''))+'000' AS int)
	   WHEN LEN(REPLACE(@year,'.',''))=3 THEN CAST(STR(REPLACE(@year,'.',''))+'0' AS int)
	   ELSE REPLACE(@year,'.','')
	   END

	RETURN @dev
END
GO

--FUNCION fechas simples
CREATE OR ALTER FUNCTION [GABP].[fnFechas] (@fecha AS VARCHAR(15))
RETURNS VARCHAR(15) AS
BEGIN
	DECLARE @dev VARCHAR(15)
	SET @dev = @fecha
	SET @dev = (IIF(@fecha != 'N/A',LEFT(@fecha,4) +'-'+ SUBSTRING(@fecha,5,2) +'-'+ RIGHT(@fecha,2) ,NULL))

	RETURN @dev
END
GO

--FUNCION fechas2
CREATE OR ALTER FUNCTION [GABP].[fnFechas2] (@fecha2 AS VARCHAR(15))
RETURNS VARCHAR(15) AS
BEGIN
	DECLARE @dev VARCHAR(15)
	SET @dev = @fecha2
	SET @dev = (IIF(@fecha2 != '0',LEFT(REPLACE(@fecha2,',',''),4) +'-'+ SUBSTRING(REPLACE(@fecha2,',',''),5,2) +'-'+ RIGHT(REPLACE(@fecha2,',',''),2) ,NULL))

	RETURN @dev
END
GO

--FUNCION codigo-municipio
CREATE OR ALTER FUNCTION [GABP].[fnMunicipio] (@municipio AS VARCHAR(1000))
RETURNS VARCHAR(1000) AS
BEGIN
	DECLARE @dev VARCHAR(1000)
	SET @dev = @municipio
	SET @dev = (SUBSTRING(@municipio, CHARINDEX('-',@municipio, 1) + 2, (LEN(@municipio) - (CHARINDEX('-',@municipio, 1) + 1))))

	RETURN @dev
END
GO

--FUNCION codigo-asterisco
CREATE OR ALTER FUNCTION [GABP].[fnAsterisco] (@asterisco AS VARCHAR(1000))
RETURNS VARCHAR(1000) AS
BEGIN
	DECLARE @dev VARCHAR(1000)
	SET @dev = @asterisco
	SET @dev = (IIF(@asterisco = 'N/A', NULL, SUBSTRING(@asterisco, CHARINDEX('**', @asterisco, 1)+3, LEN(@asterisco) - (CHARINDEX('**', @asterisco, 1)+1))))

	RETURN @dev
END
GO

--FUNCION dinero
CREATE OR ALTER FUNCTION [GABP].[fnDinero1] (@dinero1 AS VARCHAR(100))
RETURNS VARCHAR(100) AS
BEGIN
	DECLARE @dev VARCHAR(1000)
	SET @dev = @dinero1
	SET @dev = TRY_CAST(CASE
	   WHEN @dinero1 = 'N/A' THEN NULL
	   WHEN CHARINDEX('-',@dinero1,1) = 0 THEN LTRIM(RIGHT(@dinero1, LEN(@dinero1)-1))
	   WHEN CHARINDEX('-',@dinero1,1) = 6 THEN '0'
	   END AS MONEY)

	RETURN @dev
END
GO




--CREACION DE VISTA CON DATOS LIMPIOS

CREATE VIEW GABP.vwCleanedData AS
(
SELECT 
	[MATRICULA]
	,[ORGANIZACION]
	,[GABP].[fnLimpiarnulos]([CATEGORIA]) AS [CATEGORIA]
	,[EST-MATRICULA]
    ,[RAZON SOCIAL]
	,[GABP].[fnFechasComa]([FEC-MATRICULA]) AS [FEC-MATRICULA]
	,[GABP].[fnFechasComa]([FEC-RENOVACION]) AS [FEC-RENOVACION]
	,[GABP].[fnYear]([ULT-ANO_REN]) AS [ULT-ANO_REN]
	,[GABP].[fnFechas]([FEC-CANCELACION]) AS [FEC-CANCELACION]
	,[GABP].[fnFechas]([FEC-CONSTITUCION]) AS [FEC-CONSTITUCION]
	,[DIR-COMERCIAL]
	,[GABP].[fnMunicipio]([MUN-COMERCIAL]) AS [MUN-COMERCIAL]
	,[GABP].[fnAsterisco]([CIIU-1]) AS [CIIU-1]
	,[GABP].[fnAsterisco]([CIIU-2]) AS [CIIU-2]
	,[GABP].[fnAsterisco]([CIIU-3]) AS [CIIU-3]
	,[GABP].[fnLimpiarnulos]([ACTIVIDAD]) AS [ACTIVIDAD]
	,[GABP].[fnDinero1]([ING-TAM-EMPRESARIAL]) AS [ING-TAM-EMPRESARIAL]
	,[GABP].[fnLimpiarnulos]([TAM-EMPRESA]) AS [TAM-EMPRESA]
	,[PERSONAL]
	,CAST([ACTIVO-TOTAL] AS MONEY) AS [ACTIVO-TOTAL]
	,[GABP].[fnLimpiarnulos]([GRUPO-NIIF]) AS [GRUPO-NIIF]
	,[GABP].[fnYear]([ANO-DATOS]) AS [ANO-DATOS]
	,[GABP].[fnFechas2]([FECHA-DATOS]) AS [FECHA-DATOS]
	,[GABP].[fnFechas]([FEC-PAG-REN 2018]) AS [FEC-PAG-REN 2018]
	,[GABP].[fnFechas]([FEC-PAG-REN 2019]) AS [FEC-PAG-REN 2019]
	,[GABP].[fnFechas]([FEC-PAG-REN 2020]) AS [FEC-PAG-REN 2020]
	,[GABP].[fnFechas]([FEC-PAG-REN 2021]) AS [FEC-PAG-REN 2021]
	,[GABP].[fnFechas]([FEC-PAG-REN 2022]) AS [FEC-PAG-REN 2022]
	,CAST([GABP].[fnLimpiarnulos]([ACTI 2018])AS MONEY) AS [ACTI 2018]
	,CAST([GABP].[fnLimpiarnulos]([ACTI 2019])AS MONEY) AS [ACTI 2019]
	,CAST([GABP].[fnLimpiarnulos]([ACTI 2020])AS MONEY) AS [ACTI 2020]
	,CAST([GABP].[fnLimpiarnulos]([ACTI 2021])AS MONEY) AS [ACTI 2021]
	,CAST([GABP].[fnLimpiarnulos]([ACTI 2022])AS MONEY) AS [ACTI 2022]
	,[GABP].[fnLimpiarnulos]([MOT-CAN]) AS [MOT-CAN]
FROM [CursoSQL].[dbo].[vwDatosPractica] WITH(NOLOCK)
GO
