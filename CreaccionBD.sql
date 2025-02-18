CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    CONSTRAINT PK_ProductosCategorias PRIMARY KEY (IdCategoria, IdProducto),
    CONSTRAINT FK_ProductosCategorias_Categoria FOREIGN KEY (IdCategoria) 
        REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_ProductosCategorias_Producto FOREIGN KEY (IdProducto) 
        REFERENCES Productos(IdProducto)
);

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
    Cantidad INT,
    PRIMARY KEY (IdPedido, IdProducto),
	CONSTRAINT FK_PedidosProductos_Pedido FOREIGN KEY (IdPedido) REFERENCES Pedidos(IdPedido),
    CONSTRAINT FK_PedidosProductos_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) 
);

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
