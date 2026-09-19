# Synthetic lab accounts (never real health data)

All names and metrics are fake. Used only on `127.0.0.1`.

Password pattern: `LabUser-ChangeMe-2026!` plus a per-user suffix so two accounts differ.

| App | User A | Email A | User B | Email B |
| --- | --- | --- | --- | --- |
| Workout.cool | alice_lab | alice.lab@example.test | bob_lab | bob.lab@example.test |
| FitTrackee | alice_lab | alice.lab@example.test | bob_lab | bob.lab@example.test |
| openGym | alice_lab | alice.lab@example.test | bob_lab | bob.lab@example.test |
| FitnessTrack | alice_lab | alice.lab@example.test | bob_lab | bob.lab@example.test |
| Endurain | alice_lab | alice.lab@example.com | bob_lab | bob.lab@example.com |

Passwords (lab only):

- Alice: `LabUser-ChangeMe-2026!A`
- Bob: `LabUser-ChangeMe-2026!B`

Login notes:

- FitnessTrack uses **username** `alice_lab` / `bob_lab` (no email on register).
- FitTrackee login body uses **email**, not username.
- Endurain uses **username** + form body + header `X-Client-Type: mobile`. App also has default `admin` / `admin`. Signup is disabled; Alice/Bob were created by admin then language set to `en` in Postgres so login serialization succeeds.
- openGym has no passwords: WebAuthn passkeys. Profiles `alice_lab` / `bob_lab` are reserved names; they were **not** created in Phase 1.

