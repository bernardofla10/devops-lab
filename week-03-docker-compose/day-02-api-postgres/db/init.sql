CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO items (title)
SELECT 'initial-postgres-item'
WHERE NOT EXISTS (
    SELECT 1
    FROM items
);
