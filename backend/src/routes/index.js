const express = require('express');
const router = express.Router();
const authMw = require('../middleware/auth');
const adminMw = require('../middleware/admin');
const authCtrl = require('../controllers/authController');
const productCtrl = require('../controllers/productController');
const orderCtrl = require('../controllers/orderController');
const addrCtrl = require('../controllers/addressController');
const miscCtrl = require('../controllers/miscController');
const blogCtrl = require('../controllers/blogController');
const custCtrl = require('../controllers/customizationController');
const reviewCtrl = require('../controllers/reviewController');
const wishlistCtrl = require('../controllers/wishlistController');

router.post('/auth/register', authCtrl.register);
router.post('/auth/login', authCtrl.login);
router.get('/auth/me', authMw, authCtrl.getMe);
router.put('/auth/profile', authMw, authCtrl.updateProfile);

// Admin User Management
router.get('/admin/users', authMw, adminMw, authCtrl.getAllUsers);
router.put('/admin/users/:id', authMw, adminMw, authCtrl.adminUpdateUser);
router.delete('/admin/users/:id', authMw, adminMw, authCtrl.deleteUser);
router.get('/admin/stats', authMw, adminMw, miscCtrl.getStats);
router.get('/admin/stats/detailed', authMw, adminMw, miscCtrl.getDetailedStats);

router.get('/products', productCtrl.getAll);
router.get('/products/:id', productCtrl.getOne);
router.get('/categories', productCtrl.getCategories);

// Admin Product Management
router.post('/admin/products', authMw, adminMw, productCtrl.create);
router.put('/admin/products/:id', authMw, adminMw, productCtrl.update);
router.delete('/admin/products/:id', authMw, adminMw, productCtrl.delete);

router.post('/orders', authMw, orderCtrl.createOrder);
router.get('/orders', authMw, orderCtrl.getMyOrders);
router.get('/orders/:id', authMw, orderCtrl.getOrderDetail);

// Admin Order Management
router.get('/admin/orders', authMw, adminMw, orderCtrl.getAll);
router.put('/admin/orders/:id/status', authMw, adminMw, orderCtrl.updateStatus);

router.get('/addresses', authMw, addrCtrl.getAll);
router.post('/addresses', authMw, addrCtrl.create);
router.put('/addresses/:id/default', authMw, addrCtrl.setDefault);
router.delete('/addresses/:id', authMw, addrCtrl.remove);

router.get('/stores', miscCtrl.getStores);
router.get('/promotions', miscCtrl.getPromotions);
router.post('/promotions/validate', miscCtrl.validatePromo);
router.get('/notifications', authMw, miscCtrl.getNotifications);
router.put('/notifications/:id/read', authMw, miscCtrl.markRead);
router.get('/loyalty', authMw, miscCtrl.getLoyalty);
// Admin Promotion Management
router.get('/admin/promotions', authMw, adminMw, miscCtrl.adminGetAllPromotions);
router.post('/admin/promotions', authMw, adminMw, miscCtrl.createPromotion);
router.put('/admin/promotions/:id', authMw, adminMw, miscCtrl.updatePromotion);
router.delete('/admin/promotions/:id', authMw, adminMw, miscCtrl.deletePromotion);
// Admin Notifications
router.post('/admin/notifications/broadcast', authMw, adminMw, miscCtrl.broadcastNotification);

// Blogs
router.get('/blogs', blogCtrl.getAll);
router.get('/blogs/:slug', blogCtrl.getOne);
router.get('/blog-categories', blogCtrl.getCategories);

// Customizations
router.get('/sizes', custCtrl.getSizes);
router.get('/toppings', custCtrl.getToppings);
router.get('/products/:productId/options', custCtrl.getProductOptions);

// Reviews & Wishlist
router.get('/products/:productId/reviews', reviewCtrl.getReviews);
router.post('/reviews', authMw, reviewCtrl.addReview);
router.get('/wishlist', authMw, wishlistCtrl.getWishlist);
router.post('/wishlist/toggle', authMw, wishlistCtrl.toggleWishlist);

module.exports = router;
