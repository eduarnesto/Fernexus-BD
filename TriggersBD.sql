CREATE TRIGGER trg_SoftDelete_ProductosCategorias
ON ProductosCategorias
INSTEAD OF DELETE
AS
BEGIN
    UPDATE ProductosCategorias
    SET DeletedAt = GETDATE()
    WHERE IdCategoria IN (SELECT IdCategoria FROM DELETED)
      AND IdProducto IN (SELECT IdProducto FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_Pedidos
ON Pedidos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Pedidos
    SET DeletedAt = GETDATE()
    WHERE IdPedido IN (SELECT IdPedido FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_Productos
ON Productos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Productos
    SET DeletedAt = GETDATE()
    WHERE IdProducto IN (SELECT IdProducto FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_Proveedores
ON Proveedores
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Proveedores
    SET DeletedAt = GETDATE()
    WHERE IdProveedor IN (SELECT IdProveedor FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_Categorias
ON Categorias
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Categorias
    SET DeletedAt = GETDATE()
    WHERE IdCategoria IN (SELECT IdCategoria FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_PedidosProductos
ON PedidosProductos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE PedidosProductos
    SET DeletedAt = GETDATE()
    WHERE IdPedido IN (SELECT IdPedido FROM DELETED)
      AND IdProducto IN (SELECT IdProducto FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE TRIGGER trg_SoftDelete_ProveedoresProductos
ON ProveedoresProductos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE ProveedoresProductos
    SET DeletedAt = GETDATE()
    WHERE IdProveedor IN (SELECT IdProveedor FROM DELETED)
      AND IdProducto IN (SELECT IdProducto FROM DELETED)
      AND DeletedAt IS NULL;
END;

CREATE OR ALTER TRIGGER trg_AfterUpdate_PedidosProductos
ON PedidosProductos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE p
    SET p.Coste = ISNULL(p.Coste, 0) 
                  - ISNULL(sub_old.Total, 0) 
                  + ISNULL(sub_new.Total, 0)
    FROM Pedidos p
    LEFT JOIN (
        SELECT d.IdPedido, SUM(d.Cantidad * pr.Precio) AS Total
        FROM deleted d
        JOIN Productos pr ON d.IdProducto = pr.IdProducto
        GROUP BY d.IdPedido
    ) sub_old ON p.IdPedido = sub_old.IdPedido
    LEFT JOIN (
        SELECT i.IdPedido, SUM(i.Cantidad * pr.Precio) AS Total
        FROM inserted i
        JOIN Productos pr ON i.IdProducto = pr.IdProducto
        GROUP BY i.IdPedido
    ) sub_new ON p.IdPedido = sub_new.IdPedido;
END;

CREATE OR ALTER TRIGGER trg_AfterInsert_AfterUpdate_Pedidos
ON Pedidos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN deleted d ON i.IdPedido = d.IdPedido -- Para UPDATE
        WHERE i.Coste <> d.Coste OR i.Coste IS NOT NULL
    )
    BEGIN
        RAISERROR ('No puedes insertar ni modificar el campo Coste manualmente.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;