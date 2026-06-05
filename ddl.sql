-- ============================================================
--  RETAIL E-COMMERCE PRACTICE DATABASE
--  Compatible with: PostgreSQL, SQL Server, MySQL (minor tweaks)
--  Schema: 8 tables, FK constraints, realistic sample data
-- ============================================================

-- ============================================================
--  1. DROP & CREATE TABLES
-- ============================================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INT IDENTITY(1,1) PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(120) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(60),
    region        VARCHAR(60),
    joined_at     DATE NOT NULL DEFAULT GETDATE()
);

CREATE TABLE categories (
    category_id        INT IDENTITY(1,1) PRIMARY KEY,
    category_name      VARCHAR(80) NOT NULL,
    parent_category_id INT REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id    INT IDENTITY(1,1) PRIMARY KEY,
    product_name  VARCHAR(150) NOT NULL,
    category_id   INT REFERENCES categories(category_id),
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_qty     INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    sku           VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE employees (
    employee_id   INT IDENTITY(1,1) PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    role          VARCHAR(60) NOT NULL,
    manager_id    INT REFERENCES employees(employee_id),
    hire_date     DATE NOT NULL
);

CREATE TABLE orders (
    order_id       INT IDENTITY(1,1) PRIMARY KEY,
    customer_id    INT NOT NULL REFERENCES customers(customer_id),
    employee_id    INT REFERENCES employees(employee_id),
    order_date     DATE NOT NULL DEFAULT GETDATE(),
    status         VARCHAR(30) NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending','processing','shipped','delivered','cancelled')),
    shipping_city  VARCHAR(60),
    shipping_fee   NUMERIC(8,2) DEFAULT 0
);

CREATE TABLE order_items (
    item_id       INT IDENTITY(1,1) PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL,
    discount_pct  NUMERIC(5,2) DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);

CREATE TABLE payments (
    payment_id  INT IDENTITY(1,1) PRIMARY KEY,
    order_id    INT NOT NULL REFERENCES orders(order_id),
    method      VARCHAR(40) NOT NULL
                CHECK (method IN ('bkash','nagad','card','cod','bank_transfer')),
    amount      NUMERIC(12,2) NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending','completed','failed','refunded')),
    paid_at     DATETIME2
);

CREATE TABLE reviews (
    review_id    INT IDENTITY(1,1) PRIMARY KEY,
    product_id   INT NOT NULL REFERENCES products(product_id),
    customer_id  INT NOT NULL REFERENCES customers(customer_id),
    rating       INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment      TEXT,
    reviewed_at  DATE NOT NULL DEFAULT GETDATE(),
    UNIQUE (product_id, customer_id)
);

-- ============================================================
--  2. SEED DATA
-- ============================================================

-- Customers (20 rows)
INSERT INTO customers (name, email, phone, city, region, joined_at) VALUES
('Rahim Uddin',       'rahim@mail.com',    '01711-100001', 'Dhaka',      'Dhaka',     '2022-01-15'),
('Sumaiya Begum',     'sumaiya@mail.com',  '01819-100002', 'Chittagong', 'Chittagong','2022-03-22'),
('Karim Hossain',     'karim@mail.com',    '01911-100003', 'Sylhet',     'Sylhet',    '2022-05-10'),
('Nasrin Akter',      'nasrin@mail.com',   '01711-100004', 'Dhaka',      'Dhaka',     '2022-06-01'),
('Tariq Islam',       'tariq@mail.com',    '01611-100005', 'Rajshahi',   'Rajshahi',  '2022-08-19'),
('Farhana Nitu',      'farhana@mail.com',  '01511-100006', 'Dhaka',      'Dhaka',     '2022-09-05'),
('Arif Chowdhury',    'arif@mail.com',     '01711-100007', 'Khulna',     'Khulna',    '2022-11-11'),
('Mita Sarkar',       'mita@mail.com',     '01811-100008', 'Barisal',    'Barisal',   '2023-01-20'),
('Sohel Rana',        'sohel@mail.com',    '01911-100009', 'Dhaka',      'Dhaka',     '2023-02-14'),
('Poly Khanam',       'poly@mail.com',     '01611-100010', 'Mymensingh', 'Dhaka',     '2023-03-03'),
('Jahid Hassan',      'jahid@mail.com',    '01711-100011', 'Dhaka',      'Dhaka',     '2023-04-17'),
('Rupa Biswas',       'rupa@mail.com',     '01811-100012', 'Chittagong', 'Chittagong','2023-05-25'),
('Masum Billah',      'masum@mail.com',    '01711-100013', 'Sylhet',     'Sylhet',    '2023-06-09'),
('Shaila Parvin',     'shaila@mail.com',   '01911-100014', 'Dhaka',      'Dhaka',     '2023-07-30'),
('Rakib Hasan',       'rakib@mail.com',    '01511-100015', 'Comilla',    'Chittagong','2023-08-12'),
('Tania Akter',       'tania@mail.com',    '01711-100016', 'Dhaka',      'Dhaka',     '2023-09-01'),
('Nabila Chowdhury',  'nabila@mail.com',   '01811-100017', 'Rajshahi',   'Rajshahi',  '2023-10-18'),
('Sabbir Ahmed',      'sabbir@mail.com',   '01611-100018', 'Khulna',     'Khulna',    '2023-11-05'),
('Lima Begum',        'lima@mail.com',     '01711-100019', 'Dhaka',      'Dhaka',     '2024-01-08'),
('Imran Hossain',     'imran@mail.com',    '01911-100020', 'Dhaka',      'Dhaka',     '2024-02-20');

-- Categories (parent + child)
INSERT INTO categories (category_name, parent_category_id) VALUES
('Electronics',    NULL),   -- 1
('Clothing',       NULL),   -- 2
('Food & Grocery', NULL),   -- 3
('Home & Living',  NULL),   -- 4
('Mobile Phones',     1),   -- 5 (child of Electronics)
('Laptops',           1),   -- 6
('Men''s Wear',        2),  -- 7
('Women''s Wear',      2),  -- 8
('Rice & Pulses',     3),   -- 9
('Snacks',            3),   -- 10
('Furniture',         4),   -- 11
('Kitchen',           4);   -- 12

-- Products (20 rows)
INSERT INTO products (product_name, category_id, unit_price, stock_qty, sku) VALUES
('Samsung Galaxy A54',          5,  34999.00, 45,  'MOB-SAMGA54'),
('Xiaomi Redmi Note 12',        5,  22500.00, 60,  'MOB-XIAM12'),
('Dell Inspiron 15',            6,  65000.00, 20,  'LAP-DELL15'),
('HP 15s Core i5',              6,  72000.00, 15,  'LAP-HP15S'),
('Asus ZenBook 14',             6,  95000.00, 10,  'LAP-ASUSZ14'),
('Polo T-Shirt (Men)',          7,    850.00, 200, 'CLO-POLO-M'),
('Formal Shirt (Men)',          7,   1200.00, 150, 'CLO-FSHRT-M'),
('Saree (Cotton)',              8,   1800.00, 120, 'CLO-SAREE-C'),
('Kameez (Women)',              8,    950.00, 180, 'CLO-KMEZ-W'),
('Minicut Rice 5kg',            9,    420.00, 500, 'GRO-RICE5'),
('Lentil (Masoor) 1kg',        9,    130.00, 400, 'GRO-LNTL1'),
('Pran Chanachur 200g',        10,     45.00, 800, 'SNK-PRAN200'),
('Handi Nuts Mix 300g',        10,     85.00, 600, 'SNK-HNUTS300'),
('Walton Refrigerator 250L',    1, 42000.00,  18,  'ELC-WALT250'),
('Vision LED TV 43"',           1,  35500.00, 25,  'ELC-VIS43'),
('Steel Bookshelf 5-tier',     11,   6500.00, 30,  'FRN-BSHF5'),
('Wooden Dining Table 4-seat', 11,  18000.00,  8,  'FRN-DTBL4'),
('Non-stick Frying Pan 28cm',  12,    950.00, 200, 'KIT-FRYPAN28'),
('Pressure Cooker 5L',         12,   1850.00, 100, 'KIT-PCOOK5'),
('Blender (Butterfly)',        12,   2200.00, 75,  'KIT-BLND-B');

-- Employees (8 rows, self-referencing manager)
INSERT INTO employees (name, role, manager_id, hire_date) VALUES
('Monir Hossain',   'CEO',             NULL, '2018-03-01'),
('Roksana Begum',   'Sales Manager',    1,   '2019-06-15'),
('Farhan Kabir',    'Operations Mgr',   1,   '2019-08-20'),
('Saima Islam',     'Sales Executive',  2,   '2020-02-10'),
('Emon Chowdhury',  'Sales Executive',  2,   '2020-07-05'),
('Nusrat Jahan',    'Logistics Exec',   3,   '2021-01-18'),
('Jakir Hosen',     'Warehouse Staff',  3,   '2021-09-12'),
('Tahmina Akter',   'Customer Support', 2,   '2022-04-03');

-- Orders (20 rows)
INSERT INTO orders (customer_id, employee_id, order_date, status, shipping_city, shipping_fee) VALUES
( 1,  4, '2024-01-10', 'delivered',  'Dhaka',       60),
( 2,  5, '2024-01-15', 'delivered',  'Chittagong',  80),
( 3,  4, '2024-02-02', 'delivered',  'Sylhet',     100),
( 4,  5, '2024-02-14', 'delivered',  'Dhaka',       60),
( 5,  4, '2024-03-01', 'shipped',    'Rajshahi',   100),
( 6,  5, '2024-03-10', 'delivered',  'Dhaka',       60),
( 7,  4, '2024-03-22', 'cancelled',  'Khulna',     120),
( 8,  5, '2024-04-05', 'delivered',  'Barisal',    100),
( 9,  4, '2024-04-18', 'processing', 'Dhaka',       60),
(10,  5, '2024-04-25', 'delivered',  'Mymensingh',  80),
(11,  4, '2024-05-03', 'delivered',  'Dhaka',       60),
(12,  5, '2024-05-11', 'pending',    'Chittagong',  80),
(13,  4, '2024-05-20', 'delivered',  'Sylhet',     100),
(14,  5, '2024-06-01', 'delivered',  'Dhaka',       60),
( 1,  4, '2024-06-10', 'delivered',  'Dhaka',       60),
( 3,  5, '2024-06-18', 'shipped',    'Sylhet',     100),
( 6,  4, '2024-07-02', 'delivered',  'Dhaka',       60),
( 9,  5, '2024-07-15', 'pending',    'Dhaka',       60),
(16,  4, '2024-08-01', 'delivered',  'Dhaka',       60),
(20,  5, '2024-08-20', 'processing', 'Dhaka',       60);

-- Order Items (35 rows)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
(1,  1,  1, 34999, 0),
(1,  18, 2,   950, 5),
(2,  6,  3,   850, 0),
(2,  8,  1,  1800, 10),
(3,  2,  1, 22500, 0),
(3,  10, 2,   420, 0),
(4,  9,  2,   950, 0),
(4,  12, 5,    45, 0),
(5,  3,  1, 65000, 5),
(6,  15, 1, 35500, 0),
(6,  19, 1,  1850, 0),
(7,  17, 1, 18000, 0),
(8,  14, 1, 42000, 3),
(8,  18, 1,   950, 0),
(9,  4,  1, 72000, 0),
(10, 11, 3,   130, 0),
(10, 13, 2,    85, 0),
(11, 1,  1, 34999, 0),
(11, 20, 1,  2200, 0),
(12, 7,  2,  1200, 0),
(12, 9,  1,   950, 0),
(13, 2,  2, 22500, 5),
(14, 5,  1, 95000, 2),
(14, 19, 2,  1850, 0),
(15, 6,  4,   850, 0),
(15, 12, 10,   45, 0),
(16, 3,  1, 65000, 0),
(16, 10, 3,   420, 0),
(17, 15, 1, 35500, 5),
(17, 18, 2,   950, 0),
(18, 1,  1, 34999, 0),
(19, 4,  1, 72000, 0),
(19, 11, 5,   130, 0),
(20, 2,  1, 22500, 0),
(20, 20, 2,  2200, 0);

-- Payments (18 rows)
INSERT INTO payments (order_id, method, amount, status, paid_at) VALUES
(1,  'bkash',        36849.00, 'completed', '2024-01-10 10:22:00'),
(2,  'cod',           5250.00, 'completed', '2024-01-16 14:00:00'),
(3,  'nagad',        23340.00, 'completed', '2024-02-02 09:15:00'),
(4,  'bkash',         1960.00, 'completed', '2024-02-14 11:30:00'),
(5,  'card',         65060.00, 'completed', '2024-03-01 08:50:00'),
(6,  'bkash',        37410.00, 'completed', '2024-03-10 13:00:00'),
(8,  'cod',          43010.00, 'completed', '2024-04-06 16:45:00'),
(9,  'nagad',        72060.00, 'pending',   NULL),
(10, 'bkash',           560.00,'completed', '2024-04-25 10:00:00'),
(11, 'card',         37259.00, 'completed', '2024-05-03 09:20:00'),
(13, 'bkash',        45100.00, 'completed', '2024-05-20 11:10:00'),
(14, 'nagad',        98750.00, 'completed', '2024-06-01 15:00:00'),
(15, 'bkash',         3850.00, 'completed', '2024-06-10 12:00:00'),
(16, 'cod',          66520.00, 'completed', '2024-06-19 17:00:00'),
(17, 'card',         36460.00, 'completed', '2024-07-02 10:30:00'),
(18, 'bkash',        35059.00, 'pending',   NULL),
(19, 'nagad',        72710.00, 'pending',   NULL),
(20, 'card',         26960.00, 'pending',   NULL);

-- Reviews (15 rows)
INSERT INTO reviews (product_id, customer_id, rating, comment, reviewed_at) VALUES
(1,  1,  5, 'Excellent phone, fast delivery!',       '2024-01-20'),
(6,  2,  4, 'Good quality t-shirt, true to size.',   '2024-01-25'),
(2,  3,  4, 'Battery life is great.',                '2024-02-12'),
(9,  4,  3, 'Average quality, expected better.',     '2024-02-20'),
(3,  5,  5, 'Best laptop in this price range.',      '2024-03-10'),
(15, 6,  4, 'Good TV, clear picture quality.',       '2024-03-18'),
(14, 8,  5, 'Refrigerator is working perfectly.',    '2024-04-15'),
(11, 10, 4, 'Fresh lentils, good packaging.',        '2024-05-01'),
(1,  11, 4, 'Nice phone but slightly overpriced.',   '2024-05-10'),
(5,  14, 5, 'Premium laptop, totally worth it.',     '2024-06-05'),
(6,  15, 3, 'Color faded after first wash.',         '2024-06-20'),
(2,  13, 5, 'Amazing performance for the price.',    '2024-06-01'),
(15, 17, 4, 'Good product, fast shipping.',          '2024-07-10'),
(18, 19, 5, 'Non-stick coating is excellent.',       '2024-08-08'),
(4,  9,  4, 'Solid laptop, handles multitasking well.','2024-08-25');


