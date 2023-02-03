-- drop owned by auction;

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
       ('Bibelot'),
       ('BeauArt'),
       ('Cute'),
       ('Kids');

--Produit--
insert into product(name, category_id)
values ('Montre', 1),
       ('Montre orme de pierre precieuse', 1),
       ('Voiture', 1),
       ('Bibelot en jade', 2),
       ('Bibelot en porcelaine', 2),
       ('Bibelot en plastique', 2),
       ('Peinture', 3),
       ('Art abstrait', 3),
       ('Art XXI', 3),
       ('Barbie doll', 4),
       ('Cry Babies', 4),
       ('Bebe Animal', 4),
       ('Figurine', 5),
       ('Voiture en plastique', 5),
       ('Jouet en bois', 5);



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


CREATE OR REPLACE VIEW auction_done AS
SELECT b.user_id,sum(b.amount) amount
FROM bid b
JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    WHERE auction_id IN (SELECT id FROM v_auction WHERE status = 2) GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount GROUP BY b.user_id;

CREATE OR REPLACE VIEW gain AS
SELECT b.amount,b.auction_id,a.user_id,b.amount-(b.amount*commission) gain
FROM bid b
         JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount JOIN auction a ON a.id=b.auction_id;


CREATE OR REPLACE VIEW deposit_done AS
SELECT user_id,SUM(amount) amount FROM account_deposit WHERE status=20 GROUP BY user_id;

CREATE OR REPLACE VIEW full_balance AS
SELECT d.user_id
     ,CASE WHEN SUM(d.amount) IS NULL THEN 0 ELSE SUM(d.amount) END deposit
     ,CASE WHEN SUM(a.amount) IS NULL THEN 0 ELSE SUM(a.amount) END auction_bid
     ,CASE WHEN SUM(g.gain) IS NULL THEN 0 ELSE SUM(g.gain) END auction_gain
      FROM deposit_done d
          LEFT JOIN auction_done a ON d.user_id=a.user_id
          LEFT JOIN gain g ON g.user_id=a.user_id
        GROUP BY d.user_id;


--- CORRECTION BALANCE
--- BEGIN

create view v_user_default as
select id user_id, 0 as amount from "user";

create view v_deposit as
select user_id, amount from v_user_default
union all
select user_id, amount from account_deposit where status = 20;

create view v_deposit_final as
select user_id, sum(amount) as amount from v_deposit group by user_id;

create view v_auction_user_bid as
select auction_id, user_id, max(amount) amount from bid group by auction_id, user_id;

create view v_user_bids as
select user_id, sum(amount) amount from v_auction_user_bid group by user_id;

create view v_bids as
select user_id, amount from v_user_default
union all
select user_id, amount from v_user_bids;

create view v_user_bids_final as
select user_id, sum(amount) amount from v_bids group by user_id;

create view v_auction_winner_amount as
select v.id, max(amount) as amount
from v_auction v join bid b on v.id = b.auction_id where status = 2
group by v.id;

create view v_owner_benefit as
select user_id, amount * (1 - commission) as amount from auction a join v_auction_winner_amount v on a.id = v.id;

create view v_user_benefit as
select user_id, amount from v_user_default
union all
select user_id, amount from v_owner_benefit;

create view v_user_benefit_final as
select user_id, sum(amount) amount from v_user_benefit group by user_id;

create or replace view balance as
select v1.user_id, v1.amount + v2.amount - v3.amount amount from v_deposit_final v1
    join v_user_benefit_final v2 on v1.user_id = v2.user_id
    join v_user_bids_final v3 on v1.user_id = v3.user_id;

-- CREATE OR REPLACE VIEW balance AS
-- SELECT user_id,deposit-auction_bid+auction_gain amount FROM full_balance;
-- END

create view v_user_auction as
    select auction_id, user_id from bid group by auction_id, user_id;

create view v_auction_bidder as
select a.*, v.user_id bidder from v_auction a join v_user_auction v
on a.id = v.auction_id;

