d# CLAUDE.md — ĐƯƠNG Coffee & Tea House
## App Mobile + Website phong cách KATINAT | Backend Node.js + PostgreSQL (Docker)

> File này chứa **toàn bộ** hướng dẫn, code mẫu, cấu hình để xây dựng lại dự án từ đầu.
> Bỏ vào thư mục gốc dự án trong VS Code và làm theo từng phần.

---

## 1. TỔNG QUAN DỰ ÁN

| Hạng mục | Hiện tại | Mục tiêu |
|---|---|---|
| Tên app | app_tuan89 / ĐƯƠNG | **ĐƯƠNG Coffee & Tea House** |
| Màu chủ đạo | `#1F4352` + nâu random | Hệ thống màu Katinat chuẩn |
| Font | Roboto | **Playfair Display** (heading) + **Inter** (body) |
| Backend | Firebase Auth + Firestore | **Node.js + Express + PostgreSQL (Docker)** |
| State management | Provider | Provider (giữ nguyên, tổ chức lại) |
| Platform | Flutter mobile | Flutter (iOS + Android) + **Flutter Web** |
| Navigation | Named routes | **GoRouter** |
| Package name | `app_tuan89` | `com.duong.coffee` |

---

## 2. CẤU TRÚC THƯ MỤC

```
project-root/
│
├── CLAUDE.md                        ← file này
│
├── flutter_app/                     ← Flutter source
│   ├── lib/
│   │   ├── core/
│   │   │   ├── theme/
│   │   │   │   ├── app_colors.dart
│   │   │   │   ├── app_text_styles.dart
│   │   │   │   └── app_theme.dart
│   │   │   └── router/
│   │   │       └── app_router.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── services/
│   │   │       └── api_service.dart  ← kết nối Node.js backend
│   │   ├── providers/
│   │   ├── screens/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── backend/                         ← Node.js API
    ├── docker-compose.yml
    ├── Dockerfile
    ├── .env
    ├── package.json
    ├── sql/
    │   └── init.sql
    └── src/
        ├── index.js
        ├── config/db.js
        ├── middleware/auth.js
        ├── routes/index.js
        └── controllers/
            ├── authController.js
            ├── productController.js
            ├── orderController.js
            ├── addressController.js
            └── miscController.js
```

---

## 3. BACKEND — Node.js + PostgreSQL + Docker

### 3.1 backend/docker-compose.yml

```yaml
version: '3.8'

services:
  duong_db:
    image: postgres:16
    container_name: duong_db
    restart: always
    environment:
      POSTGRES_DB: duong_coffee
      POSTGRES_USER: duong_user
      POSTGRES_PASSWORD: duong_pass_2024
    ports:
      - "5432:5432"
    volumes:
      - duong_db_data:/var/lib/postgresql/data
      - ./sql/init.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U duong_user -d duong_coffee"]
      interval: 10s
      timeout: 5s
      retries: 5

  duong_api:
    build: .
    container_name: duong_api
    restart: always
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
      PORT: 3000
      DB_HOST: duong_db
      DB_PORT: 5432
      DB_NAME: duong_coffee
      DB_USER: duong_user
      DB_PASSWORD: duong_pass_2024
      JWT_SECRET: duong_jwt_secret_key_2024_change_in_production
      JWT_EXPIRES_IN: 7d
    depends_on:
      duong_db:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules

volumes:
  duong_db_data:
```

