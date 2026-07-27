const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

function readSecret(filePath, fallbackValue) {
  if (fallbackValue) {
    return fallbackValue;
  }

  if (!filePath) {
    throw new Error("Secret file path was not provided.");
  }

  return fs.readFileSync(filePath, "utf-8").trim();
}

const DB_PASSWORD = readSecret(
  process.env.DB_PASSWORD_FILE,
  process.env.DB_PASSWORD
);

const pool = new Pool({
  host: process.env.DB_HOST || "db",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "devopsdb",
  user: process.env.DB_USER || "devops",
  password: DB_PASSWORD,
  connectionTimeoutMillis: 5000
});

const migrationFile = path.join(
  __dirname,
  "migrations",
  "001-create-items.sql"
);

function sleep(milliseconds) {
  return new Promise((resolve) => {
    setTimeout(resolve, milliseconds);
  });
}

async function connectWithRetry(maxAttempts = 20) {
  for (let attempt = 1; attempt <= maxAttempts; attempt += 1) {
    try {
      await pool.query("SELECT 1");

      console.log(
        JSON.stringify({
          timestamp: new Date().toISOString(),
          level: "info",
          message: "Migration database connection established",
          attempt
        })
      );

      return;
    } catch (error) {
      console.error(
        JSON.stringify({
          timestamp: new Date().toISOString(),
          level: "error",
          message: "Migration database connection failed",
          attempt,
          error: error.message
        })
      );

      if (attempt === maxAttempts) {
        throw error;
      }

      await sleep(2000);
    }
  }
}

async function migrate() {
  await connectWithRetry();

  const sql = fs.readFileSync(migrationFile, "utf-8");

  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level: "info",
      message: "Applying migration",
      migration: path.basename(migrationFile)
    })
  );

  await pool.query(sql);

  const result = await pool.query(`
    SELECT version, applied_at
    FROM schema_migrations
    ORDER BY applied_at
  `);

  console.log(
    JSON.stringify({
      timestamp: new Date().toISOString(),
      level: "info",
      message: "Migrations completed successfully",
      migrations: result.rows
    })
  );
}

migrate()
  .then(async () => {
    await pool.end();
    process.exit(0);
  })
  .catch(async (error) => {
    console.error(
      JSON.stringify({
        timestamp: new Date().toISOString(),
        level: "error",
        message: "Migration failed",
        error: error.message
      })
    );

    await pool.end();
    process.exit(1);
  });