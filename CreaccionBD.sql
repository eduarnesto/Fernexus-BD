Create database Fernexus
Use Fernexus

CREATE TABLE Pedidos (
    IdPedido INT IDENTITY(1,1),
    FechaPedido DateTime NOT NULL,
    Coste DECIMAL(10,2),
	CONSTRAINT PK_Pedidos PRIMARY KEY (IdPedido)
);

CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    IdCategoria INT,
	CONSTRAINT PK_Productos PRIMARY KEY (IdProducto),
);

CREATE TABLE Proveedores (
    IdProveedor INT IDENTITY(1,1),
    Nombre VARCHAR (255) NOT NULL,
    Correo VARCHAR (255) UNIQUE NOT NULL,
    Telefono VARCHAR (20) NOT NULL,
    Direccion TEXT NOT NULL,
    Pais VARCHAR (100) NOT NULL
	CONSTRAINT PK_Proveedores PRIMARY KEY (IdProveedor)
);

CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1),
    nombre VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Categorias PRIMARY KEY (IdCategoria)
);

CREATE TABLE PedidosProductos (
    IdPedido INT,
    IdProducto INT,
    Cantidad INT NOT NULL,
    CONSTRAINT PK_PedidosProductos PRIMARY KEY (IdPedido, IdProducto),
	CONSTRAINT FK_PedidosProductos_Pedido FOREIGN KEY (IdPedido) REFERENCES Pedidos(IdPedido),
    CONSTRAINT FK_PedidosProductos_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) 
);

CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    CONSTRAINT PK_ProductosCategorias PRIMARY KEY (IdCategoria, IdProducto),
    CONSTRAINT FK_ProductosCategorias_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_ProductosCategorias_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);
GO

CREATE PROCEDURE productosPorPedido 
    @idPedido NVARCHAR(255) 
AS
BEGIN
    SELECT * 
    FROM Productos P
    INNER JOIN PedidosProductos PP ON PP.IdProducto = P.IdProducto
    WHERE PP.IdPedido = @idPedido;
END;

GO

CREATE PROCEDURE productosPorCategoria 
    @idCategoria NVARCHAR(255)  
AS
BEGIN
    SELECT * 
    FROM Productos P
    INNER JOIN ProductosCategorias PC ON PC.IdProducto = P.IdProducto
    WHERE PC.IdCategoria = @idCategoria;
END;

exec productosPorPedido 12

CREATE PROCEDURE FiltrarPedidosPorFecha 
    @FechaInicio DATETIME, 
    @FechaFin DATETIME
AS
BEGIN
    SELECT * 
    FROM Pedidos
    WHERE FechaPedido BETWEEN @FechaInicio AND @FechaFin;
END;

EXEC FiltrarPedidosPorFecha '01-01-2023', '31-12-2023';
--exec productosPorCategoria @idCategoria=''
--exec productosPorPedido @idPedido=''

CREATE TRIGGER trg_AfterInsert_PedidosProductos
ON PedidosProductos
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.Coste = ISNULL(p.Coste, 0) + (i.Cantidad * pr.Precio)
    FROM Pedidos p
    JOIN inserted i ON p.IdPedido = i.IdPedido
    JOIN Productos pr ON i.IdProducto = pr.IdProducto
END;

CREATE TRIGGER trg_AfterDelete_PedidosProductos
ON PedidosProductos
AFTER DELETE
AS
BEGIN
    UPDATE p
    SET p.Coste = ISNULL(p.Coste, 0) - (d.Cantidad * pr.Precio)
    FROM Pedidos p
    JOIN deleted d ON p.IdPedido = d.IdPedido
    JOIN Productos pr ON d.IdProducto = pr.IdProducto;
END;

CREATE TRIGGER trg_AfterUpdate_PedidosProductos
ON PedidosProductos
AFTER UPDATE
AS
BEGIN
    -- Actualizar el coste en caso de que la cantidad cambie
    UPDATE p
    SET p.Coste = ISNULL(p.Coste, 0) 
                  + (i.Cantidad * pr.Precio) 
                  - (d.Cantidad * pr2.Precio)
    FROM Pedidos p
    JOIN inserted i ON p.IdPedido = i.IdPedido
    JOIN deleted d ON p.IdPedido = d.IdPedido
    JOIN Productos pr ON i.IdProducto = pr.IdProducto
    JOIN Productos pr2 ON d.IdProducto = pr2.IdProducto;
END;