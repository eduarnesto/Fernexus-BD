CREATE OR ALTER PROCEDURE filtrarPedidosPorFechas
    @fechaInicio DATETIME,
    @fechaFin DATETIME
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        pr.Nombre, 
        pro.IdProveedor,
		pro.Nombre as 'NombreProveedor',
		pro.Correo,
		pro.Telefono,
		pro.Direccion,
		pro.Pais,
		c.IdCategoria,
		c.Nombre as 'NombreCategoria',
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
	JOIN
		Proveedores pro ON pro.IdProveedor = p.IdProveedor
    WHERE FechaPedido >= @fechaInicio AND FechaPedido <= DATEADD(DAY, 1, @fechaFin)
        AND p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11'
		AND c.deletedat = '1111-11-11'
		AND prp.deletedat = '1111-11-11'
		AND pro.deletedat = '1111-11-11';
END;

DECLARE @fechaInicio DATETIME = '2023-03-05',  
        @fechaFin DATETIME = '2026-03-06';  



CREATE OR ALTER PROCEDURE filtrarPedidosPorProducto
    @idProducto INT
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        pr.Nombre AS 'Nombre', 
        pro.IdProveedor,
        pro.Nombre AS 'NombreProveedor',
        pro.Correo,
        pro.Telefono,
        pro.Direccion,
        pro.Pais,
        c.IdCategoria,
        c.Nombre AS 'NombreCategoria',
        prp.PrecioUnidad,
        pp.Cantidad,
        prp.PrecioUnidad * pp.Cantidad AS PrecioTotal
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
    JOIN
        Proveedores pro ON pro.IdProveedor = p.IdProveedor
    WHERE 
        p.IdPedido IN (
            SELECT IdPedido 
            FROM PedidosProductos 
            WHERE IdProducto = @idProducto
        )
        AND p.DeletedAt = '1111-11-11'
        AND pp.DeletedAt = '1111-11-11'
        AND pr.DeletedAt = '1111-11-11'
        AND pc.DeletedAt = '1111-11-11'
        AND c.DeletedAt = '1111-11-11'
        AND prp.DeletedAt = '1111-11-11'
        AND pro.DeletedAt = '1111-11-11';
END;



CREATE OR ALTER PROCEDURE filtrarProductosPorCategoria
    @idCategoria INT
AS
BEGIN
    SELECT 
		p.*, 
		pp.PrecioUnidad, 
		pp.Stock, 
		pro.IdProveedor,
		pro.Nombre as 'NombreProveedor',
		pro.Correo,
		pro.Telefono,
		pro.Direccion,
		pro.Pais,
		c.IdCategoria,
		c.Nombre as 'NombreCategoria'
    FROM 
		Productos p
    INNER JOIN 
		ProductosCategorias pc ON p.IdProducto = pc.IdProducto
	INNER JOIN 
		ProveedoresProductos pp ON p.IdProducto = pp.IdProducto
	INNER JOIN
		Proveedores pro ON pro.Idproveedor = pp.Idproveedor
	INNER JOIN
		Categorias c ON c.IdCategoria = pc.IdCategoria
    WHERE pc.IdCategoria = @idCategoria
      AND p.deletedat = '1111-11-11'
      AND pc.deletedat = '1111-11-11';
END;

exec filtrarProductosPorCategoria 1

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



CREATE OR ALTER PROCEDURE modificarPedido
    @IdPedido INT,
    @lista ListaProductos READONLY,
    @Resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el pedido existe y no est� eliminado
        IF NOT EXISTS (
            SELECT 1 FROM Pedidos 
            WHERE IdPedido = @IdPedido 
              AND deletedat = '1111-11-11'
        )
        BEGIN
            SET @Resultado = -1; -- C�digo para indicar que el pedido no existe
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar productos actuales del pedido
        DELETE FROM PedidosProductos
        WHERE IdPedido = @IdPedido;

        -- Insertar nuevos productos
        INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad)
        SELECT @IdPedido, idProducto, cantidad
        FROM @lista;

        COMMIT TRANSACTION;
        SET @Resultado = 1; -- C�digo para indicar �xito
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @Resultado = 0; -- C�digo para indicar error
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

Select * from Proveedores
Select * from Categorias
Exec pedidoCompleto

CREATE OR ALTER PROCEDURE pedidoCompleto
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        pr.Nombre, 
        pro.IdProveedor,
		pro.Nombre as 'NombreProveedor',
		pro.Correo,
		pro.Telefono,
		pro.Direccion,
		pro.Pais,
		c.IdCategoria,
		c.Nombre as 'NombreCategoria',
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
	JOIN
		Proveedores pro ON pro.IdProveedor = p.IdProveedor
    WHERE 
        p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11'
		AND c.deletedat = '1111-11-11'
		AND prp.deletedat = '1111-11-11'
		AND pro.deletedat = '1111-11-11';
END;



CREATE OR ALTER PROCEDURE pedidoCompletoPorId
	@IdPedido INT
AS
BEGIN
    SELECT 
        p.IdPedido, 
        p.FechaPedido, 
        pp.IdProducto, 
        pr.Nombre, 
        pro.IdProveedor,
		pro.Nombre as 'NombreProveedor',
		pro.Correo,
		pro.Telefono,
		pro.Direccion,
		pro.Pais,
		c.IdCategoria,
		c.Nombre as 'NombreCategoria',
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
	JOIN
		Proveedores pro ON pro.IdProveedor = p.IdProveedor
    WHERE p.IdPedido = @IdPedido
        AND p.deletedat = '1111-11-11'
        AND pp.deletedat = '1111-11-11'
        AND pr.deletedat = '1111-11-11'
        AND pc.deletedat = '1111-11-11'
		AND c.deletedat = '1111-11-11'
		AND prp.deletedat = '1111-11-11'
		AND pro.deletedat = '1111-11-11';
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