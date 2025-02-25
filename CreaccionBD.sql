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

CREATE TABLE ProductosCategorias (
    IdCategoria INT,
    IdProducto INT,
    CONSTRAINT PK_ProductosCategorias PRIMARY KEY (IdCategoria, IdProducto),
    CONSTRAINT FK_ProductosCategorias_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_ProductosCategorias_Producto FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);
GO


INSERT INTO Proveedores (Nombre, Correo, Telefono, Direccion, Pais) VALUES 
    ('Alimentos Naturales S.A.', 'contacto@alimentosnaturales.com', '555-314-6721', 'Avenida Verde 42, Barrio Ecologia, Ciudad Verde', 'Mexico'),
    ('TechnoMakers', 'info@technomakers.com', '555-987-2365', 'Calle Innovacion 98, Parque Tecnologico, Monterrey', 'Mexico'),
    ('Muebles del Sol', 'ventas@mueblesdelsol.com', '555-145-8320', 'Avenida los Robles 3, Zona Industrial, Guadalajara', 'Mexico'),
    ('Distribuidora Rapida', 'soporte@distribuidorarapida.com', '555-876-9034', 'Calle del Comercio 21, Sector 5, Ciudad Industrial', 'Colombia'),
    ('Jardines & Flores', 'ventas@jardinesyflores.com', '555-234-8765', 'Calle de las Flores 15, Parque Natural, Bogota', 'Colombia'),
    ('Electro Mundo', 'atencion@electromundo.com', '555-659-7452', 'Avenida Circuito 55, Poligono Electrico, Buenos Aires', 'Argentina'),
    ('Ladrillos Fenix', 'contacto@ladrillosfenix.com', '555-783-2154', 'Avenida Fenix 12, Zona de Construccion, Rosario', 'Argentina'),
    ('Rapido Transporte', 'contacto@rapidotransporte.com', '555-912-7843', 'Calle de los Transportistas 29, Zona Logistica, Lima', 'Peru'),
    ('Cafe Montana', 'info@cafemontana.com', '555-642-1384', 'Calle Bosques 7, Centro Agropecuario, Cusco', 'Peru'),
    ('Arte & Creatividad', 'contacto@arteycreatividad.com', '555-237-6541', 'Calle del Arte 15, Barrio de los Creadores, Santiago', 'Chile');

INSERT INTO Categorias (nombre) VALUES 
    ('Tecnologia'),
    ('Ropa y Accesorios'),
    ('Muebles'),
    ('Electrodomesticos'),
    ('Deportes y Aire Libre'),
    ('Hogar y Cocina'),
    ('Salud y Belleza'),
    ('Juguetes y Juegos'),
    ('Automoviles y Accesorios'),
    ('Oficina y Papeleria');


INSERT INTO Productos (Nombre) VALUES 
    ('Laptop Gaming'), -- Tecnologia
    ('Camiseta de Algodon'), -- Ropa y Accesorios
    ('Sofa Moderno'), -- Muebles
    ('Refrigerador'), -- Electrodomesticos
    ('Raqueta de Tenis'), -- Deportes y Aire Libre
    ('Olla de Cocina'), -- Hogar y Cocina
    ('Crema Hidratante'), -- Salud y Belleza
    ('Juego de Mesa'), -- Juguetes y Juegos
    ('Bicicleta'), -- Automoviles y Accesorios
    ('Impresora'); -- Oficina y Papeleria


INSERT INTO Pedidos (FechaPedido, Coste) VALUES 
    (GETDATE(), 0.00), -- Pedido inicial con coste 0
    (GETDATE(), 0.00), -- Otro pedido inicial
    (GETDATE(), 0.00); -- Otro pedido inicial


INSERT INTO ProductosCategorias (IdCategoria, IdProducto) VALUES 
    (1, 1), -- Laptop Gaming en Tecnologia
    (2, 2), -- Camiseta de Algodon en Ropa y Accesorios
    (3, 3), -- Sofa Moderno en Muebles
    (4, 4), -- Refrigerador en Electrodomesticos
    (5, 5), -- Raqueta de Tenis en Deportes y Aire Libre
    (6, 6), -- Olla de Cocina en Hogar y Cocina
    (7, 7), -- Crema Hidratante en Salud y Belleza
    (8, 8), -- Juego de Mesa en Juguetes y Juegos
    (9, 9), -- Bicicleta en Automoviles y Accesorios
    (10, 10); -- Impresora en Oficina y Papeleria


INSERT INTO PedidosProductos (IdPedido, IdProducto, Cantidad) VALUES 
    (1, 1, 1), -- 1 Laptop Gaming en el pedido 1
    (1, 2, 2), -- 2 Camisetas de Algodon en el pedido 1
    (2, 3, 1), -- 1 Sofa Moderno en el pedido 2
    (2, 4, 1); -- 1 Refrigerador en el pedido 2


CREATE OR ALTER PROCEDURE filtrarPedidosPorProducto
    @idProducto INT
AS
BEGIN
    SELECT * 
    FROM Pedidos P
    INNER JOIN PedidosProductos PP ON PP.IdPedido = P.IdPedido
    WHERE PP.IdProducto = @idProducto;
END;


CREATE OR ALTER PROCEDURE filtrarPedidosPorFechas
    @fechaInicio DATETIME,
    @fechaFin DATETIME
AS
BEGIN
    SELECT *
    FROM Pedidos
    WHERE FechaPedido BETWEEN @fechaInicio AND @fechaFin;
END;


CREATE OR ALTER PROCEDURE filtrarProductosPorCategoria
    @idCategoria INT
AS
BEGIN
    SELECT p.*
    FROM Productos p
    INNER JOIN ProductosCategorias pc ON p.IdProducto = pc.IdProducto
    WHERE pc.IdCategoria = @idCategoria;
END;


CREATE PROCEDURE filtrarProveedoresPorPais
    @Pais NVARCHAR(100)  
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * 
    FROM Proveedores
    WHERE Pais = @Pais;
END;


CREATE OR ALTER PROCEDURE filtrarPedidosConDatosDelProducto
    @IdPedido INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.IdPedido,
        p.FechaPedido,
        p.Coste,
        pr.IdProducto,
        pr.Nombre AS NombreProducto,
        pp.Cantidad
    FROM Pedidos p
    LEFT JOIN PedidosProductos pp ON p.IdPedido = pp.IdPedido
    LEFT JOIN Productos pr ON pp.IdProducto = pr.IdProducto
    WHERE p.IdPedido = @IdPedido;
END;


<<<<<<< Updated upstream
<<<<<<< Updated upstream
CREATE OR ALTER PROCEDURE obtenerProveedorPorId
    @IdProveedor INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM Proveedores
    WHERE IdProveedor = @IdProveedor;
END;



=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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


CREATE OR ALTER TRIGGER trg_AfterInsert_AfterUpdate_Pedidos
ON Pedidos
AFTER INSERT, UPDATE
AS
BEGIN
    -- Si se intenta insertar o actualizar manualmente 'Coste', se bloquea
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN deleted d ON i.IdPedido = d.IdPedido -- Para UPDATE
        WHERE i.Coste <> d.Coste OR i.Coste IS NOT NULL
    )
    BEGIN
        RAISERROR ('No puedes insertar ni modificar el campo Coste manualmente.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

