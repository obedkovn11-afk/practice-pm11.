DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL CHECK (price >= 0)
);

INSERT INTO products (name, category, price) VALUES
    ('Ноутбук', 'Электроника', 850.00),
    ('Смартфон', 'Электроника', 620.00),
    ('Наушники', 'Электроника', 90.00),
    ('Стол', 'Мебель', 180.00),
    ('Стул', 'Мебель', 75.00),
    ('Лампа', 'Мебель', 45.00),
    ('Книга', 'Книги', 25.00),
    ('Энциклопедия', 'Книги', 130.00),
    ('Тетрадь', 'Книги', 8.00);

SELECT COUNT(*) AS total_products
FROM products;

SELECT AVG(price) AS average_price
FROM products;

SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category;

SELECT category, SUM(price) AS total_price
FROM products
GROUP BY category;

SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 2;

SELECT MAX(price) AS highest_price,
       MIN(price) AS lowest_price
FROM products;

SELECT category, AVG(price) AS average_price
FROM products
GROUP BY category
HAVING AVG(price) > 100;

SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT category,
       COUNT(*) AS product_count,
       AVG(price) AS average_price,
       MAX(price) AS maximum_price
FROM products
GROUP BY category
ORDER BY average_price;
