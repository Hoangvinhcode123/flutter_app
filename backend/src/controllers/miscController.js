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
