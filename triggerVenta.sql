create trigger venta_actualizar_stock
on detalle_venta
for insert
as
update a set a.stock=a.stock-d.cantidad
from MAEarticulo as a inner join
inserted as d on d.idarticulo=a.id_articulo
go