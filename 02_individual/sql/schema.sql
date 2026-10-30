PRAGMA foreign_keys = ON;

CREATE TABLE branches (
    branch_id INTEGER PRIMARY KEY,
    branch_name TEXT NOT NULL,
    city TEXT NOT NULL,
    address TEXT NOT NULL UNIQUE
);

CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    phone TEXT UNIQUE,
    email TEXT UNIQUE,
    registration_date TEXT NOT NULL
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    branch_id INTEGER NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    position TEXT NOT NULL,
    hire_date TEXT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE account_types (
    account_type_id INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL UNIQUE,
    annual_interest_rate REAL NOT NULL CHECK (annual_interest_rate >= 0),
    monthly_fee INTEGER NOT NULL DEFAULT 0 CHECK (monthly_fee >= 0)
);

CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    account_type_id INTEGER NOT NULL,
    account_number TEXT NOT NULL UNIQUE,
    opened_date TEXT NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0 CHECK (balance >= 0),
    status TEXT NOT NULL CHECK (status IN ('active', 'blocked', 'closed')),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id)
);

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL,
    employee_id INTEGER,
    transaction_date TEXT NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('deposit', 'withdrawal', 'transfer_in', 'transfer_out', 'payment')),
    amount INTEGER NOT NULL CHECK (amount > 0),
    description TEXT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE loans (
    loan_id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    loan_type TEXT NOT NULL,
    principal INTEGER NOT NULL CHECK (principal > 0),
    annual_interest_rate REAL NOT NULL CHECK (annual_interest_rate >= 0),
    issue_date TEXT NOT NULL,
    due_date TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('active', 'paid', 'overdue')),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- Index 1: speeds up a client's account lookup filtered by status.
CREATE INDEX idx_accounts_client_status ON accounts(client_id, status);
-- Index 2: speeds up ordered/range searches for transactions belonging to an account.
CREATE INDEX idx_transactions_account_date ON transactions(account_id, transaction_date);
