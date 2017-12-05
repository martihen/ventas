--El siguiente script crea una base de datos relacional para una programa de compras y ventas llamado Rocket.
--Autor: Henry Daniel Mart�nez Chabl�
--Curso: Dise�o de Sistemas
--Catedr�tico: Ing. Jorge Ibarra
--Fecha: 01 de junio de 2017

CREATE DATABASE BD_ROCKET
USE BD_ROCKET


--TABLA PRODUCTO 
CREATE TABLE TB_PRODUCTO 
(
	PRODUCTO_ID		INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,DESCRIPCION	VARCHAR(75) NOT NULL
	,PORCENTAJE		DECIMAL(10,3) NOT NULL	--Porcentaje de ganancia
	,ESTADO			BIT DEFAULT 1			--Activo(1) o Inactivo(0)
	,IMAGEN			IMAGE
)


--TABLA DEPARTAMENTO: Est� relacionada con la tabla ciudad. Fue creada para evitar redundancia de datos. 
CREATE TABLE TB_DEPARTAMENTO 
(
	DEPARTAMENTO_ID		TINYINT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,DESCRIPCION		VARCHAR (50) NOT NULL
)

--TABLA CIUDAD 
CREATE TABLE TB_CIUDAD
(
	CIUDAD_ID			TINYINT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,DESCRIPCION		VARCHAR(50) NOT NULL
	,DEPARTAMENTO_ID	TINYINT FOREIGN KEY REFERENCES TB_DEPARTAMENTO(DEPARTAMENTO_ID)
)

--TABLA PROVEEDOR
CREATE TABLE TB_PROVEEDOR
(
	NIT			VARCHAR(20) NOT NULL PRIMARY KEY
	,NOMBRE	VARCHAR(20) NOT NULL		--NOMBRE COMPLETO DEL PROVEEDOR
	,CALLE		VARCHAR(35) 
	,TELEFONO	VARCHAR(12) NOT NULL
	,EMAIL		VARCHAR(40)
	,CIUDAD_ID	TINYINT FOREIGN KEY REFERENCES TB_CIUDAD(CIUDAD_ID) NOT NULL
	,ESTADO		BIT DEFAULT 1 NOT NULL
)

--TABLA CARGO
CREATE TABLE TB_CARGO
(
	CARGO_ID		TINYINT IDENTITY (1,1) NOT NULL PRIMARY KEY 
	,DESCRIPCION	VARCHAR(50)  NOT NULL
	,ESTADO			BIT DEFAULT 1
)

--TABLA EMPLEADO 
CREATE TABLE TB_EMPLEADO
(
	EMPLEADO_ID INT IDENTITY (1,1) NOT NULL PRIMARY KEY 
	,DPI		VARCHAR(20)
	,NIT		VARCHAR(20)
	,NOMBRE1	VARCHAR(20) NOT NULL		--primer nombre obligatorio
	,NOMBRE2	VARCHAR(20)					--segundo nombre no obligatorio
	,APELLIDO1	VARCHAR(20) NOT NULL		--primer apellido obligatorio
	,APELLIDO2	VARCHAR(20)					--segundo apellido no obligatorio
	,FECHA_INICIO	DATETIME  NOT NULL
	,FECHA_FIN		DATETIME
	,PASS			VARCHAR(25) NOT NULL
	,CARGO_ID		TINYINT FOREIGN KEY REFERENCES TB_CARGO(CARGO_ID)
	,TELEFONO	VARCHAR(12) NOT NULL
	,EMAIL		VARCHAR(40) 
	,CALLE		VARCHAR(35) 
	,CIUDAD_ID	TINYINT FOREIGN KEY REFERENCES TB_CIUDAD(CIUDAD_ID) NOT NULL
	,ESTADO			BIT DEFAULT 1 NOT NULL
)

--TABLA PEDIDO
CREATE TABLE TB_PEDIDO
(
	PEDIDO_ID		INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,NIT_PROV		VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES TB_PROVEEDOR(NIT)
	,EMPLEADO_ID	INT NOT NULL FOREIGN KEY REFERENCES TB_EMPLEADO(EMPLEADO_ID)
	,FECHA			DATETIME NOT NULL DEFAULT GETDATE() --Guarda la fecha actual
	,ESTADO			BIT DEFAULT 1
)


