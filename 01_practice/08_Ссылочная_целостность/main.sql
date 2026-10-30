PRAGMA foreign_keys = ON;

-- 1–4. Связь 1:N и ON DELETE CASCADE.
DROP TABLE IF EXISTS "Заказ";
DROP TABLE IF EXISTS "Клиент";

CREATE TABLE "Клиент" (
    id INTEGER PRIMARY KEY,
    имя TEXT NOT NULL
);

CREATE TABLE "Заказ" (
    id INTEGER PRIMARY KEY,
    клиент_id INTEGER NOT NULL,
    сумма REAL NOT NULL,
    FOREIGN KEY (клиент_id) REFERENCES "Клиент"(id) ON DELETE CASCADE
);

INSERT INTO "Клиент" (id, имя) VALUES (1, 'Анна');
INSERT INTO "Заказ" (id, клиент_id, сумма) VALUES
    (101, 1, 1200.00),
    (102, 1, 850.00);

-- Проверка связи 1:N: у клиента два заказа.
SELECT * FROM "Заказ" WHERE клиент_id = 1;

-- Попытка вставить заказ для несуществующего клиента нарушит FOREIGN KEY.
-- SQLite сообщит о нарушении внешнего ключа, если выполнить эту команду:
-- INSERT INTO "Заказ" (id, клиент_id, сумма) VALUES (103, 999, 50.00);

-- CASCADE: удаление клиента автоматически удаляет связанные заказы.
DELETE FROM "Клиент" WHERE id = 1;
SELECT * FROM "Заказ"; -- Пустой результат.

-- 5. Меняем правило на RESTRICT: в SQLite для этого пересоздаём таблицу.
DROP TABLE "Заказ";
DROP TABLE "Клиент";

CREATE TABLE "Клиент" (
    id INTEGER PRIMARY KEY,
    имя TEXT NOT NULL
);

CREATE TABLE "Заказ" (
    id INTEGER PRIMARY KEY,
    клиент_id INTEGER NOT NULL,
    сумма REAL NOT NULL,
    FOREIGN KEY (клиент_id) REFERENCES "Клиент"(id) ON DELETE RESTRICT
);

INSERT INTO "Клиент" (id, имя) VALUES (2, 'Борис');
INSERT INTO "Заказ" (id, клиент_id, сумма) VALUES (201, 2, 450.00);

-- Попытка удалить клиента при наличии заказа нарушит FOREIGN KEY (RESTRICT):
-- DELETE FROM "Клиент" WHERE id = 2;
-- Клиент останется в таблице, а заказ — связанным с ним.
SELECT * FROM "Клиент";
SELECT * FROM "Заказ";

-- 6. ON DELETE SET NULL: товар сохраняется, ссылка на удалённую категорию обнуляется.
DROP TABLE IF EXISTS "Товар";
DROP TABLE IF EXISTS "Категория";

CREATE TABLE "Категория" (
    id INTEGER PRIMARY KEY,
    название TEXT NOT NULL
);

CREATE TABLE "Товар" (
    id INTEGER PRIMARY KEY,
    название TEXT NOT NULL,
    категория_id INTEGER,
    FOREIGN KEY (категория_id) REFERENCES "Категория"(id) ON DELETE SET NULL
);

INSERT INTO "Категория" (id, название) VALUES (10, 'Книги');
INSERT INTO "Товар" (id, название, категория_id) VALUES (1001, 'SQLite для начинающих', 10);
DELETE FROM "Категория" WHERE id = 10;
SELECT * FROM "Товар"; -- категория_id будет NULL.

-- 7–8. M:N через промежуточную таблицу.
-- Эта же таблица имеет составной PRIMARY KEY (order_id, product_id),
-- поэтому одна пара «заказ–товар» не может встречаться дважды.
DROP TABLE IF EXISTS order_product;
CREATE TABLE order_product (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES "Заказ"(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES "Товар"(id) ON DELETE CASCADE
);

-- Данные для проверки промежуточной таблицы.
INSERT INTO "Товар" (id, название, категория_id) VALUES (1002, 'SQL на практике', NULL);
INSERT INTO "Заказ" (id, клиент_id, сумма) VALUES (202, 2, 700.00);
INSERT INTO order_product (order_id, product_id, quantity) VALUES (202, 1001, 1);
INSERT INTO order_product (order_id, product_id, quantity) VALUES (202, 1002, 2);
SELECT * FROM order_product;

-- Повторная вставка пары (202, 1001) нарушит составной PRIMARY KEY:
-- INSERT INTO order_product (order_id, product_id, quantity) VALUES (202, 1001, 3);

-- 9. Самоссылка: manager_id указывает на другого сотрудника в этой же таблице.
DROP TABLE IF EXISTS "Сотрудник";
CREATE TABLE "Сотрудник" (
    id INTEGER PRIMARY KEY,
    имя TEXT NOT NULL,
    manager_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES "Сотрудник"(id) ON DELETE SET NULL
);

INSERT INTO "Сотрудник" (id, имя, manager_id) VALUES
    (1, 'Елена', NULL),
    (2, 'Игорь', 1),
    (3, 'Мария', 1);

SELECT сотрудник.имя AS сотрудник, руководитель.имя AS руководитель
FROM "Сотрудник" AS сотрудник
LEFT JOIN "Сотрудник" AS руководитель ON сотрудник.manager_id = руководитель.id;

-- Самоссылка нужна для хранения иерархий: например, структуры подчинения,
-- категорий с родительскими категориями или дерева комментариев.
