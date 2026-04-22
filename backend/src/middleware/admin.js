module.exports = (req, res, next) => {
  if (req.user && (req.user.role === 'ADMIN' || req.user.role === 'SUPER_ADMIN')) {
    next();
  } else {
    res.status(403).json({ message: 'Quyền truy cập bị từ chối: Chỉ dành cho Admin' });
  }
};
