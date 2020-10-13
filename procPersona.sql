--Procedimiento Listar
create proc persona_listar
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
order by id_persona desc
go

--Procedimiento Listar Proveedores      para optimizar la estructura de la base de datos              
create proc persona_listar_proveedores   -- se generaliza como persona a todos los clientes y proveedores
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
where tipo_persona='Proveedor'
order by id_persona desc
go

--Procedimiento Listar Clientes                
create proc persona_listar_clientes
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
where tipo_persona='Cliente'
order by id_persona desc
go

--Procedimiento Buscar
create proc persona_buscar
@valor varchar(50)
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
where nombre like '%' +@valor + '%' Or email like '%' +@valor + '%'
order by nombre asc
go

--Procedimiento Buscar Proveedores
create proc persona_buscar_proveedores
@valor varchar(50)
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
where (nombre like '%' +@valor + '%' Or email like '%' +@valor + '%')
and tipo_persona='Proveedor'
order by nombre asc
go

--Procedimiento Buscar Clientes
create proc persona_buscar_clientes
@valor varchar(50)
as
select id_persona as ID, tipo_persona as Tipo_Persona,nombre as Nombre,
tipo_documento as Tipo_Documento,num_documento as Num_Documento,
direccion as Direccion,telefono as Telefono,email as Email
from MAEpersonas
where (nombre like '%' +@valor + '%' Or email like '%' +@valor + '%')
and tipo_persona='Cliente'
order by nombre asc
go

--Procedimiento Insertar
create proc persona_insertar
@tipo_persona varchar(20),
@nombre varchar(100),
@tipo_documento varchar(20),
@num_documento varchar(20),
@direccion varchar(70),
@telefono varchar(20),
@email varchar(50)
as
insert into MAEpersonas (tipo_persona,nombre,tipo_documento,num_documento,direccion,telefono,email)
values (@tipo_persona,@nombre,@tipo_documento,@num_documento,@direccion,@telefono,@email)
go

--Procedimiento Actualizar
create proc persona_actualizar
@idpersona integer,
@tipo_persona varchar(20),
@nombre varchar(100),
@tipo_documento varchar(20),
@num_documento varchar(20),
@direccion varchar(70),
@telefono varchar(20),
@email varchar(50)
as
update MAEpersonas set tipo_persona=@tipo_persona,nombre=@nombre,
tipo_documento=@tipo_documento,num_documento=@num_documento,direccion=@direccion,
telefono=@telefono,email=@email
where id_persona=@idpersona
go

--Procedimiento Eliminar
create proc persona_eliminar
@idpersona integer
as
delete from MAEpersonas
where id_persona=@idpersona
go

--Procedimiento Existe
create proc persona_existe
@valor varchar(100),
@existe bit output
as
if exists (select nombre from MAEpersonas where nombre = ltrim(rtrim(@valor)))
	begin
		set @existe=1
	end
else
	begin
		set @existe=0
	end
go
