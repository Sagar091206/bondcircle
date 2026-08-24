# BondCircle API

Node.js/Express API backed by MySQL. Flutter must call this API instead of connecting directly to MySQL.

## Local setup

1. Install and start MySQL 8 or newer.
2. Run `database/schema.sql` in MySQL Workbench or the MySQL command-line client.
3. Create an application-only database user and grant it access to `bondcircle`.
4. Copy `.env.example` to `.env` and enter the local database credentials and a long random JWT secret.
5. Run `npm install` and then `npm run dev`.
6. Verify `http://localhost:3000/api/health` returns a JSON success response.

Android Emulator reaches the computer through `http://10.0.2.2:3000`. Do not commit `.env`.

## Authentication endpoints

- `POST /api/auth/signup` with `{ "name", "email", "password" }`
- `POST /api/auth/login` with `{ "email", "password" }`
- `GET /api/auth/me` with header `Authorization: Bearer <token>`
