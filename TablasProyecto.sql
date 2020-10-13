
--tabla categoria
CREATE TABLE MAEcategoria(
id_categoria integer primary key identity,
nombre varchar(50) not null unique,
descripcion varchar(255) null,
estado bit default(1) -- por defecto cuando no se envie ningun valor almacena 1
)

--Tabla articulo
create table MAEarticulo(
id_articulo integer primary key identity,
id_categoria integer not null,
codigo varchar(50)null,
nombre varchar(100) not null unique,
precio_venta decimal(11,2) not null,
stock integer not null,
descripcion varchar(255) null,
imagen varchar(20) null,
estado bit default(1),
FOREIGN KEY (id_categoria) references MAEcategoria(id_categoria)
)

--tabla personas
create table MAEpersonas(
id_persona integer primary key identity,
tipo_persona varchar(20) not null,
nombre varchar(100)not null,
tipo_documento varchar(20) null,
num_documento varchar(20) null,
direccion varchar(70) null,
telefono varchar(255) null,
email varchar(50) null

)

--tabla rol
create table Rol(
id_rol integer primary key identity,
nombre varchar(30) not null,
descripcion varchar(255) null,
estado bit default(1)
)

--tabla usuarios
create table Usuario(
id_usuario integer primary key identity,
id_rol integer not null,
nombre varchar(100) not null,
tipo_documento varchar(20) null,
num_documento varchar (20) null,
direccion varchar(70) null,
telefono varchar(20) null,
email varchar(50)not null,
clave varbinary(MAX) not null, --se deja varbinari porque no se sabe cual es el hash, para almacenar cantidad grande de caracteres
estado bit default(1),

FOREIGN KEY(id_rol) references Rol(id_rol)
)


--Tabla ingreso
create table Ingreso(
	idingreso integer primary key identity,
	idproveedor integer not null,
	idusuario integer not null,
	tipo_comprobante varchar(20) not null,
	serie_comprobante varchar(7) null,
	num_comprobante varchar (10) not null,
	fecha datetime not null,
	impuesto decimal (4,2) not null,
	total decimal (11,2) not null,
	estado varchar(20) not null,
	FOREIGN KEY (idproveedor) REFERENCES MAEpersonas (id_persona),
	FOREIGN KEY (idusuario) REFERENCES usuario (id_usuario)
);
go

--Tabla detalle_ingreso
create table Detalle_ingreso (
	iddetalle_ingreso integer primary key identity,
	idingreso integer not null,
	idarticulo integer not null,
	cantidad integer not null,
	precio decimal(11,2) not null,
	FOREIGN KEY (idingreso) REFERENCES ingreso (idingreso) ON DELETE CASCADE,
	FOREIGN KEY (idarticulo) REFERENCES MAEarticulo (id_articulo)
);
go

--Tabla venta
create table Venta(
	idventa integer primary key identity,
	idcliente integer not null,
	idusuario integer not null,
	tipo_comprobante varchar(20) not null,
	serie_comprobante varchar(7) null,
	num_comprobante varchar (10) not null,
	fecha datetime not null,
	impuesto decimal (4,2) not null,
	total decimal (11,2) not null,
	estado varchar(20) not null,
	FOREIGN KEY (idcliente) REFERENCES MAEpersonaS (id_persona),
	FOREIGN KEY (idusuario) REFERENCES usuario (id_usuario)
);
go


--Tabla detalle_venta
create table detalle_venta (
	iddetalle_venta integer primary key identity,
	idventa integer not null,
	idarticulo integer not null,
	cantidad integer not null,
	precio decimal(11,2) not null,
	descuento decimal(11,2) not null,
	FOREIGN KEY (idventa) REFERENCES Venta (idventa) ON DELETE CASCADE,
	FOREIGN KEY (idarticulo) REFERENCES MAEarticulo (id_articulo)
);
go


use SOFT_FACTURACION 
-- Primero desabilitar la integridad referencial
 EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
 GO
EXEC sp_MSforeachtable @command1 = "DROP TABLE ?"
-- Ahora volver a habilitar la integridad referencial
 EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
 GO 