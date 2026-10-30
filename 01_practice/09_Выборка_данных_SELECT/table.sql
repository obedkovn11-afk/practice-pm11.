CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category TEXT
);

INSERT INTO products (name, price, category) VALUES
    ('Хлеб', 40, 'Продукты'),
    ('Молоко', 80, 'Продукты'),
    ('Холодильник', 25000, 'Техника'),
    ('Телефон', 15000, 'Техника'),
    ('Стол', 3500, 'Мебель'),
    ('Книга', 500, NULL),
    ('Чай', 120, 'Продукты'),
    ('Кофе', 200, 'Продукты'),
    ('Халат', 900, 'Одежда'),
    ('Лампа', 100, NULL);

SELECT * FROM products
WHERE price > 100;

SELECT * FROM products
WHERE price BETWEEN 50 AND 200;

SELECT * FROM products
WHERE name LIKE 'Х%' OR name LIKE 'х%';

SELECT * FROM products
WHERE category IS NULL;

SELECT * FROM products
ORDER BY price DESC;

SELECT * FROM products
LIMIT 3;

SELECT * FROM products
WHERE price % 10 = 0;

SELECT * FROM products
WHERE name LIKE '%о%' OR name LIKE '%О%';

SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products)
  AND category IS NOT NULL
ORDER BY price DESC
LIMIT 5;