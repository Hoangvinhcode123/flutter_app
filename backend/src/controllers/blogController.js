const pool = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    const { category, featured } = req.query;
    let query = `SELECT * FROM blogs WHERE is_published=TRUE`;
    const params = [];

    if (category) {
      params.push(category);
      query += ` AND category=$${params.length}`;
    }
    if (featured === 'true') {
      query += ` AND is_featured=TRUE`;
    }

    query += ` ORDER BY is_featured DESC, published_at DESC`;

    res.json((await pool.query(query, params)).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getOne = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM blogs WHERE slug=$1 AND is_published=TRUE',
      [req.params.slug]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Không tìm thấy bài viết' });

    // Tăng view count
    await pool.query('UPDATE blogs SET view_count=view_count+1 WHERE slug=$1', [req.params.slug]);

    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getCategories = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT DISTINCT category FROM blogs WHERE is_published=TRUE ORDER BY category'
    );
    res.json(result.rows.map(r => r.category));
  } catch (err) { res.status(500).json({ message: err.message }); }
};
