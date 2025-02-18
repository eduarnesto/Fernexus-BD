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
    ('Alimentos Naturales S.A.', 'contacto@alimentosnaturales.com', '555-314-6721', 'Avenida Verde 42, Barrio Ecolog�a, Ciudad Verde', 'M�xico'),
    ('TechnoMakers', 'info@technomakers.com', '555-987-2365', 'Calle Innovaci�n 98, Parque Tecnol�gico, Monterrey', 'M�xico'),
    ('Muebles del Sol', 'ventas@mueblesdelsol.com', '555-145-8320', 'Avenida los Robles 3, Zona Industrial, Guadalajara', 'M�xico'),
    ('Distribuidora R�pida', 'soporte@distribuidorarapida.com', '555-876-9034', 'Calle del Comercio 21, Sector 5, Ciudad Industrial', 'Colombia'),
    ('Jardines & Flores', 'ventas@jardinesyflores.com', '555-234-8765', 'Calle de las Flores 15, Parque Natural, Bogot�', 'Colombia'),
    ('Electro Mundo', 'atencion@electromundo.com', '555-659-7452', 'Avenida Circuito 55, Pol�gono El�ctrico, Buenos Aires', 'Argentina'),
    ('Ladrillos Fenix', 'contacto@ladrillosfenix.com', '555-783-2154', 'Avenida F�nix 12, Zona de Construcci�n, Rosario', 'Argentina'),
    ('R�pido Transporte', 'contacto@rapidotransporte.com', '555-912-7843', 'Calle de los Transportistas 29, Zona Log�stica, Lima', 'Per�'),
    ('Caf� Monta�a', 'info@cafemontana.com', '555-642-1384', 'Calle Bosques 7, Centro Agropecuario, Cusco', 'Per�'),
    ('Arte & Creatividad', 'contacto@arteycreatividad.com', '555-237-6541', 'Calle del Arte 15, Barrio de los Creadores, Santiago', 'Chile');


INSERT INTO Categorias (nombre)
VALUES 
    ('Tecnolog�a'),
    ('Ropa y Accesorios'),
    ('Muebles'),
    ('Electrodom�sticos'),
    ('Deportes y Aire Libre'),
    ('Hogar y Cocina'),
    ('Salud y Belleza'),
    ('Juguetes y Juegos'),
    ('Autom�viles y Accesorios'),
    ('Oficina y Papeler�a');


INSERT INTO Productos (Nombre, Precio, IdCategoria)
VALUES 
    ('Camiseta Deportiva', 25.99, 2), -- Ropa y Accesorios
    ('Auriculares Inal�mbricos', 45.50, 1), -- Tecnolog�a
    ('Silla Ergonomica', 89.99, 3), -- Muebles
    ('Laptop Gaming', 1200.00, 1), -- Tecnolog�a
    ('Cafetera Express', 150.75, 6), -- Hogar y Cocina
    ('Televisor LED 55"', 799.99, 1), -- Tecnolog�a
    ('Refrigerador Inteligente', 1200.50, 6), -- Hogar y Cocina
    ('Monitor Curvo 27"', 350.40, 1), -- Tecnolog�a
    ('Reloj Inteligente', 120.99, 1), -- Tecnolog�a
    ('C�mara de Seguridad WiFi', 95.90, 1), -- Tecnolog�a
    ('Zapatos Running', 65.45, 2), -- Ropa y Accesorios
    ('Tablet 10"', 299.99, 1), -- Tecnolog�a
    ('Mochila Antirrobo', 45.00, 2), -- Ropa y Accesorios
    ('Microondas Digital', 175.00, 6), -- Hogar y Cocina
    ('Lentes de Sol Polarizados', 39.90, 2), -- Ropa y Accesorios
    ('Silla de Oficina', 110.75, 3), -- Muebles
    ('Bocina Bluetooth', 55.60, 1), -- Tecnolog�a
    ('Ropa de Cama 3 Piezas', 75.99, 6), -- Hogar y Cocina
    ('Cargador Solar', 25.99, 1), -- Tecnolog�a
    ('Proyector Port�til', 210.50, 1); -- Tecnolog�a


--exec productosPorPedido