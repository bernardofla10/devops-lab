#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

PUBLIC_NETWORK="devops-compose-day03_public-net"
PRIVATE_NETWORK="devops-compose-day03_private-net"

echo "Docker Compose Day 03 - Network Tests"
echo "====================================="
echo ""

echo "1. Testing API resolution on public network..."

docker run --rm \
  --network "$PUBLIC_NETWORK" \
  node:20-alpine \
  node -e "
    require('dns').lookup('api', (error, address) => {
      if (error) {
        console.error(error.message);
        process.exit(1);
      }

      console.log('api resolved to:', address);
    });
  "

echo ""
echo "2. Confirming db is isolated from public network..."

docker run --rm \
  --network "$PUBLIC_NETWORK" \
  node:20-alpine \
  node -e "
    require('dns').lookup('db', (error, address) => {
      if (error) {
        console.log('Expected failure:', error.message);
        process.exit(0);
      }

      console.error('Unexpected db resolution:', address);
      process.exit(1);
    });
  "

echo ""
echo "3. Testing db resolution on private network..."

docker run --rm \
  --network "$PRIVATE_NETWORK" \
  node:20-alpine \
  node -e "
    require('dns').lookup('db', (error, address) => {
      if (error) {
        console.error(error.message);
        process.exit(1);
      }

      console.log('db resolved to:', address);
    });
  "

echo ""
echo "4. Testing API to PostgreSQL query..."

docker compose exec -T api node -e "
  const { Client } = require('pg');

  const client = new Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
  });

  client.connect()
    .then(() => client.query('SELECT COUNT(*) AS item_count FROM items'))
    .then((result) => console.log(result.rows))
    .then(() => client.end())
    .catch((error) => {
      console.error(error.message);
      process.exit(1);
    });
"

echo ""
echo "All network tests finished successfully."