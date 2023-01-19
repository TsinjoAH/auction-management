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

--user allmdp:'gemmedecristal'--
insert into "user"(name, email, password, signup_date)
values ('Steven', 'Steven@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-02'),
       ('Grenat', 'Grenat@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-05'),
       ('Perle', 'Perle@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-07'),
       ('Amethiste', 'Amethiste@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-10'),
       ('Jaspe', 'Jaspe@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-12'),
       ('Peridote', 'Peridote@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-15'),
       ('Lapislazuli', 'Lapislazuli@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-17'),
       ('RoseQuartz', 'RoseQuartz@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-19'),
       ('Ruby', 'Ruby@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-20'),
       ('Saphir', 'Saphir@exemple.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-01-22');

insert into commission(rate, set_date)
values (0.5, '2023-01-28');

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
           WHEN start_date > current_timestamp THEN 3
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
SELECT b.user_id,sum(b.amount) amount,
FROM bid b
JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount GROUP BY b.user_id;

CREATE VIEW deposit_done AS
SELECT user_id,SUM(amount) amount FROM account_deposit WHERE status=20 GROUP BY user_id;

CREATE VIEW balance AS
SELECT d.user_id,CASE WHEN d.amount-a.amount IS NULL THEN d.amount ELSE d.amount-a.amount END amount FROM deposit_done d LEFT JOIN auction_done a ON d.user_id=a.user_id;

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