const pool = require('../config/db');

exports.getWishlist = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT w.*, p.name, p.price, p.image_url, c.name as category_name 
       FROM wishlist w 
       JOIN products p ON w.product_id = p.id 
       JOIN categories c ON p.category_id = c.id
       WHERE w.user_id = $1`,
      [req.user.id]
    );
    res.json(result.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.toggleWishlist = async (req, res) => {
  const { product_id } = req.body;
  try {
    const exists = await pool.query(
      'SELECT id FROM wishlist WHERE user_id = $1 AND product_id = $2',
      [req.user.id, product_id]
    );

    if (exists.rows.length) {
      await pool.query('DELETE FROM wishlist WHERE id = $1', [exists.rows[0].id]);
      res.json({ message: 'Đã xóa khỏi danh sách yêu thích', action: 'removed' });
    } else {
      await pool.query(
        'INSERT INTO wishlist (user_id, product_id) VALUES ($1, $2)',
        [req.user.id, product_id]
      );
      res.json({ message: 'Đã thêm vào danh sách yêu thích', action: 'added' });
    }
  } catch (err) { res.status(500).json({ message: err.message }); }
};
