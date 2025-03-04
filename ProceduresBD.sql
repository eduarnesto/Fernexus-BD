CREATE OR ALTER PROCEDURE filtrarPedidosPorProducto
    @idProducto INT
AS
BEGIN
    SELECT * 
    FROM Pedidos P
    INNER JOIN PedidosProductos PP ON PP.IdPedido = P.IdPedido
    WHERE PP.IdProducto = @idProducto
      AND P.deletedat = '1111-11-11'
      AND PP.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE filtrarPedidosPorFechas
    @fechaInicio DATETIME,
    @fechaFin DATETIME
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        prp.IdProveedor,
        pr.Nombre, 
        pc.IdCategoria,
        pp.Cantidad,
        prp.PrecioUnidad * pp.Cantidad as PrecioTotal
    FROM 
        Pedidos p
    JOIN 
        PedidosProductos pp ON p.IdPedido = pp.IdPedido
    JOIN 
        Productos pr ON pp.IdProducto = pr.IdProducto
    JOIN 
        ProductosCategorias pc ON pr.IdProducto = pc.IdProducto
    JOIN 
        Categorias c ON pc.IdCategoria = c.IdCategoria
    JOIN
        ProveedoresProductos prp ON prp.IdProducto = pp.IdProducto AND prp.IdProveedor = p.IdProveedor
    WHERE FechaPedido BETWEEN @fechaInicio AND @fechaFin
        AND p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE filtrarPedidosPorIdProducto
    @idProducto
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        prp.IdProveedor,
        pr.Nombre, 
        pc.IdCategoria,
        pp.Cantidad,
        prp.PrecioUnidad * pp.Cantidad as PrecioTotal
    FROM 
        Pedidos p
    JOIN 
        PedidosProductos pp ON p.IdPedido = pp.IdPedido
    JOIN 
        Productos pr ON pp.IdProducto = pr.IdProducto
    JOIN 
        ProductosCategorias pc ON pr.IdProducto = pc.IdProducto
    JOIN 
        Categorias c ON pc.IdCategoria = c.IdCategoria
    JOIN
        ProveedoresProductos prp ON prp.IdProducto = pp.IdProducto AND prp.IdProveedor = p.IdProveedor
    WHERE pp.IdProducto = @idProducto
        AND p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE filtrarProductosPorCategoria
    @idCategoria INT
AS
BEGIN
    SELECT p.*
    FROM Productos p
    INNER JOIN ProductosCategorias pc ON p.IdProducto = pc.IdProducto
    WHERE pc.IdCategoria = @idCategoria
      AND p.deletedat = '1111-11-11'
      AND pc.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE filtrarProveedoresPorPais
    @Pais NVARCHAR(100)  
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * 
    FROM Proveedores
    WHERE Pais = @Pais
      AND deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE crearPedido
    @lista ListaProductos READONLY
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NuevoPedidoId INT;
    DECLARE @IdProveedor INT;

    -- Validar que todos los productos tengan el mismo proveedor
    SELECT @IdProveedor = MIN(idProveedor) FROM @lista;
    IF (SELECT COUNT(DISTINCT idProveedor) FROM @lista) > 1
    BEGIN
        RAISERROR('Todos los productos deben pertenecer al mismo proveedor.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar Pedido
        INSERT INTO Pedidos (FechaPedido, IdProveedor)
        VALUES (GETDATE(), @IdProveedor);

        SET @NuevoPedidoId = SCOPE_IDENTITY();

        -- Insertar Productos (sin GROUP BY innecesario)
        INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad)
        SELECT @NuevoPedidoId, idProducto, cantidad
        FROM @lista;

        COMMIT TRANSACTION;

        -- Retornar el pedido creado (asumiendo que deletedat es un soft delete)
        SELECT * 
        FROM Pedidos 
        WHERE IdPedido = @NuevoPedidoId
          AND deletedat = '1111-11-11';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW; -- Propagar el error
    END CATCH;
END;

CREATE OR ALTER PROCEDURE filtrarPedidosConDatosDelProducto
    @IdPedido INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.IdPedido,
        p.FechaPedido,
        p.Coste,
        pr.IdProducto,
        pr.Nombre AS NombreProducto,
        pp.Cantidad
    FROM Pedidos p
    LEFT JOIN PedidosProductos pp ON p.IdPedido = pp.IdPedido
    LEFT JOIN Productos pr ON pp.IdProducto = pr.IdProducto
    WHERE p.IdPedido = @IdPedido
      AND p.deletedat = '1111-11-11'
      AND pp.deletedat = '1111-11-11'
      AND pr.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE pedidoCompleto
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        prp.IdProveedor,
        pr.Nombre, 
        pc.IdCategoria,
        prp.IdProveedor,
        pr.Nombre, 
        pc.IdCategoria,
		prp.PrecioUnidad,
        pp.Cantidad,
        prp.PrecioUnidad * pp.Cantidad as PrecioTotal
    FROM 
        Pedidos p
    JOIN 
        PedidosProductos pp ON p.IdPedido = pp.IdPedido
    JOIN 
        Productos pr ON pp.IdProducto = pr.IdProducto
    JOIN 
        ProductosCategorias pc ON pr.IdProducto = pc.IdProducto
    JOIN 
        Categorias c ON pc.IdCategoria = c.IdCategoria
    JOIN
        ProveedoresProductos prp ON prp.IdProducto = pp.IdProducto AND prp.IdProveedor = p.IdProveedor
    WHERE 
        p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11';
END;

CREATE OR ALTER PROCEDURE ObtenerDetallesProducto
    @IdProducto INT
AS
BEGIN
    SELECT 
        p.IdProducto, 
        p.Nombre, 
        pp.IdProveedor,
        pp.PrecioUnidad, 
        pr.Nombre AS NombreProveedor
    FROM 
        Productos p
    JOIN 
        ProveedoresProductos pp ON p.IdProducto = pp.IdProducto
    JOIN 
        Proveedores pr ON pp.IdProveedor = pr.IdProveedor
    WHERE 
        p.IdProducto = @IdProducto
      AND p.deletedat = '1111-11-11'
      AND pp.deletedat = '1111-11-11'
      AND pr.deletedat = '1111-11-11';
END;