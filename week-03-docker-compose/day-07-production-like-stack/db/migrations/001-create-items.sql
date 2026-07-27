BEGIN;

CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by TEXT NOT NULL
);

INSERT INTO items (title, created_by)
SELECT
    'initial-production-like-item',
    'migration-001'
WHERE NOT EXISTS (
    SELECT 1
    FROM items
);

INSERT INTO schema_migrations (version)
VALUES ('001-create-items')
ON CONFLICT (version) DO NOTHING;

COMMIT;