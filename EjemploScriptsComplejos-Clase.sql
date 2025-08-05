-- ===============================
-- 1️⃣ CREACIÓN DE TABLAS
-- ===============================

-- Tabla principal: Producto
CREATE TABLE Producto (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Costo DECIMAL(18,2) NOT NULL,
    Cantidad INT NOT NULL
);

-- Tabla de bitácora: registra acciones sobre productos
CREATE TABLE BitacoraProducto (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductoId INT,
    Fecha DATETIME DEFAULT GETDATE(),
    Accion NVARCHAR(50),
    FOREIGN KEY (ProductoId) REFERENCES Producto(Id)
);

-- ===============================
-- 2️⃣ VISTA: vw_ProductosConEstado
-- ===============================
CREATE OR ALTER VIEW vw_ProductosConEstado AS
SELECT 
    p.Id, 
    p.Nombre, 
    p.Costo, 
    p.Cantidad, 
    CASE 
        WHEN p.Cantidad >= 10 THEN 'Suficiente'
        WHEN p.Cantidad BETWEEN 1 AND 9 THEN 'Bajo'
        WHEN p.Cantidad = 0 THEN 'Agotado'
        ELSE 'Desconocido'
    END AS EstadoStock
FROM Producto p;
GO

-- ===============================
-- 3️⃣ PROCEDIMIENTO: sp_ActualizarProducto
-- ===============================
CREATE OR ALTER PROCEDURE sp_ActualizarProducto
    @Id INT,
    @Nombre NVARCHAR(100),
    @Costo DECIMAL(18,2),
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Producto WHERE Id = @Id)
    BEGIN
        UPDATE Producto
        SET Nombre = @Nombre,
            Costo = @Costo,
            Cantidad = @Cantidad
        WHERE Id = @Id;

        PRINT 'Producto actualizado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'El producto que intentas actualizar no existe.';
    END
END;
GO

-- ===============================
-- 4️⃣ TRIGGER: trg_Producto_Insertado
-- ===============================
CREATE OR ALTER TRIGGER trg_Producto_Insertado
ON Producto
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- inserted = contiene las filas recién insertadas
    INSERT INTO BitacoraProducto (ProductoId, Accion)
    SELECT Id, 'INSERTADO'
    FROM inserted;
END;
GO

-- ===============================
-- 5️⃣ TRIGGER: trg_Producto_Actualizado
-- ===============================
CREATE OR ALTER TRIGGER trg_Producto_Actualizado
ON Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- inserted = valores nuevos tras el UPDATE
    -- deleted  = valores antiguos antes del UPDATE
    -- Comparamos ambos para registrar cambios
    INSERT INTO BitacoraProducto (ProductoId, Accion)
    SELECT 
        i.Id,
        'ACTUALIZADO - Costo o Cantidad cambiado'
    FROM inserted i
    INNER JOIN deleted d ON i.Id = d.Id
    WHERE i.Costo <> d.Costo OR i.Cantidad <> d.Cantidad;
END;
GO
