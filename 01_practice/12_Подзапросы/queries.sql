CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER REFERENCES categories(id)
);

INSERT INTO categories (id, name) VALUES
    (1, 'Еда'),
    (2, 'Напитки'),
    (3, 'Одежда');

INSERT INTO products (id, name, price, category_id) VALUES
    (1, 'Хлеб', 50, 1),
    (2, 'Молоко', 80, 1),
    (3, 'Сок', 120, 2),
    (4, 'Кофе', 250, 2);

SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT *
FROM products
WHERE category_id IN (
    SELECT id
    FROM categories
    WHERE name = 'Еда'
);

SELECT c.*
FROM categories AS c
WHERE EXISTS (
    SELECT 1
    FROM products AS p
    WHERE p.category_id = c.id
);

SELECT c.*
FROM categories AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM products AS p
    WHERE p.category_id = c.id
);

SELECT *
FROM products
WHERE price = (SELECT MAX(price) FROM products);

SELECT p.*
FROM products AS p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products AS p2
    WHERE p2.category_id = p.category_id
);

SELECT *
FROM products
WHERE price > (
    SELECT MAX(price)
    FROM products
    WHERE category_id = 2
);

SELECT c.id, c.name, AVG(p.price) AS average_price
FROM categories AS c
JOIN products AS p ON p.category_id = c.id
GROUP BY c.id, c.name
HAVING AVG(p.price) > 100;
