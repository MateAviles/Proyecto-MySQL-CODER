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