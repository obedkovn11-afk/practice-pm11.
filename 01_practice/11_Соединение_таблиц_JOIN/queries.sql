DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category_id INTEGER,
    supplier_id INTEGER,
    price REAL NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

INSERT INTO categories (category_id, category_name) VALUES
    (1, 'Книги'),
    (2, 'Мебель'),
    (3, 'Электроника'),
    (4, 'Еда'),
    (5, 'Спорт');

INSERT INTO suppliers (supplier_id, supplier_name) VALUES
    (1, 'Поставщик А'),
    (2, 'Поставщик Б'),
    (3, 'Поставщик В');

INSERT INTO products (product_id, name, category_id, supplier_id, price) VALUES
    (1, 'Ноутбук', 3, 1, 850),
    (2, 'Смартфон', 3, 2, 620),
    (3, 'Наушники', 3, 1, 90),
    (4, 'Роман', 1, 2, 25),
    (5, 'Справочник', 1, 3, 130),
    (6, 'Стол', 2, 1, 180),
    (7, 'Стул', 2, 2, 120),
    (8, 'Хлеб', 4, 3, 8),
    (9, 'Товар без категории', NULL, 1, 50);

SELECT p.product_id, p.name AS product_name, c.category_name
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id;

SELECT c.category_id, c.category_name, p.product_id, p.name AS product_name
FROM categories AS c
LEFT JOIN products AS p ON p.category_id = c.category_id;

SELECT p.product_id, p.name AS product_name
FROM products AS p
LEFT JOIN categories AS c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories AS c
LEFT JOIN products AS p ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

SELECT p.product_id, p.name AS product_name, c.category_id, c.category_name
FROM products AS p
FULL OUTER JOIN categories AS c ON p.category_id = c.category_id;

SELECT c.category_id, c.category_name
FROM categories AS c
LEFT JOIN products AS p ON p.category_id = c.category_id
WHERE p.product_id IS NULL;

SELECT p.product_id, p.name AS product_name, c.category_name, s.supplier_name
FROM products AS p
LEFT JOIN categories AS c ON p.category_id = c.category_id
LEFT JOIN suppliers AS s ON p.supplier_id = s.supplier_id;

SELECT p.product_id, p.name AS product_name, c.category_name
FROM products AS p
INNER JOIN categories AS c ON p.category_id = c.category_id
WHERE c.category_name LIKE 'Е%';

SELECT c.category_name,
       p1.product_id AS product_id_1, p1.name AS product_name_1,
       p2.product_id AS product_id_2, p2.name AS product_name_2
FROM products AS p1
INNER JOIN products AS p2
    ON p1.category_id = p2.category_id
   AND p1.product_id < p2.product_id
INNER JOIN categories AS c ON c.category_id = p1.category_id;
