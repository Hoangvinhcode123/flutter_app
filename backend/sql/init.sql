DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS promotions CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS stores CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS loyalty_transactions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) UNIQUE NOT NULL,
    phone       VARCHAR(20),
    password    VARCHAR(255) NOT NULL,
    avatar_url  TEXT DEFAULT '',
    kat_points  INTEGER DEFAULT 0,
    tier        VARCHAR(20) DEFAULT 'NEW',
    role        VARCHAR(20) DEFAULT 'USER',
    birthday    DATE,
    gender      VARCHAR(10),
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    image_url   TEXT DEFAULT '',
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE products (
    id              SERIAL PRIMARY KEY,
    category_id     INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT DEFAULT '',
    price           NUMERIC(10,0) NOT NULL,
    original_price  NUMERIC(10,0) DEFAULT 0,
    image_url       TEXT DEFAULT '',
    is_best_seller  BOOLEAN DEFAULT FALSE,
    is_available    BOOLEAN DEFAULT TRUE,
    tags            TEXT[] DEFAULT '{}',
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE stores (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    address     TEXT NOT NULL,
    lat         NUMERIC(10,7),
    lng         NUMERIC(10,7),
    phone       VARCHAR(20),
    hours       VARCHAR(100) DEFAULT '7:00 - 22:00',
    features    TEXT[] DEFAULT '{}',
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE addresses (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name            VARCHAR(100) NOT NULL,
    phone           VARCHAR(20) NOT NULL,
    address_type    VARCHAR(20) DEFAULT 'Nhà riêng',
    tinh            VARCHAR(100) NOT NULL,
    huyen           VARCHAR(100) NOT NULL,
    xa              VARCHAR(100) NOT NULL,
    detail          TEXT NOT NULL,
    note            TEXT DEFAULT '',
    is_default      BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE promotions (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    description TEXT DEFAULT '',
    image_url   TEXT DEFAULT '',
    code        VARCHAR(50) UNIQUE,
    discount    NUMERIC(5,2) DEFAULT 0,
    min_order   NUMERIC(10,0) DEFAULT 0,
    start_date  TIMESTAMP,
    end_date    TIMESTAMP,
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER REFERENCES users(id) ON DELETE SET NULL,
    address_id      INTEGER REFERENCES addresses(id) ON DELETE SET NULL,
    status          VARCHAR(30) DEFAULT 'pending',
    delivery_mode   VARCHAR(20) DEFAULT 'delivery',
    total_price     NUMERIC(10,0) NOT NULL,
    delivery_fee    NUMERIC(10,0) DEFAULT 15000,
    discount        NUMERIC(10,0) DEFAULT 0,
    promo_code      VARCHAR(50),
    payment_method  VARCHAR(30) DEFAULT 'cod',
    note            TEXT DEFAULT '',
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id  INTEGER REFERENCES products(id) ON DELETE SET NULL,
    name        VARCHAR(200) NOT NULL,
    price       NUMERIC(10,0) NOT NULL,
    quantity    INTEGER NOT NULL DEFAULT 1,
    image_url   TEXT DEFAULT ''
);

CREATE TABLE notifications (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(200) NOT NULL,
    body        TEXT DEFAULT '',
    type        VARCHAR(30) DEFAULT 'general',
    is_read     BOOLEAN DEFAULT FALSE,
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE loyalty_transactions (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER REFERENCES users(id) ON DELETE CASCADE,
    order_id    INTEGER REFERENCES orders(id) ON DELETE SET NULL,
    points      INTEGER NOT NULL,
    description VARCHAR(200) DEFAULT '',
    created_at  TIMESTAMP DEFAULT NOW()
);

-- SEED DATA
INSERT INTO categories (name, sort_order) VALUES
('Tất cả',0),('Best Seller',1),('Trà Sữa',2),
('Cà Phê',3),('Trái Cây',4),('Combo',5);

INSERT INTO products (category_id,name,price,original_price,image_url,is_best_seller,tags) VALUES
(3,'Trà Đào Hồng Đài (L)',    64000, 75000,'assets/images/Sp_1.jpg',TRUE, '{"best_seller","tra_sua"}'),
(3,'TaRo Coco (L)',            59000, 70000,'assets/images/Sp_2.jpg',     TRUE, '{"best_seller","tra_sua"}'),
(3,'Bơ Già Dừa Non (L)',      55000, 65000,'assets/images/Sp_3.jpg',  FALSE,'{"tra_sua"}'),
(3,'Trà Sữa Matcha (L)',      70000, 85000,'assets/images/Sp_4.jpg',FALSE,'{"tra_sua","matcha"}'),
(6,'Combo Trà Sữa Chôm Chôm',169000,218000,'assets/images/Sp_5.jpg',      FALSE,'{"combo"}'),
(6,'Combo Cốc Cốc Đặc Đặc',  169000,229000,'assets/images/Sp_6.jpg',      FALSE,'{"combo"}'),
(6,'Combo Bơ Già Dừa Non',   169000,228000,'assets/images/Sp_7.jpg',      FALSE,'{"combo"}'),
(6,'Combo Hibi Số Rỉ',       169000,228000,'assets/images/Sp_8.jpg',      FALSE,'{"combo"}');

INSERT INTO stores (name,address,lat,lng,phone,hours,features) VALUES
('ĐƯƠNG - Quận 1','123 Nguyễn Huệ, Q.1, TP.HCM',    10.7769,106.7009,'028-1234-5678','7:00-22:00','{"delivery","pickup","wifi"}'),
('ĐƯƠNG - Quận 3','45 Võ Văn Tần, Q.3, TP.HCM',      10.7736,106.6873,'028-2345-6789','7:00-22:00','{"delivery","pickup"}'),
('ĐƯƠNG - Quận 7','88 Nguyễn Thị Thập, Q.7, TP.HCM', 10.7295,106.7219,'028-3456-7890','7:00-21:30','{"delivery","pickup","wifi"}');

INSERT INTO promotions (title,description,code,discount,min_order,is_active) VALUES
('Giảm 20% đơn đầu tiên','Áp dụng cho khách hàng mới','WELCOME20',20,50000,TRUE),
('Mua 2 tặng 1',          'Áp dụng thứ 2 - thứ 6',    'MUA2TANG1',0, 100000,TRUE),
('Giảm 50K cuối tuần',    'Áp dụng thứ 7, CN',         'WEEKEND50K',0,150000,TRUE);

-- BLOGS / TIN TỨC
CREATE TABLE blogs (
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(300) NOT NULL,
    slug            VARCHAR(300) UNIQUE NOT NULL,
    excerpt         TEXT DEFAULT '',
    content         TEXT NOT NULL,
    featured_image  TEXT DEFAULT '',
    category        VARCHAR(50) DEFAULT 'news',
    is_featured     BOOLEAN DEFAULT FALSE,
    is_published    BOOLEAN DEFAULT TRUE,
    view_count      INTEGER DEFAULT 0,
    published_at    TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- PRODUCT SIZES
CREATE TABLE product_sizes (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(50) NOT NULL,
    display_name    VARCHAR(50) NOT NULL,
    price_adjust    INTEGER DEFAULT 0,
    sort_order      INTEGER DEFAULT 0,
    is_active       BOOLEAN DEFAULT TRUE
);

-- PRODUCT TOPPINGS
CREATE TABLE product_toppings (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    display_name    VARCHAR(100) NOT NULL,
    price           INTEGER NOT NULL,
    image_url       TEXT DEFAULT '',
    category        VARCHAR(50) DEFAULT 'topping',
    is_active       BOOLEAN DEFAULT TRUE
);

-- PRODUCT CUSTOMIZATIONS (link products với sizes và toppings)
CREATE TABLE product_customizations (
    id              SERIAL PRIMARY KEY,
    product_id      INTEGER REFERENCES products(id) ON DELETE CASCADE,
    size_id         INTEGER REFERENCES product_sizes(id) ON DELETE SET NULL,
    topping_id      INTEGER REFERENCES product_toppings(id) ON DELETE SET NULL,
    sugar_levels    TEXT[] DEFAULT '{"0%","30%","50%","70%","100%"}',
    ice_levels      TEXT[] DEFAULT '{"0%","30%","50%","70%","100%"}',
    is_default      BOOLEAN DEFAULT FALSE
);

-- CONTACT MESSAGES
CREATE TABLE contact_messages (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL,
    phone           VARCHAR(20),
    subject         VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    status          VARCHAR(20) DEFAULT 'pending',
    created_at      TIMESTAMP DEFAULT NOW()
);

-- SEED BLOG DATA
INSERT INTO blogs (title,slug,excerpt,content,featured_image,category,is_featured,published_at) VALUES
('Khai trương chi nhánh Đà Nẵng','khai-truong-chi-nhanh-da-nang',
 'Katinat chính thức khai trương chi nhánh mới tại thành phố Đà Nẵng với nhiều ưu đãi hấp dẫn',
 'Katinat Coffee & Tea House vui mừng thông báo khai trương chi nhánh mới tại số 123 Nguyễn Văn Linh, Q. Hải Châu, TP. Đà Nẵng. Nhân dịp khai trương, chúng tôi dành tặng ưu đãi giảm 30% cho tất cả đơn hàng trong tuần đầu tiên.','assets/images/blog1.jpg','event',TRUE,NOW()),

('Công thức mới: Trà Đào Hồng Đài','cong-thuc-moi-tra-dao-hong-dai',
 'Khám phá hương vị độc đáo của Trà Đào Hồng Đài - sự kết hợp hoàn hảo giữa trà và đào tươi',
 'Trà Đào Hồng Đài là sự kết hợp tinh tế giữa lá trà Đào Hồng Đài cao cấp và những miếng đào tươi mọng nước. Mỗi ly trà đều được pha chế cẩn thận để giữ nguyên hương vị tự nhiên.','assets/images/blog2.jpg','product',TRUE,NOW()),

('Chương trình tích điểm mới 2024','chuong-trinh-tich-diem-moi-2024',
 'Cập nhật chính sách tích điểm KATINAT với nhiều quyền lợi hấp dẫn cho thành viên',
 'Từ tháng 1/2024, Katinat áp dụng chính sách tích điểm mới với 4 hạng thành viên: NEW, SILVER, GOLD và DIAMOND. Mỗi 10.000đ chi tiêu = 1 điểm KAT.','assets/images/blog3.jpg','promotion',FALSE,NOW()),

('Workshop pha chế cà phê','workshop-pha-che-ca-phe',
 'Tham gia workshop miễn phí để học cách pha chế cà phê tại nhà',
 'Katinat tổ chức workshop pha chế cà phê vào cuối tuần này. Đăng ký ngay để nhận voucher 50.000đ.','assets/images/blog4.jpg','event',FALSE,NOW());

-- SEED PRODUCT SIZES
INSERT INTO product_sizes (name,display_name,price_adjust,sort_order) VALUES
('S','Size S (Nhỏ)',0,1),
('M','Size M (Vừa)',10000,2),
('L','Size L (Lớn)',15000,3);

-- SEED PRODUCT TOPPINGS
INSERT INTO product_toppings (name,display_name,price,category) VALUES
('tranchau','Trân châu đen',10000,'topping'),
('tranchautrang','Trân châu trắng',10000,'topping'),
('pudding','Pudding trứng',10000,'topping'),
('thachphomai','Thạch phô mai',12000,'topping'),
('thachdua','Thạch dừa',8000,'topping'),
('kemtuoi','Kem tươi',10000,'topping'),
('matcha','Bột matcha',15000,'flavor'),
('socola','Socola đen',10000,'flavor');

-- Test: email=test@duong.com | password=123456
INSERT INTO users (name,email,phone,password,kat_points,tier) VALUES
('Vinh Thái Tín','test@duong.com','0388290904',
 '$2a$10$rOzJqYjMTvZMqLvnzKQxOu8K1mX9pN2TgH4vE6wS7aB3cD5eF0gHi',0,'NEW');

-- ==========================================
-- NEW FEATURES FOR EXPANSION
-- ==========================================

-- Bảng Đánh giá sản phẩm (Reviews)
CREATE TABLE IF NOT EXISTS product_reviews (
    id              SERIAL PRIMARY KEY,
    product_id      INTEGER REFERENCES products(id) ON DELETE CASCADE,
    user_id         INTEGER REFERENCES users(id) ON DELETE CASCADE,
    rating          INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment         TEXT,
    image_url       TEXT DEFAULT '',
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Bảng Sản phẩm yêu thích (Wishlist)
CREATE TABLE IF NOT EXISTS wishlist (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER REFERENCES users(id) ON DELETE CASCADE,
    product_id      INTEGER REFERENCES products(id) ON DELETE CASCADE,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, product_id)
);

-- Bảng Chi nhánh (Bổ sung tọa độ cho bản đồ)
ALTER TABLE stores ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS opening_hours VARCHAR(100);

-- Bảng Voucher chi tiết
CREATE TABLE IF NOT EXISTS vouchers (
    id              SERIAL PRIMARY KEY,
    code            VARCHAR(50) UNIQUE NOT NULL,
    description     TEXT,
    discount_amount NUMERIC(10, 0),
    discount_percent INTEGER,
    min_order_value NUMERIC(10, 0) DEFAULT 0,
    max_discount    NUMERIC(10, 0),
    start_date      TIMESTAMP,
    end_date        TIMESTAMP,
    usage_limit     INTEGER DEFAULT 1,
    used_count      INTEGER DEFAULT 0,
    is_active       BOOLEAN DEFAULT TRUE
);

