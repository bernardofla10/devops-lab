CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by TEXT
);

INSERT INTO items (title, created_by)
SELECT
    'initial-scaling-lab-item',
    'database-init-script'
WHERE NOT EXISTS (
    SELECT 1
    FROM items
);