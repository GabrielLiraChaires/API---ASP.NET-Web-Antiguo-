CREATE DATABASE AbarrotesPrueba
GO
USE AbarrotesPrueba
GO

CREATE TABLE Producto
(
	Clave NVARCHAR(50) PRIMARY KEY,
	Nombre NVARCHAR(100) NOT NULL,
	CostoUnidad DECIMAL(18,2) NOT NULL,
	Unidades INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE()
);

CREATE TABLE Venta
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Cliente NVARCHAR(100),
	Fecha DATETIME DEFAULT GETDATE()
);

CREATE TABLE DetalleVenta
(
	FkIdVenta INT,
	FkClaveProducto NVARCHAR(50) NOT NULL, 
	Cantidad INT NOT NULL,
	Subtotal DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(FkIdVenta,FkClaveProducto),
	FOREIGN KEY(FkIdVenta) REFERENCES Venta(Id),
	FOREIGN KEY(FkClaveProducto) REFERENCES Producto(Clave)
);

--Vista.
CREATE OR ALTER VIEW vw_VentasConDetalles
AS
SELECT 
    v.Id AS IdVenta,
    v.Cliente,
    v.Fecha AS FechaVenta,
    d.FkClaveProducto,
    p.Nombre AS NombreProducto,
    d.Cantidad,
    d.Subtotal
FROM Venta v
INNER JOIN DetalleVenta d ON v.Id = d.FkIdVenta
INNER JOIN Producto p ON d.FkClaveProducto = p.Clave;
GO

--Procedure para almacenar una venta y sus multiples detalles, haciendo uso de un tipo de tabla como auxiliar.
CREATE TYPE DetalleVentaTipo AS TABLE
(
    FkClaveProducto NVARCHAR(50),
    Cantidad INT,
    Subtotal DECIMAL(18,2)
);
CREATE OR ALTER PROCEDURE sp_GuardarVenta
    @Cliente NVARCHAR(100),
    @Detalles DetalleVentaTipo READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Insertando la venta y obtener el ID generado.
        INSERT INTO Venta(Cliente) VALUES(@Cliente);

        -- Extrayendo el ide de la venta nueva.
        DECLARE @NuevoIdVenta INT = SCOPE_IDENTITY();

        -- Insertando los detalles con el ID de la venta.
        INSERT INTO DetalleVenta (FkIdVenta, FkClaveProducto, Cantidad, Subtotal)
        SELECT 
            @NuevoIdVenta, 
            FkClaveProducto, 
            Cantidad, 
            Subtotal
        FROM @Detalles;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

--Trigger para actualizar las existencias al insertar un registro.
CREATE OR ALTER TRIGGER tr_DetalleVentaGuardado
ON DetalleVenta
AFTER INSERT
AS BEGIN 
    SET NOCOUNT ON;
    --Actualizando unidades.
    UPDATE Producto
    SET Unidades = Unidades - i.Cantidad
    FROM Producto p
    INNER JOIN inserted i ON p.Clave = i.FkClaveProducto;
END
GO

--Trigger para actualizar las existencias de productos al eliminar un detalle de venta.
CREATE OR ALTER TRIGGER tr_DetalleVentaEliminado
ON DetalleVenta
AFTER DELETE
AS BEGIN
    SET NOCOUNT ON;
    --Actualizando unidades.
    UPDATE Producto SET Unidades = Unidades + i.Cantidad
    FROM Producto p
    INNER JOIN deleted i ON p.Clave = i.FkClaveProducto;
END
GO