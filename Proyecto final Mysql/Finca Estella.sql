CREATE DATABASE FincaEstella;
 USE FincaEstella;
 
 CREATE TABLE Empresas (
 	id_empresa INT AUTO_INCREMENT primary key,
 	nombre_empresa VARCHAR(100) NOT NULL,
 	telefono VARCHAR(15)
 
 );
 
 CREATE TABLE Productos(
 	id_producto INT AUTO_INCREMENT PRIMARY KEY,
 	nombre_producto VARCHAR(100) NOT NULL,
 	precio DECIMAL(10, 2) NOT NULL
 );
 
 CREATE TABLE Ventas (
     id_venta INT AUTO_INCREMENT PRIMARY KEY,
     id_producto INT NOT NULL,
     id_empresa INT NOT NULL,
     cantidad INT NOT NULL,
     fecha DATE NOT NULL,
     FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
     FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
 );
 
 
 -- Inserción de datos de prueba
 INSERT INTO Empresas (nombre_empresa, telefono) VALUES
 ('Distribuidora Alma Flor', '2944112233'),
 ('Almacen corralito', '2944223344'),
 ('Supermercado El Todo', '2944334455'),
 ('Bodega El Primo', '2944556677'),
 ('Mercado Libre', '2944778899'),
 ('Feria Pioneros', '2944889910'),
 ('Almacen de Marce', '2944991011'),
 ('La Esquina Gourmet', '2944101112'),
 ('Comercio elemental', '2944111213'),
 ('Tiritas Axe', '2944121314');
 
 INSERT INTO Productos (nombre_producto, precio) VALUES
 ('Vino Malbec', 1500),
 ('Aceite de Oliva', 2300),
 ('Queso Artesanal', 1800),
 ('Harina Integral', 950),
 ('Yerba Mate', 1200),
 ('Dulce de Leche', 1100),
 ('Miel', 1400),
 ('Café Molido', 2500),
 ('Té Verde', 800),
 ('Almendras', 3000);
 
 INSERT INTO Ventas (id_producto, id_empresa, cantidad, fecha) VALUES
 (1, 1, 50, '2024-01-01'),
 (2, 2, 30, '2024-01-05'),
 (3, 3, 20, '2024-02-10'),
 (4, 4, 15, '2024-01-12'),
 (5, 5, 40, '2024-02-15'),
 (6, 6, 35, '2024-02-18'),
 (7, 7, 25, '2024-03-20'),
 (8, 8, 45, '2024-02-22'),
 (9, 9, 55, '2024-02-24'),
 (10, 10, 60, '2024-03-26');
 
 
 -- VISTAS -- 
 -- vista/view para ver el total de ventas por empresa
 
 CREATE VIEW Vista_Ventas_Empresas AS
 SELECT e.nombre_empresa, p.nombre_producto, SUM(v.cantidad) AS total_vendido
 FROM Ventas v
 JOIN Empresas e ON v.id_empresa = e.id_empresa
 JOIN Productos p ON v.id_producto = p.id_producto
 GROUP BY e.nombre_empresa, p.nombre_producto;
 
 --  vistas/views para análisis de ventas
 CREATE VIEW Vista_Total_Ventas AS
 SELECT SUM(cantidad) AS total_general FROM Ventas;
 
 CREATE VIEW Vista_Productos_Mas_Vendidos AS
 SELECT p.nombre_producto, SUM(v.cantidad) AS total_vendido
 FROM Ventas v
 JOIN Productos p ON v.id_producto = p.id_producto
 GROUP BY p.nombre_producto
 ORDER BY total_vendido DESC;
 
 CREATE VIEW Vista_Empresas_Clientes AS
 SELECT e.nombre_empresa, COUNT(v.id_venta) AS total_compras
 FROM Ventas v
 JOIN Empresas e ON v.id_empresa = e.id_empresa
 GROUP BY e.nombre_empresa
 ORDER BY total_compras DESC;
 
 CREATE VIEW Vista_Productos_Caros AS
 SELECT nombre_producto, precio FROM Productos ORDER BY precio DESC LIMIT 5;
 
 CREATE VIEW Vista_Productos_Baratos AS
 SELECT nombre_producto, precio FROM Productos ORDER BY precio ASC LIMIT 5;
 
 CREATE VIEW Vista_Ventas_Recientes AS
 SELECT * FROM Ventas ORDER BY fecha DESC LIMIT 10;
 
 CREATE VIEW Vista_Ventas_Mensuales AS
 SELECT MONTH(fecha) AS mes, SUM(cantidad) AS total_vendido FROM Ventas GROUP BY mes;
 
 CREATE VIEW Vista_Empresas_Sin_Compras AS
 SELECT e.nombre_empresa FROM Empresas e LEFT JOIN Ventas v ON e.id_empresa = v.id_empresa WHERE v.id_venta IS NULL;
 
 
 -- FUNCIONES --
 -- Función para obtener el total de ventas de un producto
 DELIMITER $$
 CREATE FUNCTION TotalVentasProducto(producto_id INT) RETURNS INT DETERMINISTIC
 BEGIN
     DECLARE total INT;
     SELECT SUM(cantidad) INTO total FROM Ventas WHERE id_producto = producto_id;
     RETURN COALESCE(total, 0);
 END $$
 DELIMITER ;
 
DELIMITER $$
CREATE FUNCTION TotalVentasEmpresa(empresa_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(cantidad) INTO total FROM Ventas WHERE id_empresa = empresa_id;
    RETURN COALESCE(total, 0);
END $$
DELIMITER ;
 
 
 -- STORED PROCEDURES --
 -- Stored Procedure para registrar una venta
 DELIMITER $$
 CREATE PROCEDURE RegistrarVenta(IN prod_id INT, IN emp_id INT, IN cant INT, IN fecha_venta DATE)
 BEGIN
     INSERT INTO Ventas (id_producto, id_empresa, cantidad, fecha)
     VALUES (prod_id, emp_id, cant, fecha_venta);
 END $$
 DELIMITER ;
 
DELIMITER $$
CREATE PROCEDURE ModificarPrecioProducto(IN prod_id INT, IN nuevo_precio DECIMAL(10,2))
BEGIN
    UPDATE Productos SET precio = nuevo_precio WHERE id_producto = prod_id;
END $$
DELIMITER ;
 
 -- Trigger para evitar ventas con cantidad negativa
 DELIMITER $$
 CREATE TRIGGER PreventNegativeSales BEFORE INSERT ON Ventas
 FOR EACH ROW
 BEGIN
     IF NEW.cantidad <= 0 THEN
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'La cantidad de venta debe ser mayor a cero';
     END IF;
 END $$
 DELIMITER ;
 
DESC Ventas;
 
 