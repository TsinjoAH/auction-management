drop owned by auction;

create table admin
(
    id       serial primary key,
    name     varchar(40) not null,
    email    varchar(40) not null,
    password varchar(40) not null
);

create table admin_token
(
    token           varchar(40) primary key,
    expiration_date timestamp not null,
    validity        boolean   not null default true,
    admin_id        integer   not null references admin (id)
);

create table category
(
    id   serial primary key,
    name varchar(40) not null
);

create table product
(
    id          serial primary key,
    name        varchar(40) not null,
    category_id integer     not null references category (id)
);

create table "user"
(
    id          serial primary key,
    name        varchar(40) not null,
    email       varchar(40) not null,
    password    varchar(40) not null,
    signup_date timestamp   not null default current_timestamp
);

create table user_token
(
    token           varchar(40) primary key,
    expiration_date timestamp not null,
    validity        boolean   not null default true,
    user_id         integer   not null references "user" (id)
);

create table commission (
    id serial primary key,
    rate double precision not null check ( rate > 0 and rate < 1 ),
    set_date timestamp not null default current_timestamp
);

create table auction
(
    id          serial primary key,
    title       varchar(40)  not null,
    description varchar(255) not null,
    start_date  timestamp    not null default current_timestamp,
    end_date    timestamp    not null check ( end_date > start_date ),
    product_id  integer      not null references product (id),
    start_price double precision check ( start_price > 0 ),
    commission double precision not null check ( commission > 0 and commission < 1 )
);

create table auction_pic
(
    id         serial primary key,
    auction_id integer     not null references auction (id),
    pic_path   varchar(40) not null
);

create table account_deposit
(
    id            serial primary key,
    user_id       integer          not null references "user" (id),
    amount        double precision not null check ( amount > 0 ),
    approved      boolean          not null default false,
    approval_date timestamp
);

create table bid
(
    id         serial primary key,
    auction_id integer          not null references auction (id),
    user_id    integer          not null references "user" (id),
    amount     double precision not null check ( amount > 0 ),
    bid_date   timestamp        not null default current_timestamp
);

--mdp:admin--
insert into admin(name,email,password) values('admin','admin@example.com','d033e22ae348aeb5660fc2140aec35850c4da997');

--categorie--
insert into category(name) values('Luxe'),
                                 ('BriqueABraque'),
                                 ('Bibelot'),
                                 ('fancy'),
                                 ('Cool'),
                                 ('Vintage'),
                                 ('Retro'),
                                 ('Modern'),
                                 ('BeauArt'),
                                 ('Country'),
                                 ('Rustique'),
                                 ('Cute'),
                                 ('Kids'),
                                 ('Adolescent'),
                                 ('Adult'),
                                 ('Revue'),
                                 ('Prehistorical'),
                                 ('Lofi'),
                                 ('Hiver'),
                                 ('Spring');

--Produit--
insert into product(name,category_id) values('Rollex',1),
                                            ('Attrape-Reve',2),
                                            ('Mouchoir',2),
                                            ('RepliqueEpee',2),
                                            ('Laine',2),
                                            ('Oursin',3),
                                            ('Manteau',3),
                                            ('Drap',3),
                                            ('Costard',4),
                                            ('Vin',4),
                                            ('Ampoule',4),
                                            ('Photos',5),
                                            ('T-Shirt',5),
                                            ('PorteManteau',5),
                                            ('Poele',6),
                                            ('EclatVerre',20),
                                            ('Ecouteur',6),
                                            ('Telephone',7),
                                            ('Clavier',7),
                                            ('Souris',7),
                                            ('Chargeur',8),
                                            ('Boitier',8),
                                            ('Cable',8),
                                            ('Chaise',9),
                                            ('Mustang',1),
                                            ('Ferrari',1),
                                            ('Gourmet',1),
                                            ('FossileAmbre',9),
                                            ('FossileKiers',9),
                                            ('Photos2GM',10),
                                            ('Babyliss',10),
                                            ('Yogurt',10),
                                            ('Spoon',11),
                                            ('Casque',11),
                                            ('Couverture',11),
                                            ('Medicament',12),
                                            ('Poids',12),
                                            ('CarteDeJeux',12),
                                            ('MonopoliLimitedEdition',13),
                                            ('Short',13),
                                            ('Jean',13),
                                            ('Converse',14),
                                            ('GoldenBall',14),
                                            ('SilverBall',15),
                                            ('Ordinateur',15),
                                            ('ChaiseRoulante',16),
                                            ('ChienEmpaille',16),
                                            ('AnimalEnJade',17),
                                            ('Figurine',18),
                                            ('RepliqueCoutier',19);

--user allmdp:'gemmedecristal'--
insert into "user"(name,email,password,signup_date) values('Steven','Steven@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-02'),
                                                          ('Grenat','Grenat@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-05'),
                                                          ('Perle','Perle@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-07'),
                                                          ('Amethiste','Amethiste@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-10'),
                                                          ('Jaspe','Jaspe@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-12')
        , ('Peridote','Peridote@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-15'),
                                                          ('Lapislazuli','Lapislazuli@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-17')
        , ('RoseQuartz','RoseQuartz@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-19')
        , ('Ruby','Ruby@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-20')
        , ('Saphir','Saphir@exemple.com','602260addce6b6f6f7a3b3bd8f55d95241dd0c5c','2023-01-22');

insert into commission(rate,set_date) values(0.5,'2023-01-28');

insert into account_deposit(user_id, amount, approved,approval_date) values(1,5000,true,'2023-01-24'),
                                                                           (2,8000,true,'2023-01-23'),
                                                                           (3,7000,true,'2023-01-22'),
                                                                           (4,6000,true,'2023-01-21'),
                                                                           (5,9000,true,'2023-01-20'),
                                                                           (6,10000,true,'2023-01-19'),
                                                                           (7,2000,true,'2023-01-18'),
                                                                           (8,3000,true,'2023-01-17'),
                                                                           (9,5000,true,'2023-01-16'),
                                                                           (10,8500,true,'2023-01-15');