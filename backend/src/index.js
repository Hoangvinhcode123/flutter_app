require('dotenv').config();
const express = require('express');
const cors = require('cors');
const routes = require('./routes');

const app = express();
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('public/uploads'));
app.get('/health', (_, res) => res.json({ status: 'ok', service: 'ĐƯƠNG Coffee API' }));
app.use('/api', routes);
app.use('/api/upload', require('./routes/uploadRoutes'));
app.use((req, res) => res.status(404).json({ message: `Route ${req.path} không tồn tại` }));

app.listen(process.env.PORT || 3000, () => {
  console.log(`🚀 API: http://localhost:${process.env.PORT || 3000}`);
});
