-- insertar roles

insert into rol(nombre) values('Administrador')
insert into rol(nombre) values('Vendedor')
insert into rol(nombre) values('Almacenenero')

-- procedimiento listar rol

create proc rol_listar
as
select id_rol,nombre from Rol
where estado=1
