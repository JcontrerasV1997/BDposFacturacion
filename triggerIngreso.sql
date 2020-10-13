CREATE TRIGGER Ingreso_ActualizarStock
   ON detalle_ingreso
   FOR INSERT
   AS
   UPDATE a SET a.stock=a.stock+d.cantidad
   FROM MAEarticulo AS a INNER JOIN
   INSERTED AS d ON d.idarticulo=a.id_articulo
go