### 3.2 backend/Dockerfile

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "src/index.js"]
```

### 3.3 backend/.env

```env
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=duong_coffee
DB_USER=duong_user
DB_PASSWORD=duong_pass_2024
JWT_SECRET=duong_jwt_secret_key_2024_change_in_production
JWT_EXPIRES_IN=7d
```

### 3.4 backend/package.json

```json
{
  "name": "duong-coffee-backend",
  "version": "1.0.0",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js"
  },
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.18.2",
    "jsonwebtoken": "^9.0.2",
    "pg": "^8.11.3"
  },
  "devDependencies": {
    "nodemon": "^3.1.0"
  }
}
```

### 3.5 backend/sql/init.sql

```sql
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
(3,'Trà Đào Hồng Đài (L)',    64000, 75000,'assets/images/tradaohongdai.png',TRUE, '{"best_seller","tra_sua"}'),
(3,'TaRo Coco (L)',            59000, 70000,'assets/images/tarococo.jpg',     TRUE, '{"best_seller","tra_sua"}'),
(3,'Bơ Già Dừa Non (L)',      55000, 65000,'assets/images/bogiaduanon.jpg',  FALSE,'{"tra_sua"}'),
(3,'Trà Sữa Matcha (L)',      70000, 85000,'assets/images/ikimatchatofu.jpg',FALSE,'{"tra_sua","matcha"}'),
(6,'Combo Trà Sữa Chôm Chôm',169000,218000,'assets/images/combo1.jpg',      FALSE,'{"combo"}'),
(6,'Combo Cốc Cốc Đặc Đặc',  169000,229000,'assets/images/combo2.jpg',      FALSE,'{"combo"}'),
(6,'Combo Bơ Già Dừa Non',   169000,228000,'assets/images/combo3.jpg',      FALSE,'{"combo"}'),
(6,'Combo Hibi Số Rỉ',       169000,228000,'assets/images/combo4.jpg',      FALSE,'{"combo"}');

INSERT INTO stores (name,address,lat,lng,phone,hours,features) VALUES
('ĐƯƠNG - Quận 1','123 Nguyễn Huệ, Q.1, TP.HCM',    10.7769,106.7009,'028-1234-5678','7:00-22:00','{"delivery","pickup","wifi"}'),
('ĐƯƠNG - Quận 3','45 Võ Văn Tần, Q.3, TP.HCM',      10.7736,106.6873,'028-2345-6789','7:00-22:00','{"delivery","pickup"}'),
('ĐƯƠNG - Quận 7','88 Nguyễn Thị Thập, Q.7, TP.HCM', 10.7295,106.7219,'028-3456-7890','7:00-21:30','{"delivery","pickup","wifi"}');

INSERT INTO promotions (title,description,code,discount,min_order,is_active) VALUES
('Giảm 20% đơn đầu tiên','Áp dụng cho khách hàng mới','WELCOME20',20,50000,TRUE),
('Mua 2 tặng 1',          'Áp dụng thứ 2 - thứ 6',    'MUA2TANG1',0, 100000,TRUE),
('Giảm 50K cuối tuần',    'Áp dụng thứ 7, CN',         'WEEKEND50K',0,150000,TRUE);

-- Test: email=test@duong.com | password=123456
INSERT INTO users (name,email,phone,password,kat_points,tier) VALUES
('Vinh Thái Tín','test@duong.com','0388290904',
 '$2a$10$rOzJqYjMTvZMqLvnzKQxOu8K1mX9pN2TgH4vE6wS7aB3cD5eF0gHi',0,'NEW');
```

### 3.6 backend/src/config/db.js

```javascript
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host:     process.env.DB_HOST     || 'localhost',
  port:     parseInt(process.env.DB_PORT) || 5432,
  database: process.env.DB_NAME     || 'duong_coffee',
  user:     process.env.DB_USER     || 'duong_user',
  password: process.env.DB_PASSWORD || 'duong_pass_2024',
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('connect', () => console.log('✅ PostgreSQL connected'));
pool.on('error',   (err) => console.error('❌ DB error:', err.message));

module.exports = pool;
```

### 3.7 backend/src/middleware/auth.js

```javascript
const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  const header = req.headers['authorization'];
  if (!header) return res.status(401).json({ message: 'Không có token' });
  const token = header.split(' ')[1];
  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ message: 'Token hết hạn hoặc không hợp lệ' });
  }
};
```

### 3.8 backend/src/controllers/authController.js

```javascript
const pool   = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt    = require('jsonwebtoken');

const makeToken = (user) =>
  jwt.sign({ id: user.id, email: user.email, name: user.name },
    process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN || '7d' });

