# Proposal (first version)

| | |
| --- | --- |
| **Student** | Achraf Bennani Ziatni |
| **Supervisor** | Prof. Leonardo Iwaya |
| **Course** | DVAE06 Research Project |
| **Date** | 7 September 2026 |
| **Version** | 1 (first) |

**Title.** Evaluating Open-Source AI Security Testing Tools on a Fitness and Health App

This file is the **first** proposal text. The current proposal is [`Master-Semester-Project-Proposal.md`](Master-Semester-Project-Proposal.md).

---

## Motivation

Fitness and health apps store data people care about protecting: workouts, body metrics, heart rate, sometimes GPS traces from runs. Most are built the same way. A mobile or web client talks to a REST API, with several accounts that should never see each other’s records. AI-guided security tools can now find missing authorization checks, leaked secrets, and simple API mistakes, but they also hallucinate findings and claim success without proof. Fully autonomous agents need a GPU or a paid API key and can burn through tokens in a handful of runs, which makes them a poor fit for a student project.

A more realistic project: take a fitness app running on my own laptop, test it with one traditional scanner and one human-in-the-loop AI assistant on a free local model, measure what’s actually true versus hallucinated, fix the confirmed issues, and retest. That fits a laptop, and a free token budget, while still answering a question nobody has looked at closely: how much does a cheap, local AI assistant actually add over a standard scanner on a health-data API?

---

## Research questions

**RQ1.** Which weaknesses do AI tools report on a fitness/health API (e.g. broken object-level authorization, missing authentication, exposed secrets), and how does that differ from a standard scan?

**RQ2.** What share of AI-reported findings hold up under human review, and how often does the tool claim a result with no evidence behind it?

**RQ3.** After a short hardening pass (authorization checks, session rules, removing secrets, basic rate limiting), which findings disappear on retest?

---

## Target and method

The test target is **Wger**, a small self-hosted fitness app with open-source code on GitHub. We will test two versions of the app: one old version with known and reported vulnerabilities and one new version with potential vulnerabilities. We will compare the results of the tests to identify any differences.

Before any scan runs, we will write down the issues we expect to find, so recall can be measured honestly rather than after the fact. We then run a fixed protocol on the same target: OWASP ZAP as a free baseline, optionally Semgrep against the source, and PentestGPT in interactive mode backed by a local Ollama model. The AI session is human-in-the-loop by design (HITL): the model proposes the next hypothesis to check, we run the actual request or read the actual response, and nothing runs unattended. The whole project has a hard ceiling of 80 LLM calls, with prompts capped at roughly 2,000 tokens each, so the comparison stays about a cheap local assistant rather than a large autonomous agent. If Ollama or PentestGPT setup fails partway through, a fallback of 15 fixed prompts on the same model keeps the research questions answerable.

Every finding gets sorted into confirmed, false positive, or unverified claim. Once the fixes are in and the newest version is called, we rerun the same protocol and see what’s gone.

Confirmed findings are labeled against two public references, the OWASP API Security Top 10 and the MITRE ATT&CK matrix, so the results speak a language a security engineer already knows. This is a lookup exercise against public technique IDs, not a new lab: no Caldera, no enterprise emulation.

---

## Scope

**In scope:** one self-hosted app on own laptop, synthetic accounts, authentication and cross-user authorization, secrets, session handling, export endpoints, two free local tools, and a short fix-and-retest cycle.

**Out of scope:** building a new AI agent, autonomous or unattended agent loops, paid cloud APIs as the default, cloud GPUs, full mobile reverse engineering, and a full legal or GDPR analysis (a one-page ethics note covers that instead). A brief static look at a dummy mobile client is possible in the last two weeks, only if the API study is already finished, as a bonus rather than a requirement.

---

## Deliverables

- A Dockerized Wger repo with the seed-issue list and setup scripts
- A spreadsheet of raw tool output plus the LLM call and token log
- A 4–20 page report covering the three research questions and the OWASP/ATT&CK label table
- A fitness-app hardening checklist
- A short demo showing Alice and Bob’s data isolated from each other, before and after the fix pass

---

## Research papers

Deng, G., Liu, Y., Mayoral-Vilches, V., Liu, P., Yue, Y., Xu, W., Zhang, T., Xu, Y., Pinzger, M., & Rass, S. (2024). *PentestGPT: Evaluating and harnessing large language models for automated penetration testing.* In *33rd USENIX Security Symposium*. USENIX Association. https://www.usenix.org/conference/usenixsecurity24/presentation/deng — also arXiv:2308.06782.

Supports: the main method. An LLM that *guides* a human tester (task tree, human in the loop), which is the cheap laptop setup used here.

Happe, A., & Cito, J. (2023). *Getting pwn’d by AI: Penetration testing with large language models.* In *Proceedings of the 31st ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE ’23)* (pp. 2082–2086). ACM. https://doi.org/10.1145/3611643.3613083

Supports: early peer-reviewed evidence that LLMs can drive security-testing steps. Useful to justify “AI-assisted testing” without claiming a new agent.

Peng, J., Li, Z., You, C., Wang, Y., Sun, H., Tian, X., Zhang, S., Liu, J., Zhao, J., Liu, R., Ou, H., Sun, Y., Zhang, J., Jiao, Y., Song, K., Zhang, C., Shi, F., Sun, H., Yan, R., & Huang, C. (2026). *Hackers or hallucinators? A comprehensive analysis of LLM-based automated penetration testing.* arXiv preprint. https://arxiv.org/abs/2604.05719

Supports: RQ2 and the token cap. Shows hallucination / false-success, and that more tools or multi-agent swarms are not automatically better.

Sun, F., Xu, L., & Su, Z. (2011). *Static detection of access control vulnerabilities in web applications.* In *20th USENIX Security Symposium*. USENIX Association. https://www.usenix.org/conference/usenixsecurity11/static-detection-access-control-vulnerabilities-web-applications

Supports: the core bug class in Wger — one user reaching another user’s objects (workout/metrics IDs). Grounds the seed list and the hardening pass in established access-control research, not only in OWASP slogans.

Papageorgiou, A., Strigkos, M., Politou, E., Alepis, E., Solanas, A., & Patsakis, C. (2018). *Security and privacy analysis of mobile health applications: The alarming state of practice.* *IEEE Access*, 6, 9390–9403. https://doi.org/10.1109/ACCESS.2018.2799522

Supports: the target choice. Empirical study of health/fitness-style apps: weak authentication, sensitive data mishandling, third-party leakage. Motivates the checklist without a hospital system or real patient data.
