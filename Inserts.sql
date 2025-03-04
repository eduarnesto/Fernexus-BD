-- Insertar Categorías
INSERT INTO Categorias (Nombre) VALUES 
('Electrónica'),
('Hogar'),
('Deportes'),
('Ropa'),
('Juguetes');

-- Insertar Productos
INSERT INTO Productos (Nombre) VALUES 
('Smartphone Samsung Galaxy'),
('Laptop Dell XPS 15'),
('Aspiradora Dyson V10'),
('Bicicleta Montaña Trek'),
('Camiseta Nike Dri-Fit'),
('LEGO Star Wars Millennium Falcon');

-- Insertar Proveedores
INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais) VALUES 
('TechWorld', 'ventas@techworld.com', '+1-555-1234', '123 Tech St, San Francisco, USA', 'USA'),
('ElectroShop', 'contacto@electroshop.com', '+44-789-5555', '45 Oxford St, London, UK', 'UK'),
('HogarPerfecto', 'info@hogarperfecto.com', '+34-912-3456', 'Calle Mayor 12, Madrid, España', 'España'),
('DeportesPro', 'soporte@deportespro.com', '+49-172-6543', 'Bahnhofstr. 10, Berlín, Alemania', 'Alemania'),
('TiendaJuguetes', 'juguetes@tiendajuguetes.com', '+33-645-3333', 'Rue des Enfants, París, Francia', 'Francia');

-- Insertar ProductosCategorias (relacionando productos con categorías y stock)
INSERT INTO ProductosCategorias (IdCategoria, IdProducto, Stock, Precio) VALUES 
(1, 1, 50, 699.99),  -- Smartphone en Electrónica
(1, 2, 30, 1299.99), -- Laptop en Electrónica
(2, 3, 40, 399.99),  -- Aspiradora en Hogar
(3, 4, 20, 799.99),  -- Bicicleta en Deportes
(4, 5, 100, 29.99),  -- Camiseta en Ropa
(5, 6, 25, 159.99);  -- LEGO en Juguetes

-- Insertar ProveedoresProductos (asociando proveedores con productos y precios)
INSERT INTO ProveedoresProductos (IdProveedor, IdProducto, PrecioUnidad) VALUES 
(1, 1, 650.00),  -- TechWorld vende Smartphone
(1, 2, 1200.00), -- TechWorld vende Laptop
(2, 3, 370.00),  -- ElectroShop vende Aspiradora
(3, 4, 750.00),  -- HogarPerfecto vende Bicicleta
(4, 5, 25.00),   -- DeportesPro vende Camiseta
(5, 6, 150.00);  -- TiendaJuguetes vende LEGO

-- Insertar Pedidos (compras realizadas)
INSERT INTO Pedidos (FechaPedido, Coste, IdProveedor) VALUES 
('2024-02-15 10:30:00', 1300.00, 1),  -- Pedido de TechWorld
('2024-02-20 14:45:00', 750.00, 3),   -- Pedido de HogarPerfecto
('2024-02-25 09:20:00', 400.00, 2),   -- Pedido de ElectroShop
('2024-03-01 16:50:00', 200.00, 4),   -- Pedido de DeportesPro
('2024-03-05 12:10:00', 500.00, 5);   -- Pedido de TiendaJuguetes

-- Insertar PedidosProductos (productos en los pedidos)
INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES 
(1, 1, 2),  -- Pedido 1: 2 Smartphones
(1, 2, 1),  -- Pedido 1: 1 Laptop
(2, 4, 1),  -- Pedido 2: 1 Bicicleta
(3, 3, 1),  -- Pedido 3: 1 Aspiradora
(4, 5, 5),  -- Pedido 4: 5 Camisetas
(5, 6, 3);  -- Pedido 5: 3 sets de LEGO

