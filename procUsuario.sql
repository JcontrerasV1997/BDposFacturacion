
--Procedimiento Listar
create proc usuario_listar
as
select u.id_usuario as ID,u.id_rol, r.nombre as Rol,u.nombre as Nombre,
u.tipo_documento as Tipo_Documento,u.num_documento as Num_Documento,
u.direccion as Direccion,u.telefono as Telefono,u.email as Email,
u.estado as Estado
 from Usuario u inner join Rol r on u.id_rol=r.id_rol
 order by u.id_usuario desc
 go

--Procedimiento Buscar
create proc usuario_buscar
@valor varchar(50)
as
select u.id_usuario as ID,u.id_rol, r.nombre as Rol,u.nombre as Nombre,
u.tipo_documento as Tipo_Documento,u.num_documento as Num_Documento,
u.direccion as Direccion,u.telefono as Telefono,u.email as Email,
u.estado as Estado
 from Usuario u inner join Rol r on u.id_rol=r.id_rol
 where u.nombre like '%' +@valor + '%' Or u.email like '%' +@valor + '%'
 order by u.nombre asc
 go

--Procedimiento Insertar
create proc usuario_insertar
@idrol integer,
@nombre varchar(100),
@tipo_documento varchar(20),
@num_documento varchar(20),
@direccion varchar(70),
@telefono varchar(20),
@email varchar(50),
@clave varchar(50)
as
insert into usuario (id_rol,nombre,tipo_documento,num_documento,direccion,telefono,email,clave)
values (@idrol,@nombre,@tipo_documento,@num_documento,@direccion,@telefono,@email,HASHBYTES('SHA2_256',@clave)) --la clave la encripto mediante el algoritmo sha2_256
                                                                                                               -- el metodo hashbyte recibe dos parametros
go

--Procedimiento Actualizar
create proc usuario_actualizar
@idusuario integer,
@idrol integer,
@nombre varchar(100),
@tipo_documento varchar(20),
@num_documento varchar(20),
@direccion varchar(70),
@telefono varchar(20),
@email varchar(50),
@clave varchar(50)
as
if @clave<>'' --condicional si la clave es vacia entonces
update Usuario set id_rol=@idrol,nombre=@nombre,tipo_documento=@tipo_documento, --actualizame los campos y asigno los parametros como argumentos a recibir 
num_documento=@num_documento,direccion=@direccion,telefono=@telefono,
email=@email,clave=HASHBYTES('SHA2_256', @clave)
where id_usuario=@idusuario;
else
update Usuario set id_rol=@idrol,nombre=@nombre,tipo_documento=@tipo_documento,
num_documento=@num_documento,direccion=@direccion,telefono=@telefono,
email=@email
where id_usuario=@idusuario;
go

--Procedimiento Eliminar
create proc usuario_eliminar
@idusuario integer
as
delete from usuario
where id_usuario=@idusuario
go

--Procedimiento Desactivar
create proc usuario_desactivar
@idusuario integer
as
update usuario set estado=0
where id_usuario=@idusuario
go

--Procedimiento Activar
create proc usuario_activar
@idusuario integer
as
update usuario set estado=1
where id_usuario=@idusuario
go
-- Procedimiento existe
create proc usuario_existe
@valor varchar(100),
@existe bit output
as
	if exists (select email from usuario where email = ltrim(rtrim(@valor)))
		begin
		 set @existe=1
		end
	else
		begin
		 set @existe=0
		end

		--procedimiento login
		create proc usuario_loguin
		@email varchar(50),
		@clave varchar(50)
		as
		select u.id_usuario,u.id_rol,r.nombre as Rol, u.nombre,u.estado
		from Usuario u inner join Rol r on u.id_rol=r.id_rol
		where u.email=@email and u.clave=HASHBYTES('SHA2_256',@clave)