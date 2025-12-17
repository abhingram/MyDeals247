#!/bin/bash

# setup-local-prod-db.sh
# Sets up local MySQL production database for Deals247 backend
# Idempotent script - safe to re-run

set -e  # Exit on any error

echo "🚀 Starting local MySQL production database setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DB_NAME="deals247_prod"
DB_USER="deals247"
DB_PASS="MyDeals247@Prod#2025!"
DB_HOST="127.0.0.1"
DB_PORT="3306"
PROJECT_PATH="/var/www/deals247"
ENV_FILE="${PROJECT_PATH}/server/.env"
SCHEMA_DIR="${PROJECT_PATH}/server/database"

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Verify MySQL is installed and running
echo "🔍 Step 1: Checking MySQL service..."
if ! systemctl is-active --quiet mysql; then
    print_warning "MySQL service is not running. Attempting to start..."
    systemctl start mysql
    sleep 2
    if ! systemctl is-active --quiet mysql; then
        print_error "Failed to start MySQL service. Please install/start MySQL manually."
        exit 1
    fi
fi
print_status "MySQL service is running"

# Step 2: Create database
echo "🗄️  Step 2: Creating database ${DB_NAME}..."
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
print_status "Database ${DB_NAME} created/verified"

# Step 3: Create user
echo "👤 Step 3: Creating database user ${DB_USER}..."
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASS}';"
print_status "User ${DB_USER} created/verified"

# Step 4: Grant privileges
echo "🔑 Step 4: Granting privileges..."
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${DB_HOST}';"
mysql -e "FLUSH PRIVILEGES;"
print_status "Privileges granted and flushed"

# Step 5: Import schema files
echo "📄 Step 5: Importing schema files..."
if [ ! -d "${SCHEMA_DIR}" ]; then
    print_error "Schema directory ${SCHEMA_DIR} not found"
    exit 1
fi

SQL_FILES=$(find "${SCHEMA_DIR}" -name "*.sql" | sort)
if [ -z "$SQL_FILES" ]; then
    print_warning "No .sql files found in ${SCHEMA_DIR}"
else
    for sql_file in $SQL_FILES; do
        echo "  Importing $(basename "$sql_file")..."
        mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" < "$sql_file"
    done
    print_status "Schema files imported"
fi

# Step 6: Update environment file
echo "⚙️  Step 6: Updating environment configuration..."
if [ ! -f "${ENV_FILE}" ]; then
    print_error "Environment file ${ENV_FILE} not found"
    exit 1
fi

# Update DB_HOST
sed -i "s|^DB_HOST=.*|DB_HOST=${DB_HOST}|" "${ENV_FILE}"

# Update DB_PORT
sed -i "s|^DB_PORT=.*|DB_PORT=${DB_PORT}|" "${ENV_FILE}"

# Update DB_NAME
sed -i "s|^DB_NAME=.*|DB_NAME=${DB_NAME}|" "${ENV_FILE}"

# Update DB_USER
sed -i "s|^DB_USER=.*|DB_USER=${DB_USER}|" "${ENV_FILE}"

# Update DB_PASSWORD
sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|" "${ENV_FILE}"

print_status "Environment file updated"

# Step 7: Restart backend
echo "🔄 Step 7: Restarting backend service..."
pm2 restart deals247-backend --update-env
print_status "Backend restarted with new configuration"

# Final success message
echo ""
echo -e "${GREEN}🎉 Local MySQL production database setup completed successfully!${NC}"
echo ""
echo "📋 Next steps:"
echo "1. Verify backend is running: pm2 status"
echo "2. Check logs: pm2 logs deals247-backend --lines 10"
echo "3. Test API: curl localhost:5000/api/deals"
echo "4. Verify database: mysql -h 127.0.0.1 -u deals247 -p deals247_prod -e 'SHOW TABLES;'"
echo ""
echo "🔐 Database credentials:"
echo "  Host: ${DB_HOST}"
echo "  Port: ${DB_PORT}"
echo "  Database: ${DB_NAME}"
echo "  User: ${DB_USER}"
echo "  Password: ${DB_PASS}"