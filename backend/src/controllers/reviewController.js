const pool = require('../config/db');

exports.getReviews = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT r.*, u.name as user_name, u.avatar_url 
       FROM product_reviews r JOIN users u ON r.user_id = u.id 
       WHERE r.product_id = $1 ORDER BY r.created_at DESC`,
      [req.params.productId]
    );
    res.json(result.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.addReview = async (req, res) => {
  const { product_id, rating, comment, image_url } = req.body;
  try {
    // Kiểm tra xem user đã mua hàng chưa (optional nhưng nên có)
    const hasOrdered = await pool.query(
      `SELECT oi.id FROM order_items oi JOIN orders o ON oi.order_id = o.id 
       WHERE o.user_id = $1 AND oi.product_id = $2 AND o.status = 'Hoàn tất'`,
      [req.user.id, product_id]
    );
    
    if (!hasOrdered.rows.length) {
      return res.status(403).json({ message: 'Bạn cần hoàn tất mua sản phẩm này trước khi đánh giá' });
    }

    const result = await pool.query(
      `INSERT INTO product_reviews (product_id, user_id, rating, comment, image_url) 
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [product_id, req.user.id, rating, comment, image_url || '']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};
