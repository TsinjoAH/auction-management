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


create or replace view v_auction_user_bid as
select t.auction_id, user_id, t.amount from
    (select auction_id,  max(amount) amount from bid group by auction_id) t
        join bid on t.auction_id = bid.auction_id and t.amount = bid.amount;


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
values ('tsinjoah', 'tsinjoah@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-02'),
        ('rova', 'rova@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-02'),
        ('lahatra', 'lahatra@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-02'),
        ('larousso', 'larousso@gmail.com', '602260addce6b6f6f7a3b3bd8f55d95241dd0c5c', '2023-02-02');
      




insert into account_deposit(user_id, amount, status, status_change_date)
values (1, 50000, 20, '2023-01-24'),
       (2, 80000, 20, '2023-01-23'),
       (3, 70000, 20, '2023-01-22'),
       (4, 60000, 20, '2023-01-21');


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
('Rollex','Une montre qui attise la curiosite des femmes',1,'2023-02-02 13:36','2023-02-10 13:36',10080,1,2500,0.5),
('Bibelot en jade','Une vache en jade',2,'2023-02-02 13:44','2023-02-10 13:44',10080,4,150,0.5),
('La Joconde','Une replique de Mona Lisa',3,'2023-02-02 13:46','2023-02-10 13:46',10080,5,2500,0.5),
('Cute barbie doll','Une poupee de barbie magnifique',4,'2023-02-02 13:50','2023-02-10 13:50',10080,6,250,0.5),
('Voiture','Un voiture enfantin attiran',1,'2023-02-02 13:55','2023-02-10 13:55',10080,7,2500,0.5);


insert into auction_pic(auction_id, pic_path) values(1,'images/Rolex.jpg'),
                                                (2,'images/Bibelot.jpg'),
                                                (3,'images/BeauxArt.jpg'),
                                                (4,'images/Cute.jpg'),
                                                (5,'images/Kids.jpg');


insert into bid(auction_id, user_id, amount,bid_date) values(1,2,2550,'2023-02-02 15:36'),
                                                            (1,3,2600,'2023-02-02 15:39'),

                                                            (2,1,255,'2023-02-02 14:36'),
                                                            (2,4,290,'2023-02-02 14:39'),

                                                            (3,1,2700,'2023-02-02 16:36'),
                                                            (3,2,2750,'2023-02-02 17:39'),

                                                            (4,2,255,'2023-02-02 21:36'),
                                                            (4,3,270,'2023-02-02 21:58'),

                                                            (5,3,2555,'2023-02-02 23:36'),
                                                            (5,2,2600,'2023-02-02 23:58');


create table user_device (
    id serial primary key,
    user_id int not null references "user"(id),
    device_token text not null,
    unique (user_id, device_token)
);



      
--------------------to restart all data to 0------------------------
-- TRUNCATE TABLE "user" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE auction RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE bid RESTART IDENTITY CASCADE;