# Semester Project Proposal

**Title:** Black-Box Evaluation of Three Security Testing Tools on Open-Source Fitness Apps — Using the Peng et al. AutoPT Taxonomy

**Level:** Master’s semester project  
**Field:** Application security, AI-assisted testing, privacy of health data  
**Duration:** one semester (12–14 working weeks)  
**Indicative load:** 240–280 hours (~10–12 ECTS)  
**Test target:** one self-hosted open-source fitness/health app (primary), chosen from a shortlist of six  
**Empirical knowledge level:** **black-box only** (white-box and grey-box out of the empirical scope, as in Peng et al.)  
**Tools (exactly three):** OWASP ZAP, ProjectDiscovery Nuclei, PentestGPT (human-in-the-loop + Ollama)  
**Taxonomy:** Peng, Li, You, et al. (2026), *Hackers or Hallucinators?*, arXiv:2604.05719  
**Runtime:** a normal student laptop only — no GPU cluster, no cloud VMs  
**LLM cost:** free range — local models first (Ollama), paid APIs not required  
**Nature of work:** applied research + small lab study, defensive only

This proposal is sized so a student can finish it in one semester, on a personal laptop, without building a new AI agent, without a large token bill, and without repeating Peng et al.’s 10-billion-token bake-off. The student **uses their taxonomy and findings**, then runs a **laptop-sized black-box** case study on a fitness API. White-box and grey-box appear only as **definitions** in the background chapter; they are **not** run.

---

## 1. Motivation

Fitness and health apps store sensitive data: workouts, weight, heart rate, sleep, GPS of runs, sometimes wearable tokens. They are usually a **web or mobile client plus a REST API**, with several accounts that must not see each other’s records.

Peng et al. (2026) showed that LLM AutoPT papers exploded without (1) a shared **architectural taxonomy** and (2) a fair comparison under one protocol. Their bake-off is far beyond a semester. What a master’s student *can* do is take that taxonomy as the **language of the method**, then answer a smaller, still new question:

> On a **self-hosted fitness app**, how do **three different black-box testing tools** behave on the same target, and how much of the AI tool’s output is confirmed evidence rather than hallucination?

Fully autonomous multi-agent swarms are a poor fit here. Peng et al. found that extra agents, huge Kali menus, and mismatched knowledge bases often **do not** raise scores, while flag-style hallucinations are common. This project therefore uses:

1. one **traditional black-box DAST** (OWASP ZAP),
2. one **template-based black-box scanner** (Nuclei, HTTP templates only),
3. one **LLM AutoPT assistant** classified with Peng’s six dimensions (PentestGPT, interactive, Ollama).

The student measures real versus false findings, applies a short fix list, **retests the same black-box protocol**, labels confirmed issues with OWASP API Top 10 and MITRE ATT&CK, and writes a hardening checklist for this class of app.

---

## 2. Problem statement

Security teams and small product companies do not know **how much an open-source AI testing tool actually helps** on a realistic health-related app, compared with ordinary black-box scanners, when nobody has source, OpenAPI dumps, or insider maps in the tester’s hands.

Peng et al. already compared 13 AutoPT frameworks on **black-box web CTFs**. They explicitly set **white-box and grey-box out of their empirical scope**. This project **follows that same empirical boundary**. Existing fitness-app papers (e.g. Papageorgiou et al., 2018) study privacy practice, not AI testers. Vendor blogs mix knowledge levels and hide false-success rates.

**Gap this project fills:** a small, reproducible, defensive case study that (a) speaks Peng’s taxonomy, (b) runs a **black-box-only** protocol on a **fitness product** rather than an XBOW CTF, (c) uses **three** tools a student can actually install, (d) stays on a laptop with free local models.

---

## 3. Research questions

Keep exactly three questions.

**RQ1.** Under **black-box** conditions, which weakness *classes* do the three tools report on a typical fitness/health API (especially broken object-level authorization, broken authentication, secrets, insecure export), and how do the three sets differ?

**RQ2.** What share of findings is **confirmed** after human review with request/response evidence, and how often does the LLM assistant claim success without usable evidence (Peng et al.’s hallucination / false-success problem)?

**RQ3.** After a short hardening pass, which confirmed findings disappear on a **black-box retest** with the same three tools?

