DROP TABLE IF EXISTS product;

CREATE TABLE product (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    price REAL NOT NULL DEFAULT 0 CHECK (price >= 0),
    category_id INTEGER,
    discount REAL
);

INSERT INTO product (name, price, category_id, discount) VALUES
    ('Чай', 40, 1, 5),
    ('Кофе', 75, 1, NULL),
    ('Какао', 150, 2, 10),
    ('Вода', 0, NULL, 0),
    ('Сок', 100, 2, NULL);

SELECT name, price,
       CASE WHEN price >= 100 THEN 'дорого' ELSE 'дёшево' END AS price_label
FROM product;

SELECT name, COALESCE(category_id, 0) AS category_id
FROM product;

SELECT SUM(price) * 1.0 / NULLIF(COUNT(*), 0) AS average_price
FROM product;

INSERT INTO product (name, category_id) VALUES ('Без цены', 1);

SELECT name, price,
       CASE
           WHEN price < 50 THEN 'дёшево'
           WHEN price <= 100 THEN 'средне'
           ELSE 'дорого'
       END AS price_label
FROM product;

SELECT name,
       COALESCE(price, 0) + COALESCE(discount, 0) AS price_plus_discount
FROM product;

SELECT name, price,
       CASE
           WHEN price > 100 THEN 'дорого'
           WHEN price >= 50 THEN 'средне'
           ELSE 'дёшево'
       END AS price_label
FROM product
ORDER BY CASE
             WHEN price > 100 THEN 1
             WHEN price >= 50 THEN 2
             ELSE 3
         END,
         price DESC;
