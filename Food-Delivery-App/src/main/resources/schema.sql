CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS food_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    is_veg BOOLEAN DEFAULT TRUE,
    category_id INT,
    rating DECIMAL(3, 2) DEFAULT 0.0,
    prep_time INT DEFAULT 30,
    image_url VARCHAR(500),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_percent DECIMAL(5, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    food_item_id INT,
    user_id INT,
    rating INT,
    feedback TEXT,
    FOREIGN KEY (food_item_id) REFERENCES food_items(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    food_item_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (food_item_id) REFERENCES food_items(id)
);

-- Insert dummy data
INSERT IGNORE INTO users (username, password, role, address) VALUES 
('admin', 'admin123', 'ADMIN', 'Restaurant HQ'),
('user', 'user123', 'CUSTOMER', '123 Main St');

INSERT IGNORE INTO categories (name) VALUES ('Starters'), ('Main Course'), ('Desserts');

INSERT IGNORE INTO food_items (name, description, price, is_veg, category_id, rating, prep_time, image_url) VALUES 
('Paneer Tikka', 'Spicy grilled cottage cheese cubes marinated in yogurt and spices.', 150.00, TRUE, 1, 4.5, 20, 'https://images.unsplash.com/photo-1567188040759-bf8d7feac0e2?auto=format&fit=crop&w=800&q=80'),
('Chicken Curry', 'Authentic Indian chicken curry slow-cooked with aromatic spices.', 250.00, FALSE, 2, 4.2, 40, 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=800&q=80'),
('Chocolate Brownie', 'Warm, gooey double chocolate brownie served with fudge sauce.', 90.00, TRUE, 3, 4.8, 15, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=800&q=80');

INSERT IGNORE INTO vouchers (code, discount_percent) VALUES ('WELCOME50', 50.00), ('FESTIVE20', 20.00);