--TABLA DETALLE DE PEDIDO
CREATE TABLE TB_DET_PEDIDO
(
	DETALLE_ID		INT IDENTITY(1,1)NOT NULL
	,PEDIDO_ID		INT NOT NULL FOREIGN KEY REFERENCES TB_PEDIDO(PEDIDO_ID)
	,PRODUCTO_ID	INT NOT NULL FOREIGN KEY REFERENCES TB_PRODUCTO(PRODUCTO_ID)
	,CANTIDAD		INT NOT NULL
	,COSTO			MONEY NOT NULL
	,NUM_LOTE		VARCHAR(50)
	PRIMARY KEY (PEDIDO_ID, PRODUCTO_ID) --IMPIDE QUE EN UN PEDIDO SE TENGAS DOS DETALLES DEL MISMO PRODUCTO
)


 --TABLA CLIENTES
CREATE TABLE TB_CLIENTE 
(
	NIT			VARCHAR(20) NOT NULL PRIMARY KEY
	,NOMBRES	VARCHAR(20) NOT NULL		--obligatorio
	,APELLIDOS	VARCHAR(20)	NOT NULL		--obligatorio
	,TELEFONO	VARCHAR(12) NOT NULL
	,EMAIL		VARCHAR(40)	
	,CALLE		VARCHAR(35)
	,CIUDAD_ID	TINYINT FOREIGN KEY REFERENCES TB_CIUDAD(CIUDAD_ID)
	,ESTADO			BIT DEFAULT 1 NOT NULL
)


 --TABLA FACTURA
CREATE TABLE TB_FACTURA
(
	FACTURA_ID		INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,NIT_CLI		VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES TB_CLIENTE(NIT)
	,EMPLEADO_ID	INT NOT NULL FOREIGN KEY REFERENCES TB_EMPLEADO(EMPLEADO_ID)
	,FECHA			DATETIME NOT NULL DEFAULT GETDATE() --fecha de la compra
	,ESTADO			BIT DEFAULT 1
)

--TABLA DETALLE DE FACTURA
CREATE TABLE TB_DET_FACTURA
(
	DETALLE_ID		INT IDENTITY(1,1)NOT NULL
	,FACTURA_ID		INT NOT NULL FOREIGN KEY REFERENCES TB_FACTURA(FACTURA_ID)
	,PRODUCTO_ID	INT NOT NULL FOREIGN KEY REFERENCES TB_PRODUCTO(PRODUCTO_ID)
	,CANTIDAD		INT NOT NULL
	,COSTO			MONEY NOT NULL
	,PRIMARY KEY (FACTURA_ID, PRODUCTO_ID) --IMPIDE QUE EN UNA FACTURA SE TENGAN DOS DETALLES DEL MISMO PRODUCTO
 )


 --TABLA EXISTENCIA (DESCRICION)
CREATE TABLE TB_EXISTENCIA 
(
	EXISTENCIA_ID	INT IDENTITY (1,1) NOT NULL
	,CANTIDAD		INT NOT NULL
	,PRODUCTO_ID	INT FOREIGN KEY REFERENCES TB_PRODUCTO(PRODUCTO_ID)
	,STORE_ID		TINYINT NOT NULL
	PRIMARY KEY (PRODUCTO_ID, STORE_ID) --IMPIDE QUE EN UN PEDIDO SE TENGAS DOS DETALLES DEL MISMO PRODUCTO
)

--TABLA ESTADO
CREATE TABLE TB_ESTADO
(
	ESTADO_ID		TINYINT IDENTITY(1,1) NOT NULL PRIMARY KEY
	,DESCRIPCION	VARCHAR(25) NOT NULL
	,ESTADO			BIT DEFAULT 1
)

--TIPO DE MONEDA
CREATE TABLE TB_MONEDA
(
	MONEDA_ID		INT IDENTITY(1,1)NOT NULL PRIMARY KEY
	,DECRIPCION		VARCHAR(30) NOT NULL 
 )

--BANCO
CREATE TABLE TB_BANCO
(
	BANCO_ID		INT IDENTITY(1,1)NOT NULL PRIMARY KEY
	,NOMBRE		VARCHAR(30) NOT NULL
 )

--TIPO CUENTA
CREATE TABLE TB_TIPO_CUENTA
(
	TIPO_CUENTA_ID		INT IDENTITY(1,1)NOT NULL PRIMARY KEY
	,TIPO		VARCHAR(30) NOT NULL
 )


