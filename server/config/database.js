import mysql from 'mysql2/promise';

// Validate required environment variables
const requiredEnvVars = ['DB_HOST', 'DB_USER', 'DB_PASSWORD', 'DB_NAME'];
const missingVars = requiredEnvVars.filter(varName => !process.env[varName] || process.env[varName].trim() === '');

if (missingVars.length > 0) {
  throw new Error(`DB credentials missing in environment variables: ${missingVars.join(', ')}`);
}

// Create connection pool with better error handling
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: String(process.env.DB_USER),
  password: String(process.env.DB_PASSWORD),
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  connectTimeout: 60000,
  idleTimeout: 60000,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0
});

// Add error handling for the pool
pool.on('error', (err) => {
  console.error('Database pool error:', err);
  if (err.code === 'ECONNRESET' || err.code === 'ENOTFOUND' || err.code === 'ECONNREFUSED') {
    console.log('Attempting to reconnect to database...');
    // The pool will automatically handle reconnection
  }
});

export default pool;

// Test connection on startup and fail fast if DB is unavailable
(async () => {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Database connection successful');
    connection.release();
  } catch (error) {
    console.error('❌ Database connection failed:', error.message);
    console.error('Full error:', error);
    process.exit(1);
  }
})();
