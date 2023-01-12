drop owned by auction;

create table admin
(
    id       serial primary key,
    name     varchar(40) not null,
    email    varchar(40) not null,
    password varchar(40) not null
);

insert into admin(name,email,password) values('admin','admin@example.com',md5('admin'));

create table admin_token
(
    token           varchar(40) primary key,
    expiration_date timestamp not null,
    validity        boolean   not null default true,
    admin_id        integer   not null references admin (id)
);

insert into admin_token (token, expiration_date,validity,admin_id) values ('21232f297a57a5a743894a0e4a801fc3','2023-01-12',true,1);

create table category
(
    id   serial primary key,
    name varchar(40) not null
);

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

create table product
(
    id          serial primary key,
    name        varchar(40) not null,
    category_id integer     not null references category (id)
);

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



create table "user"
(
    id          serial primary key,
    name        varchar(40) not null,
    email       varchar(40) not null,
    password    varchar(40) not null,
    signup_date timestamp   not null default current_timestamp
);

insert into "user"(name,email,password,signup_date) values('Steven','Steven@exemple.com',md5('Steven'),'2023-01-02'),
                                ('Grenat','Grenat@exemple.com',md5('Grenat'),'2023-01-05'),
                                ('Perle','Perle@exemple.com',md5('Perle'),'2023-01-07'),
                                ('Amethiste','Amethiste@exemple.com',md5('Amethiste'),'2023-01-10'),
                                 ('Jaspe','Jaspe@exemple.com',md5('Jaspe'),'2023-01-12')
                                 , ('Peridote','Peridote@exemple.com',md5('Peridote'),'2023-01-15'),
                                  ('Lapislazuli','Lapislazuli@exemple.com',md5('LapisLazuli'),'2023-01-17')
                                , ('RoseQuartz','RoseQuartz@exemple.com',md5('RoseQuartz'),'2023-01-19')
                                , ('Ruby','Ruby@exemple.com',md5('Ruby'),'2023-01-20')
                                , ('Saphir','Saphir@exemple.com',md5('Saphir'),'2023-01-22');


create table user_token
(
    token           varchar(40) primary key,
    expiration_date timestamp not null,
    validity        boolean   not null default true,
    user_id         integer   not null references "user" (id)
);

insert into user_token (token, expiration_date,validity,user_id) values ('c44e1acacdf5711ffa393d32636dc596','2023-01-20',true,1),
                                                                        ('393fa15150a0de49a7f7deb353ac32f2','2023-01-20',true,2),
                                                                        (' fbda6b0c0c46b4abfd3518c03e96e02d','2023-01-20',true,3),
                                                                        ('db271031ca0ca9d322c46e2692afce40','2023-01-28',false,4),
                                                                        ('e8e3059ead52c016d9b69fc68f3340dc','2023-01-28',false,5)
                                                                        ,('e31128956cff1aac20818d26ed210e31','2023-01-28',false,6)
                                                                        ,('1d8187de0f54215c27376f80851bab74','2023-01-30',false,7)
                                                                        ,('bb246e6cde9ba945b4d1806a35067e2b','2023-01-30',false,8)
                                                                        ,('9916d1fc59fe22cc046a2fe1615bc764','2023-01-30',false,9)
                                                                        ,('b4c3620381991c7f803f9f0beef133e7','2023-01-30',false,10);

create table commission (
    id serial primary key,
    rate double precision not null check ( rate > 0 and rate < 1 ),
    set_date timestamp not null default current_timestamp
);

insert into commission(rate,set_date) values(0.5,'2023-01-28');

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

insert into auction(title,description,start_date,end_date,product_id,start_price,commission) values('Luxe Jeweller','it is my sunhine','2023-01-25 08:00','2023-01-26 08:00',1,1500,0.1),
                                                                                                    ('Grenier','nothing special','2023-01-26 08:00','2023-01-27 08:00',2,500,0.2),
                                                                                                    ('Mouchoir basique','Base in modern','2023-01-28 08:00','2023-01-29 08:00',3,1000,0.2),
                                                                                                    ('Excalibur','Arthur sword','2023-01-29 08:00','2023-01-30 08:00',4,2500,0.3);


create table auction_pic
(
    id         serial primary key,
    auction_id integer     not null references auction (id),
    pic_path   varchar(40) not null
);

insert into auction_pic(auction_id, pic_path) values(1,'pic1'),
                                                    (2,'pic2'),
                                                    (3,'pic3'),
                                                    (4,'pic4');

create table account_deposit
(
    id            serial primary key,
    user_id       integer          not null references "user" (id),
    amount        double precision not null check ( amount > 0 ),
    approved      boolean          not null default false,
    approval_date timestamp
);

insert into account_deposit(user_id, amount, approved,approval_date) values(1,5000,true,'2023-01-24'),
                                                                            (2,8000,true,'2023-01-23'),
                                                                            (3,7000,true,'2023-01-22'),
                                                                            (4,6000,true,'2023-01-21');

create table bid
(
    id         serial primary key,
    auction_id integer          not null references auction (id),
    user_id    integer          not null references "user" (id),
    amount     double precision not null check ( amount > 0 ),
    bid_date   timestamp        not null default current_timestamp
);
