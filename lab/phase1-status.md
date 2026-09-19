# Phase 1 status

**Done when:** ≥ 4 apps accept two synthetic users on `127.0.0.1`.

**Result (2026-09-19):** pass — 4 / 5 apps accept Alice + Bob. Stacks are sequential (one compose project at a time). Colima Docker socket: `unix://$HOME/.colima/default/docker.sock`. Use `docker-compose` (v1-style CLI) with `-f docker-compose.yml -f lab/overrides/<app>.yml`.

| App | Cloned | Pin recorded | Compose up | Bound 127.0.0.1 | Two users | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Workout.cool | yes | yes | yes | yes (`3101`) | yes | Signup `POST /api/auth/signup` 200; Better Auth sign-in 200. |
| FitTrackee | yes | yes | yes | yes (`5100`) | yes | Login `POST /api/auth/login` with **email** 200 (username field is not the login id). |
| openGym | yes | yes | yes | yes (`3102`) | no | `GET /api/health` 200, `users: 0`. Auth is WebAuthn passkeys only. |
| FitnessTrack | yes | yes | yes | yes (`3103`) | yes | Register 409 (already present); login 200 for `alice_lab` and `bob_lab`. |
| Endurain | yes | yes | yes | yes (`18080`) | yes | Admin + `alice_lab` + `bob_lab`. Login 200 with form body + `X-Client-Type: mobile`. |

Bring-up helper: `lab/scripts/up-one.sh <app>` then stop the stack before starting the next.
