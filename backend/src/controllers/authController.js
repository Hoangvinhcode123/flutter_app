const pool   = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt    = require('jsonwebtoken');

const makeToken = (user) =>
  jwt.sign({ id: user.id, email: user.email, name: user.name, role: user.role },
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
      'SELECT id,name,email,phone,avatar_url,kat_points,tier,birthday,gender,created_at FROM users WHERE id=$1',
      [req.user.id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'User không tồn tại' });
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.updateProfile = async (req, res) => {
  const { name, phone, avatar_url, birthday, gender } = req.body;
  try {
    let birthdayVal = birthday;
    if (birthdayVal && typeof birthdayVal === 'string') {
      const parts = birthdayVal.split(/[-/]/);
      if (parts.length === 3 && parts[0].length === 2) {
        birthdayVal = `${parts[2]}-${parts[1]}-${parts[0]}`;
      }
    }

    const result = await pool.query(
      `UPDATE users SET name=$1, phone=$2, avatar_url=$3, birthday=$4, gender=$5, updated_at=NOW()
       WHERE id=$6 RETURNING id,name,email,phone,avatar_url,kat_points,tier,birthday,gender`,
      [name, phone, avatar_url, birthdayVal, gender, req.user.id]
    );
    res.json({ message: 'Cập nhật thành công', user: result.rows[0] });
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.getAllUsers = async (req, res) => {
  try {
    const result = await pool.query('SELECT id,name,email,phone,role,kat_points,tier,created_at FROM users ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.adminUpdateUser = async (req, res) => {
  const { name, email, role, phone } = req.body;
  try {
    const result = await pool.query(
      'UPDATE users SET name=$1, email=$2, role=$3, phone=$4, updated_at=NOW() WHERE id=$5 RETURNING id,name,email,role,phone',
      [name, email, role, phone, req.params.id]
    );
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.deleteUser = async (req, res) => {
  try {
    await pool.query('DELETE FROM users WHERE id=$1', [req.params.id]);
    res.json({ message: 'Đã xóa người dùng' });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
