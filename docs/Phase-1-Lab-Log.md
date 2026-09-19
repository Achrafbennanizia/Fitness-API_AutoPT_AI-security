# Phase 1 lab log (2026-09-19)

Bring-up record: outcome, problems, and fixes. **Not** a Phase 2 security-finding table. Confirmed HTTP weaknesses start with ZAP/Nuclei.

Related runtime files: [`lab/phase1-status.md`](../lab/phase1-status.md), [`lab/pins.md`](../lab/pins.md), [`lab/dropout-log.md`](../lab/dropout-log.md), [`lab/patches/README.md`](../lab/patches/README.md), [`lab/synthetic-accounts.md`](../lab/synthetic-accounts.md).

Plan for this phase: [proposal § Phase 1](Master-Semester-Project-Proposal.md).

## Outcome

**Pass.** Four of five apps accept two synthetic users on `127.0.0.1`. openGym serves HTTP but has no passkey profiles. Stacks run **one at a time**.

Host Docker is **Colima**. The CLI that worked is `docker-compose` with `DOCKER_HOST=unix://$HOME/.colima/default/docker.sock`. Plugin `docker compose` (v2) exited **125**.

| App | Pin | Loopback URL | Two users | How accounts were proven |
| --- | --- | --- | --- | --- |
| Workout.cool | `e3dcd23b4ebdfb6254010b9a7c350cfef9e236c8` | http://127.0.0.1:3101 | yes | `POST /api/auth/signup` 200; Better Auth sign-in 200 |
| FitTrackee | `d9cfb15e6d2a5a3523dde7fbd5c098f6fb68357d` + image `fittrackee/fittrackee:v1.3.5` | http://127.0.0.1:5100 | yes | `POST /api/auth/login` with **email** 200 |
| FitnessTrack | `f627429623756aebe93e15bada6f698e8385f6ed` | http://127.0.0.1:3103 | yes | register 409 (already present); login 200 |
| Endurain | `2d8a1aa7e1048e428e17840a41245537f8cda9aa` | http://127.0.0.1:18080 | yes | form login + `X-Client-Type: mobile` 200 |
| openGym | `a68a88d2da04cf3334eeeca136385114a65450ff` | http://127.0.0.1:3102 | **no** | `GET /api/health` 200, `users: 0`. WebAuthn only |

Endurain compose used the project image at that commit (about endpoint reported the v0.19.2 family).

## Host / Compose problems and fixes

| Problem | What we saw | Fix |
| --- | --- | --- |
| No Docker Desktop | `docker` missing on macOS | Homebrew **Colima** + `docker` + `docker-compose`; `colima start` |
| Compose v2 | `docker compose -f …` exit **125** | Use **`docker-compose`** and set `DOCKER_HOST` to the Colima socket |
| Git clone in sandbox | hook / permission failures | Clone outside the tight sandbox |
| Port collisions | host **5000** and **8080** already in use | FitTrackee **5100**, Endurain **18080**, unique 31xx ports for the rest |
| Compose **merges** `ports:` | override `127.0.0.1:x` **added** to the app’s `0.0.0.0:x` (openGym briefly published **8080 on all interfaces**) | Put the loopback mapping in the app `docker-compose.yml`; do not also set `WEB_PORT` / `APP_PORT` / `HOST_APP_PORT` in a way that publishes a second mapping. `lab/overrides/` is for **platform** (FitTrackee amd64), not a second port |
| No Buildx | classic builder cannot parse `FROM --platform=$BUILDPLATFORM` | Lab edit of openGym `web/Dockerfile` (see [`lab/patches/README.md`](../lab/patches/README.md)) |
| `openssl rand` blocked | could not generate Endurain `FERNET_KEY` that way | 32-byte url-safe base64 from Python — lab secret, not committed |
| 8 GB RAM | five stacks at once not viable | Sequential `up` → two users → `down` (`lab/scripts/up-one.sh`) |

## Per-app problems and fixes

### Workout.cool

