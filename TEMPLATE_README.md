# Deploy and Host Tindra on Railway

## About Hosting Tindra

Tindra is a self-hosted error tracking, performance monitoring, profiling, uptime monitoring, and cron monitoring platform with full Sentry SDK compatibility. This template deploys the stable release `0.6.4` as a single Go binary backed by PostgreSQL 18, with persistent volumes for the database and uploaded source maps.

## Common Use Cases

- Capture exceptions from any Sentry SDK by pointing the DSN at your private Tindra instance
- Monitor API latency with transaction traces, span waterfalls, and p50/p75/p95/p99 percentiles
- Profile slow transactions with flame graphs from Sentry SDK profiling
- Probe HTTP/HTTPS endpoints for uptime with status-code and body assertions, and get down/recovery alerts
- Monitor scheduled jobs with cron check-ins and missed/error alerts
- Alert teams through email, Slack, Discord, Microsoft Teams, or webhooks

## Dependencies for Tindra Hosting

### Deployment Dependencies

The template creates two Railway resources: the public `tindra` service and a PostgreSQL `18-alpine` service. Tindra owns a persistent volume at `/data` for source maps; Postgres owns a persistent data volume. There is no Redis, no queue, and no separate worker — all background jobs run inside the Tindra process.

### Implementation Details

The `tindra` service owns the public HTTPS domain and listens on port 8080. `DATABASE_URL` references Postgres over Railway private networking with a generated password. Tindra runs database migrations automatically at startup, so the schema is always current on deploy.

The first administrator has no sign-up page: open the Railway shell for the `tindra` service and run `/tindra users create --email you@example.com --name "Your Name" --password 'a-long-password'` (minimum 12 characters). First login requires MFA setup by default (`REQUIRE_MFA=true`).

Generated variables: `POSTGRES_PASSWORD` for the database, `PUBLIC_URL` wired to the Railway public domain (used to build project DSNs), and `COOKIE_SECURE=true` for HTTPS-only cookies. `PUBLIC_URL` must match the domain users actually visit or DSNs generated in the dashboard will point at the wrong host.

Do not change cross-service references independently — `DATABASE_URL` is wired to the Postgres private hostname and the generated `POSTGRES_PASSWORD`.

### Why Deploy Tindra on Railway?

Railway provides the public HTTPS endpoint your Sentry SDKs and cron check-ins need, private networking for the database, durable volumes for source maps, and one-click redeploys — all for a two-service stack that starts in seconds and needs no orchestrator.

## Limitations

- Email alerts require an external provider credential; without one, webhook, Slack, Discord, and Teams alerts still work.
- SSO requires provider credentials and a correctly set `OAUTH_REDIRECT_BASE`.
- Source maps persist on the `tindra` volume; deleting that volume loses stack-trace resolution for previously uploaded maps.
- The version-update check contacts `tindra.sh` every 6 hours unless `DISABLE_VERSION_CHECK=true`.
- Tindra is Elastic License 2.0 software: self-hosting is free, but offering it to third parties as a managed service is prohibited.
