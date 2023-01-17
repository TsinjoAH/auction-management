create table marque (
    id serial,
    nom_marque varchar(40)
);

insert into marque (nom_marque)
values ('APPLE'),
       ('GOOGLE'),
       ('DELL'),
       ('ASUS');

create table produit (
    id serial,
    nom varchar(40),
    prix double precision,
    marque_id integer
);

insert into produit (nom, prix, marque_id)
values
    ('iphone X', 10000, 1),
    ('iphone 10', 20000, 1),
    ('iphone 11', 30000, 1),
    ('iphone 12', 40000, 1),
    ('iphone 14', 50000, 1),
    ('GP 2', 1000, 2),
    ('GP 2XL', 2000, 2),
    ('GP 3', 3000, 2),
    ('GP 3 XL', 4000, 2),
    ('GP 4 XL', 5000, 2);