CREATE TABLE Pedidos (
    IdPedido INT PRIMARY KEY,
    FechaPedido DateTime,
    Coste DECIMAL(10,2)
);

CREATE TABLE PedidosProductos (
    IdPedido INT,
    IdProducto INT,
    Cantidad INT,
    PRIMARY KEY (IdPedido, IdProducto),
	CONSTRAINT FKPedidosProductosPedido FOREIGN KEY (IdPedido) REFERENCES Pedidos(IdPedido),
    CONSTRAINT FKPedidosProductosProducto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    CONSTRAINT PKProductosCategorias PRIMARY KEY (IdCategoria, IdProducto),
    CONSTRAINT FKProductosCategoriasCategoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FKProductosCategoriasProducto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);