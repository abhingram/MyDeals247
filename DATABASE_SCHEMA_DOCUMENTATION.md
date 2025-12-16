# Deals247 Database Schema Documentation

## 1. Deals Table Structure

The main **`deals`** table stores all product/deal information in the Deals247 application.

### Table Headers/Columns:

| Column | Type | Description |
|--------|------|-------------|
| `id` | INT PRIMARY KEY AUTO_INCREMENT | Unique identifier for each deal |
| `title` | VARCHAR(255) NOT NULL | Deal/product title |
| `store` | VARCHAR(100) NOT NULL | Store/retailer name |
| `original_price` | DECIMAL(10, 2) NOT NULL | Original price before discount |
| `discounted_price` | DECIMAL(10, 2) NOT NULL | Price after discount |
| `discount` | INT NOT NULL | Discount percentage |
| `rating` | DECIMAL(2, 1) DEFAULT 0 | Average user rating (0-5) |
| `reviews` | INT DEFAULT 0 | Number of user reviews |
| `image` | TEXT | Product image URL |
| `category` | VARCHAR(100) | Product category (Electronics, Fashion, etc.) |
| `expires_at` | DATETIME | Deal expiration date/time |
| `verified` | BOOLEAN DEFAULT 0 | Whether deal is verified by admin |
| `deleted` | BOOLEAN DEFAULT 0 | Soft delete flag |
| `deleted_at` | TIMESTAMP NULL | Deletion timestamp |
| `created_at` | TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | Last update time |

### Indexes:
- `idx_category` (category)
- `idx_store` (store)
- `idx_created_at` (created_at)
- `idx_deleted` (deleted)

---

## 2. Complete List of Tables and Their Purposes

Based on the database schema, here are all **45 tables** and their specific uses:

### **Core Application Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`deals`** | Main products/deals storage | `id`, `title`, `store`, `original_price`, `discounted_price`, `discount`, `rating`, `reviews`, `image`, `category`, `expires_at`, `verified`, `deleted` |
| **`users`** | User accounts and authentication | `id`, `firebase_uid`, `email`, `display_name`, `role`, `created_at` |
| **`categories`** | Deal categories (Electronics, Fashion, etc.) | `id`, `name`, `slug`, `icon` |
| **`stores`** | Store/retailer information | `id`, `name`, `logo`, `website` |

### **User Interaction Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`user_favorites`** | User's saved/favorited deals | `user_id`, `deal_id`, `created_at` |
| **`deal_views`** | Tracks when users view deals | `user_id`, `deal_id`, `viewed_at` |
| **`deal_clicks`** | Tracks deal link clicks | `user_id`, `deal_id`, `clicked_at`, `ip_address`, `user_agent` |
| **`deal_ratings`** | User ratings for deals (1-5 stars) | `user_id`, `deal_id`, `rating` |
| **`deal_reviews`** | Detailed user reviews | `user_id`, `deal_id`, `rating`, `title`, `comment`, `helpful_votes` |
| **`deal_review_votes`** | Helpful/not helpful votes on reviews | `user_id`, `review_id`, `vote_type` |
| **`deal_shares`** | Social media sharing tracking | `user_id`, `deal_id`, `platform`, `shared_at` |

### **Business & Affiliate Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`affiliate_links`** | Affiliate marketing links | `name`, `original_url`, `affiliate_url`, `commission_rate`, `store` |
| **`affiliate_clicks`** | Tracks affiliate link clicks | `affiliate_link_id`, `user_id`, `clicked_at` |
| **`affiliate_conversions`** | Tracks affiliate conversions/sales | `affiliate_link_id`, `commission_amount`, `status` |
| **`commission_payouts`** | Affiliate commission payouts | `affiliate_user_id`, `amount`, `status`, `payment_method` |
| **`deal_verifications`** | Deal verification status | `deal_id`, `verified_by`, `verification_status`, `trust_score` |
| **`store_reliability`** | Store trust scores and ratings | `store_name`, `total_deals`, `verified_deals`, `avg_rating`, `trust_score` |
| **`business_analytics`** | Business performance metrics | `date`, `total_revenue`, `affiliate_revenue`, `conversion_rate` |

