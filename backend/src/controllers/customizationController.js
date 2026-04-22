const pool = require('../config/db');

// Get all sizes
exports.getSizes = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM product_sizes WHERE is_active=TRUE ORDER BY sort_order'
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// Get all toppings
exports.getToppings = async (req, res) => {
  try {
    res.json((await pool.query(
      'SELECT * FROM product_toppings WHERE is_active=TRUE ORDER BY category, name'
    )).rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// Get product customizations
exports.getProductCustomizations = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT pc.*, ps.name as size_name, ps.display_name as size_display,
              ps.price_adjust as size_price, pt.name as topping_name,
              pt.display_name as topping_display, pt.price as topping_price
       FROM product_customizations pc
       LEFT JOIN product_sizes ps ON pc.size_id=ps.id
       LEFT JOIN product_toppings pt ON pc.topping_id=pt.id
       WHERE pc.product_id=$1`,
      [req.params.productId]
    );
    res.json(result.rows);
  } catch (err) { res.status(500).json({ message: err.message }); }
};

// Get available options for a product
exports.getProductOptions = async (req, res) => {
  try {
    const productId = req.params.productId;

    // Get product details
    const product = await pool.query('SELECT * FROM products WHERE id=$1', [productId]);
    if (!product.rows.length) {
      return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
    }

    // Get all active sizes
    const sizes = await pool.query(
      'SELECT * FROM product_sizes WHERE is_active=TRUE ORDER BY sort_order'
    );

    // Get all active toppings
    const toppings = await pool.query(
      'SELECT * FROM product_toppings WHERE is_active=TRUE ORDER BY price'
    );

    res.json({
      product: product.rows[0],
      sizes: sizes.rows,
      toppings: toppings.rows,
      sugarLevels: ['0%', '30%', '50%', '70%', '100%'],
      iceLevels: ['0%', '30%', '50%', '70%', '100%'],
    });
  } catch (err) { res.status(500).json({ message: err.message }); }
};
