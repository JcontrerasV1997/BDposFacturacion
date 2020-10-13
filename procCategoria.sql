create proc listar_categoria
as
select id_categoria as ID, nombre as Nombre, descripcion as Descripcion, estado as Estado
from MAEcategoria
order by id_categoria desc

--procedimiento buscar
create proc buscar_categoria
@valor varchar(50)
as
select id_categoria as ID, nombre as Nombre, descripcion as Descripcion, estado as Estado
from MAEcategoria
where nombre like '%' + @valor + '%' or descripcion like '%' + @valor + '%'  
order by id_categoria desc

--procedimiento insertar
create proc insertar_categoria
@nombre varchar(50),
@descripcion varchar(255)
as
insert into MAEcategoria(nombre,descripcion)
values (@nombre,@descripcion)
--actualizar
create proc actualizar_categoria
@id_categoria int,
@nombre varchar(50),
@descripcion varchar(255)
as
update MAEcategoria set nombre=@nombre,descripcion=@descripcion
where id_categoria=@id_categoria

--eliminar categoria
create proc eliminar_categoria
@idcategoria int
as
delete from MAEcategoria 
where  id_categoria=@idcategoria

--desactivar
create proc desactivar_categoria
@idcategoria int
as
update MAEcategoria set estado=0
where id_categoria=@idcategoria


create proc activar_categoria
@idcategoria int
as
update MAEcategoria set estado=1
where id_categoria=@idcategoria


create proc existe_categoria
@valor varchar(100),
@existe bit output
as
--si existe un campo nombre de la tabla categoria, donde el campo nombre tiene almacenado un valor.
--la funcion ltrim sirve rtrim sirve para limpiar espacios izquierda y derecha
if exists(select nombre from MAEcategoria where nombre=LTRIM(rtrim(@valor))) 
begin
set @existe=1
  end
else
   begin

set @existe=0
  end


  create proc categoria_seleccionar
  as
  select id_categoria, nombre from MAEcategoria
  where estado=1
  go