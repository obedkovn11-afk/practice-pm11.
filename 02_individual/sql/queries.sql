-- 01. Список клиентов
SELECT client_id, first_name, last_name, phone, email
FROM clients
ORDER BY last_name, first_name;

-- 02. Активные счета и владельцы
SELECT a.account_number, c.first_name, c.last_name, a.balance, a.status
FROM accounts AS a
JOIN clients AS c ON c.client_id = a.client_id
WHERE a.status = 'active'
ORDER BY a.balance DESC;

-- 03. Счета с типом и ставкой
SELECT a.account_number, t.type_name, t.annual_interest_rate, t.monthly_fee
FROM accounts AS a
JOIN account_types AS t ON t.account_type_id = a.account_type_id
ORDER BY t.type_name, a.account_number;

-- 04. Количество клиентов
SELECT COUNT(*) AS client_count FROM clients;

-- 05. Общая сумма остатков по статусам
SELECT status, SUM(balance) AS total_balance_rub
FROM accounts
GROUP BY status
ORDER BY total_balance_rub DESC;

-- 06. Средний остаток по типам счетов
SELECT t.type_name, ROUND(AVG(a.balance), 2) AS average_balance_rub
FROM accounts AS a
JOIN account_types AS t ON t.account_type_id = a.account_type_id
GROUP BY t.type_name
ORDER BY average_balance_rub DESC;

-- 07. Количество счетов в каждом отделении
SELECT b.branch_name, b.city, COUNT(a.account_id) AS account_count
FROM branches AS b
LEFT JOIN accounts AS a ON a.branch_id = b.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY account_count DESC;

-- 08. Операции за октябрь 2026 года
SELECT transaction_id, transaction_date, transaction_type, amount, description
FROM transactions
WHERE transaction_date >= '2026-10-01' AND transaction_date < '2026-11-01'
ORDER BY transaction_date, transaction_id;

-- 09. Число и сумма операций по типам
SELECT transaction_type, COUNT(*) AS operations_count, SUM(amount) AS total_amount_rub
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount_rub DESC;

-- 10. Клиенты с действующими кредитами
SELECT DISTINCT c.client_id, c.first_name, c.last_name
FROM clients AS c
JOIN loans AS l ON l.client_id = c.client_id
WHERE l.status = 'active'
ORDER BY c.last_name;

-- 11. Кредиты выше среднего размера (подзапрос)
SELECT loan_id, client_id, loan_type, principal, status
FROM loans
WHERE principal > (SELECT AVG(principal) FROM loans)
ORDER BY principal DESC;

-- 12. Клиенты без кредитов (NOT EXISTS)
SELECT c.client_id, c.first_name, c.last_name
FROM clients AS c
WHERE NOT EXISTS (
    SELECT 1 FROM loans AS l WHERE l.client_id = c.client_id
)
ORDER BY c.last_name;

-- 13. Клиенты с суммой остатков выше средней по счетам
SELECT c.client_id, c.first_name, c.last_name, SUM(a.balance) AS total_balance_rub
FROM clients AS c
JOIN accounts AS a ON a.client_id = c.client_id
GROUP BY c.client_id, c.first_name, c.last_name
HAVING SUM(a.balance) > (SELECT AVG(balance) FROM accounts)
ORDER BY total_balance_rub DESC;

-- 14. Сотрудники и их отделения
SELECT e.first_name, e.last_name, e.position, b.branch_name, b.city
FROM employees AS e
JOIN branches AS b ON b.branch_id = e.branch_id
ORDER BY b.city, e.last_name;

-- 15. Активные кредиты со сроком погашения в ближайшие 90 дней
SELECT loan_id, client_id, loan_type, principal, due_date
FROM loans
WHERE status = 'active'
  AND due_date >= date('now')
  AND due_date < date('now', '+90 days')
ORDER BY due_date;
