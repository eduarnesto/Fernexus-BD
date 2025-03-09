Use MarcoDB

INSERT INTO Categorias (Nombre) VALUES
('Electrónica'),
('Hogar'),
('Juguetes'),
('Ropa'),
('Deportes');

INSERT INTO Productos (Nombre) VALUES
('Smartphone'),
('Lavadora'),
('Muñeca Barbie'),
('Camiseta de Algodón'),
('Balón de Fútbol'),
('Pelota de tenis');

INSERT INTO ProductosCategorias (IdCategoria, IdProducto) VALUES
(1, 1), -- Smartphone y Electrónica
(2, 2), -- Lavadora y Hogar
(3, 3), -- Muñeca Barbie y Juguetes
(4, 4), -- Camiseta y Ropa
(5, 5), -- Balón de Fútbol y Deportes
(5, 6); --Pelota de Tennis y Deportes

INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais) VALUES
('TechZone', 'contacto@techzone.com', '123456789', 'Calle Tecnología 45', 'España'),
('HomeStyle', 'ventas@homestyle.com', '987654321', 'Avenida Hogar 22', 'México'),
('ToysWorld', 'info@toysworld.com', '555123456', 'Calle Infantil 99', 'Argentina'),
('FashionWear', 'soporte@fashionwear.com', '666987654', 'Paseo de la Moda 12', 'Colombia'),
('SportLife', 'deportes@sportlife.com', '777333222', 'Av. del Deporte 5', 'Chile');

INSERT INTO Pedidos (FechaPedido, Coste, IdProveedor) VALUES
('2024-03-01', 1500.00, 1), --Pedido 1 3*500=1500
('2024-03-05', 1500.00, 2), --Pedido 2 750*2=1500
('2024-03-10', 100.00, 3), --Pedido 3 10*10=100
('2024-03-15', 300.00, 4), --Pedido 4 15*20=300
('2024-03-20', 300.00, 5); -- Pedido 5 10*30=300

-- Insertar ProveedoresProductos
INSERT INTO ProveedoresProductos (IdProveedor, IdProducto, PrecioUnidad, Stock) VALUES
(1, 1, 500.00, 50),  -- TechZone vende Smartphones
(2, 2, 750.00, 30),  -- HomeStyle vende Lavadoras
(3, 3, 10, 100),  -- ToysWorld vende Muñecas Barbie
(4, 4, 15.00, 200),  -- FashionWear vende Camisetas
(5, 5, 30.00, 80),   -- SportLife vende Balones
(5, 6, 2.00, 200), --SportLife vende Pelotas de tennis
(5, 4, 16.00, 100); --SportLife vende Camisetas

-- Insertar PedidosProductos
INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES
(1, 1, 3),  -- Pedido 1 contiene 3 Smartphones
(2, 2, 2),  -- Pedido 2 contiene 2 Lavadoras
(3, 3, 10), -- Pedido 3 contiene 10 Muñecas Barbie
(4, 4, 20), -- Pedido 4 contiene 20 Camisetas
(5, 6, 10),
(5, 5, 10);  -- Pedido 5 contiene 10 Balones