| Problem | Fix |
| --- | --- |
| `pnpm install` frozen lockfile, then `ERR_PNPM_IGNORED_BUILDS` | `pnpm config set dangerouslyAllowAllBuilds true` and `pnpm install --no-frozen-lockfile` in **deps** and **builder** |
| Image build: sitemap Prisma call to `localhost:5432` (DB not in build stage) | Warning only; `next build` still finished |
| Runtime `Invalid environment variables` | t3 `env.ts` requires `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`; dummy lab values |
| Signup 500: `user.onboardingPreferences` missing | `prisma migrate deploy` used an outdated `0_init` migration; one-time `npx prisma db push` in the container |
| After that | Alice/Bob signup 200 and login 200 |

### FitTrackee

| Problem | Fix |
| --- | --- |
| PostGIS image has **no arm64** | `platform: linux/amd64` on db + app (QEMU; first start slow; healthcheck lagged behind `/api/ping` 200) |
| Port 5000 taken | `127.0.0.1:5100` |
| Accounts | `ftcli users create` for alice/bob (signup UI not used) |
| Login with `username` → 401 | Login JSON uses **`email`** (`alice.lab@example.test` / `bob.lab@example.test`) |

### FitnessTrack

| Problem | Fix |
| --- | --- |
| Needed a compose/port story | Lab compose + bind `127.0.0.1:3103` |
| Re-register 409 | Users already created earlier; **login 200** is the Phase 1 proof |

### Endurain

| Problem | Fix |
| --- | --- |
| Example compose + data dirs | Copied compose; data under `lab/apps-data/endurain`; port **18080** |
| Invalid Fernet key | Lab `FERNET_KEY` as 32-byte url-safe base64 |
| Email `@example.test` rejected | Use `@example.com` for Alice/Bob |
| Public signup off (`signup_enabled: false`) | Admin `POST /api/v1/users` |
| JSON login failed | `application/x-www-form-urlencoded` + header **`X-Client-Type: mobile`** (or `web`) |
| Create-user HTTP **500** | User **was** inserted; response schema `UsersRead` rejected DB enums `ENGLISH` / `METRIC` / `UNSPECIFIED` / `MONDAY` / `EURO` (admin row already used `en` / `metric` / …) |
| Alice/Bob login 500 after create | SQL: `preferred_language = 'en'` (not `english`) and lowercase `gender` / `units` / `first_day_of_week` / `currency`; then login **200** |
| Default `admin` / `admin` | Left as vendor default; not one of the two synthetic users |

### openGym (kept; two-user incomplete)

| Problem | Fix or decision |
| --- | --- |
| Web image: `FROM --platform=$BUILDPLATFORM` | Drop the flag for classic builder |
| Exercise media clone ~140 MB | Placeholder files so the one-shot `media` service skips the download (UI images missing; API still up) |
| `RP_ID=localhost` vs origin `127.0.0.1` | Set `RP_ID=127.0.0.1` to match the bind |
| Auth is **passkeys only** (plus optional guest) | No password Alice/Bob. Virtual WebAuthn via browser CDP was blocked. **Not dropped**: stack starts; corpus still has four two-user apps |

## Findings that matter for later phases (not OWASP rows yet)

1. **Auth is not one protocol.** Email (FitTrackee), username (FitnessTrack, Endurain), Better Auth email (Workout.cool), WebAuthn (openGym), plus Endurain’s required `X-Client-Type`. ZAP/Nuclei/T3 need per-app login recipes, not a single template.
2. **Two-user is the right unit, and it is work.** Vendor signup flags, default admin, and schema bugs all sat on the path to Alice vs Bob (Sun’s two-principal story, still black-box).
3. **Loopback is easy to get wrong.** Compose list-merge published `0.0.0.0` until ports lived in one place. Phase 2 must re-check `docker inspect` PortBindings before any scan.
4. **Apple Silicon is part of the method.** FitTrackee/PostGIS amd64 under QEMU is a pin, not a footnote.
5. **Product bugs showed up during bring-up.** Workout.cool migration vs Prisma schema; Endurain enum case in `UsersRead`. Treat as lab friction unless Phase 2 confirms them as in-scope HTTP findings.
6. **Empty memory files exist.** `lab/facts-file.md` and `lab/token-log.csv` are ready; they stay empty until screens and T3.

## Dropout

No stack failed to *start*. openGym is logged as kept-with-gap (passkeys). Pass criterion (≥ 4 two-user apps) holds. Re-apply clone-local edits from [`lab/patches/README.md`](../lab/patches/README.md) because `lab/apps/` is gitignored.
