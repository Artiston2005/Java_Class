USE food_delivery;

CREATE TABLE IF NOT EXISTS user_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    label VARCHAR(50),
    address_text TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