--user allmdp:'gemmedecristal'--
insert into "user"(name, email, password, signup_date)
values ('tsinjoah', 'tsinjoah@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-03'),
        ('rova', 'rova@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-03'),
        ('lahatra', 'lahatra@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-03'),
        ('larousso', 'larousso@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-03');
      


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

CREATE OR REPLACE VIEW rating AS
SELECT count(*),extract("month" from start_date) as month,extract("year" from start_date) as year,(SELECT COUNT(*) FROM auction) total,(count(*)::REAL/(SELECT COUNT(*) FROM auction)::REAL) rate FROM auction GROUP BY month,year;


CREATE or replace VIEW rating_month AS
select
    (select count(*) from auction) total
     ,case when (select rate from rating where month=(extract("month" from current_date )) AND year=extract("year" from current_date)) is null then 0 else (select rate from rating where month=(extract("month" from current_date )) AND year=extract("year" from current_date)) end increaserate;

CREATE VIEW user_month_year AS
SELECT (SELECT count(*) FROM "user") as total,count(*),extract("month" from signup_date) as month,extract("year" from signup_date) as year from "user" GROUP BY month,year;

CREATE VIEW rating_user AS
SELECT CASE WHEN  (SELECT count(*) FROM "user") IS NULL THEN 0 ELSE (SELECT count(*) FROM "user") END userCount,
       CASE WHEN  (SELECT count::REAL/(SELECT count(*) FROM "user")::REAL from user_month_year WHERE month=(extract("month" from current_date )) AND year=extract("year" from current_date)) IS NULL THEN 0 ELSE (SELECT count::REAL/(SELECT count(*) FROM "user")::REAL increaseRate from user_month_year WHERE month=(extract("month" from current_date )) AND year=extract("year" from current_date)) END increaseRate ;

CREATE VIEW commission_per_month AS
SELECT (SELECT SUM(commission) FROM commission_per_day) total,SUM(commission) commission,extract("month" from date) as month,extract("year" from date) as year FROM commission_per_day GROUP BY month,year;

CREATE VIEW rating_commission AS
SELECT
    CASE WHEN (SELECT SUM(commission) FROM commission_per_day) IS NULL THEN 0 ELSE (SELECT SUM(commission) FROM commission_per_day) END totalcommission
     ,CASE WHEN (SELECT commission::REAL/total::REAL from commission_per_month  WHERE month=(extract("month" from current_date )) AND year=extract("year" from current_date)) IS NULL THEN 0 ELSE (SELECT commission::REAL/total::REAL from commission_per_month  WHERE month=(extract("month" from current_date )) AND year=extract("year" from current_date)) END increaseRate;

CREATE VIEW rating_user_auction AS
SELECT count(*) auctionCount,user_id,count(*)::REAL/(SELECT count(*) from v_auction where status=2)::REAL rate from v_auction where status =2 GROUP BY user_id ORDER BY auctioncount DESC LIMIT 10;

CREATE OR REPLACE VIEW rating_user_sale AS
SELECT user_id "user", count(*) sales,(SUM(amount)-SUM(gain)) commission,(count(*)::REAL/(SELECT count(*) from gain)::REAL) rate FROM gain GROUP BY user_id ORDER BY sales DESC LIMIT 10;

CREATE VIEW product_ratio AS
SELECT a.product_id product,bid_date date,a.start_price::REAL/amount::REAL ratio
FROM bid b
         JOIN (
    SELECT auction_id, MAX(amount) max_amount
    FROM bid
    GROUP BY auction_id
) max_bids ON b.auction_id = max_bids.auction_id AND b.amount = max_bids.max_amount JOIN auction a ON a.id=b.auction_id;

