# Re-apply after each fresh clone (`lab/apps/` is gitignored)

## Workout.cool `Dockerfile`

In `deps` and `builder` stages, allow pnpm native builds:

```
RUN pnpm config set dangerouslyAllowAllBuilds true && pnpm install --no-frozen-lockfile
RUN pnpm config set dangerouslyAllowAllBuilds true && pnpm run build
```

Host ports in `docker-compose.yml`: `127.0.0.1:5433` (or `DB_PORT`) for Postgres, `127.0.0.1:3101` for the app.

After first migrate, if signup errors on `user.onboardingPreferences`:

```
docker exec <workout_cool> npx prisma db push
```

`.env` must include dummy `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` (t3 env requires them).

## openGym `web/Dockerfile`

Replace:

`FROM --platform=$BUILDPLATFORM node:22-alpine AS build`

with:

`FROM node:22-alpine AS build`

Host port in `docker-compose.yml`: `127.0.0.1:3102`. Do not also set `WEB_PORT` in `.env` (compose would publish twice).

`.env`: `RP_ID=127.0.0.1`, `ORIGIN=http://127.0.0.1:3102`.

## FitnessTrack / FitTrackee / Endurain

Keep published ports on `127.0.0.1` only (see `lab/README.md`). FitTrackee PostGIS: `platform: linux/amd64` in `overrides/fittrackee.yml`.