--TABLA PAGO
CREATE TABLE TB_PAGO
(
PAGO_ID			TINYINT IDENTITY (1,1)  NOT NULL PRIMARY KEY
,MONEDA_ID		INT NOT NULL FOREIGN KEY REFERENCES TB_MONEDA(MONEDA_ID)
,BANCO_ID		INT NOT NULL FOREIGN KEY REFERENCES TB_BANCO(BANCO_ID)
,TIPO_CUENTA_ID INT NOT NULL FOREIGN KEY REFERENCES TB_TIPO_CUENTA(TIPO_CUENTA_ID)
,NUM_CUENTA		INT NOT NULL
,NIT			VARCHAR(20)  NOT NULL FOREIGN KEY REFERENCES TB_PROVEEDOR(NIT)
,FECHA			DATE NOT NULL
,MONTO			MONEY NOT NULL
)

--TABLA PERMISO
--Aqu� se llevar� el control de los permisos a los m�dulos que se le asignar� a los usuarios

CREATE TABLE TB_PERMISO
(
PERMISO_ID		TINYINT IDENTITY (1,1)  NOT NULL PRIMARY KEY
,CARGO_ID		TINYINT NOT NULL FOREIGN KEY REFERENCES TB_CARGO(CARGO_ID)
,MOD1			BIT DEFAULT 0
,MOD2			BIT DEFAULT 0
,MOD3			BIT DEFAULT 0
,MOD4			BIT DEFAULT 0
,MOD5			BIT DEFAULT 0
)



--PROCEDIMIENTOS ALMACENADOS-----------------------------------------

--INSERTAR DEPARTAMENTO
CREATE PROCEDURE SP_INSERT_DEPARTAMENTO
	@DESCRIPCION VARCHAR(75) 
AS 
BEGIN TRY
	BEGIN TRAN
			INSERT INTO TB_DEPARTAMENTO VALUES (UPPER(@DESCRIPCION))
			COMMIT TRAN
	END TRY
	BEGIN CATCH 
			ROLLBACK 
			SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

--INSERCIONES
--EXEC SP_INSERT_DEPARTAMENTO PETEN
--EXEC SP_INSERT_DEPARTAMENTO ZACAPA
--EXEC SP_INSERT_DEPARTAMENTO CHIQUIMULA
--EXEC SP_INSERT_DEPARTAMENTO RETALHULEU

--

Alter authorization on database::BD_ROCKET to sa --Para realizar diagramas

-- BORRAR DEPARTAMENTO
CREATE PROCEDURE SP_DELETE_DEPARTAMENTO
@ID INT
AS
DELETE FROM TB_DEPARTAMENTO WHERE DEPARTAMENTO_ID=@ID

--EJECUCI�N DE SP 
--EXEC SP_DELETE_DEPARTAMENTO 4

CREATE FUNCTION FN_BUSCAR_INGRESO
(
@USER INT
,@PASS	VARCHAR(25)
)
RETURNS BIT
AS 
BEGIN
DECLARE @PassBase	Varchar(25)
DECLARE @RESPUESTA BIT

Select @PassBase = PASS  FROM TB_EMPLEADO where EMPLEADO_ID = @USER
IF (@PassBase = @PASS) SET @RESPUESTA = 1 Else SET @RESPUESTA = 0 
RETURN (@RESPUESTA) 
END

SELECT dbo.FN_BUSCAR_INGRESO('12345677','1111') as Respuesta

CREATE PROCEDURE SP_BUSCAR_INGRESO
@USER INT
,@PASS	VARCHAR(25)
AS 
SELECT dbo.FN_BUSCAR_INGRESO(@USER,@PASS)
GO

Exec SP_BUSCAR_INGRESO '12345677','0111'

--Ejemplo de funciones
--CREATE FUNCTION [dbo].[PERMISO_5] (@MONTO INT,@NIT VARCHAR(20))
--RETURNS BIT  
--AS 
--BEGIN 
--DECLARE @CANTIDAD INT, @ESTADO BIT 
--SELECT @CANTIDAD=B.CANT_MAX FROM TB_USUARIO A LEFT JOIN TB_NIVEL_AUTORIDAD B ON A.AUTORIDAD_ID=B.AUTORIDAD_ID WHERE A.NIT=@NIT
--IF (@CANTIDAD<=@MONTO)
--SET @ESTADO=0
--ELSE IF(@CANTIDAD>@MONTO)
--SET @ESTADO=1
 -- Return (@ESTADO) 
--end


--INGRESO DE PRODUCTOS 
CREATE PROCEDURE SP_INSERT_PRODUCTO
	@DESCRIPCION	VARCHAR(75) 
   ,@PORCENTAJE	    FLOAT 
   ,@ESTADO			BIT 
   ,@IMAGEN			IMAGE 
