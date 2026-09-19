# Lab corpus (Phase 1)

Authorized **localhost** instances of the five fitness apps in the semester proposal. Bind to `127.0.0.1` only. Synthetic users only. One stack at a time on 8 GB RAM.

## Layout

| Path | Role |
| --- | --- |
| `apps/` | Git clones (gitignored). Pin recorded in `pins.md`. |
| `pins.md` | Commit hash / image tag per app |
| `dropout-log.md` | Apps that would not start |
| `facts-file.md` | Peng/Deng memory (empty until screens) |
| `token-log.csv` | LLM call log (empty until T3) |
| `synthetic-accounts.md` | Two fake users per app |
| `phase1-status.md` | Done-when checklist |

## Ports (unique)

| App | Host URL |
| --- | --- |
| Workout.cool | http://127.0.0.1:3101 |
| FitTrackee | http://127.0.0.1:5000 |
| openGym | http://127.0.0.1:3102 |
| FitnessTrack | http://127.0.0.1:3103 |
| Endurain | http://127.0.0.1:8080 |

Start **one** compose project, verify two accounts, stop it, then the next.
