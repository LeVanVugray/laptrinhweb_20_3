/*
Câu b
*/
-- 1 Liệt kê các hóa đơn của khách hàng (mã user, tên user, mã hóa đơn):
SELECT orders.user_id, users.user_name, orders.order_id 
FROM orders 
JOIN users ON orders.user_id = users.user_id;

-- 2 Liệt kê số lượng các hóa đơn của khách hàng:
SELECT orders.user_id, users.user_name, COUNT(orders.order_id) AS so_don_hang
FROM orders 
JOIN users ON orders.user_id = users.user_id
GROUP BY orders.user_id, users.user_name;

-- 3 Liệt kê thông tin hóa đơn (mã đơn hàng, số sản phẩm):
SELECT orders.order_id, COUNT(order_details.product_id) AS so_san_pham
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_id;

-- 4 Liệt kê thông tin mua hàng của người dùng (mã user, tên user, mã đơn hàng, tên sản phẩm):
SELECT orders.user_id, users.user_name, orders.order_id, products.product_name
FROM orders
JOIN users ON orders.user_id = users.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
ORDER BY orders.order_id;

-- 5 Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất:
SELECT orders.user_id, users.user_name, COUNT(orders.order_id) AS so_don_hang
FROM orders 
JOIN users ON orders.user_id = users.user_id
GROUP BY orders.user_id, users.user_name
ORDER BY so_don_hang DESC
LIMIT 7;

-- 6 Liệt kê 7 người dùng mua sản phẩm có tên Samsung hoặc Apple:
SELECT DISTINCT orders.user_id, users.user_name, orders.order_id, products.product_name
FROM orders
JOIN users ON orders.user_id = users.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
WHERE products.product_name LIKE '%Samsung%' OR products.product_name LIKE '%Apple%'
LIMIT 7;

-- 7 Liệt kê danh sách mua hàng của user bao gồm tổng tiền từng đơn hàng:
SELECT orders.user_id, users.user_name, orders.order_id, SUM(products.product_price) AS tong_tien
FROM orders
JOIN users ON orders.user_id = users.user_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY orders.user_id, users.user_name, orders.order_id;

-- 8 Liệt kê danh sách mua hàng với mỗi user chỉ chọn 1 đơn hàng có giá trị lớn nhất:
SELECT user_id, user_name, order_id, tong_tien FROM (
    SELECT orders.user_id, users.user_name, orders.order_id, 
           SUM(products.product_price) AS tong_tien, 
           RANK() OVER (PARTITION BY orders.user_id ORDER BY SUM(products.product_price) DESC) AS r
    FROM orders
    JOIN users ON orders.user_id = users.user_id
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY orders.user_id, users.user_name, orders.order_id
) AS ranked_orders
WHERE r = 1;

-- 9 Liệt kê danh sách mua hàng với mỗi user chỉ chọn 1 đơn hàng có giá trị lớn nhất, bao gồm số sản phẩm:
SELECT user_id, user_name, order_id, tong_tien, so_san_pham FROM (
    SELECT orders.user_id, users.user_name, orders.order_id, 
           SUM(products.product_price) AS tong_tien, 
           COUNT(order_details.product_id) AS so_san_pham,
           RANK() OVER (PARTITION BY orders.user_id ORDER BY SUM(products.product_price) DESC) AS r
    FROM orders
    JOIN users ON orders.user_id = users.user_id
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY orders.user_id, users.user_name, orders.order_id
) AS ranked_orders
WHERE r = 1;

-- 10 Liệt kê danh sách mua hàng với mỗi user chỉ chọn 1 đơn hàng có số sản phẩm nhiều nhất:
SELECT user_id, user_name, order_id, tong_tien, so_san_pham FROM (
    SELECT orders.user_id, users.user_name, orders.order_id, 
           SUM(products.product_price) AS tong_tien, 
           COUNT(order_details.product_id) AS so_san_pham,
           RANK() OVER (PARTITION BY orders.user_id ORDER BY COUNT(order_details.product_id) DESC) AS r
    FROM orders
    JOIN users ON orders.user_id = users.user_id
    JOIN order_details ON orders.order_id = order_details.order_id
    JOIN products ON order_details.product_id = products.product_id
    GROUP BY orders.user_id, users.user_name, orders.order_id
) AS ranked_orders
WHERE r = 1;
