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

CREATE OR ALTER PROCEDURE pedidosPorProducto
    @idProducto NVARCHAR(255) 
AS
BEGIN
    SELECT * 
    FROM Pedidos P
    INNER JOIN PedidosProductos PP ON PP.IdPedido = P.IdPedido
    WHERE PP.IdProducto = @idProducto;
END;

--exec productosPorCategoria @idCategoria=''
--exec productosPorPedido @idPedido=''

