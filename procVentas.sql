create proc venta_listar
as
select v.idventa as ID,v.idusuario,u.nombre as Usuario,p.nombre as Cliente,
v.tipo_comprobante as Tipo_Comprobante,v.serie_comprobante as Serie,
v.num_comprobante as Numero,v.fecha as Fecha,v.impuesto as Impuesto,
v.total as Total,v.estado as Estado
from venta v inner join usuario u on v.idusuario=u.id_usuario
inner join MAEpersonas p on v.idcliente=p.id_persona
Order by v.idventa desc
go

create proc venta_buscar
@valor varchar(50)
as
select v.idventa as ID,v.idusuario,u.nombre as Usuario,p.nombre as Cliente,
v.tipo_comprobante as Tipo_Comprobante,v.serie_comprobante as Serie,
v.num_comprobante as Numero,v.fecha as Fecha,v.impuesto as Impuesto,
v.total as Total,v.estado as Estado
from venta v inner join usuario u on v.idusuario=u.id_usuario
inner join MAEpersonas p on v.idcliente=p.id_persona
where v.num_comprobante like '%' + @valor + '%' Or p.nombre like '%' + @valor + '%'
Order by v.fecha asc
go

create proc venta_anular
@idventa int
as
update venta set estado='Anulado'
where idventa=@idventa
go


--Proc para insertar
create TYPE type_detalle_venta as table
(
	idarticulo int,	
	codigo varchar(50),
	articulo varchar(100),
	stock int,
	cantidad int,
	precio decimal(11,2),
	descuento decimal(11,2),
	importe decimal(11,2) 
);
go

create proc venta_insertar
@idusuario int,
@idcliente int,
@tipo_comprobante varchar(20),
@serie_comprobante varchar(7),
@num_comprobante varchar(10),
@impuesto decimal(4,2),
@total decimal(11,2),
@detalle type_detalle_venta READONLY
as
begin
	insert into venta (idusuario,idcliente,tipo_comprobante,serie_comprobante,
	num_comprobante,fecha,impuesto,total,estado)
	values (@idusuario,@idcliente,@tipo_comprobante,@serie_comprobante,
	@num_comprobante,getdate(),@impuesto,@total,'Aceptado');
	
	insert detalle_venta (idventa,idarticulo,cantidad,precio,descuento)
	select @@IDENTITY,d.idarticulo,d.cantidad,d.precio,d.descuento
	from @detalle d;
end




create proc venta_listar_detalle
@idventa int
as
select d.idarticulo as ID,a.codigo as CODIGO, a.nombre as ARTICULO,
d.cantidad as CANTIDAD,d.precio as PRECIO,d.descuento as DESCUENTO,
((d.cantidad*d.precio)-d.descuento) as IMPORTE
from detalle_venta d inner join MAEarticulo a on d.idarticulo=a.id_articulo
where d.idventa=@idventa
go


create proc venta_comprobante
@idventa int
as
select p.nombre as Cliente,p.direccion,p.telefono,p.email,
u.nombre as Usuario,v.tipo_comprobante,v.serie_comprobante,v.num_comprobante,
v.fecha,v.impuesto,v.total,
a.nombre as Articulo,d.cantidad,d.precio,d.descuento,
((d.cantidad*d.precio)-d.descuento)as Importe
from Venta v inner join MAEpersonas p on v.idcliente=p.id_persona
inner join Usuario u on v.idusuario=u.id_usuario
inner join detalle_venta d on v.idventa=d.idventa
inner join MAEarticulo a on d.idarticulo=a.id_articulo
where v.idventa=@idventa

create proc venta_consulta_fechas
@fecha_inicio date,
@fecha_fin date
as
select v.idventa as ID,v.idusuario,u.nombre as Usuario,p.nombre as Cliente,
v.tipo_comprobante as Tipo_Comprobante,v.serie_comprobante as Serie,
v.num_comprobante as Numero,v.fecha as Fecha,v.impuesto as Impuesto,
v.total as Total,v.estado as Estado
from venta v inner join usuario u on v.idusuario=u.id_usuario
inner join MAEpersonas p on v.idcliente=p.id_persona
where v.fecha>=@fecha_inicio and v.fecha<=@fecha_fin
Order by v.idventa desc















