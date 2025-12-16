-- Create users table for role management
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  firebase_uid VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255),
  photo_url TEXT,
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_firebase_uid (firebase_uid),
  INDEX idx_email (email),
  INDEX idx_role (role)
);

-- Create deals table
CREATE TABLE IF NOT EXISTS deals (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  store VARCHAR(100) NOT NULL,
  original_price DECIMAL(10, 2) NOT NULL,
  discounted_price DECIMAL(10, 2) NOT NULL,
  discount INT NOT NULL,
  rating DECIMAL(2, 1) DEFAULT 0,
  reviews INT DEFAULT 0,
  image TEXT,
  category VARCHAR(100),
  expires_at DATETIME,
  verified BOOLEAN DEFAULT 0,
  deleted BOOLEAN DEFAULT 0,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_category (category),
  INDEX idx_store (store),
  INDEX idx_created_at (created_at),
  INDEX idx_deleted (deleted)
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  icon VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create stores table
CREATE TABLE IF NOT EXISTS stores (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE,
  logo TEXT,
  website VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create user_favorites table
CREATE TABLE IF NOT EXISTS user_favorites (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_deal (user_id, deal_id),
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id)
);

-- Create deal_views table for tracking user interactions
CREATE TABLE IF NOT EXISTS deal_views (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_id INT NOT NULL,
  viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_viewed_at (viewed_at)
);

-- Create deal_clicks table for tracking deal clicks
CREATE TABLE IF NOT EXISTS deal_clicks (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255),
  deal_id INT NOT NULL,
  clicked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  user_agent TEXT,
  referrer TEXT,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_clicked_at (clicked_at)
);

-- Create deal_ratings table for user ratings
CREATE TABLE IF NOT EXISTS deal_ratings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_id INT NOT NULL,
  rating TINYINT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_deal_rating (user_id, deal_id),
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_rating (rating)
);

-- Create deal_reviews table for user reviews
CREATE TABLE IF NOT EXISTS deal_reviews (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_id INT NOT NULL,
  rating TINYINT NOT NULL,
  title VARCHAR(255),
  comment TEXT,
  verified_purchase BOOLEAN DEFAULT 0,
  helpful_votes INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_rating (rating),
  INDEX idx_created_at (created_at)
);

-- Create deal_review_votes table for helpful votes
CREATE TABLE IF NOT EXISTS deal_review_votes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  review_id INT NOT NULL,
  vote_type ENUM('helpful', 'not_helpful') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (review_id) REFERENCES deal_reviews(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_review_vote (user_id, review_id),
  INDEX idx_user_id (user_id),
  INDEX idx_review_id (review_id)
);

-- Create deal_shares table for tracking social shares
CREATE TABLE IF NOT EXISTS deal_shares (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255),
  deal_id INT NOT NULL,
  platform ENUM('facebook', 'twitter', 'linkedin', 'whatsapp', 'telegram', 'email', 'copy_link') NOT NULL,
  shared_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_platform (platform),
  INDEX idx_shared_at (shared_at)
);

-- Create analytics_summary table for cached analytics data
CREATE TABLE IF NOT EXISTS analytics_summary (
  id INT PRIMARY KEY AUTO_INCREMENT,
  date DATE NOT NULL,
  total_users INT DEFAULT 0,
  new_users INT DEFAULT 0,
  total_deals INT DEFAULT 0,
  active_deals INT DEFAULT 0,
  total_views INT DEFAULT 0,
  total_clicks INT DEFAULT 0,
  total_shares INT DEFAULT 0,
  total_ratings INT DEFAULT 0,
  total_reviews INT DEFAULT 0,
  avg_rating DECIMAL(3,2) DEFAULT 0,
  revenue DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_date (date),
  INDEX idx_date (date)
);

-- Create notification_preferences table for user notification settings
CREATE TABLE IF NOT EXISTS notification_preferences (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL UNIQUE,
  deal_expiring BOOLEAN DEFAULT 1,
  deal_expired BOOLEAN DEFAULT 0,
  new_deal BOOLEAN DEFAULT 1,
  price_drop BOOLEAN DEFAULT 1,
  system BOOLEAN DEFAULT 1,
  email_enabled BOOLEAN DEFAULT 1,
  push_enabled BOOLEAN DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id)
);

-- Create notifications table for storing user notifications
CREATE TABLE IF NOT EXISTS notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  type ENUM('deal_expiring', 'deal_expired', 'new_deal', 'price_drop', 'system') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  data JSON,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_type (type),
  INDEX idx_read_at (read_at),
  INDEX idx_created_at (created_at)
);

-- Create saved_searches table for user saved searches
CREATE TABLE IF NOT EXISTS saved_searches (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  search_query VARCHAR(500),
  filters JSON,
  sort_by VARCHAR(50) DEFAULT 'newest',
  is_default BOOLEAN DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_is_default (is_default)
);

-- Create search_history table for tracking user searches
CREATE TABLE IF NOT EXISTS search_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255),
  search_query VARCHAR(500),
  filters JSON,
  results_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at),
  INDEX idx_search_query (search_query(100))
);

-- Create deal_comparisons table for deal comparison feature
CREATE TABLE IF NOT EXISTS deal_comparisons (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_ids JSON NOT NULL,
  name VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at)
);

-- Create user_recommendations table for storing personalized recommendations
CREATE TABLE IF NOT EXISTS user_recommendations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(255) NOT NULL,
  deal_id INT NOT NULL,
  recommendation_score DECIMAL(3,2) DEFAULT 0,
  reason ENUM('viewed_similar', 'favorited_category', 'price_range', 'popular_in_category', 'trending') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (deal_id) REFERENCES deals(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_deal_id (deal_id),
  INDEX idx_recommendation_score (recommendation_score),
  INDEX idx_reason (reason)
);

-- Add subcategories to categories table
ALTER TABLE categories ADD COLUMN IF NOT EXISTS parent_id INT NULL AFTER name;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS level TINYINT DEFAULT 1 AFTER parent_id;
ALTER TABLE categories ADD COLUMN IF NOT EXISTS sort_order INT DEFAULT 0 AFTER level;

-- Add analytics fields to deals table
ALTER TABLE deals ADD COLUMN IF NOT EXISTS total_views INT DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS total_clicks INT DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS total_shares INT DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS total_ratings INT DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS total_reviews INT DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS avg_rating DECIMAL(3,2) DEFAULT 0;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS last_viewed_at TIMESTAMP NULL;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS last_clicked_at TIMESTAMP NULL;

-- Add analytics fields to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_views INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_clicks INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_favorites INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_ratings INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_reviews INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users ADD COLUMN IF NOT EXISTS last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Create newsletter_subscribers table
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  unsubscribed_at TIMESTAMP NULL,
  is_active BOOLEAN DEFAULT 1,
  subscription_source VARCHAR(50) DEFAULT 'website',
  INDEX idx_email (email),
  INDEX idx_is_active (is_active),
  INDEX idx_subscribed_at (subscribed_at)
);
