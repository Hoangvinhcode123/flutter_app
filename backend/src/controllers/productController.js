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

exports.create = async (req, res) => {
  const { name, category_id, price, description, image_url, is_best_seller } = req.body;
  try {
    const { rows: [p] } = await pool.query(
      `INSERT INTO products (name, category_id, price, description, image_url, is_best_seller)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [name, category_id, price, description, image_url, is_best_seller || false]
    );
    res.status(201).json(p);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.update = async (req, res) => {
  const { name, category_id, price, description, image_url, is_best_seller, is_available } = req.body;
  try {
    const { rows: [p] } = await pool.query(
      `UPDATE products SET name=$1, category_id=$2, price=$3, description=$4, image_url=$5, is_best_seller=$6, is_available=$7
       WHERE id=$8 RETURNING *`,
      [name, category_id, price, description, image_url, is_best_seller, is_available, req.params.id]
    );
    res.json(p);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.delete = async (req, res) => {
  try {
    await pool.query('DELETE FROM products WHERE id=$1', [req.params.id]);
    res.json({ message: 'Đã xóa sản phẩm' });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
