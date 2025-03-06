-- Insertar Categorías
INSERT INTO Categorias (Nombre) VALUES ('Electrónica');
INSERT INTO Categorias (Nombre) VALUES ('Hogar');
INSERT INTO Categorias (Nombre) VALUES ('Ropa');

-- Insertar Productos
INSERT INTO Productos (Nombre) VALUES ('Televisor');
INSERT INTO Productos (Nombre) VALUES ('Sofá');
INSERT INTO Productos (Nombre) VALUES ('Camisa');

-- Insertar Proveedores
INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais) VALUES ('Proveedor1', 'contacto1@email.com', '123456789', 'Calle 123', 'España');
INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais) VALUES ('Proveedor2', 'contacto2@email.com', '987654321', 'Avenida 456', 'México');

-- Insertar ProductosCategorias
INSERT INTO ProductosCategorias (IdCategoria, IdProducto, Stock, Precio) VALUES (1, 1, 50, 499.99);
INSERT INTO ProductosCategorias (IdCategoria, IdProducto, Stock, Precio) VALUES (2, 2, 20, 299.99);
INSERT INTO ProductosCategorias (IdCategoria, IdProducto, Stock, Precio) VALUES (3, 3, 100, 19.99);

-- Insertar Pedidos
INSERT INTO Pedidos (FechaPedido, Coste, IdProveedor) VALUES ('2024-03-01', 1000.50, 1);
INSERT INTO Pedidos (FechaPedido, Coste, IdProveedor) VALUES ('2024-03-02', 500.75, 2);

-- Insertar PedidosProductos
INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES (3, 1, 2);
INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES (4, 2, 1);
INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES (5, 3, 5);

-- Insertar ProveedoresProductos
INSERT INTO ProveedoresProductos (IdProveedor, IdProducto, PrecioUnidad) VALUES (1, 1, 450.00);
INSERT INTO ProveedoresProductos (IdProveedor, IdProducto, PrecioUnidad) VALUES (2, 2, 280.00);
INSERT INTO ProveedoresProductos (IdProveedor, IdProducto, PrecioUnidad) VALUES (1, 3, 15.00);