# Dropout log (Phase 1.3)

A row is dropped only if the stack **fails to start** in weeks 2–4. Pass requires ≥ 4 running apps.

| App | Attempt date | Result | Reason | Substitute |
| --- | --- | --- | --- | --- |
| openGym | 2026-09-19 | kept (HTTP up; two-user incomplete) | Passkey (WebAuthn) signup only. Stack binds `127.0.0.1:3102` and `/api/health` returns 200. Two synthetic passkey profiles were not created in this session. | none — corpus still has four apps with two password users |
