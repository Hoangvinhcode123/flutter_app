const pool = require('../config/db');

exports.getAll = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM addresses WHERE user_id=$1 ORDER BY is_default DESC,id DESC', [req.user.id]
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.create = async (req, res) => {
  const { name, phone, address_type, tinh, huyen, xa, detail, note, is_default } = req.body;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    if (is_default) await client.query('UPDATE addresses SET is_default=FALSE WHERE user_id=$1', [req.user.id]);
    const result = await client.query(
      `INSERT INTO addresses (user_id, name, phone, address_type, tinh, huyen, xa, detail, note, is_default)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING *`,
      [req.user.id, name, phone, address_type || 'Nhà riêng', tinh, huyen, xa, detail, note || '', is_default || false]
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