### **Analytics & Reporting Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`analytics_summary`** | Daily aggregated analytics | `date`, `total_users`, `total_deals`, `total_views`, `total_clicks` |
| **`deal_analytics`** | Individual deal performance | `deal_id`, `views`, `clicks`, `conversions`, `revenue` |
| **`user_analytics`** | User behavior analytics | `user_id`, `session_count`, `total_views`, `total_clicks` |
| **`ab_tests`** | A/B testing configurations | `name`, `variants`, `start_date`, `end_date`, `status` |
| **`ab_test_results`** | A/B test results and metrics | `test_id`, `variant`, `users`, `conversions`, `revenue` |

### **Social & Community Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`user_generated_content`** | User-created guides, tips, reviews | `user_id`, `deal_id`, `content_type`, `title`, `content`, `likes_count` |
| **`content_likes`** | Likes on user-generated content | `user_id`, `content_id` |
| **`content_comments`** | Comments on user content | `user_id`, `content_id`, `comment` |
| **`deal_discussions`** | Discussion threads for deals | `deal_id`, `user_id`, `title`, `content` |
| **`discussion_replies`** | Replies to discussion threads | `discussion_id`, `user_id`, `content` |
| **`discussion_likes`** | Likes on discussions/replies | `user_id`, `discussion_id` |
| **`social_shares`** | Social media sharing tracking | `user_id`, `content_id`, `platform` |
| **`user_follows`** | User following relationships | `follower_id`, `following_id` |
| **`review_photos`** | Photos attached to reviews | `review_id`, `photo_url`, `photo_order` |

### **Search & Recommendations Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`saved_searches`** | User's saved search filters | `user_id`, `name`, `search_query`, `filters` |
| **`search_history`** | User's search history | `user_id`, `search_query`, `results_count` |
| **`deal_comparisons`** | Deal comparison lists | `user_id`, `deal_ids`, `name` |
| **`user_recommendations`** | AI-generated recommendations | `user_id`, `deal_id`, `recommendation_score`, `reason` |
| **`user_segments`** | User segmentation for targeting | `user_id`, `segment_type`, `segment_value` |

### **Communication & Notifications Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`notifications`** | User notifications (email/push) | `user_id`, `type`, `title`, `message`, `read_at` |
| **`notification_preferences`** | User notification settings | `user_id`, `deal_expiring`, `new_deal`, `price_drop`, `email_enabled` |
| **`newsletter_subscribers`** | Email newsletter subscriptions | `email`, `subscribed_at`, `status` |

### **System & Utility Tables**

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **`bulk_import_logs`** | Logs for bulk data imports | `imported_by`, `file_name`, `total_records`, `successful_imports` |
| **`cache_store`** | Application caching system | `key`, `value`, `expires_at` |
| **`shortened_urls`** | URL shortening for sharing | `original_url`, `short_code`, `clicks` |
| **`user_sessions`** | User session tracking | `user_id`, `session_id`, `ip_address`, `user_agent` |
| **`user_subscriptions`** | Premium subscriptions | `user_id`, `plan_type`, `start_date`, `end_date` |
| **`price_intelligence`** | Price tracking and alerts | `deal_id`, `price`, `change_type`, `change_percentage` |
| **`revenue_analytics`** | Revenue tracking and reporting | `date`, `source`, `amount`, `currency` |
| **`automated_reports`** | Scheduled report configurations | `name`, `type`, `schedule`, `recipients` |
| **`chatbot_conversations`** | AI chatbot interaction logs | `user_id`, `message`, `response`, `timestamp` |

---

## Data Flow Summary

**Deals Data Flow:**
1. **Input**: Deals are added to `deals` table via admin panel or bulk import
2. **User Interaction**: Views (`deal_views`), clicks (`deal_clicks`), ratings (`deal_ratings`), reviews (`deal_reviews`)
3. **Social**: Sharing (`deal_shares`), discussions (`deal_discussions`), user content (`user_generated_content`)
4. **Analytics**: Performance tracked in `analytics_summary`, `deal_analytics`
5. **Business**: Affiliate tracking (`affiliate_clicks`, `affiliate_conversions`), revenue (`revenue_analytics`)

**User Data Flow:**
1. **Registration**: Stored in `users` table
2. **Activity**: Favorites (`user_favorites`), searches (`search_history`), sessions (`user_sessions`)
3. **Social**: Following (`user_follows`), content creation (`user_generated_content`)
4. **Preferences**: Notifications (`notification_preferences`), subscriptions (`user_subscriptions`)

---

*Generated on: December 16, 2025*
*Database: u515501238_MyDeals247*
*Total Tables: 45*</content>
<parameter name="filePath">d:/Repos/Pet Projects/Deals247/DATABASE_SCHEMA_DOCUMENTATION.md