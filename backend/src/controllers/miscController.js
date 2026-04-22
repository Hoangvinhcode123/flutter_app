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
  const { code, total_price, items } = req.body;
  try {
    const result = await pool.query(
      `SELECT * FROM promotions WHERE code=$1 AND is_active=TRUE
       AND (start_date IS NULL OR start_date<=NOW()) AND (end_date IS NULL OR end_date>=NOW())`, [code]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Mã không hợp lệ hoặc đã hết hạn' });
    const promo = result.rows[0];
    
    // Ép kiểu về số để so sánh chính xác
    const minOrder = Number(promo.min_order);
    const discountPercent = Number(promo.discount);
    const discountAmount = Number(promo.discount_amount);
    const buyQty = Number(promo.buy_qty);
    const getQty = Number(promo.get_qty);

    if (total_price < minOrder) return res.status(400).json({ message: `Đơn tối thiểu ${minOrder}đ` });
    
    let discount = 0;

    if (promo.promo_type === 'bogo' && items && items.length > 0) {
      let totalQty = items.reduce((sum, item) => sum + Number(item.quantity), 0);
      if (totalQty >= (buyQty + getQty)) {
        const times = Math.floor(totalQty / (buyQty + getQty));
        const unitPrice = Number(items[0].price); 
        discount = times * getQty * unitPrice;
      }
    } else if (discountAmount > 0) {
      discount = discountAmount;
    } else if (discountPercent > 0) {
      discount = Math.round(total_price * discountPercent / 100);
    }

    if (discount <= 0) return res.status(400).json({ message: 'Mã hợp lệ nhưng không đủ điều kiện giảm giá (Giá trị giảm = 0)' });
    
    res.json({ valid: true, promo, discount });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getNotifications = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM notifications WHERE user_id=$1 AND scheduled_at <= NOW() ORDER BY created_at DESC LIMIT 50', [req.user.id]
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
    const user = await pool.query('SELECT kat_points, tier FROM users WHERE id=$1', [req.user.id]);
    const history = await pool.query(
      'SELECT * FROM loyalty_transactions WHERE user_id=$1 ORDER BY created_at DESC LIMIT 20', [req.user.id]
    );
    res.json({ ...user.rows[0], thresholds: { NEW: 0, SILVER: 500, GOLD: 2000, DIAMOND: 5000 }, history: history.rows });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getStats = async (req, res) => {
  try {
    const revenue = await pool.query("SELECT SUM(total_price) as total FROM orders WHERE status='Hoàn tất'");
    const orders = await pool.query("SELECT COUNT(*) as count FROM orders WHERE status='pending'");
    const users = await pool.query("SELECT COUNT(*) as count FROM users WHERE created_at >= NOW() - INTERVAL '30 days'");
    const outOfStock = await pool.query("SELECT COUNT(*) as count FROM products WHERE is_available=FALSE");
    
    const recentOrders = await pool.query(
      `SELECT o.*, u.name as user_name FROM orders o 
       LEFT JOIN users u ON o.user_id=u.id 
       ORDER BY o.created_at DESC LIMIT 5`
    );

    res.json({
      revenue: revenue.rows[0].total || 0,
      pendingOrders: orders.rows[0].count,
      newUsers: users.rows[0].count,
      outOfStock: outOfStock.rows[0].count,
      recentOrders: recentOrders.rows.map(o => ({
        id: `ORD-${o.id}`,
        customer: o.user_name || 'Khách',
        total: `${o.total_price}đ`,
        status: o.status
      }))
    });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getDetailedStats = async (req, res) => {
  try {
    // 1. Doanh thu 7 ngày gần nhất
    const dailyRevenue = await pool.query(`
      SELECT TO_CHAR(created_at, 'DD/MM') as date, SUM(total_price) as amount
      FROM orders 
      WHERE status='Hoàn tất' AND created_at >= NOW() - INTERVAL '7 days'
      GROUP BY TO_CHAR(created_at, 'DD/MM'), DATE_TRUNC('day', created_at)
      ORDER BY DATE_TRUNC('day', created_at)
    `);

    // 2. Doanh thu 6 tháng gần nhất
    const monthlyRevenue = await pool.query(`
      SELECT TO_CHAR(created_at, 'Month') as month, SUM(total_price) as amount
      FROM orders 
      WHERE status='Hoàn tất' AND created_at >= NOW() - INTERVAL '6 months'
      GROUP BY TO_CHAR(created_at, 'Month'), DATE_TRUNC('month', created_at)
      ORDER BY DATE_TRUNC('month', created_at)
    `);

    // 3. Top sản phẩm bán chạy
    const topProducts = await pool.query(`
      SELECT p.name, COUNT(oi.product_id) as sales, SUM(oi.quantity * oi.price) as revenue
      FROM order_items oi
      JOIN products p ON oi.product_id = p.id
      JOIN orders o ON oi.order_id = o.id
      WHERE o.status = 'Hoàn tất'
      GROUP BY p.name
      ORDER BY sales DESC LIMIT 5
    `);

    res.json({
      daily: dailyRevenue.rows,
      monthly: monthlyRevenue.rows,
      topProducts: topProducts.rows
    });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// ==========================================
// ADMIN PROMOTIONS (VOUCHERS)
// ==========================================
exports.adminGetAllPromotions = async (req, res) => {
  try { res.json((await pool.query('SELECT * FROM promotions ORDER BY id DESC')).rows); }
  catch (err) { res.status(500).json({ message: err.message }); }
};

exports.createPromotion = async (req, res) => {
  const { title, description, code, discount, min_order, image_url, is_active, promo_type, buy_qty, get_qty, discount_amount } = req.body;
  try {
    const result = await pool.query(
      `INSERT INTO promotions (title, description, code, discount, min_order, image_url, is_active, promo_type, buy_qty, get_qty, discount_amount)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) RETURNING *`,
      [title, description, code, discount, min_order, image_url, is_active !== false, promo_type || 'discount', buy_qty || 0, get_qty || 0, discount_amount || 0]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.updatePromotion = async (req, res) => {
  const { title, description, code, discount, min_order, image_url, is_active, promo_type, buy_qty, get_qty, discount_amount } = req.body;
  try {
    const result = await pool.query(
      `UPDATE promotions SET title=$1, description=$2, code=$3, discount=$4, min_order=$5, image_url=$6, is_active=$7, promo_type=$8, buy_qty=$9, get_qty=$10, discount_amount=$11
       WHERE id=$12 RETURNING *`,
      [title, description, code, discount, min_order, image_url, is_active, promo_type, buy_qty, get_qty, discount_amount, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.deletePromotion = async (req, res) => {
  try {
    await pool.query('DELETE FROM promotions WHERE id=$1', [req.params.id]);
    res.json({ message: 'Đã xoá khuyến mãi' });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// ==========================================
// ADMIN NOTIFICATIONS
// ==========================================
exports.broadcastNotification = async (req, res) => {
  const { title, body, scheduled_at } = req.body;
  try {
    // Lấy tất cả user ID
    const users = await pool.query('SELECT id FROM users');
    
    // Tạo thông báo cho từng user (trong thực tế nên dùng batch insert)
    for (const user of users.rows) {
      await pool.query(
        'INSERT INTO notifications (user_id, title, body, scheduled_at) VALUES ($1, $2, $3, $4)',
        [user.id, title, body, scheduled_at || new Date()]
      );
    }
    
    res.status(201).json({ message: `Đã gửi thông báo đến ${users.rowCount} người dùng` });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
