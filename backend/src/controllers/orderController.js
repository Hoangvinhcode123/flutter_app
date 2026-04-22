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

exports.getAll = async (req, res) => {
  try {
    const orders = await pool.query(
      `SELECT o.*, u.name as user_name, u.phone as user_phone
       FROM orders o LEFT JOIN users u ON o.user_id=u.id
       ORDER BY o.created_at DESC`
    );
    res.json(orders.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

exports.updateStatus = async (req, res) => {
  const { status } = req.body;
  try {
    const { rows: [order] } = await pool.query(
      'UPDATE orders SET status=$1 WHERE id=$2 RETURNING *',
      [status, req.params.id]
    );
    res.json(order);
  } catch (err) { res.status(500).json({ message: err.message }); }
};