exports.register = async (req, res) => {
  const { name, email, phone, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' });
  try {
    const exists = await pool.query('SELECT id FROM users WHERE email=$1', [email]);
    if (exists.rows.length) return res.status(409).json({ message: 'Email đã được sử dụng' });
    const hashed = await bcrypt.hash(password, 10);
    const result = await pool.query(
      `INSERT INTO users (name,email,phone,password) VALUES ($1,$2,$3,$4)
       RETURNING id,name,email,phone,kat_points,tier`,
      [name, email, phone||null, hashed]
    );
    const user = result.rows[0];
    res.status(201).json({ message: 'Đăng ký thành công', token: makeToken(user), user });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: 'Thiếu email hoặc mật khẩu' });
  try {
    const result = await pool.query('SELECT * FROM users WHERE email=$1', [email]);
    const user = result.rows[0];
    if (!user) return res.status(401).json({ message: 'Email không tồn tại' });
    if (!await bcrypt.compare(password, user.password))
      return res.status(401).json({ message: 'Mật khẩu không đúng' });
    const { password: _, ...safeUser } = user;
    res.json({ message: 'Đăng nhập thành công', token: makeToken(user), user: safeUser });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getMe = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id,name,email,phone,avatar_url,kat_points,tier,created_at FROM users WHERE id=$1',
      [req.user.id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'User không tồn tại' });
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.updateProfile = async (req, res) => {
  const { name, phone, avatar_url } = req.body;
  try {
    const result = await pool.query(
      `UPDATE users SET name=$1,phone=$2,avatar_url=$3,updated_at=NOW()
       WHERE id=$4 RETURNING id,name,email,phone,avatar_url,kat_points,tier`,
      [name, phone, avatar_url, req.user.id]
    );
    res.json({ message: 'Cập nhật thành công', user: result.rows[0] });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
```

### 3.9 backend/src/controllers/productController.js

```javascript
const pool = require('../config/db');

exports.getAll = async (req, res) => {
  const { category_id, best_seller, search } = req.query;
  try {
    let query = `SELECT p.*,c.name AS category_name FROM products p
                 LEFT JOIN categories c ON p.category_id=c.id WHERE p.is_available=TRUE`;
    const params = [];
    if (category_id && category_id !== '1') { params.push(category_id); query += ` AND p.category_id=$${params.length}`; }
    if (best_seller === 'true') query += ` AND p.is_best_seller=TRUE`;
    if (search) { params.push(`%${search}%`); query += ` AND p.name ILIKE $${params.length}`; }
    query += ' ORDER BY p.is_best_seller DESC,p.id ASC';
    res.json((await pool.query(query, params)).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getOne = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT p.*,c.name AS category_name FROM products p
       LEFT JOIN categories c ON p.category_id=c.id WHERE p.id=$1`, [req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getCategories = async (req, res) => {
  try {
    res.json((await pool.query('SELECT * FROM categories WHERE is_active=TRUE ORDER BY sort_order')).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};
```

### 3.10 backend/src/controllers/orderController.js

```javascript
const pool = require('../config/db');

exports.createOrder = async (req, res) => {
  const { items, address_id, delivery_mode, payment_method, promo_code, note } = req.body;
  if (!items?.length) return res.status(400).json({ message: 'Giỏ hàng trống' });
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const totalPrice = items.reduce((sum, i) => sum + i.price * i.quantity, 0);
    const deliveryFee = delivery_mode === 'pickup' ? 0 : 15000;
    let discount = 0;
    if (promo_code) {
      const promo = await client.query(
        `SELECT * FROM promotions WHERE code=$1 AND is_active=TRUE
         AND (start_date IS NULL OR start_date<=NOW()) AND (end_date IS NULL OR end_date>=NOW())`,
        [promo_code]
      );
      if (promo.rows.length && totalPrice >= promo.rows[0].min_order)
        discount = promo.rows[0].discount > 0 ? Math.round(totalPrice * promo.rows[0].discount / 100) : 0;
    }
    const { rows: [order] } = await client.query(
      `INSERT INTO orders (user_id,address_id,delivery_mode,total_price,delivery_fee,discount,promo_code,payment_method,note)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *`,
      [req.user.id,address_id||null,delivery_mode||'delivery',totalPrice,deliveryFee,discount,promo_code||null,payment_method||'cod',note||'']
    );
    for (const item of items)
      await client.query(
        `INSERT INTO order_items (order_id,product_id,name,price,quantity,image_url) VALUES ($1,$2,$3,$4,$5,$6)`,
        [order.id,item.product_id,item.name,item.price,item.quantity,item.image_url||'']
      );
    const katEarned = Math.floor(totalPrice / 10000);
    if (katEarned > 0) {
      await client.query('UPDATE users SET kat_points=kat_points+$1 WHERE id=$2', [katEarned, req.user.id]);
      await client.query(
        `INSERT INTO loyalty_transactions (user_id,order_id,points,description) VALUES ($1,$2,$3,$4)`,
        [req.user.id, order.id, katEarned, `Tích điểm đơn hàng #${order.id}`]
      );
    }
    await client.query('COMMIT');
    res.status(201).json({ message: 'Đặt hàng thành công', order, kat_earned: katEarned });
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ message: err.message });
  } finally { client.release(); }
};

