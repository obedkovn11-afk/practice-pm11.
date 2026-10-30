DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS categories;

CREATE TABLE product (
    id INTEGER PRIMARY KEY,
    name TEXT,
    price TEXT
);

CREATE TABLE category (
    id INTEGER PRIMARY KEY,
    name TEXT
);

INSERT INTO product (name, price) VALUES ('Книга', '19.99');
INSERT INTO category (name) VALUES ('Товары');

ALTER TABLE product ADD COLUMN description TEXT;

ALTER TABLE product RENAME COLUMN name TO title;

ALTER TABLE product DROP COLUMN description;

ALTER TABLE category RENAME TO categories;

CREATE TABLE product_new (
    id INTEGER PRIMARY KEY,
    title TEXT,
    price TEXT,
    created TEXT DEFAULT (date('now'))
);
INSERT INTO product_new (id, title, price)
    SELECT id, title, price FROM product;
DROP TABLE product;
ALTER TABLE product_new RENAME TO product;

CREATE TABLE product_new (
    id INTEGER PRIMARY KEY,
    title TEXT,
    price REAL,
    created TEXT DEFAULT (date('now'))
);
INSERT INTO product_new (id, title, price, created)
    SELECT id, title, CAST(price AS REAL), created FROM product;
DROP TABLE product;
ALTER TABLE product_new RENAME TO product;

CREATE TABLE product_new (
    id INTEGER PRIMARY KEY,
    title TEXT,
    price REAL CHECK (price >= 0),
    created TEXT DEFAULT (date('now'))
);
INSERT INTO product_new (id, title, price, created)
    SELECT id, title, price, created FROM product;
DROP TABLE product;
ALTER TABLE product_new RENAME TO product;

CREATE TABLE product_new (
    id INTEGER PRIMARY KEY,
    title TEXT,
    price REAL CHECK (price >= 0),
    created TEXT DEFAULT (date('now'))
);
INSERT INTO product_new (id, title, price, created)
    SELECT id, title, price, created FROM product;
DROP TABLE product;
ALTER TABLE product_new RENAME TO product;

DROP TABLE product;
