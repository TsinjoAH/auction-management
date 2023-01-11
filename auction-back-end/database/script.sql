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

create table auction
(
    id          serial primary key,
    title       varchar(40)  not null,
    description varchar(255) not null,
    start_date  timestamp    not null default current_timestamp,
    end_date    timestamp    not null check ( end_date > start_date ),
    product_id  integer      not null references product (id),
    start_price double precision check ( start_price > 0 )
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