# Fitness-API AutoPT semester lab

Black-box evaluation of OWASP ZAP, Nuclei, and a student-built AutoPT agent on five self-hosted fitness apps. Defensive research only. Localhost, synthetic users, no production SaaS.

Start with the [semester proposal](docs/Master-Semester-Project-Proposal.md).

```
rpk/
├── README.md                          ← you are here
├── docs/                              reading and planning
│   ├── README.md
│   ├── Master-Semester-Project-Proposal.md
│   ├── Phase-1-Lab-Log.md             Phase 1 corpus outcome
│   ├── Papers-Tools-Extract.md        tools named in the five papers
│   ├── AI-Pentesting-Tools-Research-Catalog.md
│   └── papers/                        five cited papers
│       ├── README.md
│       ├── Deng-PentestGPT-Paper-Sections-Explained.md
│       ├── Happe-Cito-Paper-Sections-Explained.md
│       ├── Hackers-or-Hallucinators-Paper-Sections-Explained.md
│       ├── Hackers-or-Hallucinators-Mindmaps.md
│       ├── Hackers-or-Hallucinators-Mindmaps-Explained.md
│       ├── Sun-Access-Control-Paper-Sections-Explained.md
│       └── Papageorgiou-mHealth-Paper-Sections-Explained.md
└── lab/                               runtime (localhost only)
    ├── README.md
    ├── pins.md
    ├── dropout-log.md
    ├── facts-file.md
    ├── synthetic-accounts.md
    ├── phase1-status.md
    ├── patches/                       re-apply after clone
    ├── overrides/                     compose bind-to-localhost
    └── apps/                          git clones (gitignored)
```

| Path | What it is |
| --- | --- |
| [`docs/`](docs/README.md) | Proposal, Phase 1 lab log, tool catalog, paper reading guides |
| [`docs/papers/`](docs/papers/README.md) | Section-by-section notes for Deng, Happe, Peng, Sun, Papageorgiou |
| [`lab/`](lab/README.md) | Docker corpus, pins, facts file, account notes |
