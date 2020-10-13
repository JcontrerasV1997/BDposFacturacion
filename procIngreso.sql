--Procedimiento listar
create proc ingreso_listar
as
select i.idingreso as ID, i.idusuario,u.nombre as Usuario,p.nombre as Proveedor, --Concaten
i.tipo_comprobante as Tipo_Comprobante,i.serie_comprobante as Serie,
i.num_comprobante as Numero,i.fecha as Fecha,i.impuesto as Impuesto,
i.total as Total,i.estado as Estado
from Ingreso i inner join Usuario u on i.idusuario=u.id_usuario
inner join MAEpersonas p on i.idproveedor=p.id_persona
order by i.idingreso desc
go

--Procedimiento buscar
create proc ingreso_buscar
@valor varchar(50)
as
select i.idingreso as ID, i.idusuario,u.nombre as Usuario,p.nombre as Proveedor,
i.tipo_comprobante as Tipo_Comprobante,i.serie_comprobante as Serie,
i.num_comprobante as Numero,i.fecha as Fecha,i.impuesto as Impuesto,
i.total as Total,i.estado as Estado

from Ingreso i inner join Usuario u on i.idusuario=u.id_usuario
inner join MAEpersonas p on i.idproveedor=p.id_persona
where i.num_comprobante like '%' +@valor + '%' Or p.nombre like '%' +@valor + '%'  --SIEMPRE EL WHERE BUSCARA EN LA TABLA QUE SE TRABAJA 
order by i.fecha asc
go

--Procedimiento anular
create proc ingreso_anular
@idingreso int
as
update ingreso set estado='Anulado'
where idingreso=@idingreso
go

create type types_detalle_ingreso as table --aqui creo lo que se denomina un type o tipo y lo referencio a una tabla
(                                             --quiere decir que estoy haciendo una tabla dentro de un type
	idarticulo int,
	codigo varchar(50),
	articulo varchar(100),
	cantidad int,
	precio decimal(11,2),
	importe decimal(11,2)
);
go

--Procedimiento insertar
create proc ingreso_insertar
@idusuario int,
@idproveedor int,
@tipo_comprobante varchar(20),
@serie_comprobante varchar(7),
@num_comprobante varchar(10),
@impuesto decimal(4,2),
@total decimal(11,2),
@detalle types_detalle_ingreso READONLY
as
begin
	--Insertamos en la cabecera
	insert into ingreso (idproveedor,idusuario,tipo_comprobante,serie_comprobante,
	num_comprobante,fecha,impuesto,total,estado)
	values(@idproveedor,@idusuario,@tipo_comprobante,@serie_comprobante,
	@num_comprobante,getdate(),@impuesto,@total,'Aceptado');
	--Insertar los detalles
	insert detalle_ingreso (idingreso,idarticulo,cantidad,precio)
	select @@IDENTITY,d.idarticulo,d.cantidad,d.precio
	from @detalle d;
end
go

create proc ingreso_listar_detalle
@idingreso int
as
select d.idarticulo as ID,a.codigo as CODIGO,a.nombre as ARTICULO,
d.cantidad as CANTIDAD,d.precio as PRECIO,(d.precio*d.cantidad) as IMPORTE
from detalle_ingreso d inner join MAEarticulo a on d.idarticulo=a.id_articulo
where d.idingreso=@idingreso
go
