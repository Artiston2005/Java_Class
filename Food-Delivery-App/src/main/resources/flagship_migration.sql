-- ============================================================
--  FLAGSHIP UPDATE — Run this ONCE in MySQL Workbench
-- ============================================================

USE food_delivery;

-- 1. orders: add payment_method, rider info
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50) DEFAULT 'COD',
  ADD COLUMN IF NOT EXISTS rider_name VARCHAR(100) DEFAULT 'Ravi Kumar',
  ADD COLUMN IF NOT EXISTS rider_phone VARCHAR(15) DEFAULT '+91 98765 43210',
  ADD COLUMN IF NOT EXISTS rider_rating DECIMAL(2,1) DEFAULT 4.8;

-- 2. restaurants: add cuisine info and offer text
ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS cuisine_type VARCHAR(100) DEFAULT 'Multi-Cuisine',
  ADD COLUMN IF NOT EXISTS min_order INT DEFAULT 100,
  ADD COLUMN IF NOT EXISTS free_delivery_above INT DEFAULT 299,
  ADD COLUMN IF NOT EXISTS is_open TINYINT(1) DEFAULT 1,
  ADD COLUMN IF NOT EXISTS offer_text VARCHAR(100) DEFAULT NULL;

-- Set restaurant details
UPDATE restaurants SET cuisine_type='Indian, Tandoor', min_order=100, free_delivery_above=199, offer_text='50% OFF up to ₹100' WHERE id=1;
UPDATE restaurants SET cuisine_type='American, Fast Food', min_order=150, free_delivery_above=299, offer_text='Free Delivery' WHERE id=2;
UPDATE restaurants SET cuisine_type='Italian, Continental', min_order=200, free_delivery_above=399, offer_text='Buy 1 Get 1 Free' WHERE id=3;

-- 3. food_items: bestseller flag, calories
ALTER TABLE food_items
  ADD COLUMN IF NOT EXISTS is_bestseller TINYINT(1) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS calories INT DEFAULT NULL;

-- Set some bestsellers
UPDATE food_items SET is_bestseller=1 WHERE id IN (4,6,18,19,35,36,44);
UPDATE food_items SET calories=320 WHERE id=4;
UPDATE food_items SET calories=280 WHERE id=6;
UPDATE food_items SET calories=540 WHERE id=18;
UPDATE food_items SET calories=890 WHERE id=19;
UPDATE food_items SET calories=410 WHERE id=35;
UPDATE food_items SET calories=750 WHERE id=36;

-- 4. reviews table (for future star ratings)
CREATE TABLE IF NOT EXISTS reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  food_item_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 5,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (food_item_id) REFERENCES food_items(id)
);

-- 5. user_addresses table (if not already created)
CREATE TABLE IF NOT EXISTS user_addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  label VARCHAR(50) DEFAULT 'Home',
  address_text TEXT,
  latitude DECIMAL(10, 8) DEFAULT 0,
  longitude DECIMAL(11, 8) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

SELECT 'Schema updated successfully!' AS status;
