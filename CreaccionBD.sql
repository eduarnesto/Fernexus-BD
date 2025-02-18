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
    @idPedido NVARCHAR(255)  -- Correct syntax for parameter type
AS
BEGIN
    SELECT * 
    FROM Productos P
    INNER JOIN PedidosProductos PP ON PP.IdProducto = P.IdProducto
    WHERE PP.IdPedido = @idPedido;
END;

INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais)
VALUES 
    ('Alimentos Naturales S.A.', 'contacto@alimentosnaturales.com', '555-314-6721', 'Avenida Verde 42, Barrio Ecología, Ciudad Verde', 'México'),
    ('TechnoMakers', 'info@technomakers.com', '555-987-2365', 'Calle Innovación 98, Parque Tecnológico, Monterrey', 'México'),
    ('Muebles del Sol', 'ventas@mueblesdelsol.com', '555-145-8320', 'Avenida los Robles 3, Zona Industrial, Guadalajara', 'México'),
    ('Distribuidora Rápida', 'soporte@distribuidorarapida.com', '555-876-9034', 'Calle del Comercio 21, Sector 5, Ciudad Industrial', 'Colombia'),
    ('Jardines & Flores', 'ventas@jardinesyflores.com', '555-234-8765', 'Calle de las Flores 15, Parque Natural, Bogotá', 'Colombia'),
    ('Electro Mundo', 'atencion@electromundo.com', '555-659-7452', 'Avenida Circuito 55, Polígono Eléctrico, Buenos Aires', 'Argentina'),
    ('Ladrillos Fenix', 'contacto@ladrillosfenix.com', '555-783-2154', 'Avenida Fénix 12, Zona de Construcción, Rosario', 'Argentina'),
    ('Rápido Transporte', 'contacto@rapidotransporte.com', '555-912-7843', 'Calle de los Transportistas 29, Zona Logística, Lima', 'Perú'),
    ('Café Montaña', 'info@cafemontana.com', '555-642-1384', 'Calle Bosques 7, Centro Agropecuario, Cusco', 'Perú'),
    ('Arte & Creatividad', 'contacto@arteycreatividad.com', '555-237-6541', 'Calle del Arte 15, Barrio de los Creadores, Santiago', 'Chile');


INSERT INTO Categorias (nombre)
VALUES 
    ('Tecnología'),
    ('Ropa y Accesorios'),
    ('Muebles'),
    ('Electrodomésticos'),
    ('Deportes y Aire Libre'),
    ('Hogar y Cocina'),
    ('Salud y Belleza'),
    ('Juguetes y Juegos'),
    ('Automóviles y Accesorios'),
    ('Oficina y Papelería');


INSERT INTO Productos (Nombre, Precio, IdCategoria)
VALUES 
    ('Camiseta Deportiva', 25.99, 2), -- Ropa y Accesorios
    ('Auriculares Inalámbricos', 45.50, 1), -- Tecnología
    ('Silla Ergonomica', 89.99, 3), -- Muebles
    ('Laptop Gaming', 1200.00, 1), -- Tecnología
    ('Cafetera Express', 150.75, 6), -- Hogar y Cocina
    ('Televisor LED 55"', 799.99, 1), -- Tecnología
    ('Refrigerador Inteligente', 1200.50, 6), -- Hogar y Cocina
    ('Monitor Curvo 27"', 350.40, 1), -- Tecnología
    ('Reloj Inteligente', 120.99, 1), -- Tecnología
    ('Cámara de Seguridad WiFi', 95.90, 1), -- Tecnología
    ('Zapatos Running', 65.45, 2), -- Ropa y Accesorios
    ('Tablet 10"', 299.99, 1), -- Tecnología
    ('Mochila Antirrobo', 45.00, 2), -- Ropa y Accesorios
    ('Microondas Digital', 175.00, 6), -- Hogar y Cocina
    ('Lentes de Sol Polarizados', 39.90, 2), -- Ropa y Accesorios
    ('Silla de Oficina', 110.75, 3), -- Muebles
    ('Bocina Bluetooth', 55.60, 1), -- Tecnología
    ('Ropa de Cama 3 Piezas', 75.99, 6), -- Hogar y Cocina
    ('Cargador Solar', 25.99, 1), -- Tecnología
    ('Proyector Portátil', 210.50, 1); -- Tecnología


--exec productosPorPedido