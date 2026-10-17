USE food_delivery;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM order_items;
DELETE FROM food_items;
SET SQL_SAFE_UPDATES = 1;

-- Restaurant 1: Spicy Route (Indian)
INSERT INTO food_items (id, name, description, price, is_veg, category_id, rating, prep_time, image_url, restaurant_id) VALUES 
(1, 'Vegetable Samosa', 'Crispy pastry filled with spiced potatoes and peas.', 50.00, TRUE, 1, 4.6, 10, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80', 1),
(2, 'Paneer Tikka', 'Grilled cottage cheese marinated in yogurt and spices.', 150.00, TRUE, 1, 4.5, 20, 'https://images.unsplash.com/photo-1567188040759-bf8d7feac0e2?w=800&q=80', 1),
(3, 'Chicken Curry', 'Authentic slow-cooked chicken curry.', 250.00, FALSE, 2, 4.2, 40, 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80', 1),
(4, 'Butter Chicken', 'Tender chicken in a rich, creamy tomato sauce.', 280.00, FALSE, 2, 4.9, 35, 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=800&q=80', 1),
(5, 'Garlic Naan', 'Soft flatbread baked in a tandoor.', 40.00, TRUE, 1, 4.8, 10, 'https://images.unsplash.com/photo-1626074964464-f655167b5bd6?w=800&q=80', 1),
(6, 'Chicken Biryani', 'Fragrant basmati rice cooked with marinated chicken.', 300.00, FALSE, 2, 4.7, 45, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80', 1),
(7, 'Lamb Rogan Josh', 'Aromatic lamb dish of Persian origin.', 350.00, FALSE, 2, 4.6, 50, 'https://images.unsplash.com/photo-1582576163090-09d3b6f8a969?w=800&q=80', 1),
(8, 'Dal Makhani', 'Black lentils slow-cooked with butter and cream.', 180.00, TRUE, 2, 4.5, 30, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=800&q=80', 1),
(9, 'Gulab Jamun', 'Deep-fried milk dumplings soaked in rose syrup.', 80.00, TRUE, 3, 4.8, 15, 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800&q=80', 1),
(10, 'Rasmalai', 'Soft paneer balls chilled in sweet milk.', 100.00, TRUE, 3, 4.9, 10, 'https://images.unsplash.com/photo-1605697223157-5506041c2bce?w=800&q=80', 1),
(11, 'Mango Lassi', 'Sweet and rich mango yogurt drink.', 60.00, TRUE, 3, 4.7, 5, 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=800&q=80', 1),
(12, 'Chole Bhature', 'Spicy chickpeas served with fluffy fried bread.', 150.00, TRUE, 2, 4.6, 25, 'https://images.unsplash.com/photo-1626779844005-59b48c26f634?w=800&q=80', 1),
(13, 'Palak Paneer', 'Cottage cheese cubes in a thick paste of pureed spinach.', 200.00, TRUE, 2, 4.4, 30, 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80', 1),
(14, 'Tandoori Chicken', 'Roasted chicken marinated in yogurt and spices.', 320.00, FALSE, 1, 4.8, 40, 'https://images.unsplash.com/photo-1599487405270-8772a5611294?w=800&q=80', 1),
(15, 'Malai Kofta', 'Potato and paneer balls in a rich creamy gravy.', 220.00, TRUE, 2, 4.5, 35, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80', 1),
(16, 'Veg Pakora', 'Assorted vegetables deep fried in chickpea batter.', 70.00, TRUE, 1, 4.3, 15, 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=800&q=80', 1),
(17, 'Fish Tikka', 'Spicy grilled fish chunks.', 280.00, FALSE, 1, 4.5, 25, 'https://images.unsplash.com/photo-1599487405270-8772a5611294?w=800&q=80', 1);

-- Restaurant 2: Burger Joint (American)
INSERT INTO food_items (id, name, description, price, is_veg, category_id, rating, prep_time, image_url, restaurant_id) VALUES 
(18, 'Classic Cheeseburger', 'Juicy beef patty with melted cheddar.', 120.00, FALSE, 2, 4.5, 15, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80', 2),
(19, 'Double Bacon Burger', 'Two patties, four slices of bacon, BBQ sauce.', 200.00, FALSE, 2, 4.8, 20, 'https://images.unsplash.com/photo-1594212699903-eca8c196feeb?w=800&q=80', 2),
(20, 'Veggie Burger', 'Plant-based patty with fresh greens.', 130.00, TRUE, 2, 4.2, 15, 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=800&q=80', 2),
(21, 'Spicy Chicken Sandwich', 'Crispy fried chicken breast with spicy mayo.', 160.00, FALSE, 2, 4.7, 15, 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800&q=80', 2),
(22, 'French Fries', 'Golden, crispy, and salted to perfection.', 60.00, TRUE, 1, 4.6, 5, 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=800&q=80', 2),
(23, 'Onion Rings', 'Crispy battered onion rings with ranch.', 70.00, TRUE, 1, 4.4, 10, 'https://images.unsplash.com/photo-1639024470200-cece148677c7?w=800&q=80', 2),
(24, 'Mozzarella Sticks', 'Fried cheese sticks with marinara sauce.', 90.00, TRUE, 1, 4.5, 10, 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=800&q=80', 2),
(25, 'Chocolate Milkshake', 'Thick and creamy chocolate shake.', 80.00, TRUE, 3, 4.8, 5, 'https://images.unsplash.com/photo-1572490122747-3968b75bb8ef?w=800&q=80', 2),
(26, 'Vanilla Milkshake', 'Classic vanilla bean milkshake.', 80.00, TRUE, 3, 4.5, 5, 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=800&q=80', 2),
(27, 'Strawberry Milkshake', 'Made with real strawberries and cream.', 80.00, TRUE, 3, 4.6, 5, 'https://images.unsplash.com/photo-1553177595-4de2bb0842b9?w=800&q=80', 2),
(28, 'Chicken Nuggets', '10 piece crispy chicken nuggets.', 110.00, FALSE, 1, 4.3, 10, 'https://images.unsplash.com/photo-1562967914-01efa7e87832?w=800&q=80', 2),
(29, 'BBQ Ribs', 'Half rack of slow-cooked pork ribs.', 350.00, FALSE, 2, 4.9, 30, 'https://images.unsplash.com/photo-1544025162-831e5df1fb2b?w=800&q=80', 2),
(30, 'Caesar Salad', 'Fresh romaine, croutons, and parmesan.', 100.00, TRUE, 1, 4.1, 10, 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=800&q=80', 2),
(31, 'Hot Dog', 'Classic beef frank with mustard and ketchup.', 80.00, FALSE, 2, 4.0, 10, 'https://images.unsplash.com/photo-1591559404283-fba03417e9ce?w=800&q=80', 2),
(32, 'Mac and Cheese', 'Creamy blend of four cheeses and macaroni.', 120.00, TRUE, 2, 4.6, 15, 'https://images.unsplash.com/photo-1612918882582-7d1c6de8189c?w=800&q=80', 2),
(33, 'Brownie Sundae', 'Warm brownie topped with ice cream.', 140.00, TRUE, 3, 4.8, 10, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=800&q=80', 2),
(34, 'Cola', 'Chilled refreshing cola.', 40.00, TRUE, 3, 4.0, 5, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=800&q=80', 2);

-- Restaurant 3: Pizza Heaven (Italian)
INSERT INTO food_items (id, name, description, price, is_veg, category_id, rating, prep_time, image_url, restaurant_id) VALUES 
(35, 'Margherita Pizza', 'Classic tomato sauce, fresh mozzarella, and basil.', 180.00, TRUE, 2, 4.7, 20, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&q=80', 3),
(36, 'Pepperoni Pizza', 'Loaded with spicy pepperoni slices and cheese.', 250.00, FALSE, 2, 4.8, 20, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800&q=80', 3),
(37, 'Veggie Supreme Pizza', 'Bell peppers, onions, mushrooms, and olives.', 220.00, TRUE, 2, 4.5, 25, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80', 3),
(38, 'BBQ Chicken Pizza', 'Grilled chicken, BBQ sauce, and red onions.', 280.00, FALSE, 2, 4.6, 25, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80', 3),
(39, 'Garlic Bread', 'Toasted bread loaded with garlic butter.', 80.00, TRUE, 1, 4.3, 10, 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=800&q=80', 3),
(40, 'Cheesy Garlic Bread', 'Garlic bread topped with melted mozzarella.', 110.00, TRUE, 1, 4.7, 12, 'https://images.unsplash.com/photo-1619531040598-a6157fba30fb?w=800&q=80', 3),
(41, 'Spaghetti Bolognese', 'Classic rich beef and tomato ragu.', 220.00, FALSE, 2, 4.6, 30, 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?w=800&q=80', 3),
(42, 'Fettuccine Alfredo', 'Pasta in a creamy parmesan and butter sauce.', 200.00, TRUE, 2, 4.5, 25, 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=800&q=80', 3),
(43, 'Lasagna', 'Layers of pasta, meat sauce, and ricotta cheese.', 280.00, FALSE, 2, 4.8, 40, 'https://images.unsplash.com/photo-1619881589316-58f1f7212726?w=800&q=80', 3),
(44, 'Tiramisu', 'Coffee-flavored Italian dessert.', 150.00, TRUE, 3, 4.9, 10, 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=800&q=80', 3),
(45, 'Panna Cotta', 'Sweetened cream thickened with gelatin, berry coulis.', 130.00, TRUE, 3, 4.6, 5, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800&q=80', 3),
(46, 'Caprese Salad', 'Fresh tomatoes, mozzarella, and basil.', 120.00, TRUE, 1, 4.4, 10, 'https://images.unsplash.com/photo-1529312266912-b33cfce2eefd?w=800&q=80', 3),
(47, 'Calzone', 'Folded pizza filled with cheese and meats.', 240.00, FALSE, 2, 4.5, 30, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800&q=80', 3),
(48, 'Chicken Parmesan', 'Breaded chicken topped with marinara and cheese.', 260.00, FALSE, 2, 4.7, 35, 'https://images.unsplash.com/photo-1632778149955-f8670d8a5948?w=800&q=80', 3),
(49, 'Minestrone Soup', 'Hearty Italian vegetable soup.', 110.00, TRUE, 1, 4.2, 15, 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80', 3),
(50, 'Gelato', 'Authentic Italian ice cream.', 90.00, TRUE, 3, 4.8, 5, 'https://images.unsplash.com/photo-1563805042-7684c8a9e9ce?w=800&q=80', 3);
