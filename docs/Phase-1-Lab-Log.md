# Phase 1 lab log (2026-09-19)

Bring-up record for the five-app corpus. Not a Phase 2 security-finding table.

Related: [`lab/phase1-status.md`](../lab/phase1-status.md), [`lab/pins.md`](../lab/pins.md), [`lab/dropout-log.md`](../lab/dropout-log.md), [`lab/synthetic-accounts.md`](../lab/synthetic-accounts.md).

## Outcome

**Pass.** Four of five applications accept two synthetic users on `127.0.0.1`. Stacks run one at a time. openGym serves HTTP but has no password accounts (WebAuthn only).

| App | Pin | Loopback URL | Two users | How accounts were proven |
| --- | --- | --- | --- | --- |
| Workout.cool | `e3dcd23b4ebdfb6254010b9a7c350cfef9e236c8` | http://127.0.0.1:3101 | yes | `POST /api/auth/signup` 200; Better Auth sign-in 200 |
| FitTrackee | `d9cfb15e6d2a5a3523dde7fbd5c098f6fb68357d` + image `fittrackee/fittrackee:v1.3.5` | http://127.0.0.1:5100 | yes | `POST /api/auth/login` with **email** 200 |
| FitnessTrack | `f627429623756aebe93e15bada6f698e8385f6ed` | http://127.0.0.1:3103 | yes | login 200 |
| Endurain | `2d8a1aa7e1048e428e17840a41245537f8cda9aa` | http://127.0.0.1:18080 | yes | form login + `X-Client-Type: mobile` 200 |
| openGym | `a68a88d2da04cf3334eeeca136385114a65450ff` | http://127.0.0.1:3102 | **no** | `GET /api/health` 200, `users: 0`. Passkeys only |

## What later phases must use

1. **Auth is not one protocol.** FitTrackee login is email; FitnessTrack and Endurain use username; Workout.cool uses Better Auth email; openGym is WebAuthn; Endurain also requires `X-Client-Type`. Screens and T3 need per-app login recipes.
2. **openGym stays in the corpus with a documented two-user gap** (dropout log). Pass still holds (≥ 4 two-user apps).
3. **Bind to loopback only.** Confirm `docker inspect` PortBindings before any Phase 2 scan.
4. **FitTrackee database** is pinned `linux/amd64` (PostGIS). Sequential `lab/scripts/up-one.sh`.

Clone-local edits: [`lab/patches/README.md`](../lab/patches/README.md) (`lab/apps/` is gitignored).
