Create TYPE ListaProductos as TABLE (idProducto INT, idProveedor INT)

CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    Stock INT,
    Precio FLOAT NOT NULL,
    DeletedAt DATE NULL,
    CONSTRAINT PK_ProductosCategorias PRIMARY KEY (IdCategoria, IdProducto, DeletedAt),
    CONSTRAINT FK_ProductosCategorias_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_ProductosCategorias_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

CREATE TABLE Pedidos (
    IdPedido INT IDENTITY(1,1),
    FechaPedido DATETIME NOT NULL,
    Coste DECIMAL(10,2),
    IdProveedor INT,
    DeletedAt DATE NULL,
    CONSTRAINT PK_Pedidos PRIMARY KEY (IdPedido, DeletedAt),
    CONSTRAINT FK_Pedidos_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor)
);

CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    DeletedAt DATE NULL,
    CONSTRAINT PK_Productos PRIMARY KEY (IdProducto, DeletedAt)
);

CREATE TABLE Proveedores (
    IdProveedor INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    Correo VARCHAR(255) UNIQUE NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    Direccion TEXT NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    DeletedAt DATE NULL,
    CONSTRAINT PK_Proveedores PRIMARY KEY (IdProveedor, DeletedAt)
);

CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    DeletedAt DATE NULL,
    CONSTRAINT PK_Categorias PRIMARY KEY (IdCategoria, DeletedAt)
);

CREATE TABLE PedidosProductos (
    IdPedido INT,
    IdProducto INT,
    Cantidad INT,
    DeletedAt DATE NULL,
    PRIMARY KEY (IdPedido, IdProducto, DeletedAt),
    CONSTRAINT FK_PedidosProductos_Pedido FOREIGN KEY (IdPedido) REFERENCES Pedidos(IdPedido),
    CONSTRAINT FK_PedidosProductos_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) 
);

CREATE TABLE ProveedoresProductos (
    IdProveedor INT,
    IdProducto INT,
    PrecioUnidad DECIMAL(10,2),
    DeletedAt DATE NULL,
    CONSTRAINT PK_ProveedoresProductos PRIMARY KEY (IdProveedor, IdProducto, DeletedAt),
    CONSTRAINT FK_ProveedoresProductos_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor),
    CONSTRAINT FK_ProveedoresProductos_Productos FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);