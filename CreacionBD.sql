-- Crear el tipo de datos
CREATE TYPE ListaProductos AS TABLE (idProducto INT, idProveedor INT, cantidad INT);

-- Crear la tabla Categorias
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_Categorias PRIMARY KEY (IdCategoria)
);

-- Crear la tabla Productos
CREATE TABLE Productos (
    IdProducto INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_Productos PRIMARY KEY (IdProducto)
);

-- Crear la tabla Proveedores
CREATE TABLE Proveedores (
    IdProveedor INT IDENTITY(1,1),
    Nombre VARCHAR(255) NOT NULL,
    Correo VARCHAR(255) UNIQUE NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    Direccion TEXT NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_Proveedores PRIMARY KEY (IdProveedor)
);

-- Crear la tabla ProductosCategorias (ON DELETE CASCADE en ambas claves)
CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_ProductosCategorias PRIMARY KEY (IdCategoria, IdProducto),
    CONSTRAINT FK_ProductosCategorias_Categoria 
        FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria) ON DELETE CASCADE,
    CONSTRAINT FK_ProductosCategorias_Producto 
        FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE
);

-- Crear la tabla Pedidos (ON DELETE CASCADE en IdProveedor)
CREATE TABLE Pedidos (
    IdPedido INT IDENTITY(1,1),
    FechaPedido DATETIME NOT NULL,
    Coste DECIMAL(10,2),
    IdProveedor INT,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_Pedidos PRIMARY KEY (IdPedido),
    CONSTRAINT FK_Pedidos_Proveedores 
        FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor) ON DELETE CASCADE
);

-- Crear la tabla PedidosProductos (ON DELETE CASCADE en ambas claves)
CREATE TABLE PedidosProductos (
    IdPedido INT,
    IdProducto INT,
    Cantidad INT,
    DeletedAt DATE DEFAULT '1111-11-11',
    PRIMARY KEY (IdPedido, IdProducto),
    CONSTRAINT FK_PedidosProductos_Pedido 
        FOREIGN KEY (IdPedido) REFERENCES Pedidos(IdPedido) ON DELETE CASCADE,
    CONSTRAINT FK_PedidosProductos_Producto 
        FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE
);

-- Crear la tabla ProveedoresProductos (ON DELETE CASCADE en ambas claves)
CREATE TABLE ProveedoresProductos (
    IdProveedor INT,
    IdProducto INT,
    PrecioUnidad DECIMAL(10,2),
	Stock INT,
    DeletedAt DATE DEFAULT '1111-11-11',
    CONSTRAINT PK_ProveedoresProductos PRIMARY KEY (IdProveedor, IdProducto),
    CONSTRAINT FK_ProveedoresProductos_Proveedores 
        FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor) ON DELETE CASCADE,
    CONSTRAINT FK_ProveedoresProductos_Productos 
        FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE
);