exports.getMyOrders = async (req, res) => {
  try {
    const orders = await pool.query(
      `SELECT o.*,json_agg(json_build_object('id',oi.id,'name',oi.name,'price',oi.price,'quantity',oi.quantity,'image_url',oi.image_url)) AS items
       FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.id
       WHERE o.user_id=$1 GROUP BY o.id ORDER BY o.created_at DESC`,
      [req.user.id]
    );
    res.json(orders.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getOrderDetail = async (req, res) => {
  try {
    const order = await pool.query(
      `SELECT o.*,json_agg(json_build_object('id',oi.id,'name',oi.name,'price',oi.price,'quantity',oi.quantity,'image_url',oi.image_url)) AS items
       FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.id
       WHERE o.id=$1 AND o.user_id=$2 GROUP BY o.id`,
      [req.params.id, req.user.id]
    );
    if (!order.rows.length) return res.status(404).json({ message: 'Không tìm thấy đơn hàng' });
    res.json(order.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};
```

### 3.11 backend/src/controllers/addressController.js

```javascript
const pool = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM addresses WHERE user_id=$1 ORDER BY is_default DESC,id DESC', [req.user.id]
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.create = async (req, res) => {
  const { name,phone,address_type,tinh,huyen,xa,detail,note,is_default } = req.body;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    if (is_default) await client.query('UPDATE addresses SET is_default=FALSE WHERE user_id=$1', [req.user.id]);
    const result = await client.query(
      `INSERT INTO addresses (user_id,name,phone,address_type,tinh,huyen,xa,detail,note,is_default)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
      [req.user.id,name,phone,address_type||'Nhà riêng',tinh,huyen,xa,detail,note||'',is_default||false]
    );
    await client.query('COMMIT');
    res.status(201).json(result.rows[0]);
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ message: err.message });
  } finally { client.release(); }
};

exports.setDefault = async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('UPDATE addresses SET is_default=FALSE WHERE user_id=$1', [req.user.id]);
    await client.query('UPDATE addresses SET is_default=TRUE WHERE id=$1 AND user_id=$2', [req.params.id, req.user.id]);
    await client.query('COMMIT');
    res.json({ message: 'Đã đặt địa chỉ mặc định' });
  } catch (err) {
    await client.query('ROLLBACK');
    res.status(500).json({ message: err.message });
  } finally { client.release(); }
};

exports.remove = async (req, res) => {
  try {
    await pool.query('DELETE FROM addresses WHERE id=$1 AND user_id=$2', [req.params.id, req.user.id]);
    res.json({ message: 'Đã xóa địa chỉ' });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
```

### 3.12 backend/src/controllers/miscController.js

```javascript
const pool = require('../config/db');

exports.getStores = async (req, res) => {
  try { res.json((await pool.query('SELECT * FROM stores WHERE is_active=TRUE ORDER BY id')).rows); }
  catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getPromotions = async (req, res) => {
  try {
    res.json((await pool.query(
      `SELECT * FROM promotions WHERE is_active=TRUE AND (end_date IS NULL OR end_date>=NOW()) ORDER BY id DESC`
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.validatePromo = async (req, res) => {
  const { code, total_price } = req.body;
  try {
    const result = await pool.query(
      `SELECT * FROM promotions WHERE code=$1 AND is_active=TRUE
       AND (start_date IS NULL OR start_date<=NOW()) AND (end_date IS NULL OR end_date>=NOW())`, [code]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Mã không hợp lệ hoặc đã hết hạn' });
    const promo = result.rows[0];
    if (total_price < promo.min_order) return res.status(400).json({ message: `Đơn tối thiểu ${promo.min_order}đ` });
    res.json({ valid: true, promo, discount: promo.discount > 0 ? Math.round(total_price * promo.discount / 100) : 0 });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getNotifications = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM notifications WHERE user_id=$1 ORDER BY created_at DESC LIMIT 50', [req.user.id]
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.markRead = async (req, res) => {
  try {
    await pool.query('UPDATE notifications SET is_read=TRUE WHERE id=$1 AND user_id=$2', [req.params.id, req.user.id]);
    res.json({ message: 'Đã đọc' });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getLoyalty = async (req, res) => {
  try {
    const user = await pool.query('SELECT kat_points,tier FROM users WHERE id=$1', [req.user.id]);
    const history = await pool.query(
      'SELECT * FROM loyalty_transactions WHERE user_id=$1 ORDER BY created_at DESC LIMIT 20', [req.user.id]
    );
    res.json({ ...user.rows[0], thresholds:{NEW:0,SILVER:500,GOLD:2000,DIAMOND:5000}, history:history.rows });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
```

### 3.13 backend/src/routes/index.js

```javascript
const express     = require('express');
const router      = express.Router();
const authMw      = require('../middleware/auth');
const authCtrl    = require('../controllers/authController');
const productCtrl = require('../controllers/productController');
const orderCtrl   = require('../controllers/orderController');
const addrCtrl    = require('../controllers/addressController');
const miscCtrl    = require('../controllers/miscController');

router.post('/auth/register',           authCtrl.register);
router.post('/auth/login',              authCtrl.login);
router.get ('/auth/me',      authMw,    authCtrl.getMe);
router.put ('/auth/profile', authMw,    authCtrl.updateProfile);

router.get('/products',                 productCtrl.getAll);
router.get('/products/:id',             productCtrl.getOne);
router.get('/categories',               productCtrl.getCategories);

router.post('/orders',       authMw,    orderCtrl.createOrder);
router.get ('/orders',       authMw,    orderCtrl.getMyOrders);
router.get ('/orders/:id',   authMw,    orderCtrl.getOrderDetail);

router.get   ('/addresses',             authMw, addrCtrl.getAll);
router.post  ('/addresses',             authMw, addrCtrl.create);
router.put   ('/addresses/:id/default', authMw, addrCtrl.setDefault);
router.delete('/addresses/:id',         authMw, addrCtrl.remove);

router.get ('/stores',                          miscCtrl.getStores);
router.get ('/promotions',                      miscCtrl.getPromotions);
router.post('/promotions/validate',             miscCtrl.validatePromo);
router.get ('/notifications',         authMw,   miscCtrl.getNotifications);
router.put ('/notifications/:id/read',authMw,   miscCtrl.markRead);
router.get ('/loyalty',               authMw,   miscCtrl.getLoyalty);

module.exports = router;
```

### 3.14 backend/src/index.js

```javascript
require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const routes  = require('./routes');

const app  = express();
app.use(cors());
app.use(express.json());
app.get('/health', (_, res) => res.json({ status: 'ok', service: 'ĐƯƠNG Coffee API' }));
app.use('/api', routes);
app.use((req, res) => res.status(404).json({ message: `Route ${req.path} không tồn tại` }));

app.listen(process.env.PORT || 3000, () => {
  console.log(`🚀 API: http://localhost:${process.env.PORT || 3000}`);
});
```

---

## 4. API ENDPOINTS — Tóm tắt

| Method | URL | Auth | Mô tả |
|--------|-----|:----:|-------|
| POST | `/api/auth/register` | ❌ | Đăng ký |
| POST | `/api/auth/login` | ❌ | Đăng nhập → JWT |
| GET | `/api/auth/me` | ✅ | Thông tin user |
| PUT | `/api/auth/profile` | ✅ | Cập nhật profile |
| GET | `/api/products` | ❌ | Danh sách sản phẩm |
| GET | `/api/products/:id` | ❌ | Chi tiết sản phẩm |
| GET | `/api/categories` | ❌ | Danh mục |
| POST | `/api/orders` | ✅ | Tạo đơn hàng |
| GET | `/api/orders` | ✅ | Lịch sử đơn |
| GET | `/api/orders/:id` | ✅ | Chi tiết đơn |
| GET | `/api/addresses` | ✅ | Danh sách địa chỉ |
| POST | `/api/addresses` | ✅ | Thêm địa chỉ |
| PUT | `/api/addresses/:id/default` | ✅ | Đặt mặc định |
| DELETE | `/api/addresses/:id` | ✅ | Xóa địa chỉ |
| GET | `/api/stores` | ❌ | Danh sách cửa hàng |
| GET | `/api/promotions` | ❌ | Khuyến mãi |
| POST | `/api/promotions/validate` | ❌ | Kiểm tra mã |
| GET | `/api/notifications` | ✅ | Thông báo |
| GET | `/api/loyalty` | ✅ | Điểm tích lũy |

---

## 5. FLUTTER — pubspec.yaml

```yaml
name: duong_coffee
description: "ĐƯƠNG Coffee & Tea House"
publish_to: none
version: 1.0.0+1

environment:
  sdk: ^3.7.0

dependencies:
  flutter:
    sdk: flutter
  http:                 ^1.2.1      # Thêm mới — kết nối backend
  provider:             ^6.1.2
  go_router:            ^14.0.0
  google_fonts:         ^6.2.1
  cached_network_image: ^3.4.1
  shimmer:              ^3.0.0
  shared_preferences:   ^2.5.3
  image_picker:         ^1.1.2
  google_maps_flutter:  ^2.9.0
  geolocator:           ^13.0.0
  qr_flutter:           ^4.1.0
  intl:                 ^0.20.2
  url_launcher:         ^6.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## 6. FLUTTER — lib/data/services/api_service.dart

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Android Emulator dùng: http://10.0.2.2:3000/api
  // Máy thật cùng wifi:    http://192.168.x.x:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString('jwt_token');

  static Future<void> saveToken(String token) async =>
      (await SharedPreferences.getInstance()).setString('jwt_token', token);

  static Future<void> clearToken() async {
    final p = await SharedPreferences.getInstance();
    await p.remove('jwt_token');
    await p.remove('user_data');
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final h = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  static Map<String, dynamic> _parse(http.Response res) {
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw Exception(body['message'] ?? 'Lỗi (${res.statusCode})');
  }

  // AUTH
  static Future<Map<String, dynamic>> register({
    required String name, required String email,
    required String password, String? phone,
  }) async {
    final res = await http.post(Uri.parse('$baseUrl/auth/register'),
      headers: await _headers(),
      body: jsonEncode({'name':name,'email':email,'password':password,'phone':phone}));
    final data = _parse(res);
    await saveToken(data['token']);
    return data;
  }

  static Future<Map<String, dynamic>> login({
    required String email, required String password,
  }) async {
    final res = await http.post(Uri.parse('$baseUrl/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email':email,'password':password}));
    final data = _parse(res);
    await saveToken(data['token']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(data['user']));
    return data;
  }

  static Future<void> logout() async => clearToken();

  static Future<Map<String, dynamic>> getMe() async =>
      _parse(await http.get(Uri.parse('$baseUrl/auth/me'), headers: await _headers(auth: true)));

  static Future<Map<String, dynamic>> updateProfile({
    required String name, String? phone, String? avatarUrl,
  }) async =>
      _parse(await http.put(Uri.parse('$baseUrl/auth/profile'),
        headers: await _headers(auth: true),
        body: jsonEncode({'name':name,'phone':phone,'avatar_url':avatarUrl})));

  // PRODUCTS
  static Future<List<dynamic>> getProducts({int? categoryId, bool? bestSeller, String? search}) async {
    final params = <String,String>{};
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (bestSeller == true) params['best_seller'] = 'true';
    if (search?.isNotEmpty == true) params['search'] = search!;
    final res = await http.get(
      Uri.parse('$baseUrl/products').replace(queryParameters: params),
      headers: await _headers());
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<Map<String, dynamic>> getProduct(int id) async =>
      _parse(await http.get(Uri.parse('$baseUrl/products/$id'), headers: await _headers()));

  static Future<List<dynamic>> getCategories() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/categories'), headers: await _headers())).bodyBytes));

  // ORDERS
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    int? addressId, String deliveryMode = 'delivery',
    String paymentMethod = 'cod', String? promoCode, String? note,
  }) async =>
      _parse(await http.post(Uri.parse('$baseUrl/orders'),
        headers: await _headers(auth: true),
        body: jsonEncode({'items':items,'address_id':addressId,'delivery_mode':deliveryMode,
          'payment_method':paymentMethod,'promo_code':promoCode,'note':note})));

  static Future<List<dynamic>> getMyOrders() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/orders'), headers: await _headers(auth: true))).bodyBytes));

  // ADDRESSES
  static Future<List<dynamic>> getAddresses() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/addresses'), headers: await _headers(auth: true))).bodyBytes));

  static Future<Map<String, dynamic>> addAddress(Map<String, dynamic> addr) async =>
      _parse(await http.post(Uri.parse('$baseUrl/addresses'),
        headers: await _headers(auth: true), body: jsonEncode(addr)));

  static Future<void> setDefaultAddress(int id) async =>
      http.put(Uri.parse('$baseUrl/addresses/$id/default'), headers: await _headers(auth: true));

  static Future<void> deleteAddress(int id) async =>
      http.delete(Uri.parse('$baseUrl/addresses/$id'), headers: await _headers(auth: true));

  // MISC
  static Future<List<dynamic>> getStores() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/stores'), headers: await _headers())).bodyBytes));

  static Future<List<dynamic>> getPromotions() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/promotions'), headers: await _headers())).bodyBytes));

  static Future<Map<String, dynamic>> validatePromo(String code, double total) async =>
      _parse(await http.post(Uri.parse('$baseUrl/promotions/validate'),
        headers: await _headers(), body: jsonEncode({'code':code,'total_price':total})));

  static Future<List<dynamic>> getNotifications() async =>
      jsonDecode(utf8.decode((await http.get(Uri.parse('$baseUrl/notifications'), headers: await _headers(auth: true))).bodyBytes));

  static Future<Map<String, dynamic>> getLoyalty() async =>
      _parse(await http.get(Uri.parse('$baseUrl/loyalty'), headers: await _headers(auth: true)));
}
```

---

## 7. THAY FIREBASE BẰNG API TRONG FLUTTER

### LoginScreen.dart
```dart
// ❌ XÓA — Firebase + lưu password thô
await FirebaseAuth.instance.signInWithEmailAndPassword(...);
await prefs.setString('password', passwordController.text); // NGUY HIỂM

// ✅ THAY
try {
  await ApiService.login(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );
  Navigator.pushReplacementNamed(context, '/');
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
}
```

### RegisterScreen.dart
```dart
// ❌ XÓA
await FirebaseAuth.instance.createUserWithEmailAndPassword(...);

// ✅ THAY
await ApiService.register(
  name: nameController.text.trim(),
  email: emailController.text.trim(),
  password: passwordController.text.trim(),
  phone: phoneController.text.trim(),
);
```

### HomeScreen.dart — Load sản phẩm từ API
```dart
// Thêm vào State
List<dynamic> drinks = [];
bool isLoading = true;

@override
void initState() {
  super.initState();
  _loadProducts();
}

Future<void> _loadProducts() async {
  try {
    final data = await ApiService.getProducts(bestSeller: true);
    setState(() { drinks = data; isLoading = false; });
  } catch (_) {
    setState(() => isLoading = false);
  }
}

// Trong build, thay hardcoded drinks bằng:
// title: drinks[i]['name']
// price: double.parse(drinks[i]['price'].toString())
// imageUrl: drinks[i]['image_url']
```

### DrawerMenu.dart — Logout
```dart
// ✅ THAY nút Đăng xuất
ListTile(
  leading: const Icon(Icons.logout, color: Colors.red),
  title: const Text('Đăng Xuất', style: TextStyle(color: Colors.red)),
  onTap: () async {
    await ApiService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  },
),
```

### main.dart — Xóa Firebase init
```dart
// ❌ XÓA
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// ✅ GIỮ LẠI chỉ
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

---

## 8. HỆ THỐNG MÀU SẮC — lib/core/theme/app_colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary       = Color(0xFF0D3349);
  static const Color primaryDark   = Color(0xFF071E2C);
  static const Color primaryLight  = Color(0xFF1F4352);
  static const Color gold          = Color(0xFFC49B6C);
  static const Color goldLight     = Color(0xFFD4AA6C);
  static const Color background    = Color(0xFFF5F0EB);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceCard   = Color(0xFFF9F4EE);
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B5C4C);
  static const Color textHint      = Color(0xFF9E9E9E);
  static const Color success       = Color(0xFF4CAF50);
  static const Color error         = Color(0xFFE53935);
  static const Color divider       = Color(0xFFE8DDD2);
  static const Color border        = Color(0xFFD4C4B4);
  static const Color tierNew       = Color(0xFF78909C);
  static const Color tierSilver    = Color(0xFFB0BEC5);
  static const Color tierGold      = Color(0xFFC49B6C);
  static const Color tierDiamond   = Color(0xFF7986CB);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0D3349), Color(0xFF1F4352)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC49B6C), Color(0xFFD4AA6C)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0D3349), Color(0xFF2A6080)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
  );
}
```

---

## 9. HƯỚNG DẪN CHẠY

### Bước 1 — Khởi động Docker backend
```bash
cd backend
docker-compose up -d

