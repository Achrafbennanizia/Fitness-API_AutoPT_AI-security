# Image / commit pins (Phase 1.2)

Recorded after first successful clone. Do not float `latest` in the report.

| App | Remote | Commit (full) | Date pinned | Notes |
| --- | --- | --- | --- | --- |
| Workout.cool | https://github.com/Snouzy/workout-cool | `e3dcd23b4ebdfb6254010b9a7c350cfef9e236c8` | 2026-09-19 | Lab Dockerfile: `pnpm config set dangerouslyAllowAllBuilds true`. Host bind `127.0.0.1:3101`. Prisma `db push` once (init migration missing `onboardingPreferences`). Dummy Google OAuth env so t3 `env.ts` validates. |
| FitTrackee | https://github.com/SamR1/FitTrackee | `d9cfb15e6d2a5a3523dde7fbd5c098f6fb68357d` | 2026-09-19 | Compose image `fittrackee/fittrackee:v1.3.5`. PostGIS `platform: linux/amd64` on Apple Silicon. Host bind `127.0.0.1:5100`. |
| openGym | https://gitlab.com/DuarteSantos8/opengym (clone remote as recorded in repo) | `a68a88d2da04cf3334eeeca136385114a65450ff` | 2026-09-19 | Lab web Dockerfile: drop `--platform=$BUILDPLATFORM` (no Docker Buildx). Host bind `127.0.0.1:3102`. `RP_ID=127.0.0.1`. Passkey-only signup; two profiles not created this session. |
| FitnessTrack | https://github.com/Gman0909/FitnessTrack | `f627429623756aebe93e15bada6f698e8385f6ed` | 2026-09-19 | Host bind `127.0.0.1:3103`. |
| Endurain | https://codeberg.org/endurain/endurain (GitHub mirror: endurain-project/endurain) | `2d8a1aa7e1048e428e17840a41245537f8cda9aa` | 2026-09-19 | Image tag used at bring-up: `v0.19.2` family via compose. Host bind `127.0.0.1:18080`. Login header `X-Client-Type: mobile`. After admin create-user, DB enum labels were `ENGLISH`/`METRIC`/…; set to `en`/`metric`/… so `UsersRead` validates. |
