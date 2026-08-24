const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { z } = require('zod');

const pool = require('../config/database');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();
const credentialsSchema = z.object({
  email: z.string().trim().email().max(255).transform((value) => value.toLowerCase()),
  password: z.string().min(6).max(72),
});
const signupSchema = credentialsSchema.extend({
  name: z.string().trim().min(2).max(100),
});

function sessionFor(user) {
  const token = jwt.sign(
    { sub: String(user.id), email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' },
  );
  return { token, user: { id: user.id, name: user.name, email: user.email } };
}

router.post('/signup', async (req, res, next) => {
  try {
    const parsed = signupSchema.safeParse(req.body);
    if (!parsed.success) return res.status(400).json({ message: 'Invalid account details.', errors: parsed.error.flatten().fieldErrors });

    const { name, email, password } = parsed.data;
    const [existing] = await pool.execute('SELECT id FROM users WHERE email = ? LIMIT 1', [email]);
    if (existing.length) return res.status(409).json({ message: 'An account with this email already exists.' });

    const passwordHash = await bcrypt.hash(password, 12);
    const [result] = await pool.execute(
      'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)',
      [name, email, passwordHash],
    );
    res.status(201).json(sessionFor({ id: result.insertId, name, email }));
  } catch (error) { next(error); }
});

router.post('/login', async (req, res, next) => {
  try {
    const parsed = credentialsSchema.safeParse(req.body);
    if (!parsed.success) return res.status(400).json({ message: 'Enter a valid email and password.' });

    const { email, password } = parsed.data;
    const [rows] = await pool.execute(
      'SELECT id, name, email, password_hash FROM users WHERE email = ? AND is_active = TRUE LIMIT 1',
      [email],
    );
    const user = rows[0];
    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      return res.status(401).json({ message: 'Incorrect email or password.' });
    }
    res.json(sessionFor(user));
  } catch (error) { next(error); }
});

router.get('/me', requireAuth, async (req, res, next) => {
  try {
    const [rows] = await pool.execute('SELECT id, name, email, created_at FROM users WHERE id = ? LIMIT 1', [req.user.sub]);
    if (!rows.length) return res.status(404).json({ message: 'Account not found.' });
    res.json({ user: rows[0] });
  } catch (error) { next(error); }
});

module.exports = router;
