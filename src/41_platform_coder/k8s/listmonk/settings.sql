\getenv root_url LISTMONK_ROOT_URL
\getenv oidc_config LISTMONK_OIDC_CONFIG

BEGIN;
INSERT INTO settings (key, value)
VALUES
    ('app.root_url', to_jsonb(:'root_url'::text)),
    ('security.oidc', :'oidc_config'::jsonb)
ON CONFLICT (key) DO UPDATE
SET value = EXCLUDED.value, updated_at = NOW();
COMMIT;
