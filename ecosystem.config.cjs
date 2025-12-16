module.exports = {
  apps: [
    {
      name: 'deals247-backend',
      script: 'server/index.js',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env_file: '/var/www/deals247/server/.env',
      env: {
        NODE_ENV: 'production',
        PORT: 5000,
        DB_HOST: 'srv994.hstgr.io',
        DB_PORT: '3306',
        DB_NAME: 'u515501238_MyDeals247',
        DB_USER: 'u515501238_MyDeals247',
        DB_PASSWORD: 'MyDeals247',
        FRONTEND_URL: 'https://deals247.online'
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      log_file: './logs/combined.log',
      time: true
    },
    {
      name: 'deals247-web',
      script: 'npm run preview',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '512M',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      env_production: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: './logs/web-err.log',
      out_file: './logs/web-out.log',
      log_file: './logs/web-combined.log',
      time: true
    }
  ]
};