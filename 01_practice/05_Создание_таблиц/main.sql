PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

CREATE TABLE category (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE product (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    price       REAL NOT NULL CHECK (price > 0),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE supplier (
    id    INTEGER PRIMARY KEY,
    name  TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE shipment (
    id          INTEGER PRIMARY KEY,
    product_id  INTEGER NOT NULL,
    supplier_id INTEGER NOT NULL,
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    date        TEXT NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

CREATE TABLE product_supplier (
    product_id  INTEGER NOT NULL,
    supplier_id INTEGER NOT NULL,
    PRIMARY KEY (product_id, supplier_id),
    UNIQUE (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

CREATE TABLE dated_record (
    id   INTEGER PRIMARY KEY,
    date TEXT NOT NULL CHECK (date >= '2020-01-01')
);

INSERT INTO category (id, name) VALUES
    (1, 'Книги'),
    (2, 'Канцелярия');

INSERT INTO product (id, name, category_id, price) VALUES
    (1, 'SQLite для начинающих', 1, 950.00),
    (2, 'Тетрадь', 2, 120.00);

INSERT INTO supplier (id, name, phone, email) VALUES
    (1, 'Поставщик А', '+7-900-111-22-33', 'a@example.com'),
    (2, 'Поставщик Б', '+7-900-444-55-66', 'b@example.com');

INSERT INTO shipment (id, product_id, supplier_id, quantity) VALUES
    (1, 1, 1, 10),
    (2, 2, 2, 25);

INSERT INTO product_supplier (product_id, supplier_id) VALUES
    (1, 1),
    (2, 2);

INSERT INTO dated_record (id, date) VALUES
    (1, '2020-01-01'),
    (2, '2025-01-15');

COMMIT;

SELECT * FROM category;
SELECT * FROM product;
SELECT * FROM supplier;
SELECT * FROM shipment;
SELECT * FROM product_supplier;
SELECT * FROM dated_record;

PRAGMA foreign_key_check;
