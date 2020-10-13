--Procedimiento Listar
create proc articulo_listar  --se representa el orden que se quiere listar, en este caso 
as                          --los id son de primero, porque estaran en inputs ocultos, luego nombre de la categoria
select a.id_articulo as ID,a.id_categoria,c.nombre as Categoria,
a.codigo as Codigo,a.nombre as Nombre,a.precio_venta as Precio_Venta,
a.stock as Stock,a.descripcion as Descripcion,a.imagen as Imagen,
a.estado as Estado
from MAEarticulo a inner join MAEcategoria c on a.id_categoria=c.id_categoria
order by a.id_articulo desc
go

--Procedimiento Buscar
create proc articulo_buscar
@valor varchar(50)
as
select a.id_articulo as ID,a.id_categoria,c.nombre as Categoria,
a.codigo as Codigo,a.nombre as Nombre,a.precio_venta as Precio_Venta,
a.stock as Stock,a.descripcion as Descripcion,a.imagen as Imagen,
a.estado as Estado
from MAEarticulo a inner join MAEcategoria c on a.id_categoria=c.id_categoria
where a.nombre like '%' +@valor + '%' Or a.descripcion like '%' +@valor + '%'
order by a.nombre asc
go
--Procedimiento Insertar
create proc articulo_insertar
@idcategoria integer,
@codigo varchar(50),
@nombre varchar(100),
@precio_venta decimal(11,2),
@stock integer,
@descripcion varchar(255),
@imagen varchar(20)
as
insert into MAEarticulo (id_categoria,codigo,nombre,precio_venta,stock,descripcion,imagen)
values (@idcategoria,@codigo,@nombre,@precio_venta,@stock,@descripcion,@imagen)
go

--Procedimiento Actualizar
create proc articulo_actualizar
@idarticulo integer,
@idcategoria integer,
@codigo varchar(50),
@nombre varchar(50),
@precio_venta decimal(11,2),
@stock integer,
@descripcion varchar(255),
@imagen varchar(20)
as
update MAEarticulo set id_categoria=@idcategoria,codigo=@codigo,
nombre=@nombre,precio_venta=@precio_venta,stock=@stock,
descripcion=@descripcion,imagen=@imagen
where id_articulo=@idarticulo
go

--Procedimiento Eliminar
create proc articulo_eliminar
@idarticulo integer
as
delete from MAEarticulo
where id_articulo=@idarticulo
go

--Procedimiento Desactivar
create proc articulo_desactivar
@idarticulo integer
as
update MAEarticulo set estado=0
where id_articulo=@idarticulo
go

--Procedimiento Activar
create proc articulo_activar
@idarticulo integer
as
update MAEarticulo set estado=1
where id_articulo=@idarticulo
go
-- Procedimiento existe
create proc articulo_existe
@valor varchar(100),
@existe bit output
as
if exists (select nombre from MAEarticulo where nombre = ltrim(rtrim(@valor)))
	begin
		set @existe=1
	end
else
	begin
		set @existe=0
	end
go

use SOFT_FACTURACION
go

exec articulo_listar
go

create proc articulo_buscar_codigo
@valor varchar(50)
as
select id_articulo,codigo,nombre,precio_venta,stock from MAEarticulo
where codigo=@valor
go


create proc articulo_buscar_codigo_venta
@valor varchar(50)
as
select id_articulo,codigo,nombre,precio_venta,stock
from MAEarticulo
where codigo=@valor and stock>0
go

create proc articulo_buscar_venta
@valor varchar(50)
as
select a.id_articulo as ID,a.id_categoria,c.nombre as Categoria,
a.codigo as Codigo,a.nombre as Nombre,a.precio_venta as Precio_Venta,
a.stock as Stock,a.descripcion as Descripcion,a.imagen as Imagen,
a.estado as Estado
from MAEarticulo a inner join MAEcategoria c on a.id_categoria=c.id_categoria
where (a.nombre like '%' +@valor + '%' Or a.descripcion like '%' +@valor + '%')
and a.stock>0
order by a.nombre asc
