# Tindra on Railway

A pinned Railway deployment for [Tindra](https://github.com/blendbyte/tindra), the self-hosted error tracking, performance monitoring, uptime monitoring, and cron monitoring platform that is compatible with every Sentry SDK.

One Go binary, one PostgreSQL database. Point your existing Sentry SDK DSN at Tindra and nothing else changes.

## What this deploys

- Tindra `0.6.4` (pinned: [release v0.6.4](https://github.com/blendbyte/tindra/releases/tag/v0.6.4), image `ghcr.io/blendbyte/tindra:0.6.4`, digest `sha256:980668a5c511b648e5551a389ffe2984a059cac2732ef9bd6d5955b7d16ac346`)
- PostgreSQL `18-alpine` with a persistent data volume
- A Railway volume on the Tindra service for uploaded source maps (`/data`)

All background jobs — uptime probes, cron monitor evaluation, alert digests, retention, and version checks — run inside the single Tindra process. No Redis, no worker service, no queue.

## First administrator

Tindra has no sign-up page. After the first deploy completes, open the Railway shell for the `tindra` service and create your administrator:

```bash
/tindra users create --email you@example.com --name "Your Name" --password 'a-long-password'
```

Passwords must be at least 12 characters. On first login you will be asked to set up MFA (this is the default `REQUIRE_MFA=true`).

## Important limits

- Tindra is licensed under the [Elastic License 2.0](https://www.elastic.co/licensing/elastic-license): you may self-host it freely, but you may not offer it to third parties as a hosted or managed service, and you must preserve upstream notices. See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).
- Source maps are stored on the Tindra service volume. Do not remove the volume; stack-trace resolution depends on it.
- Email alerts require an external provider (SMTP, Postmark, Brevo, Lettermint, AhaSend, or Cloudflare Email Routing) — leave `EMAIL_PROVIDER` unset to run without email.
- SSO (Google, GitHub, Microsoft, Auth0, Zitadel, generic OIDC) requires provider credentials and `OAUTH_REDIRECT_BASE`.
- Tindra contacts `tindra.sh` every 6 hours to check for new versions. Disable with `DISABLE_VERSION_CHECK=true`.
- This template runs the official upstream image unmodified; there is no fork.

## Version pins

See [`versions.env`](versions.env). Every image is pinned by version and immutable registry digest; no service uses `latest`.

## Updating

1. Back up PostgreSQL and the Tindra `/data` volume.
2. Review upstream [release notes](https://github.com/blendbyte/tindra/releases) for migration or behavior changes.
3. Update the image tag and digest in the template deliberately.
4. Validate ingest, uptime probing, cron check-ins, alerts, and logs on a disposable Railway project before cutting over.

## Upstream and license

- Source: https://github.com/blendbyte/tindra
- Docs: https://tindra.sh/docs
- Release: https://github.com/blendbyte/tindra/releases/tag/v0.6.4
- License: Elastic License 2.0; see [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE)