No question requires writing exploits, a full kill-chain, grey-box or white-box campaigns, or testing third-party production apps (not wger.de, not Workout.cool production).

---

## 4. Objectives

1. Choose **one** self-hosted fitness app from the shortlist in section 5 (primary recommendation: **wger**).
2. Deploy it in Docker on `127.0.0.1` with **synthetic** Alice / Bob / Coach data.
3. Write a **seed-issue list** of 8–12 flaws *before* any scan (fork-local weaknesses or documented lab issues — not live 0-days). Seeds are **experimenter ground truth**, not tester input.
4. Classify the AI method with Peng’s **six dimensions** (section 7.1) so the report uses the same vocabulary as the SoK.
5. Run the **black-box campaign** (ZAP + Nuclei + PentestGPT; no source, no OpenAPI, no architecture notes in the prompt).
6. Classify every finding: true positive / false positive / unverified claim.
7. Implement **5–8 concrete fixes** in the fork (defender work after scoring; not a grey-box test).
8. **Retest black-box** with the same three tools.
9. Map confirmed findings to **OWASP API Security Top 10** and one **MITRE ATT&CK** technique.
10. Deliver a 20–30 page report and a fitness-app hardening checklist.

---

## 5. Target: open-source fitness apps

The app is a **lab instrument**, not the product the student is building. All tests are on **the student’s Docker instance**. Public production sites are out of scope.

### 5.1 Primary recommendation

| Choice | Why |
| --- | --- |
| **wger** (`wger-project/wger`, AGPL-3.0) | Real multi-user workout / nutrition / body-metrics product with a **REST API**, Docker Compose, gym-style roles, and enough object IDs for authorization tests. Mature (~6k GitHub stars). Closest to a market fitness API without being a hospital EHR. |

Optional version pair (only if the supervisor wants a “known CVE class” story in the Peng 5.6.2 sense): pin **one old lab image** and **one newer image** that the maintainers mark as fixed, **one stack at a time**, still localhost. This is **not** required for a pass.

### 5.2 Five other top open-source fitness apps (authorized lab alternatives)

Use this table to pick a fallback in week 3 if wger is too heavy, or to write a half-page “why this one” comparison. **Do not test more than one app** in the main experiment.