create or replace view category_stat as
SELECT
    c.*,
    (SELECT COUNT(*) FROM full_v_auction WHERE category_id=c.id) auction,
    (SELECT count(*) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE category_id=c.id) sold,
    CASE WHEN (SELECT SUM(amount)-SUM(gain) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE category_id=c.id) IS NULL THEN 0 ELSE (SELECT SUM(amount)-SUM(gain) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE category_id=c.id) END commission,
    (SELECT COUNT(*) FROM bid b JOIN full_v_auction v ON b.auction_id=v.id WHERE category_id=c.id) bid,
    CASE WHEN (SELECT AVG(ratio) FROM product_ratio JOIN product pr ON product=pr.id WHERE category_id=c.id) IS NULL THEN 0 ELSE (SELECT AVG(ratio) FROM product_ratio JOIN product pr ON product=pr.id WHERE category_id=c.id) END ratio
FROM
    category c order by auction desc, sold desc, bid desc, commission desc, ratio desc
limit  10
;

create or replace view product_stat as
SELECT
    p.*,
    (SELECT COUNT(*) FROM full_v_auction WHERE product_id=p.id) auction,
    (SELECT count(*) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE product_id=p.id) sold,
    CASE WHEN (SELECT SUM(amount)-SUM(gain) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE product_id=p.id) IS NULL THEN 0 ELSE (SELECT SUM(amount)-SUM(gain) FROM gain g JOIN full_v_auction v ON g.auction_id=v.id WHERE product_id=p.id) END commission,
    ( SELECT COUNT(*) FROM bid b JOIN full_v_auction v ON b.auction_id=v.id WHERE product_id=p.id) bid,
    CASE WHEN ( SELECT AVG(ratio) FROM product_ratio WHERE product=p.id) IS NULL THEN 0 ELSE ( SELECT AVG(ratio) FROM product_ratio WHERE product=p.id) END ratio
FROM
    product p order by auction desc, sold desc, bid desc, commission desc, ratio desc
limit  10;
    
CREATE VIEW category_bid_count AS
select count(*) bidcount,p.category_id category from bid JOIN auction a ON bid.auction_id=a.id JOIN product p ON a.product_id=p.id GROUP BY category ORDER BY bidcount DESC LIMIT 10;


insert into auction
(title, description,user_id, start_date, end_date, duration, product_id, start_price,commission) 
values
('Une affaire magnifique de fleur','fleur de jade',1,'2021-01-02 02:00','2021-01-03 02:00',1440,1,150,0.5),
('Une magnifique de tetine','tetine dore',2,'2022-11-29 08:00','2022-11-30 08:30',30,2,150,0.5),
('Une  Tele genereux','Tele sans fil',3,'2023-01-02 00:00','2023-01-05 02:00',4680,3,150,0.5),
('Un clavier ','msi rgb',4,'2021-11-02 02:00','2021-11-03 02:00',1440,4,150,0.5),
('Un Chapeau','chapeau de paille',5,'2023-01-02 02:00','2023-01-03 02:00',1440,5,150,0.5),
('Une fiore ','de poudelard',6,'2022-01-02 02:00','2022-01-03 02:00',1440,6,150,0.5),
('Une affaire magnifique de telephone','iphone 13 pro max',7,'2023-01-15 02:00','2023-01-16 02:00',1440,7,150,0.5),
('Une argent','dolard signe MC',8,'2021-07-02 02:00','2021-08-03 02:00',43800,8,150,0.5),

('Une affaire de parapluie','parapluie mexicain',9,'2022-01-02 11:30','2022-01-02 23:30',720,1,200,0.5),
('Un ordinateur','MSI:RTX 3080',10,'2023-08-10 08:00','2023-08-11 08:30',1470,2,1500,0.5),
('Un album queen','Somebody to love',1,'2021-06-02 00:00','2021-06-02 18:00',1080,3,150,0.5),
('Un chat de bonheur ','chat de jade',2,'2023-01-06 02:00','2023-01-07 02:00',1440,4,250,0.5),
('Un Anime Hors Prix','slam dunk',3,'2023-11-02 02:00','2023-11-03 02:00',1440,5,150,0.5),
('Un slip kangourou ','de poudelard',4,'2022-05-02 02:00','2022-05-03 02:00',1440,6,150,0.5),
('Head golden version','Gol D Roger',5,'2023-03-15 02:00','2023-03-16 02:00',1440,7,150,0.5),
('Replique de pokeball','Une Master Ball',6,'2022-07-02 02:00','2022-07-03 02:00',1440,8,150,0.5);                                                                                                                    




