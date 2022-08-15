create database biblioteca;
create table socios (
    rut varchar(10),
    nombre varchar(40),
    apellido varchar(40),
    direccion varchar(50) unique,
    telefono int unique,
    primary key(telefono)
);
create table autor (
    id_autor serial,
    nombre_autor varchar(40),
    apellido_autor varchar(40),
    nacimiento date,
    muerte date,
    tipo_autor varchar(10),
    primary key(id_autor)
);
create table libros (
    id_libro serial,
    isbn varchar(15) unique,
    titulo varchar(70),
    paginas int,
    primary key(id_libro)
);
create table escrituras (
    id_libro int not null,
    id_autor int not null,
    foreign key (id_libro) references libros(id_libro),
    foreign key (id_autor) references autor(id_autor)
);
create table historial_prestamos (
    id_historial serial,
    nombre_socio varchar(30),
    titulo_libro varchar(40),
    id_libro int,
    telefono int,
    primary key (id_historial),
    foreign key (id_libro) references libros(id_libro),
    foreign key (telefono) references socios(telefono)
);
create table fechas_prestamo (
    id_fechas_prestamo serial,
    fecha_prestamo date,
    fecha_entrega date,
    fecha_devolucion date,
    id_historial int not null,
    primary key (id_fechas_prestamo),
    foreign key (id_historial) references historial_prestamos(id_historial)
);
insert into socios(rut, nombre, apellido, direccion, telefono)
values (
        1111111 -1,
        'JUAN',
        'SOTO',
        'AVENIDA 1, SANTIAGO',
        911111111
    ),
    (
        2222222 -2,
        'ANA',
        'PEREZ',
        'PASAJE 2, SANTIAGO',
        922222222
    ),
    (
        3333333 -3,
        'SANDRA',
        'AGUILAR',
        'AVENIDA 2, SANTIAGO',
        933333333
    ),
    (
        4444444 -4,
        'ESTEBAN',
        'JEREZ',
        'AVENIDA 3, SANTIAGO',
        944444444
    ),
    (
        5555555 -5,
        'SILVANA',
        'MUÑOZ',
        'PASAJE 3, SANTIAGO',
        955555555
    );
insert into autor (
        nombre_autor,
        apellido_autor,
        nacimiento,
        muerte,
        tipo_autor
    )
values ('ANDRES', 'ULLOA', '01-01-1982', NULL, 'PRINCIPAL'),
    (
        'SERGIO',
        'MARDONES',
        '01-01-1950',
        '01-01-2012',
        'PRINCIPAL'
    ),
    (
        'JOSE',
        'SALGADO',
        '01-01-1968',
        '01-01-2020',
        'PRINCIPAL'
    ),
    ('ANA', 'SALGADO', '01-01-1972', NULL, 'COAUTOR'),
    ('MARTIN', 'PORTA', '01-01-1976', NULL, 'PRINCIPAL');
insert into libros (isbn, titulo, paginas)
values ('111-1111111-111', 'CUENTOS DE TERROR', 344),
    ('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167),
    ('333-3333333-333', 'HISTORIA DE ASIA', 511),
    ('444-4444444-444', 'MANUAL DE MECANICA', 298);
insert into escrituras (id_libro, id_autor)
values (1, 3),
    (1, 4),
    (2, 1),
    (3, 2),
    (4, 5);
insert into historial_prestamos (nombre_socio, titulo_libro, id_libro, telefono)
values ('JUAN SOTO', 'CUENTOS DE TERROR', 1, 911111111),
    (
        'SILVANA MUÑOZ',
        'POESIAS CONTEMPORANEAS',
        2,
        955555555
    ),
    ('SANDRA AGUILAR', 'HISTORIA DE ASIA', 3, 933333333),
    ('ESTEBAN JEREZ', 'MANUAL DE MECANICA', 4, 944444444),
    ('ANA PEREZ', 'CUENTOS DE TERROR', 1, 922222222),
    ('JUAN SOTO', 'MANUAL DE MECANICA', 4, 911111111),
    (
        'SANDRA AGUILAR',
        'POESIAS CONTEMPORANEAS',
        2,
        933333333
    );
insert into fechas_prestamo (
        fecha_prestamo,
        fecha_entrega,
        fecha_devolucion,
        id_historial
    )
values ('20-01-2020', '27-01-2020', '27-01-2020', 1),
    ('20-01-2020', '30-01-2020', '30-01-2020', 2),
    ('22-01-2020', '30-01-2020', '30-01-2020', 3),
    ('23-01-2020', '30-01-2020', '30-01-2020', 4),
    ('27-01-2020', '04-02-2020', '04-02-2020', 5),
    ('31-01-2020', '12-02-2020', '12-02-2020', 6),
    ('31-01-2020', '12-02-2020', '12-02-2020', 7);
--Mostrar todos los libros que posean menos de 300 páginas.
select *
from libros
where paginas < 300;
-- Mostrar todos los autores que hayan nacido después del 01-01-1970.
select *
from autor
where muerte > '01-01-1970';
--¿Cuál es el libro más solicitado?
select hp.titulo_libro,
    count(hp.titulo_libro) maximo
from historial_prestamos hp
group by hp.titulo_libro
having count(hp.titulo_libro) = (
        select max(i.total)
        from (
                select count(t.titulo_libro) as total
                from historial_prestamos t
                group by t.titulo_libro
            ) i
    );
--Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.
SELECT historial_prestamos.nombre_socio,
    ((fecha_devolucion - fecha_prestamo) -7) * 100 as multa
FROM fechas_prestamo
    inner join historial_prestamos on fechas_prestamo.id_historial = historial_prestamos.id_historial;