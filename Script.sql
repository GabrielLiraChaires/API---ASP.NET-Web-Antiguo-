CREATE DATABASE ProductosPrueba;
GO 
USE ProductosPrueba;
GO

CREATE TABLE Producto(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Nombre NVARCHAR(100) NOT NULL,
	Costo DECIMAL(18,2) NOT NULL,
	Cantidad INT NOT NULL
);

--PROCEDIMIENTOS ALMACENADOS.

--Guardar.
CREATE OR ALTER PROCEDURE sp_GuardarProducto
	@Nombre NVARCHAR(100),
	@Costo DECIMAL(18,2),
	@Cantidad INT
AS 
BEGIN 
	SET NOCOUNT ON;
	--Insertando.
	INSERT INTO Producto(Nombre, Costo, Cantidad) VALUES (@Nombre, @Costo, @Cantidad);
	--Devolviendo fila recien insertada.
	DECLARE @NuevoId INT = SCOPE_IDENTITY();
	SELECT * FROM Producto where ID=@NuevoId;
END 
GO

--Actualizar.
CREATE OR ALTER PROCEDURE sp_ActualizarProducto
	@Id INT,
	@Nombre NVARCHAR(100),
	@Costo DECIMAL(18,2),
	@Cantidad INT
AS 
BEGIN 
	SET NOCOUNT ON;
	--Actualizando.
	UPDATE Producto SET Nombre=@Nombre, Costo=@Costo, Cantidad=@Cantidad WHERE Id=@Id;
	--Devolver registro actualizado.
	SELECT * FROM Producto WHERE Id=@Id;
END
GO

--Eliminar.
CREATE OR ALTER PROCEDURE sp_EliminarProducto
	@Id INT
AS 
BEGIN 
	SET NOCOUNT ON;
	--Eliminando.
	DELETE FROM Producto WHERE Id=@Id;
END 
GO

--Buscar.
CREATE OR ALTER PROCEDURE sp_BuscarProducto
	@Id INT
AS 
BEGIN 
	SET NOCOUNT ON;
	--Buscando.
	SELECT * FROM Producto WHERE Id=@Id;
END 
GO

--Consultar.
CREATE OR ALTER PROCEDURE sp_ConsultarProductos
AS
BEGIN 
	SET NOCOUNT ON;
	--Cosultando y mostrando.
	SELECT * FROM Producto ORDER BY Nombre;
END 
GO