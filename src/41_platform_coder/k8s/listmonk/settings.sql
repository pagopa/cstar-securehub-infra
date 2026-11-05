\getenv root_url LISTMONK_ROOT_URL
\getenv oidc_config LISTMONK_OIDC_CONFIG

BEGIN;
INSERT INTO settings (key, value)
VALUES
    ('app.root_url', to_jsonb(:'root_url'::text)),
    ('security.oidc', :'oidc_config'::jsonb)
ON CONFLICT (key) DO UPDATE
SET value = EXCLUDED.value, updated_at = NOW()
WHERE settings.value IS DISTINCT FROM EXCLUDED.value;

-- Listmonk reads SMTP from its database. Never enable psql echo or SQL value logging.
\getenv smtp_enabled LISTMONK_SMTP_ENABLED
\if :smtp_enabled
\getenv smtp_config LISTMONK_SMTP_CONFIG
\getenv smtp_username LISTMONK_SMTP_USERNAME
\getenv smtp_password LISTMONK_SMTP_PASSWORD
\getenv from_email LISTMONK_FROM_EMAIL
\getenv message_rate LISTMONK_MESSAGE_RATE
INSERT INTO settings (key, value)
VALUES
    ('smtp', jsonb_set(jsonb_set(:'smtp_config'::jsonb,
        '{0,username}', to_jsonb(:'smtp_username'::text)),
        '{0,password}', to_jsonb(:'smtp_password'::text))),
    ('app.from_email', to_jsonb(:'from_email'::text)),
    ('app.concurrency', '1'::jsonb),
    ('app.message_rate', to_jsonb(:'message_rate'::integer))
ON CONFLICT (key) DO UPDATE
SET value = EXCLUDED.value, updated_at = NOW()
WHERE settings.value IS DISTINCT FROM EXCLUDED.value;
\else
-- Fail closed: remove upstream sample SMTP and any previous SMTP when explicitly disabled.
INSERT INTO settings (key, value) VALUES ('smtp', '[]'::jsonb)
ON CONFLICT (key) DO UPDATE
SET value = EXCLUDED.value, updated_at = NOW()
WHERE settings.value IS DISTINCT FROM EXCLUDED.value;
\endif
COMMIT;
