CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email NVARCHAR(100) UNIQUE,
    password NVARCHAR(255),
    phone NVARCHAR(20),
    role NVARCHAR(20),
    status NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE user_addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    address_line_1 NVARCHAR(255),
    address_line_2 NVARCHAR(255),
    city NVARCHAR(100),
    state NVARCHAR(100),
    country NVARCHAR(100),
    postal_code NVARCHAR(20),
    address_type NVARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    description NVARCHAR(MAX),
    price DECIMAL(10, 2),
    discount_price DECIMAL(10, 2),
    stock INT,
    category_id INT FOREIGN KEY REFERENCES categories(category_id),
    brand_id INT FOREIGN KEY REFERENCES brands(brand_id),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    parent_category_id INT NULL,
    name NVARCHAR(100),
    description NVARCHAR(MAX),
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

CREATE TABLE brands (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100),
    description NVARCHAR(MAX)
);

CREATE TABLE product_images (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    image_url NVARCHAR(255),
    is_primary BIT
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    warehouse_location NVARCHAR(255),
    quantity INT,
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    total_price DECIMAL(10, 2),
    status NVARCHAR(20),
    shipping_address_id INT FOREIGN KEY REFERENCES user_addresses(address_id),
    payment_id INT,  
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES orders(order_id),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,  -- Bu sütunu daha sonra foreign key ile baðlayacaðýz
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(20),
    amount DECIMAL(10, 2),
    payment_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES orders(order_id),
    shipping_company NVARCHAR(100),
    tracking_number NVARCHAR(50),
    status NVARCHAR(50),
    estimated_delivery_date DATETIME
);

CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE,
    discount_type NVARCHAR(20),
    discount_value DECIMAL(5, 2),
    valid_from DATETIME,
    valid_to DATETIME,
    minimum_order_value DECIMAL(10, 2)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE wishlist (
    wishlist_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE logs (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    action NVARCHAR(255),
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY IDENTITY(1,1),
    order_item_id INT FOREIGN KEY REFERENCES order_items(order_item_id),
    reason NVARCHAR(MAX),
    status NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE()
);


ALTER TABLE orders
ADD CONSTRAINT FK_orders_payments
FOREIGN KEY (payment_id) REFERENCES payments(payment_id);
