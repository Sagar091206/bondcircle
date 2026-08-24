CREATE DATABASE IF NOT EXISTS bondcircle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bondcircle;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
  user_id BIGINT UNSIGNED PRIMARY KEY,
  age TINYINT UNSIGNED,
  city VARCHAR(100),
  bio VARCHAR(500),
  photo_url VARCHAR(500),
  CONSTRAINT fk_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_profile_age CHECK (age IS NULL OR age BETWEEN 18 AND 99)
);

CREATE TABLE interests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE user_interests (
  user_id BIGINT UNSIGNED NOT NULL,
  interest_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, interest_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (interest_id) REFERENCES interests(id) ON DELETE CASCADE
);

CREATE TABLE circles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description VARCHAR(500),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE circle_members (
  circle_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (circle_id, user_id),
  FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE matches (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_one_id BIGINT UNSIGNED NOT NULL,
  user_two_id BIGINT UNSIGNED NOT NULL,
  circle_id BIGINT UNSIGNED,
  status ENUM('pending', 'matched', 'blocked') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_one_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (user_two_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (circle_id) REFERENCES circles(id) ON DELETE SET NULL,
  UNIQUE KEY uq_match_pair (user_one_id, user_two_id),
  CONSTRAINT chk_match_users CHECK (user_one_id < user_two_id)
);

CREATE TABLE messages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  match_id BIGINT UNSIGNED NOT NULL,
  sender_id BIGINT UNSIGNED NOT NULL,
  body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_messages_match_time (match_id, sent_at)
);

CREATE TABLE meetup_plans (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  match_id BIGINT UNSIGNED NOT NULL,
  created_by BIGINT UNSIGNED NOT NULL,
  title VARCHAR(60) NOT NULL,
  vibe VARCHAR(60) NOT NULL,
  venue_name VARCHAR(150),
  venue_area VARCHAR(150),
  starts_at DATETIME NOT NULL,
  note VARCHAR(240),
  status ENUM('proposed', 'confirmed', 'cancelled') NOT NULL DEFAULT 'proposed',
  FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE trusted_contacts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE safety_checkins (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  meetup_plan_id BIGINT UNSIGNED NOT NULL,
  trusted_contact_id BIGINT UNSIGNED NOT NULL,
  due_at DATETIME NOT NULL,
  status ENUM('scheduled', 'safe', 'missed', 'cancelled') NOT NULL DEFAULT 'scheduled',
  FOREIGN KEY (meetup_plan_id) REFERENCES meetup_plans(id) ON DELETE CASCADE,
  FOREIGN KEY (trusted_contact_id) REFERENCES trusted_contacts(id) ON DELETE CASCADE
);

CREATE TABLE blind_sessions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_one_id BIGINT UNSIGNED NOT NULL,
  user_two_id BIGINT UNSIGNED NOT NULL,
  user_one_alias VARCHAR(50) NOT NULL,
  user_two_alias VARCHAR(50) NOT NULL,
  user_one_reveal BOOLEAN NOT NULL DEFAULT FALSE,
  user_two_reveal BOOLEAN NOT NULL DEFAULT FALSE,
  status ENUM('active', 'revealed', 'ended') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_one_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (user_two_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_blind_users CHECK (user_one_id < user_two_id)
);

CREATE TABLE blind_messages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  blind_session_id BIGINT UNSIGNED NOT NULL,
  sender_id BIGINT UNSIGNED NOT NULL,
  body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (blind_session_id) REFERENCES blind_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_blind_messages_time (blind_session_id, sent_at)
);

INSERT IGNORE INTO interests (name) VALUES
  ('Coffee'), ('Books'), ('Fitness'), ('Music'), ('Travel'), ('Startups'), ('Movies'), ('Food');
