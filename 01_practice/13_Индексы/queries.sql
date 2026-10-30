PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id)
);

INSERT INTO categories (id, name) VALUES
    (1, 'Еда'),
    (2, 'Напитки'),
    (3, 'Одежда');

INSERT INTO products (id, name, price, category_id) VALUES
    (1, 'Хлеб', 50, 1),
    (2, 'Молоко', 80, 1),
    (3, 'Сыр', 150, 1),
    (4, 'Кофе', 250, 2),
    (5, 'Чай', 120, 2),
    (6, 'Coffee', 260, 2);

CREATE INDEX idx_products_price ON products(price);

CREATE INDEX idx_products_name ON products(name);

CREATE INDEX idx_products_category_price
    ON products(category_id, price);

EXPLAIN QUERY PLAN
SELECT name, price
FROM products INDEXED BY idx_products_category_price
WHERE category_id = 1 AND price > 100;

DROP INDEX idx_products_name;

CREATE UNIQUE INDEX idx_products_name_unique ON products(name);

CREATE INDEX idx_products_name_category
    ON products(name, category_id);

DROP INDEX idx_products_price;
EXPLAIN QUERY PLAN
SELECT * FROM products WHERE price >= 100;

CREATE INDEX idx_products_price ON products(price);
EXPLAIN QUERY PLAN
SELECT * FROM products INDEXED BY idx_products_price WHERE price >= 100;

CREATE INDEX idx_products_lower_name ON products(LOWER(name));

EXPLAIN QUERY PLAN
SELECT *
FROM products INDEXED BY idx_products_lower_name
WHERE LOWER(name) = LOWER('coffee');

SELECT *
FROM products
WHERE LOWER(name) = LOWER('coffee');