insert into bid(auction_id, user_id, amount,bid_date) values(1,1,200,'2021-01-02 03:00'),
                                                            (1,2,500,'2021-01-02 04:20'),
                                                            (1,3,520,'2021-01-02 04:30'),

                                                            (2,1,200,'2022-11-29 08:01'),
                                                            (2,2,500,'2022-11-29 08:55'),
                                                            (2,3,520,'2022-11-29 10:00'),
                                                            (2,1,620,'2022-11-29 10:30'),

                                                            (3,4,200,'2023-01-02 00:00'),
                                                            (3,5,500,'2023-01-02 01:00'),
                                                            (3,6,520,'2023-01-02 02:00'),
                                                            (3,6,540,'2023-01-02 03:00'),

                                                            (4,7,200,'2021-11-02 02:00'),
                                                            (4,8,500,'2021-11-02 02:30'),
                                                            (4,9,620,'2021-11-02 02:40'),
                                                            (4,9,720,'2021-11-02 02:50'),
                                                            (4,9,740,'2021-11-02 03:00'),

                                                            (5,10,20,'2022-01-02 02:00'),
                                                            (5,2,50,'2022-01-02 03:00'),
                                                            (5,1,52,'2022-01-02 04:00'),
                                                            (5,10,72,'2022-01-02 05:00'),
                                                            (5,2,79,'2022-01-02 06:00'),
                                                            (5,1,100,'2022-01-02 09:00'),

                                                            (6,2,100,'2022-01-02 02:10'),
                                                            (6,4,120,'2022-01-02 02:30'),
                                                            (6,3,130,'2022-01-02 02:50'),
                                                            (6,2,140,'2022-01-02 03:00'),
                                                            (6,4,160,'2022-01-02 03:10'),
                                                            (6,3,170,'2022-01-02 03:20'),
                                                            (6,3,180,'2022-01-02 03:30'),

                                                            (7,10,200,'2023-01-15 02:05'),
                                                            (7,4,500,'2023-01-15 02:10'),
                                                            (7,3,520,'2023-01-15 02:30'),
                                                            (7,10,620,'2023-01-15 02:40'),
                                                            (7,4,700,'2023-01-15 02:50'),
                                                            (7,3,750,'2023-01-15 03:00'),
                                                            (7,4,760,'2023-01-15 03:05'),
                                                            (7,3,780,'2023-01-15 05:00'),

                                                            (8,10,400,'2021-07-02 02:00'),
                                                            (8,2,420,'2021-07-02 03:00'),
                                                            (8,9,425,'2021-07-02 04:00'),
                                                            (8,10,455,'2021-07-02 07:00'),
                                                            (8,8,460,'2021-07-02 10:00'),
                                                            (8,9,475,'2021-07-02 12:00'),
                                                            (8,10,480,'2021-07-02 22:00'),
                                                            (8,8,500,'2021-07-02 22:05'),
                                                            (8,9,860,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (9,10,200,'2022-01-02 11:30'),
                                                            (9,1,220,'2021-07-02 03:00'),
                                                            (9,9,225,'2021-07-02 04:00'),
                                                            (9,10,255,'2021-07-02 07:00'),
                                                            (9,8,260,'2021-07-02 10:00'),
                                                            (9,9,275,'2021-07-02 12:00'),
                                                            (9,10,280,'2021-07-02 22:00'),
                                                            (9,8,300,'2021-07-02 22:05'),
                                                            (9,9,360,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (10,10,1500,'2023-08-10 08:00'),
                                                            (10,9,1510,'2021-07-02 03:00'),
                                                            (10,9,1520,'2021-07-02 04:00'),
                                                            (10,10,1530,'2021-07-02 07:00'),
                                                            (10,1,1540,'2021-07-02 10:00'),
                                                            (10,9,1550,'2021-07-02 12:00'),
                                                            (10,2,1660,'2021-07-02 22:00'),
                                                            (10,8,1670,'2021-07-02 22:05'),
                                                            (10,9,1680,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (11,10,150,'2021-06-02 00:00'),
                                                            (11,1,120,'2021-07-02 03:00'),
                                                            (11,9,125,'2021-07-02 04:00'),
                                                            (11,2,155,'2021-07-02 07:00'),
                                                            (11,8,160,'2021-07-02 10:00'),
                                                            (11,9,175,'2021-07-02 12:00'),
                                                            (11,10,180,'2021-07-02 22:00'),
                                                            (11,5,200,'2021-07-02 22:05'),
                                                            (11,9,260,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (12,10,250,'2023-01-06 02:00'),
                                                            (12,5,420,'2021-07-02 03:00'),
                                                            (12,9,425,'2021-07-02 04:00'),
                                                            (12,1,455,'2021-07-02 07:00'),
                                                            (12,8,460,'2021-07-02 10:00'),
                                                            (12,9,475,'2021-07-02 12:00'),
                                                            (12,10,480,'2021-07-02 22:00'),
                                                            (12,8,500,'2021-07-02 22:05'),
                                                            (12,9,560,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (13,10,150,'2023-11-02 02:00'),
                                                            (13,2,120,'2021-07-02 03:00'),
                                                            (13,9,165,'2021-07-02 04:00'),
                                                            (13,10,175,'2021-07-02 07:00'),
                                                            (13,8,180,'2021-07-02 10:00'),
                                                            (13,9,185,'2021-07-02 12:00'),
                                                            (13,10,200,'2021-07-02 22:00'),
                                                            (13,8,205,'2021-07-02 22:05'),
                                                            (13,9,220,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (14,10,150,'2022-05-02 02:00'),
                                                            (14,1,155,'2021-07-02 03:00'),
                                                            (14,9,250,'2021-07-02 04:00'),
                                                            (14,10,255,'2021-07-02 07:00'),
                                                            (14,8,260,'2021-07-02 10:00'),
                                                            (14,9,265,'2021-07-02 12:00'),
                                                            (14,10,270,'2021-07-02 22:00'),
                                                            (14,8,275,'2021-07-02 22:05'),
                                                            (14,9,280,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (15,10,150,'2023-03-15 02:00'),
                                                            (15,3,155,'2021-07-02 03:00'),
                                                            (15,9,165,'2021-07-02 04:00'),
                                                            (15,10,175,'2021-07-02 07:00'),
                                                            (15,8,185,'2021-07-02 10:00'),
                                                            (15,9,186,'2021-07-02 12:00'),
                                                            (15,10,200,'2021-07-02 22:00'),
                                                            (15,8,205,'2021-07-02 22:05'),
                                                            (15,9,250,'2021-07-02 22:10'),
                                                            
                                                            
                                                            (16,10,150,'2022-07-02 02:00'),
                                                            (16,8,155,'2021-07-02 03:00'),
                                                            (16,9,160,'2021-07-02 04:00'),
                                                            (16,10,165,'2021-07-02 07:00'),
                                                            (16,8,170,'2021-07-02 10:00'),
                                                            (16,9,175,'2021-07-02 12:00'),
                                                            (16,10,180,'2021-07-02 22:00'),
                                                            (16,8,185,'2021-07-02 22:05'),
                                                            (16,9,200,'2021-07-02 22:10');


drop table user_device;

create table user_device (
    id serial primary key,
    user_id int not null references "user"(id),
    device_token text not null,
    unique (user_id, device_token)
);


