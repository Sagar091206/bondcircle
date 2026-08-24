require('dotenv').config();

const app = require('./app');
const pool = require('./config/database');

const port = Number(process.env.PORT || 3000);

async function start() {
  if (!process.env.JWT_SECRET || process.env.JWT_SECRET.length < 32) {
    throw new Error('JWT_SECRET must contain at least 32 characters.');
  }
  await pool.query('SELECT 1');
  app.listen(port, () => console.log(`BondCircle API running on http://localhost:${port}`));
}

start().catch((error) => {
  console.error('API startup failed:', error.message);
  process.exit(1);
});