# Kiểm tra
curl http://localhost:3000/health
# Kết quả: {"status":"ok","service":"ĐƯƠNG Coffee API"}
```

### Bước 2 — Chạy Flutter
```bash
cd flutter_app
flutter pub get
flutter run
```

### Tài khoản test
```
Email:    test@duong.com
Password: 123456
```

### Lệnh Docker hữu ích
```bash
docker-compose up -d              # Khởi động
docker-compose down               # Dừng
docker-compose logs -f duong_api  # Xem log API
docker-compose logs -f duong_db   # Xem log DB
docker exec -it duong_db psql -U duong_user -d duong_coffee  # Vào DB shell
```

---

## 10. CÁC LỖI CẦN FIX NGAY

| File | Lỗi | Fix |
|------|-----|-----|
| `LoginScreen.dart` | Lưu `password` thô vào SharedPreferences | XÓA, chỉ lưu JWT token |
| `HomeScreen.dart` | Sản phẩm hardcode | Gọi `ApiService.getProducts()` |
| `main.dart` | Firebase init + import OrderHistoryProvider từ Screen | Xóa Firebase, tách Provider ra file riêng |
| `cartscreen.dart` | Giá `218,000đ` hardcode | Lấy từ `original_price` API |
| `storemapscreen.dart` | File trống | Implement hoặc xóa |
| `your_cart_file_path.dart` | File trống | Xóa |
| Nhiều file | Import tên file chữ hoa (`Orderconfirmationscreen`) | Đổi tất cả thành lowercase |
| `DrawerMenu.dart` | Không xóa token khi logout | Gọi `ApiService.logout()` |

---

## 11. CHECKLIST THỰC HIỆN

### Phase 1 — Dựng Backend
- [ ] Tạo thư mục `backend/`, tạo từng file theo §3
- [ ] `docker-compose up -d`
- [ ] Test health check

### Phase 2 — Flutter kết nối API
- [ ] Cập nhật `pubspec.yaml` (thêm `http`, xóa firebase packages)
- [ ] Tạo `lib/data/services/api_service.dart` (copy từ §6)
- [ ] Fix `LoginScreen.dart` — xóa Firebase, xóa lưu password
- [ ] Fix `RegisterScreen.dart`
- [ ] Fix `HomeScreen.dart` — load sản phẩm từ API
- [ ] Fix `DrawerMenu.dart` — logout đúng cách
- [ ] Fix `main.dart` — xóa Firebase init

### Phase 3 — UI Katinat style
- [ ] Tạo `app_colors.dart` (copy từ §8)
- [ ] Tổ chức lại folder structure theo §2
- [ ] Redesign HomeScreen, CartScreen, ProfileScreen
- [ ] Thêm LoyaltyScreen, StoreLocatorScreen

### Phase 4 — Fix bugs & polish
- [ ] Xóa file trống (`storemapscreen.dart`, `your_cart_file_path.dart`)
- [ ] Đồng nhất lowercase tên file
- [ ] Thêm loading indicator / shimmer
- [ ] Test toàn bộ luồng: Login → Đặt hàng → Thanh toán → Lịch sử

---

*CLAUDE.md v2.0 — 2026-04-14*
*Stack: Flutter + Node.js/Express + PostgreSQL + Docker*
