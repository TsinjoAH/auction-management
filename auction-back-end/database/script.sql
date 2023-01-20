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
    id            serial primary key,
    name          varchar(40) not null,
    "category_id" integer     not null references category (id)
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

create table commission
(
    id       serial primary key,
    rate     double precision not null check ( rate > 0 and rate < 1 ),
    set_date timestamp        not null default current_timestamp
);

create table auction
(
    id          serial primary key,
    title       varchar(40)      not null,
    description varchar(255)     not null,
    user_id     int references "user" (id),
    start_date  timestamp        not null default current_timestamp,
    end_date    timestamp        not null check ( end_date > start_date ),
    duration    double precision not null check ( duration > 0 ),
    product_id  integer          not null references product (id),
    start_price double precision check ( start_price > 0 ),
    commission  double precision not null check ( commission > 0 and commission < 1 )
);

create table auction_pic
(
    id         serial primary key,
    auction_id integer      not null references auction (id),
    pic_path   varchar(255) not null
);


create table deposit_status
(
    status      integer     not null primary key ,
    description varchar(40) not null
);

insert into deposit_status values (0, 'Non evalue'),
                                  (10, 'Rejete'),
                                  (20, 'approuve');

create table account_deposit
(
    id            serial primary key,
    user_id       integer          not null references "user" (id),
    amount        double precision not null check ( amount > 0 ),
    date          timestamp        not null default current_timestamp,
    status        integer          not null default 0 references deposit_status(status),
    status_change_date timestamp
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
insert into admin(name, email, password)
values ('admin', 'admin@example.com', 'd033e22ae348aeb5660fc2140aec35850c4da997');

--categorie--
insert into category(name)
values ('Luxe'),
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
insert into product(name, category_id)
values ('Rollex', 1),
       ('Attrape-Reve', 2),
       ('Mouchoir', 2),
       ('RepliqueEpee', 2),
       ('Laine', 2),
       ('Oursin', 3),
       ('Manteau', 3),
       ('Drap', 3),
       ('Costard', 4),
       ('Vin', 4),
       ('Ampoule', 4),
       ('Photos', 5),
       ('T-Shirt', 5),
       ('PorteManteau', 5),
       ('Poele', 6),
       ('EclatVerre', 20),
       ('Ecouteur', 6),
       ('Telephone', 7),
       ('Clavier', 7),
       ('Souris', 7),
       ('Chargeur', 8),
       ('Boitier', 8),
       ('Cable', 8),
       ('Chaise', 9),
       ('Mustang', 1),
       ('Ferrari', 1),
       ('Gourmet', 1),
       ('FossileAmbre', 9),
       ('FossileKiers', 9),
       ('Photos2GM', 10),
       ('Babyliss', 10),
       ('Yogurt', 10),
       ('Spoon', 11),
       ('Casque', 11),
       ('Couverture', 11),
       ('Medicament', 12),
       ('Poids', 12),
       ('CarteDeJeux', 12),
       ('MonopoliLimitedEdition', 13),
       ('Short', 13),
       ('Jean', 13),
       ('Converse', 14),
       ('GoldenBall', 14),
       ('SilverBall', 15),
       ('Ordinateur', 15),
       ('ChaiseRoulante', 16),
       ('ChienEmpaille', 16),
       ('AnimalEnJade', 17),
       ('Figurine', 18),
       ('RepliqueCoutier', 19);



insert into commission(rate, set_date)
values (0.5, '2023-01-28');



CREATE OR REPLACE VIEW v_auction
AS
SELECT auction.id,
       title,
       description,
       user_id,
       start_date,
       end_date,
       duration,
       product_id,
       start_price,
       commission,
       CASE
           WHEN start_date <= current_timestamp AND current_timestamp < end_date THEN 1
           WHEN end_date < current_timestamp THEN 2
           WHEN start_date > current_timestamp THEN 0
           END AS status
FROM auction;

CREATE OR REPLACE VIEW full_v_auction
AS
SELECT a.id,a.title,a.description,start_date,end_date,duration,p.name product,p.id product_id,c2.name category,c2.id category_id,start_price,
       CASE
           WHEN start_date <= current_timestamp AND current_timestamp < end_date THEN 1
           WHEN end_date < current_timestamp THEN 2
           WHEN start_date > current_timestamp THEN 0
           END AS Status
FROM auction a
INNER JOIN product p on a.product_id = p.id
INNER JOIN category c2 on p.category_id = c2.id;


CREATE VIEW auction_done AS
SELECT b.user_id,sum(b.amount) amount
FROM bid b
JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    WHERE auction_id IN (SELECT id FROM v_auction WHERE status = 2) GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount GROUP BY b.user_id;

CREATE VIEW gain AS
SELECT b.amount,b.auction_id,a.user_id,b.amount-(b.amount*commission) gain
FROM bid b
         JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount JOIN auction a ON a.id=b.auction_id;


CREATE VIEW deposit_done AS
SELECT user_id,SUM(amount) amount FROM account_deposit WHERE status=20 GROUP BY user_id;

CREATE VIEW full_balance AS
SELECT d.user_id
     ,CASE WHEN d.amount IS NULL THEN 0 ELSE d.amount END deposit
     ,CASE WHEN a.amount IS NULL THEN 0 ELSE a.amount END auction_bid
     ,CASE WHEN g.gain IS NULL THEN 0 ELSE g.gain END auction_gain
      FROM deposit_done d
          LEFT JOIN auction_done a ON d.user_id=a.user_id
          LEFT JOIN gain g ON g.user_id=a.user_id;

CREATE VIEW balance AS
    SELECT user_id,deposit-auction_bid+auction_gain amount FROM full_balance;

create view v_user_auction as
    select auction_id, user_id from bid group by auction_id, user_id;

create view v_auction_bidder as
select a.*, v.user_id bidder from v_auction a join v_user_auction v
on a.id = v.auction_id;

--user allmdp:'gemmedecristal'--
insert into "user"(name, email, password, signup_date)
values ('Steven', 'Steven@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Grenat', 'Grenat@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Perle', 'Perle@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Amethiste', 'Amethiste@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Jaspe', 'Jaspe@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Peridote', 'Peridote@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Lapislazuli', 'Lapislazuli@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('RoseQuartz', 'RoseQuartz@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Ruby', 'Ruby@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('Saphir', 'Saphir@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('DiamondRose', 'DiamondRose@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('DiamondBleu', 'DiamondBleu@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
       ('DiamonJaune', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),

        ('Finn', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Jake', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Clarence', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Marceline', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('PrincesseBubleGum', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('PrincesseFlame', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('MissRainyCorn', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Bemo', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Rigbi', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Mordecai', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('Pops', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('MrRobinson', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('MrMuscle', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),
        ('FantomeFrappeur', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-18'),

        ('Luffy', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Zorro', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Sanji', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Nami', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Jinbei', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Robin', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Brook', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Ussop', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Chopper', 'DiamonJaune@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('DiamonRouge', 'DiamonRouge@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('DiamonBlanc', 'DiamonBlanc@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Sabo', 'Sabo@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Ace', 'Ace@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('newGate', 'newGate@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('GoldRoger', 'GoldRoger@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
        ('Garp', 'Garp@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19');



insert into account_deposit(user_id, amount, status, status_change_date)
values (1, 5000, 20, '2023-01-24'),
       (2, 8000, 20, '2023-01-23'),
       (3, 7000, 20, '2023-01-22'),
       (4, 6000, 20, '2023-01-21'),
       (5, 9000, 20, '2023-01-20'),
       (6, 10000, 20, '2023-01-19'),
       (7, 2000, 20, '2023-01-18'),
       (8, 3000, 20, '2023-01-17'),
       (9, 5000, 20, '2023-01-16'),
       (10, 8500, 20, '2023-01-15');

insert into auction (title,description,user_id,start_date,end_date,duration,product_id,start_price,commission) values('Mozart Art_1','The best of the best_1',1,'2020-01-01 02:00','2020-01-01 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_2','The best of the best',1,'2020-01-02 02:00','2020-01-02 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_3','The best of the best',1,'2020-01-03 02:00','2020-01-03 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_4','The best of the best',1,'2020-01-04 02:00','2020-01-04 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_5','The best of the best',1,'2020-01-05 02:00','2020-01-05 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_6','The best of the best',1,'2020-01-06 02:00','2020-01-06 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_7','The best of the best',1,'2020-01-07 02:00','2020-01-07 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_8','The best of the best',1,'2020-01-08 02:00','2020-01-08 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_9','The best of the best',1,'2020-01-09 02:00','2020-01-09 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_10','The best of the best',1,'2020-01-10 02:00','2020-01-10 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_11','The best of the best',1,'2020-01-11 02:00','2020-01-11 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_12','The best of the best',1,'2020-01-12 02:00','2020-01-12 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_13','The best of the best',1,'2020-01-13 02:00','2020-01-13 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_14','The best of the best',1,'2020-01-14 02:00','2020-01-14 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_15','The best of the best',1,'2020-01-15 02:00','2020-01-15 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_16','The best of the best',1,'2020-01-16 02:00','2020-01-16 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_17','The best of the best',1,'2020-01-17 02:00','2020-01-17 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_18','The best of the best',1,'2020-01-18 02:00','2020-01-18 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_19','The best of the best',1,'2020-01-19 02:00','2020-01-19 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_20','The best of the best',1,'2020-01-20 02:00','2020-01-20 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_21','The best of the best',1,'2020-01-21 02:00','2020-01-21 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_22','The best of the best',1,'2020-01-22 02:00','2020-01-22 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_23','The best of the best',1,'2020-01-23 02:00','2020-01-23 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_24','The best of the best',1,'2020-01-24 02:00','2020-01-24 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_25','The best of the best',1,'2020-01-25 02:00','2020-01-25 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_26','The best of the best',1,'2020-01-26 02:00','2020-01-26 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_27','The best of the best',1,'2020-01-27 02:00','2020-01-27 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_28','The best of the best',1,'2020-01-28 02:00','2020-01-28 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_29','The best of the best',1,'2020-01-29 02:00','2020-01-29 19:00',17,1,250,0.5),
                                                                                                                    ('Mozart Art_30','The best of the best',1,'2020-01-30 02:00','2020-01-30 19:00',17,1,250,0.5),

                                                                                                                  ('Mozart Art_31','The best of the best',2,'2020-02-01 02:00','2020-02-01 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_32','The best of the best',2,'2020-02-02 02:00','2020-02-02 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_33','The best of the best',2,'2020-02-03 02:00','2020-02-03 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_34','The best of the best',2,'2020-02-04 02:00','2020-02-04 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_35','The best of the best',2,'2020-02-05 02:00','2020-02-05 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_36','The best of the best',2,'2020-02-06 02:00','2020-02-06 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_37','The best of the best',2,'2020-02-07 02:00','2020-02-07 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_38','The best of the best',2,'2020-02-08 02:00','2020-02-08 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_39','The best of the best',2,'2020-02-09 02:00','2020-02-09 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_40','The best of the best',2,'2020-02-10 02:00','2020-02-10 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_41','The best of the best',2,'2020-02-11 02:00','2020-02-11 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_42','The best of the best',2,'2020-02-12 02:00','2020-02-12 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_43','The best of the best',2,'2020-02-13 02:00','2020-02-13 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_44','The best of the best',2,'2020-02-14 02:00','2020-02-14 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_45','The best of the best',2,'2020-02-15 02:00','2020-02-15 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_46','The best of the best',2,'2020-02-16 02:00','2020-02-16 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_47','The best of the best',2,'2020-02-17 02:00','2020-02-17 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_48','The best of the best',2,'2020-02-18 02:00','2020-02-18 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_49','The best of the best',2,'2020-02-19 02:00','2020-02-19 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_50','The best of the best',2,'2020-02-20 02:00','2020-02-20 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_51','The best of the best',2,'2020-02-21 02:00','2020-02-21 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_52','The best of the best',2,'2020-02-22 02:00','2020-02-22 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_53','The best of the best',2,'2020-02-23 02:00','2020-02-23 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_54','The best of the best',2,'2020-02-24 02:00','2020-02-24 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_55','The best of the best',2,'2020-02-25 02:00','2020-02-25 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_56','The best of the best',2,'2020-02-26 02:00','2020-02-26 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_57','The best of the best',2,'2020-02-27 02:00','2020-02-27 19:00',17,2,250,0.5),
                                                                                                                    ('Mozart Art_58','The best of the best',2,'2020-02-28 02:00','2020-02-28 19:00',17,2,250,0.5),
                                                                                                                    

                                                                                                                    ('Mozart Art_60','The best of the best',3,'2020-03-01 02:00','2020-03-01 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_61','The best of the best',3,'2020-03-02 02:00','2020-03-02 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_62','The best of the best',3,'2020-03-03 02:00','2020-03-03 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_63','The best of the best',3,'2020-03-04 02:00','2020-03-04 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_64','The best of the best',3,'2020-03-05 02:00','2020-03-05 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_65','The best of the best',3,'2020-03-06 02:00','2020-03-06 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_66','The best of the best',3,'2020-03-07 02:00','2020-03-07 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_67','The best of the best',3,'2020-03-08 02:00','2020-03-08 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_68','The best of the best',3,'2020-03-09 02:00','2020-03-09 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_69','The best of the best',3,'2020-03-10 02:00','2020-03-10 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_70','The best of the best',3,'2020-03-11 02:00','2020-03-11 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_71','The best of the best',3,'2020-03-12 02:00','2020-03-12 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_72','The best of the best',3,'2020-03-13 02:00','2020-03-13 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_73','The best of the best',3,'2020-03-14 02:00','2020-03-14 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_74','The best of the best',3,'2020-03-15 02:00','2020-03-15 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_75','The best of the best',3,'2020-03-16 02:00','2020-03-16 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_76','The best of the best',3,'2020-03-17 02:00','2020-03-17 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_77','The best of the best',3,'2020-03-18 02:00','2020-03-18 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_78','The best of the best',3,'2020-03-19 02:00','2020-03-19 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_79','The best of the best',3,'2020-03-20 02:00','2020-03-20 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_80','The best of the best',3,'2020-03-21 02:00','2020-03-21 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_81','The best of the best',3,'2020-03-22 02:00','2020-03-22 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_82','The best of the best',3,'2020-03-23 02:00','2020-03-23 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_83','The best of the best',3,'2020-03-24 02:00','2020-03-24 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_84','The best of the best',3,'2020-03-25 02:00','2020-03-25 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_85','The best of the best',3,'2020-03-26 02:00','2020-03-26 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_86','The best of the best',3,'2020-03-27 02:00','2020-03-27 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_87','The best of the best',3,'2020-03-28 02:00','2020-03-28 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_88','The best of the best',3,'2020-03-29 02:00','2020-03-29 19:00',17,3,250,0.5),
                                                                                                                    ('Mozart Art_89','The best of the best',3,'2020-03-30 02:00','2020-03-30 19:00',17,3,250,0.5),

                                                                                                                   ('Mozart Art_90','The best of the best',4,'2020-04-01 02:00','2020-04-01 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_91','The best of the best',4,'2020-04-02 02:00','2020-04-02 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_92','The best of the best',4,'2020-04-03 02:00','2020-04-03 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_93','The best of the best',4,'2020-04-04 02:00','2020-04-04 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_94','The best of the best',4,'2020-04-05 02:00','2020-04-05 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_95','The best of the best',4,'2020-04-06 02:00','2020-04-06 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_96','The best of the best',4,'2020-04-07 02:00','2020-04-07 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_97','The best of the best',4,'2020-04-08 02:00','2020-04-08 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_98','The best of the best',4,'2020-04-09 02:00','2020-04-09 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_99','The best of the best',4,'2020-04-10 02:00','2020-04-10 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_100','The best of the best',4,'2020-04-11 02:00','2020-04-11 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_101','The best of the best',4,'2020-04-12 02:00','2020-04-12 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_102','The best of the best',4,'2020-04-13 02:00','2020-04-13 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_103','The best of the best',4,'2020-04-14 02:00','2020-04-14 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_104','The best of the best',4,'2020-04-15 02:00','2020-04-15 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_105','The best of the best',4,'2020-04-16 02:00','2020-04-16 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_106','The best of the best',4,'2020-04-17 02:00','2020-04-17 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_107','The best of the best',4,'2020-04-18 02:00','2020-04-18 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_108','The best of the best',4,'2020-04-19 02:00','2020-04-19 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_109','The best of the best',4,'2020-04-20 02:00','2020-04-20 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_110','The best of the best',4,'2020-04-21 02:00','2020-04-21 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_111','The best of the best',4,'2020-04-22 02:00','2020-04-22 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_112','The best of the best',4,'2020-04-23 02:00','2020-04-23 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_113','The best of the best',4,'2020-04-24 02:00','2020-04-24 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_114','The best of the best',4,'2020-04-25 02:00','2020-04-25 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_115','The best of the best',4,'2020-04-26 02:00','2020-04-26 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_116','The best of the best',4,'2020-04-27 02:00','2020-04-27 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_117','The best of the best',4,'2020-04-28 02:00','2020-04-28 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_118','The best of the best',4,'2020-04-29 02:00','2020-04-29 19:00',17,4,250,0.5),
                                                                                                                    ('Mozart Art_119','The best of the best',4,'2020-04-30 02:00','2020-04-30 19:00',17,4,250,0.5),

                                                                                                                    ('Mozart Art_120','The best of the best',5,'2020-05-01 02:00','2020-05-01 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_121','The best of the best',5,'2020-05-02 02:00','2020-05-02 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_122','The best of the best',5,'2020-05-03 02:00','2020-05-03 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_123','The best of the best',5,'2020-05-04 02:00','2020-05-04 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_124','The best of the best',5,'2020-05-05 02:00','2020-05-05 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_125','The best of the best',5,'2020-05-06 02:00','2020-05-06 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_126','The best of the best',5,'2020-05-07 02:00','2020-05-07 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_127','The best of the best',5,'2020-05-08 02:00','2020-05-08 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_128','The best of the best',5,'2020-05-09 02:00','2020-05-09 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_129','The best of the best',5,'2020-05-10 02:00','2020-05-10 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_130','The best of the best',5,'2020-05-11 02:00','2020-05-11 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_131','The best of the best',5,'2020-05-12 02:00','2020-05-12 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_132','The best of the best',5,'2020-05-13 02:00','2020-05-13 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_133','The best of the best',5,'2020-05-14 02:00','2020-05-14 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_134','The best of the best',5,'2020-05-15 02:00','2020-05-15 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_135','The best of the best',5,'2020-05-16 02:00','2020-05-16 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_136','The best of the best',5,'2020-05-17 02:00','2020-05-17 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_137','The best of the best',5,'2020-05-18 02:00','2020-05-18 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_138','The best of the best',5,'2020-05-19 02:00','2020-05-19 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_139','The best of the best',5,'2020-05-20 02:00','2020-05-20 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_140','The best of the best',5,'2020-05-21 02:00','2020-05-21 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_141','The best of the best',5,'2020-05-22 02:00','2020-05-22 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_142','The best of the best',5,'2020-05-23 02:00','2020-05-23 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_143','The best of the best',5,'2020-05-24 02:00','2020-05-24 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_144','The best of the best',5,'2020-05-25 02:00','2020-05-25 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_145','The best of the best',5,'2020-05-26 02:00','2020-05-26 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_146','The best of the best',5,'2020-05-27 02:00','2020-05-27 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_147','The best of the best',5,'2020-05-28 02:00','2020-05-28 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_148','The best of the best',5,'2020-05-29 02:00','2020-05-29 19:00',17,5,250,0.5),
                                                                                                                    ('Mozart Art_149','The best of the best',5,'2020-05-30 02:00','2020-05-30 19:00',17,5,250,0.5),

                                                                                                                   ('Mozart Art_150','The best of the best',6,'2020-06-01 02:00','2020-06-01 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_151','The best of the best',6,'2020-06-02 02:00','2020-06-02 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_152','The best of the best',6,'2020-06-03 02:00','2020-06-03 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_153','The best of the best',6,'2020-06-04 02:00','2020-06-04 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_154','The best of the best',6,'2020-06-05 02:00','2020-06-05 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_155','The best of the best',6,'2020-06-06 02:00','2020-06-06 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_156','The best of the best',6,'2020-06-07 02:00','2020-06-07 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_157','The best of the best',6,'2020-06-08 02:00','2020-06-08 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_158','The best of the best',6,'2020-06-09 02:00','2020-06-09 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_159','The best of the best',6,'2020-06-10 02:00','2020-06-10 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_160','The best of the best',6,'2020-06-11 02:00','2020-06-11 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_161','The best of the best',6,'2020-06-12 02:00','2020-06-12 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_162','The best of the best',6,'2020-06-13 02:00','2020-06-13 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_163','The best of the best',6,'2020-06-14 02:00','2020-06-14 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_164','The best of the best',6,'2020-06-15 02:00','2020-06-15 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_165','The best of the best',6,'2020-06-16 02:00','2020-06-16 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_166','The best of the best',6,'2020-06-17 02:00','2020-06-17 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_167','The best of the best',6,'2020-06-18 02:00','2020-06-18 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_168','The best of the best',6,'2020-06-19 02:00','2020-06-19 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_169','The best of the best',6,'2020-06-20 02:00','2020-06-20 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_170','The best of the best',6,'2020-06-21 02:00','2020-06-21 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_171','The best of the best',6,'2020-06-22 02:00','2020-06-22 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_172','The best of the best',6,'2020-06-23 02:00','2020-06-23 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_173','The best of the best',6,'2020-06-24 02:00','2020-06-24 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_174','The best of the best',6,'2020-06-25 02:00','2020-06-25 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_175','The best of the best',6,'2020-06-26 02:00','2020-06-26 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_176','The best of the best',6,'2020-06-27 02:00','2020-06-27 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_177','The best of the best',6,'2020-06-28 02:00','2020-06-28 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_178','The best of the best',6,'2020-06-29 02:00','2020-06-29 19:00',17,6,250,0.5),
                                                                                                                    ('Mozart Art_179','The best of the best',6,'2020-06-30 02:00','2020-06-30 19:00',17,6,250,0.5),

                                                                                                                 ('Mozart Art_180','The best of the best',7,'2020-07-01 02:00','2020-07-01 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_181','The best of the best',7,'2020-07-02 02:00','2020-07-02 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_182','The best of the best',7,'2020-07-03 02:00','2020-07-03 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_183','The best of the best',7,'2020-07-04 02:00','2020-07-04 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_184','The best of the best',7,'2020-07-05 02:00','2020-07-05 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_185','The best of the best',7,'2020-07-06 02:00','2020-07-06 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_186','The best of the best',7,'2020-07-07 02:00','2020-07-07 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_187','The best of the best',7,'2020-07-08 02:00','2020-07-08 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_188','The best of the best',7,'2020-07-09 02:00','2020-07-09 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_189','The best of the best',7,'2020-07-10 02:00','2020-07-10 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_190','The best of the best',7,'2020-07-11 02:00','2020-07-11 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_191','The best of the best',7,'2020-07-12 02:00','2020-07-12 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_192','The best of the best',7,'2020-07-13 02:00','2020-07-13 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_193','The best of the best',7,'2020-07-14 02:00','2020-07-14 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_194','The best of the best',7,'2020-07-15 02:00','2020-07-15 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_195','The best of the best',7,'2020-07-16 02:00','2020-07-16 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_196','The best of the best',7,'2020-07-17 02:00','2020-07-17 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_197','The best of the best',7,'2020-07-18 02:00','2020-07-18 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_198','The best of the best',7,'2020-07-19 02:00','2020-07-19 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_199','The best of the best',7,'2020-07-20 02:00','2020-07-20 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_200','The best of the best',7,'2020-07-21 02:00','2020-07-21 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_201','The best of the best',7,'2020-07-22 02:00','2020-07-22 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_202','The best of the best',7,'2020-07-23 02:00','2020-07-23 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_203','The best of the best',7,'2020-07-24 02:00','2020-07-24 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_204','The best of the best',7,'2020-07-25 02:00','2020-07-25 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_205','The best of the best',7,'2020-07-26 02:00','2020-07-26 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_206','The best of the best',7,'2020-07-27 02:00','2020-07-27 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_207','The best of the best',7,'2020-07-28 02:00','2020-07-28 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_208','The best of the best',7,'2020-07-29 02:00','2020-07-29 19:00',17,7,250,0.5),
                                                                                                                    ('Mozart Art_209','The best of the best',7,'2020-07-30 02:00','2020-07-30 19:00',17,1,250,0.5),

                                                                                                                    ('Mozart Art_210','The best of the best',8,'2020-08-01 02:00','2020-08-01 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_211','The best of the best',8,'2020-08-02 02:00','2020-08-02 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_212','The best of the best',8,'2020-08-03 02:00','2020-08-03 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_213','The best of the best',8,'2020-08-04 02:00','2020-08-04 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_214','The best of the best',8,'2020-08-05 02:00','2020-08-05 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_215','The best of the best',8,'2020-08-06 02:00','2020-08-06 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_216','The best of the best',8,'2020-08-07 02:00','2020-08-07 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_217','The best of the best',8,'2020-08-08 02:00','2020-08-08 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_218','The best of the best',8,'2020-08-09 02:00','2020-08-09 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_219','The best of the best',8,'2020-08-10 02:00','2020-08-10 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_220','The best of the best',8,'2020-08-11 02:00','2020-08-11 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_221','The best of the best',8,'2020-08-12 02:00','2020-08-12 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_222','The best of the best',8,'2020-08-13 02:00','2020-08-13 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_223','The best of the best',8,'2020-08-14 02:00','2020-08-14 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_224','The best of the best',8,'2020-08-15 02:00','2020-08-15 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_225','The best of the best',8,'2020-08-16 02:00','2020-08-16 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_226','The best of the best',8,'2020-08-17 02:00','2020-08-17 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_227','The best of the best',8,'2020-08-18 02:00','2020-08-18 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_228','The best of the best',8,'2020-08-19 02:00','2020-08-19 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_229','The best of the best',8,'2020-08-20 02:00','2020-08-20 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_230','The best of the best',8,'2020-08-21 02:00','2020-08-21 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_231','The best of the best',8,'2020-08-22 02:00','2020-08-22 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_232','The best of the best',8,'2020-08-23 02:00','2020-08-23 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_233','The best of the best',8,'2020-08-24 02:00','2020-08-24 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_234','The best of the best',8,'2020-08-25 02:00','2020-08-25 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_235','The best of the best',8,'2020-08-26 02:00','2020-08-26 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_236','The best of the best',8,'2020-08-27 02:00','2020-08-27 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_237','The best of the best',8,'2020-08-28 02:00','2020-08-28 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_238','The best of the best',8,'2020-08-29 02:00','2020-08-29 19:00',17,8,250,0.5),
                                                                                                                    ('Mozart Art_239','The best of the best',8,'2020-08-30 02:00','2020-08-30 19:00',17,8,250,0.5),

                                                                                                                   ('Mozart Art_240','The best of the best',9,'2020-09-01 02:00','2020-09-01 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_241','The best of the best',9,'2020-09-02 02:00','2020-09-02 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_242','The best of the best',9,'2020-09-03 02:00','2020-09-03 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_243','The best of the best',9,'2020-09-04 02:00','2020-09-04 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_244','The best of the best',9,'2020-09-05 02:00','2020-09-05 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_245','The best of the best',9,'2020-09-06 02:00','2020-09-06 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_246','The best of the best',9,'2020-09-07 02:00','2020-09-07 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_247','The best of the best',9,'2020-09-08 02:00','2020-09-08 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_248','The best of the best',9,'2020-09-09 02:00','2020-09-09 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_249','The best of the best',9,'2020-09-10 02:00','2020-09-10 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_250','The best of the best',9,'2020-09-11 02:00','2020-09-11 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_251','The best of the best',9,'2020-09-12 02:00','2020-09-12 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_252','The best of the best',9,'2020-09-13 02:00','2020-09-13 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_253','The best of the best',9,'2020-09-14 02:00','2020-09-14 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_254','The best of the best',9,'2020-09-15 02:00','2020-09-15 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_255','The best of the best',9,'2020-09-16 02:00','2020-09-16 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_256','The best of the best',9,'2020-09-17 02:00','2020-09-17 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_257','The best of the best',9,'2020-09-18 02:00','2020-09-18 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_258','The best of the best',9,'2020-09-19 02:00','2020-09-19 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_259','The best of the best',9,'2020-09-20 02:00','2020-09-20 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_260','The best of the best',9,'2020-09-21 02:00','2020-09-21 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_261','The best of the best',9,'2020-09-22 02:00','2020-09-22 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_262','The best of the best',9,'2020-09-23 02:00','2020-09-23 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_263','The best of the best',9,'2020-09-24 02:00','2020-09-24 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_264','The best of the best',9,'2020-09-25 02:00','2020-09-25 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_265','The best of the best',9,'2020-09-26 02:00','2020-09-26 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_266','The best of the best',9,'2020-09-27 02:00','2020-09-27 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_267','The best of the best',9,'2020-09-28 02:00','2020-09-28 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_268','The best of the best',9,'2020-09-29 02:00','2020-09-29 19:00',17,9,250,0.5),
                                                                                                                    ('Mozart Art_269','The best of the best',9,'2020-09-30 02:00','2020-09-30 19:00',17,9,250,0.5),

                                                                                                                  ('Mozart Art_270','The best of the best',10,'2020-10-01 02:00','2020-10-01 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_271','The best of the best',10,'2020-10-02 02:00','2020-10-02 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_272','The best of the best',10,'2020-10-03 02:00','2020-10-03 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_273','The best of the best',10,'2020-10-04 02:00','2020-10-04 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_274','The best of the best',10,'2020-10-05 02:00','2020-10-05 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_275','The best of the best',10,'2020-10-06 02:00','2020-10-06 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_276','The best of the best',10,'2020-10-07 02:00','2020-10-07 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_277','The best of the best',10,'2020-10-08 02:00','2020-10-08 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_278','The best of the best',10,'2020-10-09 02:00','2020-10-09 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_279','The best of the best',10,'2020-10-10 02:00','2020-10-10 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_280','The best of the best',10,'2020-10-11 02:00','2020-10-11 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_281','The best of the best',10,'2020-10-12 02:00','2020-10-12 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_282','The best of the best',10,'2020-10-13 02:00','2020-10-13 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_283','The best of the best',10,'2020-10-14 02:00','2020-10-14 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_284','The best of the best',10,'2020-10-15 02:00','2020-10-15 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_285','The best of the best',10,'2020-10-16 02:00','2020-10-16 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_286','The best of the best',10,'2020-10-17 02:00','2020-10-17 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_287','The best of the best',10,'2020-10-18 02:00','2020-10-18 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_288','The best of the best',10,'2020-10-19 02:00','2020-10-19 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_289','The best of the best',10,'2020-10-20 02:00','2020-10-20 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_290','The best of the best',10,'2020-10-21 02:00','2020-10-21 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_291','The best of the best',10,'2020-10-22 02:00','2020-10-22 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_292','The best of the best',10,'2020-10-23 02:00','2020-10-23 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_293','The best of the best',10,'2020-10-24 02:00','2020-10-24 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_294','The best of the best',10,'2020-10-25 02:00','2020-10-25 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_295','The best of the best',10,'2020-10-26 02:00','2020-10-26 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_296','The best of the best',10,'2020-10-27 02:00','2020-10-27 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_297','The best of the best',10,'2020-10-28 02:00','2020-10-28 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_298','The best of the best',10,'2020-10-29 02:00','2020-10-29 19:00',17,10,250,0.5),
                                                                                                                    ('Mozart Art_299','The best of the best',10,'2020-10-30 02:00','2020-10-30 19:00',17,10,250,0.5),

                                                                                                                    ('Mozart Art_300','The best of the best',11,'2020-11-01 02:00','2020-11-01 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_301','The best of the best',11,'2020-11-02 02:00','2020-11-02 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_302','The best of the best',11,'2020-11-03 02:00','2020-11-03 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_303','The best of the best',11,'2020-11-04 02:00','2020-11-04 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_304','The best of the best',11,'2020-11-05 02:00','2020-11-05 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_305','The best of the best',11,'2020-11-06 02:00','2020-11-06 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_306','The best of the best',11,'2020-11-07 02:00','2020-11-07 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_307','The best of the best',11,'2020-11-08 02:00','2020-11-08 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_308','The best of the best',11,'2020-11-09 02:00','2020-11-09 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_309','The best of the best',11,'2020-11-10 02:00','2020-11-10 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_310','The best of the best',11,'2020-11-11 02:00','2020-11-11 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_311','The best of the best',11,'2020-11-12 02:00','2020-11-12 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_312','The best of the best',11,'2020-11-13 02:00','2020-11-13 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_313','The best of the best',11,'2020-11-14 02:00','2020-11-14 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_314','The best of the best',11,'2020-11-15 02:00','2020-11-15 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_315','The best of the best',11,'2020-11-16 02:00','2020-11-16 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_316','The best of the best',11,'2020-11-17 02:00','2020-11-17 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_317','The best of the best',11,'2020-11-18 02:00','2020-11-18 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_318','The best of the best',11,'2020-11-19 02:00','2020-11-19 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_319','The best of the best',11,'2020-11-20 02:00','2020-11-20 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_320','The best of the best',11,'2020-11-21 02:00','2020-11-21 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_321','The best of the best',11,'2020-11-22 02:00','2020-11-22 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_322','The best of the best',11,'2020-11-23 02:00','2020-11-23 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_323','The best of the best',11,'2020-11-24 02:00','2020-11-24 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_324','The best of the best',11,'2020-11-25 02:00','2020-11-25 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_325','The best of the best',11,'2020-11-26 02:00','2020-11-26 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_326','The best of the best',11,'2020-11-27 02:00','2020-11-27 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_327','The best of the best',11,'2020-11-28 02:00','2020-11-28 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_328','The best of the best',11,'2020-11-29 02:00','2020-11-29 19:00',17,11,250,0.5),
                                                                                                                    ('Mozart Art_329','The best of the best',11,'2020-11-30 02:00','2020-11-30 19:00',17,11,250,0.5),

                                                                                                                    ('Mozart Art_330','The best of the best',12,'2020-12-01 02:00','2020-12-01 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_331','The best of the best',12,'2020-12-02 02:00','2020-12-02 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_332','The best of the best',12,'2020-12-03 02:00','2020-12-03 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_333','The best of the best',12,'2020-12-04 02:00','2020-12-04 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_334','The best of the best',12,'2020-12-05 02:00','2020-12-05 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_335','The best of the best',12,'2020-12-06 02:00','2020-12-06 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_336','The best of the best',12,'2020-12-07 02:00','2020-12-07 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_337','The best of the best',12,'2020-12-08 02:00','2020-12-08 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_338','The best of the best',12,'2020-12-09 02:00','2020-12-09 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_339','The best of the best',12,'2020-12-10 02:00','2020-12-10 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_340','The best of the best',12,'2020-12-11 02:00','2020-12-11 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_341','The best of the best',12,'2020-12-12 02:00','2020-12-12 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_342','The best of the best',12,'2020-12-13 02:00','2020-12-13 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_343','The best of the best',12,'2020-12-14 02:00','2020-12-14 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_344','The best of the best',12,'2020-12-15 02:00','2020-12-15 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_345','The best of the best',12,'2020-12-16 02:00','2020-12-16 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_346','The best of the best',12,'2020-12-17 02:00','2020-12-17 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_347','The best of the best',12,'2020-12-18 02:00','2020-12-18 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_348','The best of the best',12,'2020-12-19 02:00','2020-12-19 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_349','The best of the best',12,'2020-12-20 02:00','2020-12-20 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_350','The best of the best',12,'2020-12-21 02:00','2020-12-21 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_351','The best of the best',12,'2020-12-22 02:00','2020-12-22 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_352','The best of the best',12,'2020-12-23 02:00','2020-12-23 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_353','The best of the best',12,'2020-12-24 02:00','2020-12-24 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_354','The best of the best',12,'2020-12-25 02:00','2020-12-25 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_355','The best of the best',12,'2020-12-26 02:00','2020-12-26 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_356','The best of the best',12,'2020-12-27 02:00','2020-12-27 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_357','The best of the best',12,'2020-12-28 02:00','2020-12-28 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_358','The best of the best',12,'2020-12-29 02:00','2020-12-29 19:00',17,12,250,0.5),
                                                                                                                    ('Mozart Art_359','The best of the best',12,'2020-12-30 02:00','2020-12-30 19:00',17,12,250,0.5),





                                                                                                                    ('Bethoven Art_1','The best of the best_1',1,'2021-01-01 02:00','2021-01-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_2','The best of the best',1,'2021-01-02 02:00','2021-01-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_3','The best of the best',1,'2021-01-03 02:00','2021-01-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_4','The best of the best',1,'2021-01-04 02:00','2021-01-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_5','The best of the best',1,'2021-01-05 02:00','2021-01-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_6','The best of the best',1,'2021-01-06 02:00','2021-01-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_7','The best of the best',1,'2021-01-07 02:00','2021-01-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_8','The best of the best',1,'2021-01-08 02:00','2021-01-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_9','The best of the best',1,'2021-01-09 02:00','2021-01-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_10','The best of the best',1,'2021-01-10 02:00','2021-01-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_11','The best of the best',1,'2021-01-11 02:00','2021-01-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_12','The best of the best',1,'2021-01-12 02:00','2021-01-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_13','The best of the best',1,'2021-01-13 02:00','2021-01-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_14','The best of the best',1,'2021-01-14 02:00','2021-01-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_15','The best of the best',1,'2021-01-15 02:00','2021-01-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_16','The best of the best',1,'2021-01-16 02:00','2021-01-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_17','The best of the best',1,'2021-01-17 02:00','2021-01-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_18','The best of the best',1,'2021-01-18 02:00','2021-01-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_19','The best of the best',1,'2021-01-19 02:00','2021-01-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_20','The best of the best',1,'2021-01-20 02:00','2021-01-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_21','The best of the best',1,'2021-01-21 02:00','2021-01-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_22','The best of the best',1,'2021-01-22 02:00','2021-01-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_23','The best of the best',1,'2021-01-23 02:00','2021-01-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_24','The best of the best',1,'2021-01-24 02:00','2021-01-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_25','The best of the best',1,'2021-01-25 02:00','2021-01-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_26','The best of the best',1,'2021-01-26 02:00','2021-01-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_27','The best of the best',1,'2021-01-27 02:00','2021-01-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_28','The best of the best',1,'2021-01-28 02:00','2021-01-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_29','The best of the best',1,'2021-01-29 02:00','2021-01-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_30','The best of the best',1,'2021-01-30 02:00','2021-01-30 19:00',17,1,250,0.5),

                                                                                                                  ('Bethoven Art_31','The best of the best',1,'2021-02-01 02:00','2021-02-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_32','The best of the best',1,'2021-02-02 02:00','2021-02-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_33','The best of the best',1,'2021-02-03 02:00','2021-02-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_34','The best of the best',1,'2021-02-04 02:00','2021-02-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_35','The best of the best',1,'2021-02-05 02:00','2021-02-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_36','The best of the best',1,'2021-02-06 02:00','2021-02-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_37','The best of the best',1,'2021-02-07 02:00','2021-02-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_38','The best of the best',1,'2021-02-08 02:00','2021-02-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_39','The best of the best',1,'2021-02-09 02:00','2021-02-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_40','The best of the best',1,'2021-02-10 02:00','2021-02-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_41','The best of the best',1,'2021-02-11 02:00','2021-02-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_42','The best of the best',1,'2021-02-12 02:00','2021-02-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_43','The best of the best',1,'2021-02-13 02:00','2021-02-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_44','The best of the best',1,'2021-02-14 02:00','2021-02-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_45','The best of the best',1,'2021-02-15 02:00','2021-02-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_46','The best of the best',1,'2021-02-16 02:00','2021-02-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_47','The best of the best',1,'2021-02-17 02:00','2021-02-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_48','The best of the best',1,'2021-02-18 02:00','2021-02-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_49','The best of the best',1,'2021-02-19 02:00','2021-02-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_50','The best of the best',1,'2021-02-20 02:00','2021-02-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_51','The best of the best',1,'2021-02-21 02:00','2021-02-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_52','The best of the best',1,'2021-02-22 02:00','2021-02-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_53','The best of the best',1,'2021-02-23 02:00','2021-02-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_54','The best of the best',1,'2021-02-24 02:00','2021-02-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_55','The best of the best',1,'2021-02-25 02:00','2021-02-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_56','The best of the best',1,'2021-02-26 02:00','2021-02-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_57','The best of the best',1,'2021-02-27 02:00','2021-02-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_58','The best of the best',1,'2021-02-28 02:00','2021-02-28 19:00',17,1,250,0.5),

                                                                                                                    ('Bethoven Art_60','The best of the best',1,'2021-03-01 02:00','2021-03-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_61','The best of the best',1,'2021-03-02 02:00','2021-03-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_62','The best of the best',1,'2021-03-03 02:00','2021-03-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_63','The best of the best',1,'2021-03-04 02:00','2021-03-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_64','The best of the best',1,'2021-03-05 02:00','2021-03-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_65','The best of the best',1,'2021-03-06 02:00','2021-03-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_66','The best of the best',1,'2021-03-07 02:00','2021-03-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_67','The best of the best',1,'2021-03-08 02:00','2021-03-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_68','The best of the best',1,'2021-03-09 02:00','2021-03-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_69','The best of the best',1,'2021-03-10 02:00','2021-03-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_70','The best of the best',1,'2021-03-11 02:00','2021-03-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_71','The best of the best',1,'2021-03-12 02:00','2021-03-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_72','The best of the best',1,'2021-03-13 02:00','2021-03-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_73','The best of the best',1,'2021-03-14 02:00','2021-03-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_74','The best of the best',1,'2021-03-15 02:00','2021-03-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_75','The best of the best',1,'2021-03-16 02:00','2021-03-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_76','The best of the best',1,'2021-03-17 02:00','2021-03-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_77','The best of the best',1,'2021-03-18 02:00','2021-03-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_78','The best of the best',1,'2021-03-19 02:00','2021-03-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_79','The best of the best',1,'2021-03-20 02:00','2021-03-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_80','The best of the best',1,'2021-03-21 02:00','2021-03-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_81','The best of the best',1,'2021-03-22 02:00','2021-03-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_82','The best of the best',1,'2021-03-23 02:00','2021-03-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_83','The best of the best',1,'2021-03-24 02:00','2021-03-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_84','The best of the best',1,'2021-03-25 02:00','2021-03-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_85','The best of the best',1,'2021-03-26 02:00','2021-03-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_86','The best of the best',1,'2021-03-27 02:00','2021-03-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_87','The best of the best',1,'2021-03-28 02:00','2021-03-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_88','The best of the best',1,'2021-03-29 02:00','2021-03-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_89','The best of the best',1,'2021-03-30 02:00','2021-03-30 19:00',17,1,250,0.5),

                                                                                                                   ('Bethoven Art_90','The best of the best',1,'2021-04-01 02:00','2021-04-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_91','The best of the best',1,'2021-04-02 02:00','2021-04-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_92','The best of the best',1,'2021-04-03 02:00','2021-04-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_93','The best of the best',1,'2021-04-04 02:00','2021-04-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_94','The best of the best',1,'2021-04-05 02:00','2021-04-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_95','The best of the best',1,'2021-04-06 02:00','2021-04-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_96','The best of the best',1,'2021-04-07 02:00','2021-04-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_97','The best of the best',1,'2021-04-08 02:00','2021-04-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_98','The best of the best',1,'2021-04-09 02:00','2021-04-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_99','The best of the best',1,'2021-04-10 02:00','2021-04-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_100','The best of the best',1,'2021-04-11 02:00','2021-04-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_101','The best of the best',1,'2021-04-12 02:00','2021-04-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_102','The best of the best',1,'2021-04-13 02:00','2021-04-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_103','The best of the best',1,'2021-04-14 02:00','2021-04-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_104','The best of the best',1,'2021-04-15 02:00','2021-04-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_105','The best of the best',1,'2021-04-16 02:00','2021-04-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_106','The best of the best',1,'2021-04-17 02:00','2021-04-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_107','The best of the best',1,'2021-04-18 02:00','2021-04-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_108','The best of the best',1,'2021-04-19 02:00','2021-04-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_109','The best of the best',1,'2021-04-20 02:00','2021-04-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_110','The best of the best',1,'2021-04-21 02:00','2021-04-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_111','The best of the best',1,'2021-04-22 02:00','2021-04-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_112','The best of the best',1,'2021-04-23 02:00','2021-04-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_113','The best of the best',1,'2021-04-24 02:00','2021-04-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_114','The best of the best',1,'2021-04-25 02:00','2021-04-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_115','The best of the best',1,'2021-04-26 02:00','2021-04-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_116','The best of the best',1,'2021-04-27 02:00','2021-04-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_117','The best of the best',1,'2021-04-28 02:00','2021-04-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_118','The best of the best',1,'2021-04-29 02:00','2021-04-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_119','The best of the best',1,'2021-04-30 02:00','2021-04-30 19:00',17,1,250,0.5),

                                                                                                                    ('Bethoven Art_120','The best of the best',1,'2021-05-01 02:00','2021-05-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_121','The best of the best',1,'2021-05-02 02:00','2021-05-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_122','The best of the best',1,'2021-05-03 02:00','2021-05-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_123','The best of the best',1,'2021-05-04 02:00','2021-05-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_124','The best of the best',1,'2021-05-05 02:00','2021-05-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_125','The best of the best',1,'2021-05-06 02:00','2021-05-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_126','The best of the best',1,'2021-05-07 02:00','2021-05-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_127','The best of the best',1,'2021-05-08 02:00','2021-05-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_128','The best of the best',1,'2021-05-09 02:00','2021-05-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_129','The best of the best',1,'2021-05-10 02:00','2021-05-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_130','The best of the best',1,'2021-05-11 02:00','2021-05-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_131','The best of the best',1,'2021-05-12 02:00','2021-05-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_132','The best of the best',1,'2021-05-13 02:00','2021-05-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_133','The best of the best',1,'2021-05-14 02:00','2021-05-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_134','The best of the best',1,'2021-05-15 02:00','2021-05-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_135','The best of the best',1,'2021-05-16 02:00','2021-05-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_136','The best of the best',1,'2021-05-17 02:00','2021-05-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_137','The best of the best',1,'2021-05-18 02:00','2021-05-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_138','The best of the best',1,'2021-05-19 02:00','2021-05-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_139','The best of the best',1,'2021-05-20 02:00','2021-05-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_140','The best of the best',1,'2021-05-21 02:00','2021-05-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_141','The best of the best',1,'2021-05-22 02:00','2021-05-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_142','The best of the best',1,'2021-05-23 02:00','2021-05-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_143','The best of the best',1,'2021-05-24 02:00','2021-05-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_144','The best of the best',1,'2021-05-25 02:00','2021-05-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_145','The best of the best',1,'2021-05-26 02:00','2021-05-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_146','The best of the best',1,'2021-05-27 02:00','2021-05-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_147','The best of the best',1,'2021-05-28 02:00','2021-05-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_148','The best of the best',1,'2021-05-29 02:00','2021-05-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_149','The best of the best',1,'2021-05-30 02:00','2021-05-30 19:00',17,1,250,0.5),

                                                                                                                   ('Bethoven Art_150','The best of the best',1,'2021-06-01 02:00','2021-06-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_151','The best of the best',1,'2021-06-02 02:00','2021-06-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_152','The best of the best',1,'2021-06-03 02:00','2021-06-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_153','The best of the best',1,'2021-06-04 02:00','2021-06-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_154','The best of the best',1,'2021-06-05 02:00','2021-06-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_155','The best of the best',1,'2021-06-06 02:00','2021-06-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_156','The best of the best',1,'2021-06-07 02:00','2021-06-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_157','The best of the best',1,'2021-06-08 02:00','2021-06-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_158','The best of the best',1,'2021-06-09 02:00','2021-06-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_159','The best of the best',1,'2021-06-10 02:00','2021-06-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_160','The best of the best',1,'2021-06-11 02:00','2021-06-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_161','The best of the best',1,'2021-06-12 02:00','2021-06-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_162','The best of the best',1,'2021-06-13 02:00','2021-06-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_163','The best of the best',1,'2021-06-14 02:00','2021-06-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_164','The best of the best',1,'2021-06-15 02:00','2021-06-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_165','The best of the best',1,'2021-06-16 02:00','2021-06-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_166','The best of the best',1,'2021-06-17 02:00','2021-06-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_167','The best of the best',1,'2021-06-18 02:00','2021-06-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_168','The best of the best',1,'2021-06-19 02:00','2021-06-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_169','The best of the best',1,'2021-06-20 02:00','2021-06-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_170','The best of the best',1,'2021-06-21 02:00','2021-06-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_171','The best of the best',1,'2021-06-22 02:00','2021-06-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_172','The best of the best',1,'2021-06-23 02:00','2021-06-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_173','The best of the best',1,'2021-06-24 02:00','2021-06-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_174','The best of the best',1,'2021-06-25 02:00','2021-06-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_175','The best of the best',1,'2021-06-26 02:00','2021-06-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_176','The best of the best',1,'2021-06-27 02:00','2021-06-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_177','The best of the best',1,'2021-06-28 02:00','2021-06-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_178','The best of the best',1,'2021-06-29 02:00','2021-06-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_179','The best of the best',1,'2021-06-30 02:00','2021-06-30 19:00',17,1,250,0.5),

                                                                                                                 ('Bethoven Art_180','The best of the best',1,'2021-07-01 02:00','2021-07-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_181','The best of the best',1,'2021-07-02 02:00','2021-07-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_182','The best of the best',1,'2021-07-03 02:00','2021-07-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_183','The best of the best',1,'2021-07-04 02:00','2021-07-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_184','The best of the best',1,'2021-07-05 02:00','2021-07-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_185','The best of the best',1,'2021-07-06 02:00','2021-07-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_186','The best of the best',1,'2021-07-07 02:00','2021-07-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_187','The best of the best',1,'2021-07-08 02:00','2021-07-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_188','The best of the best',1,'2021-07-09 02:00','2021-07-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_189','The best of the best',1,'2021-07-10 02:00','2021-07-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_190','The best of the best',1,'2021-07-11 02:00','2021-07-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_191','The best of the best',1,'2021-07-12 02:00','2021-07-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_192','The best of the best',1,'2021-07-13 02:00','2021-07-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_193','The best of the best',1,'2021-07-14 02:00','2021-07-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_194','The best of the best',1,'2021-07-15 02:00','2021-07-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_195','The best of the best',1,'2021-07-16 02:00','2021-07-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_196','The best of the best',1,'2021-07-17 02:00','2021-07-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_197','The best of the best',1,'2021-07-18 02:00','2021-07-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_198','The best of the best',1,'2021-07-19 02:00','2021-07-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_199','The best of the best',1,'2021-07-20 02:00','2021-07-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_200','The best of the best',1,'2021-07-21 02:00','2021-07-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_201','The best of the best',1,'2021-07-22 02:00','2021-07-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_202','The best of the best',1,'2021-07-23 02:00','2021-07-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_203','The best of the best',1,'2021-07-24 02:00','2021-07-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_204','The best of the best',1,'2021-07-25 02:00','2021-07-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_205','The best of the best',1,'2021-07-26 02:00','2021-07-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_206','The best of the best',1,'2021-07-27 02:00','2021-07-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_207','The best of the best',1,'2021-07-28 02:00','2021-07-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_208','The best of the best',1,'2021-07-29 02:00','2021-07-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_209','The best of the best',1,'2021-07-30 02:00','2021-07-30 19:00',17,1,250,0.5),

                                                                                                                    ('Bethoven Art_210','The best of the best',1,'2021-08-01 02:00','2021-08-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_211','The best of the best',1,'2021-08-02 02:00','2021-08-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_212','The best of the best',1,'2021-08-03 02:00','2021-08-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_213','The best of the best',1,'2021-08-04 02:00','2021-08-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_214','The best of the best',1,'2021-08-05 02:00','2021-08-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_215','The best of the best',1,'2021-08-06 02:00','2021-08-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_216','The best of the best',1,'2021-08-07 02:00','2021-08-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_217','The best of the best',1,'2021-08-08 02:00','2021-08-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_218','The best of the best',1,'2021-08-09 02:00','2021-08-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_219','The best of the best',1,'2021-08-10 02:00','2021-08-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_220','The best of the best',1,'2021-08-11 02:00','2021-08-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_221','The best of the best',1,'2021-08-12 02:00','2021-08-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_222','The best of the best',1,'2021-08-13 02:00','2021-08-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_223','The best of the best',1,'2021-08-14 02:00','2021-08-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_224','The best of the best',1,'2021-08-15 02:00','2021-08-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_225','The best of the best',1,'2021-08-16 02:00','2021-08-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_226','The best of the best',1,'2021-08-17 02:00','2021-08-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_227','The best of the best',1,'2021-08-18 02:00','2021-08-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_228','The best of the best',1,'2021-08-19 02:00','2021-08-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_229','The best of the best',1,'2021-08-20 02:00','2021-08-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_230','The best of the best',1,'2021-08-21 02:00','2021-08-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_231','The best of the best',1,'2021-08-22 02:00','2021-08-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_232','The best of the best',1,'2021-08-23 02:00','2021-08-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_233','The best of the best',1,'2021-08-24 02:00','2021-08-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_234','The best of the best',1,'2021-08-25 02:00','2021-08-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_235','The best of the best',1,'2021-08-26 02:00','2021-08-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_236','The best of the best',1,'2021-08-27 02:00','2021-08-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_237','The best of the best',1,'2021-08-28 02:00','2021-08-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_238','The best of the best',1,'2021-08-29 02:00','2021-08-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_239','The best of the best',1,'2021-08-30 02:00','2021-08-30 19:00',17,1,250,0.5),

                                                                                                                   ('Bethoven Art_240','The best of the best',1,'2021-09-01 02:00','2021-09-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_241','The best of the best',1,'2021-09-02 02:00','2021-09-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_242','The best of the best',1,'2021-09-03 02:00','2021-09-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_243','The best of the best',1,'2021-09-04 02:00','2021-09-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_244','The best of the best',1,'2021-09-05 02:00','2021-09-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_245','The best of the best',1,'2021-09-06 02:00','2021-09-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_246','The best of the best',1,'2021-09-07 02:00','2021-09-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_247','The best of the best',1,'2021-09-08 02:00','2021-09-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_248','The best of the best',1,'2021-09-09 02:00','2021-09-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_249','The best of the best',1,'2021-09-10 02:00','2021-09-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_250','The best of the best',1,'2021-09-11 02:00','2021-09-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_251','The best of the best',1,'2021-09-12 02:00','2021-09-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_252','The best of the best',1,'2021-09-13 02:00','2021-09-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_253','The best of the best',1,'2021-09-14 02:00','2021-09-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_254','The best of the best',1,'2021-09-15 02:00','2021-09-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_255','The best of the best',1,'2021-09-16 02:00','2021-09-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_256','The best of the best',1,'2021-09-17 02:00','2021-09-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_257','The best of the best',1,'2021-09-18 02:00','2021-09-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_258','The best of the best',1,'2021-09-19 02:00','2021-09-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_259','The best of the best',1,'2021-09-20 02:00','2021-09-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_260','The best of the best',1,'2021-09-21 02:00','2021-09-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_261','The best of the best',1,'2021-09-22 02:00','2021-09-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_262','The best of the best',1,'2021-09-23 02:00','2021-09-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_263','The best of the best',1,'2021-09-24 02:00','2021-09-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_264','The best of the best',1,'2021-09-25 02:00','2021-09-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_265','The best of the best',1,'2021-09-26 02:00','2021-09-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_266','The best of the best',1,'2021-09-27 02:00','2021-09-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_267','The best of the best',1,'2021-09-28 02:00','2021-09-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_268','The best of the best',1,'2021-09-29 02:00','2021-09-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_269','The best of the best',1,'2021-09-30 02:00','2021-09-30 19:00',17,1,250,0.5),

                                                                                                                  ('Bethoven Art_270','The best of the best',1,'2021-10-01 02:00','2021-10-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_271','The best of the best',1,'2021-10-02 02:00','2021-10-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_272','The best of the best',1,'2021-10-03 02:00','2021-10-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_273','The best of the best',1,'2021-10-04 02:00','2021-10-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_274','The best of the best',1,'2021-10-05 02:00','2021-10-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_275','The best of the best',1,'2021-10-06 02:00','2021-10-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_276','The best of the best',1,'2021-10-07 02:00','2021-10-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_277','The best of the best',1,'2021-10-08 02:00','2021-10-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_278','The best of the best',1,'2021-10-09 02:00','2021-10-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_279','The best of the best',1,'2021-10-10 02:00','2021-10-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_280','The best of the best',1,'2021-10-11 02:00','2021-10-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_281','The best of the best',1,'2021-10-12 02:00','2021-10-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_282','The best of the best',1,'2021-10-13 02:00','2021-10-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_283','The best of the best',1,'2021-10-14 02:00','2021-10-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_284','The best of the best',1,'2021-10-15 02:00','2021-10-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_285','The best of the best',1,'2021-10-16 02:00','2021-10-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_286','The best of the best',1,'2021-10-17 02:00','2021-10-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_287','The best of the best',1,'2021-10-18 02:00','2021-10-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_288','The best of the best',1,'2021-10-19 02:00','2021-10-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_289','The best of the best',1,'2021-10-20 02:00','2021-10-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_290','The best of the best',1,'2021-10-21 02:00','2021-10-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_291','The best of the best',1,'2021-10-22 02:00','2021-10-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_292','The best of the best',1,'2021-10-23 02:00','2021-10-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_293','The best of the best',1,'2021-10-24 02:00','2021-10-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_294','The best of the best',1,'2021-10-25 02:00','2021-10-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_295','The best of the best',1,'2021-10-26 02:00','2021-10-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_296','The best of the best',1,'2021-10-27 02:00','2021-10-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_297','The best of the best',1,'2021-10-28 02:00','2021-10-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_298','The best of the best',1,'2021-10-29 02:00','2021-10-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_299','The best of the best',1,'2021-10-30 02:00','2021-10-30 19:00',17,1,250,0.5),

                                                                                                                    ('Bethoven Art_300','The best of the best',1,'2021-11-01 02:00','2021-11-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_301','The best of the best',1,'2021-11-02 02:00','2021-11-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_302','The best of the best',1,'2021-11-03 02:00','2021-11-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_303','The best of the best',1,'2021-11-04 02:00','2021-11-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_304','The best of the best',1,'2021-11-05 02:00','2021-11-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_305','The best of the best',1,'2021-11-06 02:00','2021-11-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_306','The best of the best',1,'2021-11-07 02:00','2021-11-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_307','The best of the best',1,'2021-11-08 02:00','2021-11-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_308','The best of the best',1,'2021-11-09 02:00','2021-11-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_309','The best of the best',1,'2021-11-10 02:00','2021-11-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_310','The best of the best',1,'2021-11-11 02:00','2021-11-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_311','The best of the best',1,'2021-11-12 02:00','2021-11-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_312','The best of the best',1,'2021-11-13 02:00','2021-11-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_313','The best of the best',1,'2021-11-14 02:00','2021-11-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_314','The best of the best',1,'2021-11-15 02:00','2021-11-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_315','The best of the best',1,'2021-11-16 02:00','2021-11-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_316','The best of the best',1,'2021-11-17 02:00','2021-11-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_317','The best of the best',1,'2021-11-18 02:00','2021-11-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_318','The best of the best',1,'2021-11-19 02:00','2021-11-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_319','The best of the best',1,'2021-11-20 02:00','2021-11-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_320','The best of the best',1,'2021-11-21 02:00','2021-11-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_321','The best of the best',1,'2021-11-22 02:00','2021-11-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_322','The best of the best',1,'2021-11-23 02:00','2021-11-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_323','The best of the best',1,'2021-11-24 02:00','2021-11-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_324','The best of the best',1,'2021-11-25 02:00','2021-11-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_325','The best of the best',1,'2021-11-26 02:00','2021-11-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_326','The best of the best',1,'2021-11-27 02:00','2021-11-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_327','The best of the best',1,'2021-11-28 02:00','2021-11-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_328','The best of the best',1,'2021-11-29 02:00','2021-11-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_329','The best of the best',1,'2021-11-30 02:00','2021-11-30 19:00',17,1,250,0.5),

                                                                                                                    ('Bethoven Art_330','The best of the best',1,'2021-12-01 02:00','2021-12-01 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_331','The best of the best',1,'2021-12-02 02:00','2021-12-02 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_332','The best of the best',1,'2021-12-03 02:00','2021-12-03 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_333','The best of the best',1,'2021-12-04 02:00','2021-12-04 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_334','The best of the best',1,'2021-12-05 02:00','2021-12-05 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_335','The best of the best',1,'2021-12-06 02:00','2021-12-06 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_336','The best of the best',1,'2021-12-07 02:00','2021-12-07 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_337','The best of the best',1,'2021-12-08 02:00','2021-12-08 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_338','The best of the best',1,'2021-12-09 02:00','2021-12-09 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_339','The best of the best',1,'2021-12-10 02:00','2021-12-10 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_340','The best of the best',1,'2021-12-11 02:00','2021-12-11 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_341','The best of the best',1,'2021-12-12 02:00','2021-12-12 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_342','The best of the best',1,'2021-12-13 02:00','2021-12-13 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_343','The best of the best',1,'2021-12-14 02:00','2021-12-14 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_344','The best of the best',1,'2021-12-15 02:00','2021-12-15 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_345','The best of the best',1,'2021-12-16 02:00','2021-12-16 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_346','The best of the best',1,'2021-12-17 02:00','2021-12-17 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_347','The best of the best',1,'2021-12-18 02:00','2021-12-18 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_348','The best of the best',1,'2021-12-19 02:00','2021-12-19 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_349','The best of the best',1,'2021-12-20 02:00','2021-12-20 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_350','The best of the best',1,'2021-12-21 02:00','2021-12-21 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_351','The best of the best',1,'2021-12-22 02:00','2021-12-22 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_352','The best of the best',1,'2021-12-23 02:00','2021-12-23 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_353','The best of the best',1,'2021-12-24 02:00','2021-12-24 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_354','The best of the best',1,'2021-12-25 02:00','2021-12-25 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_355','The best of the best',1,'2021-12-26 02:00','2021-12-26 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_356','The best of the best',1,'2021-12-27 02:00','2021-12-27 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_357','The best of the best',1,'2021-12-28 02:00','2021-12-28 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_358','The best of the best',1,'2021-12-29 02:00','2021-12-29 19:00',17,1,250,0.5),
                                                                                                                    ('Bethoven Art_359','The best of the best',1,'2021-12-30 02:00','2021-12-30 19:00',17,1,250,0.5),




                                                                                                                    ('LeonardDavinci Art_1','The best of the best_1',1,'2022-01-01 02:00','2022-01-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_2','The best of the best',1,'2022-01-02 02:00','2022-01-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_3','The best of the best',1,'2022-01-03 02:00','2022-01-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_4','The best of the best',1,'2022-01-04 02:00','2022-01-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_5','The best of the best',1,'2022-01-05 02:00','2022-01-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_6','The best of the best',1,'2022-01-06 02:00','2022-01-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_7','The best of the best',1,'2022-01-07 02:00','2022-01-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_8','The best of the best',1,'2022-01-08 02:00','2022-01-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_9','The best of the best',1,'2022-01-09 02:00','2022-01-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_10','The best of the best',1,'2022-01-10 02:00','2022-01-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_11','The best of the best',1,'2022-01-11 02:00','2022-01-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_12','The best of the best',1,'2022-01-12 02:00','2022-01-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_13','The best of the best',1,'2022-01-13 02:00','2022-01-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_14','The best of the best',1,'2022-01-14 02:00','2022-01-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_15','The best of the best',1,'2022-01-15 02:00','2022-01-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_16','The best of the best',1,'2022-01-16 02:00','2022-01-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_17','The best of the best',1,'2022-01-17 02:00','2022-01-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_18','The best of the best',1,'2022-01-18 02:00','2022-01-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_19','The best of the best',1,'2022-01-19 02:00','2022-01-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_20','The best of the best',1,'2022-01-20 02:00','2022-01-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_21','The best of the best',1,'2022-01-21 02:00','2022-01-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_22','The best of the best',1,'2022-01-22 02:00','2022-01-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_23','The best of the best',1,'2022-01-23 02:00','2022-01-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_24','The best of the best',1,'2022-01-24 02:00','2022-01-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_25','The best of the best',1,'2022-01-25 02:00','2022-01-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_26','The best of the best',1,'2022-01-26 02:00','2022-01-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_27','The best of the best',1,'2022-01-27 02:00','2022-01-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_28','The best of the best',1,'2022-01-28 02:00','2022-01-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_29','The best of the best',1,'2022-01-29 02:00','2022-01-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_30','The best of the best',1,'2022-01-30 02:00','2022-01-30 19:00',17,1,250,0.5),

                                                                                                                  ('LeonardDavinci Art_31','The best of the best',1,'2022-02-01 02:00','2022-02-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_32','The best of the best',1,'2022-02-02 02:00','2022-02-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_33','The best of the best',1,'2022-02-03 02:00','2022-02-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_34','The best of the best',1,'2022-02-04 02:00','2022-02-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_35','The best of the best',1,'2022-02-05 02:00','2022-02-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_36','The best of the best',1,'2022-02-06 02:00','2022-02-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_37','The best of the best',1,'2022-02-07 02:00','2022-02-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_38','The best of the best',1,'2022-02-08 02:00','2022-02-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_39','The best of the best',1,'2022-02-09 02:00','2022-02-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_40','The best of the best',1,'2022-02-10 02:00','2022-02-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_41','The best of the best',1,'2022-02-11 02:00','2022-02-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_42','The best of the best',1,'2022-02-12 02:00','2022-02-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_43','The best of the best',1,'2022-02-13 02:00','2022-02-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_44','The best of the best',1,'2022-02-14 02:00','2022-02-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_45','The best of the best',1,'2022-02-15 02:00','2022-02-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_46','The best of the best',1,'2022-02-16 02:00','2022-02-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_47','The best of the best',1,'2022-02-17 02:00','2022-02-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_48','The best of the best',1,'2022-02-18 02:00','2022-02-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_49','The best of the best',1,'2022-02-19 02:00','2022-02-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_50','The best of the best',1,'2022-02-20 02:00','2022-02-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_51','The best of the best',1,'2022-02-21 02:00','2022-02-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_52','The best of the best',1,'2022-02-22 02:00','2022-02-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_53','The best of the best',1,'2022-02-23 02:00','2022-02-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_54','The best of the best',1,'2022-02-24 02:00','2022-02-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_55','The best of the best',1,'2022-02-25 02:00','2022-02-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_56','The best of the best',1,'2022-02-26 02:00','2022-02-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_57','The best of the best',1,'2022-02-27 02:00','2022-02-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_58','The best of the best',1,'2022-02-28 02:00','2022-02-28 19:00',17,1,250,0.5),
                                                                                                              

                                                                                                                    ('LeonardDavinci Art_60','The best of the best',1,'2022-03-01 02:00','2022-03-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_61','The best of the best',1,'2022-03-02 02:00','2022-03-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_62','The best of the best',1,'2022-03-03 02:00','2022-03-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_63','The best of the best',1,'2022-03-04 02:00','2022-03-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_64','The best of the best',1,'2022-03-05 02:00','2022-03-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_65','The best of the best',1,'2022-03-06 02:00','2022-03-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_66','The best of the best',1,'2022-03-07 02:00','2022-03-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_67','The best of the best',1,'2022-03-08 02:00','2022-03-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_68','The best of the best',1,'2022-03-09 02:00','2022-03-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_69','The best of the best',1,'2022-03-10 02:00','2022-03-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_70','The best of the best',1,'2022-03-11 02:00','2022-03-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_71','The best of the best',1,'2022-03-12 02:00','2022-03-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_72','The best of the best',1,'2022-03-13 02:00','2022-03-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_73','The best of the best',1,'2022-03-14 02:00','2022-03-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_74','The best of the best',1,'2022-03-15 02:00','2022-03-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_75','The best of the best',1,'2022-03-16 02:00','2022-03-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_76','The best of the best',1,'2022-03-17 02:00','2022-03-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_77','The best of the best',1,'2022-03-18 02:00','2022-03-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_78','The best of the best',1,'2022-03-19 02:00','2022-03-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_79','The best of the best',1,'2022-03-20 02:00','2022-03-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_80','The best of the best',1,'2022-03-21 02:00','2022-03-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_81','The best of the best',1,'2022-03-22 02:00','2022-03-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_82','The best of the best',1,'2022-03-23 02:00','2022-03-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_83','The best of the best',1,'2022-03-24 02:00','2022-03-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_84','The best of the best',1,'2022-03-25 02:00','2022-03-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_85','The best of the best',1,'2022-03-26 02:00','2022-03-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_86','The best of the best',1,'2022-03-27 02:00','2022-03-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_87','The best of the best',1,'2022-03-28 02:00','2022-03-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_88','The best of the best',1,'2022-03-29 02:00','2022-03-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_89','The best of the best',1,'2022-03-30 02:00','2022-03-30 19:00',17,1,250,0.5),

                                                                                                                   ('LeonardDavinci Art_90','The best of the best',1,'2022-04-01 02:00','2022-04-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_91','The best of the best',1,'2022-04-02 02:00','2022-04-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_92','The best of the best',1,'2022-04-03 02:00','2022-04-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_93','The best of the best',1,'2022-04-04 02:00','2022-04-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_94','The best of the best',1,'2022-04-05 02:00','2022-04-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_95','The best of the best',1,'2022-04-06 02:00','2022-04-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_96','The best of the best',1,'2022-04-07 02:00','2022-04-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_97','The best of the best',1,'2022-04-08 02:00','2022-04-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_98','The best of the best',1,'2022-04-09 02:00','2022-04-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_99','The best of the best',1,'2022-04-10 02:00','2022-04-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_100','The best of the best',1,'2022-04-11 02:00','2022-04-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_101','The best of the best',1,'2022-04-12 02:00','2022-04-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_102','The best of the best',1,'2022-04-13 02:00','2022-04-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_103','The best of the best',1,'2022-04-14 02:00','2022-04-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_104','The best of the best',1,'2022-04-15 02:00','2022-04-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_105','The best of the best',1,'2022-04-16 02:00','2022-04-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_106','The best of the best',1,'2022-04-17 02:00','2022-04-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_107','The best of the best',1,'2022-04-18 02:00','2022-04-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_108','The best of the best',1,'2022-04-19 02:00','2022-04-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_109','The best of the best',1,'2022-04-20 02:00','2022-04-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_110','The best of the best',1,'2022-04-21 02:00','2022-04-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_111','The best of the best',1,'2022-04-22 02:00','2022-04-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_112','The best of the best',1,'2022-04-23 02:00','2022-04-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_113','The best of the best',1,'2022-04-24 02:00','2022-04-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_114','The best of the best',1,'2022-04-25 02:00','2022-04-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_115','The best of the best',1,'2022-04-26 02:00','2022-04-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_116','The best of the best',1,'2022-04-27 02:00','2022-04-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_117','The best of the best',1,'2022-04-28 02:00','2022-04-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_118','The best of the best',1,'2022-04-29 02:00','2022-04-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_119','The best of the best',1,'2022-04-30 02:00','2022-04-30 19:00',17,1,250,0.5),

                                                                                                                    ('LeonardDavinci Art_120','The best of the best',1,'2022-05-01 02:00','2022-05-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_121','The best of the best',1,'2022-05-02 02:00','2022-05-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_122','The best of the best',1,'2022-05-03 02:00','2022-05-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_123','The best of the best',1,'2022-05-04 02:00','2022-05-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_124','The best of the best',1,'2022-05-05 02:00','2022-05-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_125','The best of the best',1,'2022-05-06 02:00','2022-05-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_126','The best of the best',1,'2022-05-07 02:00','2022-05-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_127','The best of the best',1,'2022-05-08 02:00','2022-05-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_128','The best of the best',1,'2022-05-09 02:00','2022-05-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_129','The best of the best',1,'2022-05-10 02:00','2022-05-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_130','The best of the best',1,'2022-05-11 02:00','2022-05-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_131','The best of the best',1,'2022-05-12 02:00','2022-05-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_132','The best of the best',1,'2022-05-13 02:00','2022-05-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_133','The best of the best',1,'2022-05-14 02:00','2022-05-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_134','The best of the best',1,'2022-05-15 02:00','2022-05-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_135','The best of the best',1,'2022-05-16 02:00','2022-05-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_136','The best of the best',1,'2022-05-17 02:00','2022-05-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_137','The best of the best',1,'2022-05-18 02:00','2022-05-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_138','The best of the best',1,'2022-05-19 02:00','2022-05-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_139','The best of the best',1,'2022-05-20 02:00','2022-05-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_140','The best of the best',1,'2022-05-21 02:00','2022-05-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_141','The best of the best',1,'2022-05-22 02:00','2022-05-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_142','The best of the best',1,'2022-05-23 02:00','2022-05-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_143','The best of the best',1,'2022-05-24 02:00','2022-05-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_144','The best of the best',1,'2022-05-25 02:00','2022-05-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_145','The best of the best',1,'2022-05-26 02:00','2022-05-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_146','The best of the best',1,'2022-05-27 02:00','2022-05-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_147','The best of the best',1,'2022-05-28 02:00','2022-05-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_148','The best of the best',1,'2022-05-29 02:00','2022-05-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_149','The best of the best',1,'2022-05-30 02:00','2022-05-30 19:00',17,1,250,0.5),

                                                                                                                   ('LeonardDavinci Art_150','The best of the best',1,'2022-06-01 02:00','2022-06-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_151','The best of the best',1,'2022-06-02 02:00','2022-06-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_152','The best of the best',1,'2022-06-03 02:00','2022-06-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_153','The best of the best',1,'2022-06-04 02:00','2022-06-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_154','The best of the best',1,'2022-06-05 02:00','2022-06-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_155','The best of the best',1,'2022-06-06 02:00','2022-06-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_156','The best of the best',1,'2022-06-07 02:00','2022-06-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_157','The best of the best',1,'2022-06-08 02:00','2022-06-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_158','The best of the best',1,'2022-06-09 02:00','2022-06-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_159','The best of the best',1,'2022-06-10 02:00','2022-06-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_160','The best of the best',1,'2022-06-11 02:00','2022-06-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_161','The best of the best',1,'2022-06-12 02:00','2022-06-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_162','The best of the best',1,'2022-06-13 02:00','2022-06-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_163','The best of the best',1,'2022-06-14 02:00','2022-06-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_164','The best of the best',1,'2022-06-15 02:00','2022-06-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_165','The best of the best',1,'2022-06-16 02:00','2022-06-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_166','The best of the best',1,'2022-06-17 02:00','2022-06-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_167','The best of the best',1,'2022-06-18 02:00','2022-06-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_168','The best of the best',1,'2022-06-19 02:00','2022-06-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_169','The best of the best',1,'2022-06-20 02:00','2022-06-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_170','The best of the best',1,'2022-06-21 02:00','2022-06-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_171','The best of the best',1,'2022-06-22 02:00','2022-06-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_172','The best of the best',1,'2022-06-23 02:00','2022-06-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_173','The best of the best',1,'2022-06-24 02:00','2022-06-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_174','The best of the best',1,'2022-06-25 02:00','2022-06-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_175','The best of the best',1,'2022-06-26 02:00','2022-06-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_176','The best of the best',1,'2022-06-27 02:00','2022-06-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_177','The best of the best',1,'2022-06-28 02:00','2022-06-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_178','The best of the best',1,'2022-06-29 02:00','2022-06-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_179','The best of the best',1,'2022-06-30 02:00','2022-06-30 19:00',17,1,250,0.5),

                                                                                                                 ('LeonardDavinci Art_180','The best of the best',1,'2022-07-01 02:00','2022-07-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_181','The best of the best',1,'2022-07-02 02:00','2022-07-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_182','The best of the best',1,'2022-07-03 02:00','2022-07-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_183','The best of the best',1,'2022-07-04 02:00','2022-07-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_184','The best of the best',1,'2022-07-05 02:00','2022-07-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_185','The best of the best',1,'2022-07-06 02:00','2022-07-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_186','The best of the best',1,'2022-07-07 02:00','2022-07-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_187','The best of the best',1,'2022-07-08 02:00','2022-07-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_188','The best of the best',1,'2022-07-09 02:00','2022-07-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_189','The best of the best',1,'2022-07-10 02:00','2022-07-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_190','The best of the best',1,'2022-07-11 02:00','2022-07-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_191','The best of the best',1,'2022-07-12 02:00','2022-07-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_192','The best of the best',1,'2022-07-13 02:00','2022-07-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_193','The best of the best',1,'2022-07-14 02:00','2022-07-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_194','The best of the best',1,'2022-07-15 02:00','2022-07-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_195','The best of the best',1,'2022-07-16 02:00','2022-07-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_196','The best of the best',1,'2022-07-17 02:00','2022-07-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_197','The best of the best',1,'2022-07-18 02:00','2022-07-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_198','The best of the best',1,'2022-07-19 02:00','2022-07-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_199','The best of the best',1,'2022-07-20 02:00','2022-07-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_200','The best of the best',1,'2022-07-21 02:00','2022-07-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_201','The best of the best',1,'2022-07-22 02:00','2022-07-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_202','The best of the best',1,'2022-07-23 02:00','2022-07-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_203','The best of the best',1,'2022-07-24 02:00','2022-07-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_204','The best of the best',1,'2022-07-25 02:00','2022-07-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_205','The best of the best',1,'2022-07-26 02:00','2022-07-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_206','The best of the best',1,'2022-07-27 02:00','2022-07-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_207','The best of the best',1,'2022-07-28 02:00','2022-07-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_208','The best of the best',1,'2022-07-29 02:00','2022-07-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_209','The best of the best',1,'2022-07-30 02:00','2022-07-30 19:00',17,1,250,0.5),

                                                                                                                    ('LeonardDavinci Art_210','The best of the best',1,'2022-08-01 02:00','2022-08-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_211','The best of the best',1,'2022-08-02 02:00','2022-08-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_212','The best of the best',1,'2022-08-03 02:00','2022-08-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_213','The best of the best',1,'2022-08-04 02:00','2022-08-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_214','The best of the best',1,'2022-08-05 02:00','2022-08-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_215','The best of the best',1,'2022-08-06 02:00','2022-08-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_216','The best of the best',1,'2022-08-07 02:00','2022-08-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_217','The best of the best',1,'2022-08-08 02:00','2022-08-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_218','The best of the best',1,'2022-08-09 02:00','2022-08-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_219','The best of the best',1,'2022-08-10 02:00','2022-08-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_220','The best of the best',1,'2022-08-11 02:00','2022-08-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_221','The best of the best',1,'2022-08-12 02:00','2022-08-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_222','The best of the best',1,'2022-08-13 02:00','2022-08-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_223','The best of the best',1,'2022-08-14 02:00','2022-08-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_224','The best of the best',1,'2022-08-15 02:00','2022-08-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_225','The best of the best',1,'2022-08-16 02:00','2022-08-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_226','The best of the best',1,'2022-08-17 02:00','2022-08-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_227','The best of the best',1,'2022-08-18 02:00','2022-08-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_228','The best of the best',1,'2022-08-19 02:00','2022-08-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_229','The best of the best',1,'2022-08-20 02:00','2022-08-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_230','The best of the best',1,'2022-08-21 02:00','2022-08-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_231','The best of the best',1,'2022-08-22 02:00','2022-08-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_232','The best of the best',1,'2022-08-23 02:00','2022-08-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_233','The best of the best',1,'2022-08-24 02:00','2022-08-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_234','The best of the best',1,'2022-08-25 02:00','2022-08-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_235','The best of the best',1,'2022-08-26 02:00','2022-08-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_236','The best of the best',1,'2022-08-27 02:00','2022-08-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_237','The best of the best',1,'2022-08-28 02:00','2022-08-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_238','The best of the best',1,'2022-08-29 02:00','2022-08-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_239','The best of the best',1,'2022-08-30 02:00','2022-08-30 19:00',17,1,250,0.5),

                                                                                                                   ('LeonardDavinci Art_240','The best of the best',1,'2022-09-01 02:00','2022-09-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_241','The best of the best',1,'2022-09-02 02:00','2022-09-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_242','The best of the best',1,'2022-09-03 02:00','2022-09-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_243','The best of the best',1,'2022-09-04 02:00','2022-09-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_244','The best of the best',1,'2022-09-05 02:00','2022-09-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_245','The best of the best',1,'2022-09-06 02:00','2022-09-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_246','The best of the best',1,'2022-09-07 02:00','2022-09-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_247','The best of the best',1,'2022-09-08 02:00','2022-09-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_248','The best of the best',1,'2022-09-09 02:00','2022-09-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_249','The best of the best',1,'2022-09-10 02:00','2022-09-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_250','The best of the best',1,'2022-09-11 02:00','2022-09-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_251','The best of the best',1,'2022-09-12 02:00','2022-09-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_252','The best of the best',1,'2022-09-13 02:00','2022-09-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_253','The best of the best',1,'2022-09-14 02:00','2022-09-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_254','The best of the best',1,'2022-09-15 02:00','2022-09-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_255','The best of the best',1,'2022-09-16 02:00','2022-09-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_256','The best of the best',1,'2022-09-17 02:00','2022-09-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_257','The best of the best',1,'2022-09-18 02:00','2022-09-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_258','The best of the best',1,'2022-09-19 02:00','2022-09-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_259','The best of the best',1,'2022-09-20 02:00','2022-09-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_260','The best of the best',1,'2022-09-21 02:00','2022-09-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_261','The best of the best',1,'2022-09-22 02:00','2022-09-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_262','The best of the best',1,'2022-09-23 02:00','2022-09-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_263','The best of the best',1,'2022-09-24 02:00','2022-09-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_264','The best of the best',1,'2022-09-25 02:00','2022-09-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_265','The best of the best',1,'2022-09-26 02:00','2022-09-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_266','The best of the best',1,'2022-09-27 02:00','2022-09-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_267','The best of the best',1,'2022-09-28 02:00','2022-09-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_268','The best of the best',1,'2022-09-29 02:00','2022-09-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_269','The best of the best',1,'2022-09-30 02:00','2022-09-30 19:00',17,1,250,0.5),

                                                                                                                  ('LeonardDavinci Art_270','The best of the best',1,'2022-10-01 02:00','2022-10-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_271','The best of the best',1,'2022-10-02 02:00','2022-10-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_272','The best of the best',1,'2022-10-03 02:00','2022-10-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_273','The best of the best',1,'2022-10-04 02:00','2022-10-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_274','The best of the best',1,'2022-10-05 02:00','2022-10-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_275','The best of the best',1,'2022-10-06 02:00','2022-10-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_276','The best of the best',1,'2022-10-07 02:00','2022-10-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_277','The best of the best',1,'2022-10-08 02:00','2022-10-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_278','The best of the best',1,'2022-10-09 02:00','2022-10-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_279','The best of the best',1,'2022-10-10 02:00','2022-10-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_280','The best of the best',1,'2022-10-11 02:00','2022-10-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_281','The best of the best',1,'2022-10-12 02:00','2022-10-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_282','The best of the best',1,'2022-10-13 02:00','2022-10-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_283','The best of the best',1,'2022-10-14 02:00','2022-10-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_284','The best of the best',1,'2022-10-15 02:00','2022-10-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_285','The best of the best',1,'2022-10-16 02:00','2022-10-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_286','The best of the best',1,'2022-10-17 02:00','2022-10-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_287','The best of the best',1,'2022-10-18 02:00','2022-10-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_288','The best of the best',1,'2022-10-19 02:00','2022-10-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_289','The best of the best',1,'2022-10-20 02:00','2022-10-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_290','The best of the best',1,'2022-10-21 02:00','2022-10-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_291','The best of the best',1,'2022-10-22 02:00','2022-10-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_292','The best of the best',1,'2022-10-23 02:00','2022-10-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_293','The best of the best',1,'2022-10-24 02:00','2022-10-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_294','The best of the best',1,'2022-10-25 02:00','2022-10-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_295','The best of the best',1,'2022-10-26 02:00','2022-10-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_296','The best of the best',1,'2022-10-27 02:00','2022-10-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_297','The best of the best',1,'2022-10-28 02:00','2022-10-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_298','The best of the best',1,'2022-10-29 02:00','2022-10-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_299','The best of the best',1,'2022-10-30 02:00','2022-10-30 19:00',17,1,250,0.5),

                                                                                                                    ('LeonardDavinci Art_300','The best of the best',1,'2022-11-01 02:00','2022-11-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_301','The best of the best',1,'2022-11-02 02:00','2022-11-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_302','The best of the best',1,'2022-11-03 02:00','2022-11-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_303','The best of the best',1,'2022-11-04 02:00','2022-11-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_304','The best of the best',1,'2022-11-05 02:00','2022-11-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_305','The best of the best',1,'2022-11-06 02:00','2022-11-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_306','The best of the best',1,'2022-11-07 02:00','2022-11-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_307','The best of the best',1,'2022-11-08 02:00','2022-11-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_308','The best of the best',1,'2022-11-09 02:00','2022-11-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_309','The best of the best',1,'2022-11-10 02:00','2022-11-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_310','The best of the best',1,'2022-11-11 02:00','2022-11-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_311','The best of the best',1,'2022-11-12 02:00','2022-11-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_312','The best of the best',1,'2022-11-13 02:00','2022-11-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_313','The best of the best',1,'2022-11-14 02:00','2022-11-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_314','The best of the best',1,'2022-11-15 02:00','2022-11-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_315','The best of the best',1,'2022-11-16 02:00','2022-11-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_316','The best of the best',1,'2022-11-17 02:00','2022-11-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_317','The best of the best',1,'2022-11-18 02:00','2022-11-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_318','The best of the best',1,'2022-11-19 02:00','2022-11-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_319','The best of the best',1,'2022-11-20 02:00','2022-11-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_320','The best of the best',1,'2022-11-21 02:00','2022-11-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_321','The best of the best',1,'2022-11-22 02:00','2022-11-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_322','The best of the best',1,'2022-11-23 02:00','2022-11-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_323','The best of the best',1,'2022-11-24 02:00','2022-11-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_324','The best of the best',1,'2022-11-25 02:00','2022-11-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_325','The best of the best',1,'2022-11-26 02:00','2022-11-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_326','The best of the best',1,'2022-11-27 02:00','2022-11-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_327','The best of the best',1,'2022-11-28 02:00','2022-11-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_328','The best of the best',1,'2022-11-29 02:00','2022-11-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_329','The best of the best',1,'2022-11-30 02:00','2022-11-30 19:00',17,1,250,0.5),

                                                                                                                    ('LeonardDavinci Art_330','The best of the best',1,'2022-12-01 02:00','2022-12-01 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_331','The best of the best',1,'2022-12-02 02:00','2022-12-02 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_332','The best of the best',1,'2022-12-03 02:00','2022-12-03 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_333','The best of the best',1,'2022-12-04 02:00','2022-12-04 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_334','The best of the best',1,'2022-12-05 02:00','2022-12-05 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_335','The best of the best',1,'2022-12-06 02:00','2022-12-06 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_336','The best of the best',1,'2022-12-07 02:00','2022-12-07 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_337','The best of the best',1,'2022-12-08 02:00','2022-12-08 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_338','The best of the best',1,'2022-12-09 02:00','2022-12-09 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_339','The best of the best',1,'2022-12-10 02:00','2022-12-10 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_340','The best of the best',1,'2022-12-11 02:00','2022-12-11 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_341','The best of the best',1,'2022-12-12 02:00','2022-12-12 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_342','The best of the best',1,'2022-12-13 02:00','2022-12-13 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_343','The best of the best',1,'2022-12-14 02:00','2022-12-14 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_344','The best of the best',1,'2022-12-15 02:00','2022-12-15 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_345','The best of the best',1,'2022-12-16 02:00','2022-12-16 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_346','The best of the best',1,'2022-12-17 02:00','2022-12-17 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_347','The best of the best',1,'2022-12-18 02:00','2022-12-18 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_348','The best of the best',1,'2022-12-19 02:00','2022-12-19 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_349','The best of the best',1,'2022-12-20 02:00','2022-12-20 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_350','The best of the best',1,'2022-12-21 02:00','2022-12-21 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_351','The best of the best',1,'2022-12-22 02:00','2022-12-22 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_352','The best of the best',1,'2022-12-23 02:00','2022-12-23 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_353','The best of the best',1,'2022-12-24 02:00','2022-12-24 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_354','The best of the best',1,'2022-12-25 02:00','2022-12-25 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_355','The best of the best',1,'2022-12-26 02:00','2022-12-26 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_356','The best of the best',1,'2022-12-27 02:00','2022-12-27 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_357','The best of the best',1,'2022-12-28 02:00','2022-12-28 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_358','The best of the best',1,'2022-12-29 02:00','2022-12-29 19:00',17,1,250,0.5),
                                                                                                                    ('LeonardDavinci Art_359','The best of the best',1,'2022-12-30 02:00','2022-12-30 19:00',17,1,250,0.5),

                                                                                                                    ('Decade Art_1','The best of the best_1',1,'2020-01-01 02:00','2020-01-01 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_2','The best of the best',1,'2023-01-02 02:00','2023-01-02 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_3','The best of the best',1,'2023-01-03 02:00','2023-01-03 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_4','The best of the best',1,'2023-01-04 02:00','2023-01-04 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_5','The best of the best',1,'2023-01-05 02:00','2023-01-05 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_6','The best of the best',1,'2023-01-06 02:00','2023-01-06 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_7','The best of the best',1,'2023-01-07 02:00','2023-01-07 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_8','The best of the best',1,'2023-01-08 02:00','2023-01-08 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_9','The best of the best',1,'2023-01-09 02:00','2023-01-09 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_10','The best of the best',1,'2030-01-10 02:00','2030-01-10 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_11','The best of the best',1,'2023-01-11 02:00','2023-01-11 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_12','The best of the best',1,'2023-01-12 02:00','2023-01-12 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_13','The best of the best',1,'2023-01-13 02:00','2023-01-13 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_14','The best of the best',1,'2023-01-14 02:00','2023-01-14 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_15','The best of the best',1,'2023-01-15 02:00','2023-01-15 19:00',17,1,250,0.5),
                                                                                                                    ('Decade Art_16','The best of the best',1,'2023-01-16 02:00','2023-01-16 19:00',17,1,250,0.5);


CREATE VIEW auctionPerDay AS
SELECT count(*),date(start_date) date from auction group by date;

CREATE VIEW commission_per_auction AS
    SELECT m.max_amount*a.commission commission,date(a.end_date),m.auction_id,a.user_id FROM (SELECT b.auction_id,Max(b.amount) max_amount FROM bid b GROUP BY b.auction_id) m
        JOIN auction a ON m.auction_id=a.id;

CREATE VIEW auction_number_user AS
SELECT count(*),user_id FROM commission_per_auction GROUP BY user_id ORDER BY count;

CREATE VIEW commission_per_day AS
SELECT SUM(m.max_amount*a.commission) commission,date(end_date) date FROM (SELECT b.auction_id,Max(b.amount) max_amount FROM bid b GROUP BY b.auction_id) m
JOIN auction a ON m.auction_id=a.id GROUP BY date;

CREATE VIEW rating AS
SELECT count(*),extract("month" from start_date) as month,extract("year" from start_date) as year,(SELECT COUNT(*) FROM auction) total,(count(*)/(SELECT COUNT(*) FROM auction)) rate FROM auction GROUP BY month,year;


CREATE VIEW tmp_rating_month AS
select
    total
     ,case when (
        select
            count
        from rating
        where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)
        ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_2
    ,case when (
        select
            count
        from rating
        where month=(extract("month" from current_date)-1) and year=extract("year" from current_date)
        ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_1
            from rating;

CREATE VIEW rating_month AS
    SELECT total,case when last_2 = 0 then 0 else ((last_1-last_2)/last_2)*100 end increaseRate from tmp_rating_month;

CREATE VIEW user_month_year AS
    SELECT (SELECT count(*) FROM "user") as total,count(*),extract("month" from signup_date) as month,extract("year" from signup_date) as year from "user" GROUP BY month,year;

CREATE VIEW tmp_rating_user AS
select
    total
     ,case when (
                    select
                        count
                    from user_month_year
                    where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)
    ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_2
    ,case when (
        select
            count
        from user_month_year
        where month=(extract("month" from current_date)-1) and year=extract("year" from current_date)
        ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_1
            from user_month_year;

CREATE VIEW rating_user AS
SELECT total userCount,case when last_2 = 0 then 0 else ((last_1-last_2)/last_2)*100 end increaseRate from tmp_rating_user;

CREATE VIEW commission_per_month AS
    SELECT (SELECT SUM(commission) FROM commission_per_day) total,SUM(commission) commission,extract("month" from date) as month,extract("year" from date) as year FROM commission_per_day GROUP BY month,year;

CREATE VIEW tmp_rating_commission AS
select
    total
     ,case when (
                    select
                        commission
                    from commission_per_month
                    where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)
    ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_2
    ,case when (
        select
            commission
        from commission_per_month
        where month=(extract("month" from current_date)-1) and year=extract("year" from current_date)
        ) is null then 0 else (select count from rating where month=(extract("month" from current_date)-2) and year=extract("year" from current_date)) end last_1
            from commission_per_month;

CREATE VIEW rating_commission AS
SELECT total totalcommission,case when last_2 = 0 then 0 else ((last_1-last_2)/last_2)*100 end increaseRate from tmp_rating_commission;

CREATE VIEW rating_user_auction AS
SELECT count(*) auctionCount,user_id,count(*)/(SELECT count(*) from v_auction where status=2)*100 rate from v_auction where status =2 GROUP BY user_id ORDER BY auctioncount DESC LIMIT 10;

CREATE VIEW rating_user_sale AS
SELECT user_id user, count(*) sales,(SUM(amount)-SUM(gain)) commission,(count(*)/(SELECT count(*) from gain))*100 rate FROM gain GROUP BY user_id ORDER BY sales DESC LIMIT 10;

CREATE VIEW count_rating_product AS
SELECT COUNT(*) as salesCount,a.product_id product,COUNT(*)/(SELECT COUNT(*) FROM gain)*100 rate FROM gain g JOIN auction a ON a.id=g.auction_id GROUP BY product_id ORDER BY salesCount DESC LIMIT 10;

CREATE VIEW count_rating_category AS
SELECT COUNT(*) as salesCount,p.category_id category,COUNT(*)/(SELECT COUNT(*) FROM gain)*100 rate FROM gain g JOIN auction a ON a.id=g.auction_id JOIN product p ON a.product_id=p.id GROUP BY p.category_id ORDER BY salesCount DESC LIMIT 10;

CREATE VIEW product_commission AS
SELECT COUNT(*) as sales,a.product_id product,SUM(g.amount)-SUM(g.gain) commission,(SUM(g.amount)-SUM(g.gain))/(SELECT SUM(amount-gain) FROM gain)*100 rate FROM gain g JOIN auction a ON a.id=g.auction_id GROUP BY product_id ORDER BY commission DESC LIMIT 10;

CREATE VIEW category_commission AS
SELECT COUNT(*) as sales,p.category_id category,SUM(g.amount)-SUM(g.gain) commission,(SUM(g.amount)-SUM(g.gain))/(SELECT SUM(amount-gain) FROM gain)*100 rate FROM gain g JOIN auction a ON a.id=g.auction_id JOIN product p ON a.product_id=p.id GROUP BY p.category_id ORDER BY commission DESC LIMIT 10;

CREATE VIEW product_ratio AS
SELECT a.product_id product,bid_date date,a.start_price/amount ratio
FROM bid b
         JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount JOIN auction a ON a.id=b.auction_id;

CREATE VIEW product_bid_count AS
select count(*) bidcount,a.product_id product from bid JOIN auction a ON bid.auction_id=a.id GROUP BY product ORDER BY bidcount DESC LIMIT 10;

CREATE VIEW category_bid_count AS
select count(*) bidcount,p.category_id category from bid JOIN auction a ON bid.auction_id=a.id JOIN product p ON a.product_id=p.id GROUP BY category ORDER BY bidcount DESC LIMIT 10;