| # | Project | Repo (indicative) | What it is | Why it is usable for *this* test |
| --- | --- | --- | --- | --- |
| 1 | **Workout.cool** | [Snouzy/workout-cool](https://github.com/Snouzy/workout-cool) | Modern MIT fitness coaching platform (plans, exercise DB, progress). Very active; Docker / Compose. | Multi-user plans and history IDs → black-box authorization tests on a live HTTP API. |
| 2 | **FitTrackee** | [SamR1/FitTrackee](https://github.com/SamR1/FitTrackee) | Self-hosted outdoor tracker (GPX, maps, workouts). Flask + Vue; Docker. | GPS/health-adjacent files and per-user activities; good for export/privacy seeds. |
| 3 | **openGym** | [DuarteSantos8/openGym](https://github.com/DuarteSantos8/openGym) | Self-hosted gym & body-weight tracker; passkeys; `docker compose up`. | Smaller surface, still multi-profile; passkeys add an auth theme visible from the outside. |
| 4 | **FitnessTrack** | [Gman0909/FitnessTrack](https://github.com/Gman0909/FitnessTrack) | Self-hosted progressive-overload strength logger; Docker + SQLite. | Simple API/UI on a laptop; easy Alice/Bob set logs. |
| 5 | **Endurain** | [endurain-project/endurain](https://github.com/endurain-project/endurain) (Codeberg is canonical) | Self-hosted Strava-class tracker (GPX/TCX/FIT, activity privacy, followers). Docker Compose + PostgreSQL + Redis. | Multi-user activities and privacy settings. Heavier than FitnessTrack — confirm RAM before choosing it as the *primary* target. |

If Endurain does not start cleanly in week 3, substitute another **self-hosted, multi-user, Docker** fitness app (e.g. LibreFit) and record the reason. Never use closed commercial apps (Hevy, Strong, MyFitnessPal) or university gym production systems.

**Minimum target features (whichever app is chosen)**

- Login and at least two user accounts  
- Per-user objects (workouts, metrics, GPX, or plans) addressed by ID  
- At least one export, upload, or share path  
- HTTP interface reachable on localhost (black-box testers need no source)

Source of the fork is used later to **apply fixes**, not to feed the scanners.

---

## 6. Taxonomy from Peng et al. (the language of this project)

This project does **not** rerun their 13-framework XBOW experiment. It **reuses their definitions** so the report is comparable to the SoK.

### 6.1 Knowledge levels (Peng §2.1)

| Level | Peng’s definition | This project |
| --- | --- | --- |
| **White-box** | Source and architecture fully known (code audit / SAST as the *main* paradigm) | **Out of the empirical scope.** Named in the report so the boundary is explicit. No SAST campaign, no full code audit. |
| **Grey-box** | Partial prior knowledge (insider-like access: maps, source hints, planted credentials beyond normal registration) | **Out of the empirical scope.** Same cut as Peng’s bake-off. No Semgrep campaign, no source in prompts, no OpenAPI dump as tester input. |
| **Black-box** | Zero internals; only external interfaces | **The only empirical protocol.** ZAP, Nuclei, and PentestGPT see only `http://127.0.0.1` responses. No source, no architecture notes in the prompt. |

Peng’s AutoPT bake-off was **black-box only**. This project **keeps that empirical cut** and moves the target from CTF/XBOW to a **fitness product API**, with three laptop tools instead of 13 frameworks.

Classic human models they list (Kill Chain, PTES, NIST SP 800-115, ATT&CK) stay what they are in the SoK: **labels and background**, not a Caldera lab.

### 6.2 Six design dimensions (Peng §3) — how we classify *our* AI tool

| Dimension | What Peng asks | How PentestGPT+Ollama is classified **in this lab** |
| --- | --- | --- |
| **3.1 Architecture** | Who decides? One agent vs many; role = own window + authority | **Single-agent, prompt-defined role, human-in-the-loop.** No multi-agent swarm (their §5.1: extra roles often fail or never fire). |
| **3.2 Plan** | Linear / tree / graph + feedback | **PentestGPT PTT (tree) in interactive mode**, or a **linear ReAct notebook** if install fails. Student is the feedback loop (execution-level). No autonomous graph rewrite. |
| **3.3 Memory** | Experience vs knowledge; compress; organize | **Experiential only:** a student-maintained **facts file** (structure-bound lite) + truncated tool output. No HackTricks RAG (their §5.2: mismatched KB often hurts). |
| **3.4 Execution** | Whether / which / how; tool layers | **Small menu:** browser + `curl` + ZAP/Nuclei history. Paper §5.4: successful traces are atomic HTTP/Python, not 115 Kali tools. |
| **3.5 External knowledge** | Construct → retrieve → generate | **Lab-only notes:** seed-issue *classes* after the first campaign is scored; optional **one** version-pinned advisory if using a known-fixed wger pair. No Top-100 RAG dump. Seeds never enter the PentestGPT prompt during the scored run. |
| **3.6 Benchmarks** | Testbed + metrics; contamination | **Testbed type:** closer to Peng’s *single-host / product API* than to XBOW CTF. **Success** = confirmed HTTP evidence (their flag-equality spirit), not “the model said critical.” |

### 6.3 Findings we take as design rules (Peng §5–6)

1. **Memory first** — keep a facts file; do not rely on a long chat.  
2. **Single-agent HITL is enough** for Easy/Medium API tasks.  
3. **More tools ≠ better** — three tools, small HTTP set.  
4. **KB only if it matches this app** — no generic payload wiki.  
5. **Hallucinations are structural** — never regex the model’s prose for “success”; require a saved request/response.  
6. **Do not treat SWE-bench fame as AutoPT skill** — local 3B/7B is the scientific object, not Opus.

---

## 7. Three tools (required)

Exactly **three** tools. Each is usable as a **black-box** tester. None requires source.

| # | Tool | Peng-aligned role | Knowledge level | Tokens |
| --- | --- | --- | --- | --- |
| **T1** | **OWASP ZAP** (automated / “quick” scan, localhost only) | Traditional **security-tool** DAST; no LLM. Baseline for “old tech.” | **Black-box** | None |
| **T2** | **Nuclei** (ProjectDiscovery; HTTP templates against the lab URL only) | Template-based black-box scanner; still no source. Second non-LLM baseline, different from ZAP’s crawler/scanner. | **Black-box** | None |
| **T3** | **PentestGPT** interactive / human-in-the-loop + **Ollama** (`llama3.2:3b` or `qwen2.5:7b`) | LLM AutoPT **assistant**: PTT or linear prompts; student executes. Fallback: 15-prompt notebook (same RQs). | **Black-box** only | Capped (section 9.0) |

**Why these three, not Strix/CAI/a Kali zoo / Semgrep**

- Peng §5.4: call volume and 115-tool menus did not drive success; atomic HTTP did.  
- Peng §5.1.4: a short prompt plus a terminal beat most dedicated OSS; we keep the short prompt.  
- Peng §2.1 / empirical cut: Semgrep is grey/white-box SAST — **named in §8.1, not executed**.  
- Semester + laptop: ZAP and Nuclei are free and offline; PentestGPT HITL is the only token user.

**Do not add a fourth tool** as a main condition. Mention others only in the “tools not run” paragraph (section 8.1).

---

## 8. Scope

### In scope

- One Dockerized fitness app on the laptop  
- Synthetic accounts only  
- **Black-box campaign only**  
- The three tools above  
- Authn/authz, secrets, session, export/upload **as seen from HTTP**  
- Human confirmation (read responses; no exploit development)  
- Fix-and-retest of the **same black-box protocol**  
- OWASP API + ATT&CK **label table**  
- Peng taxonomy section in the report (2–3 pages), including why grey/white are not run  
- 20–30 page report  

### Out of scope

- **White-box** empirical work (full audit, SAST-as-main-paradigm, formal verification)  
- **Grey-box** empirical work (source in prompts, OpenAPI as tester input, Semgrep campaign, insider API map as a scored condition)  
- New AutoPT agent, multi-agent swarms, overnight loops  
- Paid APIs as default; cloud GPUs; commercial AutoPT SaaS  
- Testing wger.de, Workout.cool production, or any third-party live system  
- Full mobile RE, Frida, jailbreak, AD/Caldera  
- Real wearables or real health records  
- Exploit PoCs in the report  
- Garak full suites  

### 8.1 Tools considered, not executed

Half a page: **Semgrep** (grey-box SAST — excluded by the empirical cut), Aikido Android, Thorfinn, iosHunt, TrashiOS, Caldera AI, Strix/CAI unattended — named and excluded (knowledge level, licence, hardware, or Peng-style token cost). Optional stretch only if weeks 1–10 are done: 10 local promptfoo cases if the app has a chat feature (≤ 10 extra calls).

---

## 9. Method

### 9.0 Laptop and token rules (hard)

| Resource | Minimum | Comfortable |
| --- | --- | --- |
| RAM | 8 GB (3B model; ZAP *or* Ollama, not both) | 16 GB |
| Disk | 20 GB free | 40 GB |
| GPU | Not required | Optional |

| Rule | Limit |
| --- | --- |
| Default LLM | Ollama localhost, €0 |
| Call cap | **≤ 80 LLM calls** semester-wide |
| Split | ≤ 50 black-box PentestGPT (first campaign) + ≤ 25 black-box retest + ≤ 5 buffer |
| Prompt size | ≤ 2 000 tokens; never paste a full ZAP or Nuclei dump |
| Free-tier cloud fallback | ≤ 30 calls then stop |
| Autonomous loops | Off |

**Token log (required appendix):** date, tool, knowledge level (black-box), model, call #, approx. tokens.

### 9.1 Black-box protocol (Peng §2.1)

**Black-box session (the only scored protocol)**

- Inputs: base URL, “authorized lab,” no source, no OpenAPI, no seed-issue list in the prompt, no architecture notes.  
- Accounts: the harness may create users **as a normal registration flow** (that is still black-box: a remote user can register). Do **not** paste source snippets.  
- Tools: ZAP full automated pass; Nuclei HTTP templates against the lab URL; PentestGPT (hypotheses only; student verifies with ZAP/Nuclei history or short `curl`).  
- Stop at call budget. Record “budget exhausted.”

**Fairness:** same target URL, same two users, same scope file, no extra tool tuning beyond a junior’s day-one setup.

Planting seeds in a **local fork** is experimenter setup. Once the campaign starts, the three tools stay blind to that list and to the source.

### 9.2 Seed-issue list (written first)

Examples of **classes** (adapt to the chosen app; do not publish payloads):

- object ID in the URL not bound to the logged-in user,  
- metrics or GPX export without a session,  
- role or gym membership flipped from the client,  
- token or secret in a frontend bundle,  
- missing login throttle,  
- debug errors in the lab “prod” profile,  
- CORS wide open on the API.

Ground truth for recall. Do not add seeds after the first scan starts. Do not give the list to ZAP, Nuclei, or PentestGPT during scored runs.

### 9.3 Metrics

| Metric | Definition |
| --- | --- |
| Recall (black-box) | Seeded issues found / seeded issues |
| Precision | Confirmed / reported, per tool |
| Evidence rate | Findings with a saved request/response |
| False-success count | LLM claims “done / critical” with no evidence (Peng §5.6.3) |
| Time | Hours per tool |
| LLM calls | Must stay inside 9.0 |
| Retest delta | Seeds still open after fixes, same black-box protocol |
| Coverage by class | OWASP API1 vs others |

No significance tests. Transparent tables are the scientific level.

### 9.4 Labels (desk work)

One row per **confirmed** finding: OWASP API ID + closest ATT&CK technique (T1190, T1078, T1530, T1552, T1213 or “no close match”). No Caldera.

### 9.5 Fix and retest

Smallest high-value changes: ownership checks, auth on export, secrets out of the client, role changes locked, login throttle, debug off. Then rerun **ZAP + Nuclei + PentestGPT** once (retest budget above). Reading the fork to implement a fix is defender work; it does **not** open a grey-box scoring condition.

---

## 10. Full strategy (phases, steps, and the goal of each)

This is the operational spine. Each step has a **goal** (why it exists) and a **done-when** test. Skip a stretch; do not skip a phase.

### Phase 0 — Frame the science (week 1)

| Step | What | Goal of this step |
| --- | --- | --- |
| 0.1 | Read Peng et al. (taxonomy + §5 findings) plus the other four papers in section 21 | Share vocabulary with the SoK; do not invent a private theory of agents |
| 0.2 | Write a 2-page protocol: three tools, **black-box only**, token cap, ethics, grey/white excluded | Get supervisor sign-off before any scan |
| 0.3 | Confirm Ollama replies on the laptop | Prove the free-token path works |

**Phase goal:** the project is a **Peng-taxonomy case study**, not a casual tool demo.  
**Done when:** signed ethics page + protocol + `ollama run` screenshot.

### Phase 1 — Choose the target (week 2)

| Step | What | Goal of this step |
| --- | --- | --- |
| 1.1 | Score wger + the five apps in §5.2 on: Docker on laptop, multi-user, API or ID-based objects | Pick **one** app scientifically, not by GitHub stars alone |
| 1.2 | `docker compose up` on localhost; create Alice and Bob | Prove the instrument runs |
| 1.3 | Record image tag / commit hash | Reproducibility (Peng §4 hygiene) |

**Phase goal:** one authorized, pinned, multi-user fitness system.  
**Done when:** two users can log a workout/activity on `127.0.0.1`.

### Phase 2 — Instrument the lab (weeks 3–4)

| Step | What | Goal of this step |
| --- | --- | --- |
| 2.1 | Bind all ports to `127.0.0.1`; synthetic data only | Containment and privacy |
| 2.2 | Write the 8–12 seed-issue list **before** hiding those issues | Fair recall (Peng §3.6: metric + ground truth) |
| 2.3 | Fork locally if seeds need a weak default; never weaken a live third party | Legal/ethical boundary |
| 2.4 | Create the empty **facts file** and token-log sheet | Memory-first (Peng §6) from day one |

**Phase goal:** a measurable lab, not an undefined “we will pentest wger.”  
**Done when:** seed list frozen and stored; facts file template ready.

### Phase 3 — Traditional black-box (weeks 5–6)

| Step | What | Goal of this step |
| --- | --- | --- |
| 3.1 | Scope ZAP to localhost; automated scan only | Traditional black-box baseline |
| 3.2 | Review ZAP: keep issues with evidence; drop noise | Precision, not finding-count theatre |
| 3.3 | Run Nuclei HTTP templates against the lab URL | Second non-LLM black-box signal, different engine |
| 3.4 | Triage Nuclei: keep HTTP-evidenced rows | Same confirmation rule as ZAP |
| 3.5 | Fill traditional-scanner columns of the comparison sheet | Answer RQ1 for T1 and T2 |

**Phase goal:** what two ordinary black-box scanners can see **without** internals.  
**Done when:** ZAP and Nuclei tables complete.

### Phase 4 — LLM black-box (week 7)

| Step | What | Goal of this step |
| --- | --- | --- |
| 4.1 | PentestGPT (≤ 50 calls), no source, no OpenAPI, no seed list in the prompt | LLM AutoPT under Peng’s black-box definition |
| 4.2 | Student executes only hypothesized *classes* of check; save HTTP traces | Separate model speech from evidence (anti-hallucination) |
| 4.3 | Update facts file from confirmed HTTP only | Bind feedback to memory (Peng §3.2.4 / §6) |
| 4.4 | Fill T3 columns; compare to Phase 3 | Show overlap/difference among three tools |

**Phase goal:** measure the AI assistant on the **same** blind protocol as ZAP and Nuclei.  
**Done when:** PentestGPT table complete; call log ≤ 50.

### Phase 5 — Human review and labels (week 8)

| Step | What | Goal of this step |
| --- | --- | --- |
| 5.1 | TP / FP / unverified for every row | RQ2 |
| 5.2 | Count false-success (model stopped as if done) | Operationalize Peng §5.6.3 |
| 5.3 | OWASP API + ATT&CK labels for confirmed rows only | Standard language, no extra lab |
| 5.4 | Note any “chain” (two findings that should combine) | Optional nod to Peng §5.6.1; do not force a chain |

**Phase goal:** a defensible findings set, not a tool export.  
**Done when:** label table has one row per confirmed issue.

### Phase 6 — Harden the fork (weeks 8–10)

| Step | What | Goal of this step |
| --- | --- | --- |
| 6.1 | Rank confirmed issues (authz and export first) | Papageorgiou / Sun: access control is the fitness-app risk |
| 6.2 | Implement 5–8 small fixes in the fork | Defender outcome, not a longer toolkit |
| 6.3 | Commit fixes with messages that name the finding ID | Traceability |

**Phase goal:** close the find → fix loop.  
**Done when:** 5–8 fixes merged on the lab branch.

### Phase 7 — Black-box retest (weeks 10–11)

| Step | What | Goal of this step |
| --- | --- | --- |
| 7.1 | ZAP again (same policy) | RQ3 traditional |
| 7.2 | Nuclei again (same templates) | RQ3 template scanner |
| 7.3 | PentestGPT black-box retest ≤ 25 calls | RQ3 AI, same blindness as Phase 4 |
| 7.4 | Retest-delta table | Show what disappeared vs what was missed |

**Phase goal:** prove upgrades, not only list bugs.  
**Done when:** before/after recall exists for the black-box protocol.

### Phase 8 — Write and demo (weeks 12–14)

| Step | What | Goal of this step |
| --- | --- | --- |
| 8.1 | Report chapters (section 13) | 20–30 pages, taxonomy used correctly |
| 8.2 | Hardening checklist for fitness APIs | Transferable defender output |
| 8.3 | 10–15 min demo: Alice/Bob before and after | Examiner-visible result |
| 8.4 | Buffer | Slips without dropping RQ3 |

**Phase goal:** a graded, citable semester report.  
**Done when:** PDF + tables + token log + demo.

### Strategy diagram (read top to bottom)

```
Frame (Peng taxonomy, ethics, Ollama)
        ↓
Pick one fitness app (wger or fallback from the five)
        ↓
Seed list + facts file + localhost Docker
        ↓
    BLACK-BOX ONLY
    ZAP + Nuclei + PentestGPT
        ↓
Review, labels, hallucination count
        ↓
Fix 5–8 issues on the fork
        ↓
Retest BLACK-BOX with the same three tools
        ↓
Report + checklist + demo
```

---

## 11. Expected results

The project succeeds if the student can say, with tables:

- Black-box ZAP found mostly config / injection-class noise.  
- Nuclei overlapped, missed, or added a different HTTP class (or found nothing — still a result).  
- PentestGPT produced more **authorization hypotheses** than the scanners (or did not — report honestly).  
- X findings confirmed, Y hallucinated / evidence-free (Peng RQ2).  
- After fixes, recall moved from A% to B% on the **same** black-box protocol.  
- Token total stayed under the cap.

A mixed result is acceptable: “the AI assistant did not beat ZAP or Nuclei on black-box, and half the AI claims lacked evidence.”

---

## 12. Deliverables

| Deliverable | Form |
| --- | --- |
| Lab target | Dockerized fork (wger or one of the five) + seed list + image pin |
| Evaluation pack | Tables by **tool**, raw reports, **LLM call log** |
| Report | 20–30 pages |
| Taxonomy note | How T3 maps to Peng’s six dimensions (1–2 pages); grey/white named as excluded |
| Label table | OWASP API + ATT&CK |
| Hardening checklist | 2–4 pages |
| Demo | 10–15 min Alice/Bob isolation |

The catalog `AI-Pentesting-Tools-Research-Catalog.md` is background. This project **uses three tools**, it does not rescan the market.

---

## 13. Report outline

1. Introduction and RQs  
2. Background: fitness-app threats + **Peng taxonomy** (knowledge levels, six dimensions, findings we adopt; **why empirical work is black-box only**)  
3. Related work (five papers + tools not run)  
4. Targets: why wger (or fallback) among the six apps  
5. Method: three tools, black-box protocol, seeds, metrics, ethics, token cap  
6. Strategy recap (Phase 0–8, one page)  
7. Results: RQ1–RQ3 tables  
8. Discussion: what to upgrade first; what Peng predicted that we saw  
9. Limitations (one app, weak local LLM, no grey-box, no white-box)  
10. Conclusion  

Appendices: seeds, versions, prompts, finding IDs, token log, Nuclei template IDs used.

---

## 14. Semester plan (14 weeks) and hours

| Weeks | Phase | Hours |
| --- | --- | --- |
| 1 | 0 Frame | 20 |
| 2 | 1 Target choice + Docker | 20 |
| 3–4 | 2 Lab + seeds | 40 |
| 5–6 | 3 Traditional black-box (ZAP + Nuclei) | 30 |
| 7 | 4 LLM black-box (PentestGPT) | 20 |
| 8 | 5 Review + labels; start fixes | 20 |
| 9–10 | 6 Fixes | 30 |
| 10–11 | 7 Black-box retest | 25 |
| 12–13 | 8 Report | 40 |
| 14 | Buffer, demo | 20 |
| **Total** | | **~265 hours** |

Three black-box tools replace a grey/black split. The **token cap** and **one app** are the remaining valves.

---

## 15. Scope of this semester project

| Out of this project | In this project |
| --- | --- |
| 13 frameworks × XBOW (Peng) | 3 tools × 1 fitness app × black-box |
| White-box and grey-box empirical work | Black-box only (Peng’s empirical cut) |
| Cloud GPUs / paid tokens | Laptop + Ollama ≤ 80 calls |
| New agent | Off-the-shelf HITL |
| 50–80 pages | 20–30 page report |

The **new** part is: Peng’s taxonomy + a **black-box three-tool comparison on a real open-source fitness product** (not a CTF). The **simple** part is: evaluator and defender, not tool author.

---

## 16. Required skills

HTTP APIs, Docker, reading OWASP API Top 10, honest writing. No OSCP, no RE, no ML research. Supervisor in software security or SE is enough. 16 GB laptop preferred; 8 GB works sequentially.

---

## 17. Ethics, privacy, legal

- Only the self-hosted instance; **never** production fitness SaaS.  
- Synthetic names and health values only.  
- Prefer local Ollama so data never leaves the laptop.  
- No exploit recipes or payloads in the public report — classes and **fixes** only.  
- Private logs; public aggregated tables.  
- One-page ethics appendix signed in week 2.  
- Dual-use named as in Peng §8: we study testers to **harden** apps.

---

## 18. Risks and fallbacks

| Risk | Fallback |
| --- | --- |
| wger too heavy | Workout.cool or FitnessTrack from §5.2 |
| PentestGPT install fails | 15-prompt notebook; still T3 |
| 8 GB RAM | 3B model; never ZAP + Ollama together |
| Nuclei template noise | Restrict to HTTP/exposed-panels classes; state the filter |
| Almost no findings | Valid result; keep the checklist |
| Many hallucinations | Answers RQ2; count them |
| Temptation to add Semgrep or source-in-prompt | Refuse: grey-box is out of the empirical scope |
| Temptation to add a fourth agent | Refuse: breaks Peng’s “more tools ≠ better” rule and the token cap |

RQs stay the same.

---

## 19. Suggested titles (pick one)

1. *Black-Box Testing of a Fitness API with ZAP, Nuclei, and PentestGPT*  
2. *Applying the Peng et al. AutoPT Taxonomy to Open-Source Fitness Apps: A Three-Tool Semester Study*  
3. *Authorization Bugs in Self-Hosted Workout Managers: What Three Black-Box Tools Actually Confirm*

Variant 1 is the clearest for a supervisor.

---

## 20. Supervision ask

Approve:

- the out-of-scope list,  
- laptop + free-token rules,  
- **three tools** and **black-box only** (white-box and grey-box out of the empirical scope),  
- one app from §5 (wger preferred),  
- ATT&CK/OWASP as labels only,  
- ethics (synthetic data, no production, no exploit publication),  
- Peng et al. as the **taxonomy source**, not as an experiment to replicate at scale.

**Week-2 kick-off:** chosen app + image pin, Ollama proof, draft seeds, 2-page protocol.

---

## 21. One-paragraph abstract (official form)

This semester project applies the **architectural taxonomy** of Peng et al. (2026) to a **self-hosted open-source fitness application**. Following the SoK, **white-box and grey-box are out of the empirical scope**. The lab compares **three black-box tools** — **OWASP ZAP** (DAST), **Nuclei** (HTTP templates), and **PentestGPT** in human-in-the-loop mode on a **local Ollama** model. The student pins one Docker target (recommended: wger; fallbacks: Workout.cool, FitTrackee, openGym, FitnessTrack, Endurain), freezes a seed-issue list as experimenter ground truth (never as tester input), confirms findings only with HTTP evidence (to count hallucinations), applies a short hardening pass, and retests the **same black-box protocol**. Paid APIs, GPUs, and autonomous swarms are out of scope. Confirmed issues are labelled with OWASP API Top 10 and MITRE ATT&CK. The outcome is a measured case study and a fitness-API hardening checklist: one app, three tools, black-box only, ≤ 80 LLM calls, 20–30 pages.

---

## 22. Immediate next steps

1. Confirm the one-semester format with the supervisor.  
2. Prefer **wger**; keep the five alternatives as documented fallbacks.  
3. Install Ollama; then ZAP; then Nuclei; then PentestGPT interactive (or the notebook).  
4. Freeze seeds before changing the fork to hide them. Do not put the seed list in any scanner prompt.  
5. Keep the facts file and token log from the first call.  
6. After confirmed findings, fill OWASP/ATT&CK. Do not install Caldera. Do not add a grey-box or white-box campaign.

---

## 23. Supporting literature (five papers)

Same five research papers as before. Peng et al. now also **define the method language** (not only RQ2).

1. **Deng et al. (2024).** PentestGPT, USENIX Security. — T3 and HITL/PTT.  
2. **Happe & Cito (2023).** ESEC/FSE. — LLMs for pentest steps.  
3. **Peng et al. (2026).** arXiv:2604.05719. — **Taxonomy (six dimensions; white/grey/black definitions; black-box empirical cut), findings (memory, tools, hallucination), ethics.**  
4. **Sun et al. (2011).** USENIX Security. — Access-control / Alice–Bob seeds.  
5. **Papageorgiou et al. (2018).** IEEE Access. — Why a fitness/health target.

**Where they go**

| Paper | Use in the report |
| --- | --- |
| Deng et al. | Method: T3 |
| Happe & Cito | Background |
| Peng et al. | §2 of the report (taxonomy), RQ2, tool-count, no-RAG rule, success=evidence, empirical knowledge-level cut |
| Sun et al. | Seed list |
| Papageorgiou et al. | Introduction and checklist |

Labels only (not among the five papers): OWASP API Security Top 10 (2023); MITRE ATT&CK.

Do not expand the report into a second SoK of Aikido, Thorfinn, or Caldera.