AS 
BEGIN TRY
		BEGIN TRAN
				INSERT INTO TB_PRODUCTO VALUES (UPPER(@DESCRIPCION),@PORCENTAJE,@ESTADO,@IMAGEN)
				COMMIT TRAN
	END TRY
	BEGIN CATCH 
				ROLLBACK 
				SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

--INSERCIONES 
SELECT * FROM TB_PRODUCTO
EXEC SP_INSERT_PRODUCTO 'PANTALON LEE',29,10,null
EXEC SP_INSERT_PRODUCTO 'PANTALON TOMMY',30
--EXEC SP_INSERT_PRODUCTO'PANTALONES LEVY "31',10
--EXEC SP_INSERT_PRODUCTO'PANTALONES GAP "32',10
--EXEC SP_INSERT_PRODUCTO'PANTALONES GUESS "33',10
--EXEC SP_INSERT_PRODUCTO'PANTALONES PEPE "34',10

--MODIFICACI�N DE PRODUCTOS
CREATE PROCEDURE SP_UPDATE_PRODUCTO
@ID					INT 
,@DESCRIPCION		VARCHAR(75) 
,@PORCENTAJE		DECIMAL(10,3)
--,@ESTADO			BIT	
,@IMAGEN			IMAGE
AS
UPDATE TB_PRODUCTO  set DESCRIPCION=UPPER(@DESCRIPCION), PORCENTAJE=@PORCENTAJE, IMAGEN=@IMAGEN
WHERE
PRODUCTO_ID=@ID
GO



-- BORRAR DEPARTAMENTO
CREATE PROCEDURE SP_DELETE_PRODUCTO
@ID INT
AS
DELETE FROM TB_PRODUCTO WHERE PRODUCTO_ID=@ID

--B�SQUEDAS

CREATE PROCEDURE SP_BUSCAR_PRODUCTO
@NOMBRE VARCHAR(30)
AS
SELECT * FROM TB_PRODUCTO WHERE DESCRIPCION LIKE '%'+@NOMBRE+'%'

Exec SP_BUSCAR_PRODUCTO MI


--VISTAS

--VER DEPARTAMENTO
CREATE VIEW VW_DEPT(ID, NOMBRE) AS SELECT * FROM TB_DEPARTAMENTO

--VER CIUDAD
CREATE VIEW VW_CIUDAD(ID, NOMBRE) AS SELECT CIUDAD_ID, DESCRIPCION FROM TB_CIUDAD

--VER PRODUCTO
CREATE VIEW VW_PROD(ID, PRODUCTO, PORCENTAJE, ESTADO, IMAGEN) 
AS SELECT PRODUCTO_ID, DESCRIPCION, PORCENTAJE, ESTADO, IMAGEN FROM TB_PRODUCTO

--SELECT * FROM VW_PROD

--MOSTRAR PRODUCTO
CREATE PROCEDURE SP_MOSTRAR_PRODUCTO
AS
SELECT * FROM VW_PROD


CREATE PROCEDURE SP_MOSTRAR_PEDIDOID
AS
Select Max(PEDIDO_ID) from TB_PEDIDO

CREATE VIEW VW_SUMA
AS SELECT        PEDIDO_ID, PRODUCTO_ID, CANTIDAD*COSTO as SUBTOTAL
FROM            dbo.TB_DET_PEDIDO

select * from VW_SUMA

CREATE PROCEDURE SP_MOSTRAR_DETALLE
@PEDIDO_ID INT
AS
SELECT        dbo.TB_PRODUCTO.DESCRIPCION AS PRODUCTO, dbo.TB_DET_PEDIDO.CANTIDAD, dbo.TB_DET_PEDIDO.COSTO, dbo.TB_DET_PEDIDO.NUM_LOTE AS [LOTE NO.]
FROM            dbo.TB_PEDIDO INNER JOIN
                         dbo.TB_DET_PEDIDO ON dbo.TB_PEDIDO.PEDIDO_ID = dbo.TB_DET_PEDIDO.PEDIDO_ID INNER JOIN
                         dbo.TB_PRODUCTO ON dbo.TB_DET_PEDIDO.PRODUCTO_ID = dbo.TB_PRODUCTO.PRODUCTO_ID WHERE dbo.TB_DET_PEDIDO.PEDIDO_ID = @PEDIDO_ID


Exec SP_MOSTRAR_DETALLE 49

SELECT * FROM TB_PRODUCTOS

CREATE PROCEDURE SP_MOSTRAR_DEPARTAMENTO
AS
SELECT * FROM VW_DEPT

CREATE PROCEDURE SP_MOSTRAR_CIUDADFULL
AS
SELECT * FROM VW_CIUDAD
