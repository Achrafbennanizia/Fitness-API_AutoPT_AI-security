# Semester Project Proposal

**Title:** Black-Box Evaluation of Three Security Testing Tools Across Open-Source Fitness Apps — AI-Defined Main Weakness, Using the Peng et al. AutoPT Taxonomy

**Level:** Master’s semester project  
**Field:** Application security, AI-assisted testing, privacy of health data  
**Duration:** one semester (12–14 working weeks)  
<<<<<<< HEAD
**Indicative load:** 240–280 hours (~10–12 ECTS)  
**Test targets:** the **five** self-hosted open-source fitness/health apps in §5 (pass: at least four running)  
=======
**Indicative load:** 240–280 hours (~15 ECTS)  
**Test target:** one self-hosted open-source fitness/health app (primary), chosen from a shortlist of six  
>>>>>>> refs/remotes/origin/main
**Empirical knowledge level:** **black-box only** (white-box and grey-box out of the empirical scope, as in Peng et al.)  
**Tools:** OWASP ZAP, ProjectDiscovery Nuclei, plus a **new AutoPT agent** (student-built, Ollama) run as HITL, as a **multi-agent swarm**, and as an **overnight loop**  
**AI scientific job:** **define the main weakness class** of this product family, then test that class on every running app  
**Taxonomy:** Peng, Li, You, et al. (2026), *Hackers or Hallucinators?*, arXiv:2604.05719  
**Runtime:** a normal student laptop only — no GPU cluster, no cloud VMs  
**LLM cost:** free range — local models first (Ollama), paid APIs not required  
**Nature of work:** applied research + small lab study, defensive only

This proposal is sized so a student can finish it in one semester, on a personal laptop, without a large token bill, and without repeating Peng et al.’s 10-billion-token bake-off. The student **uses their taxonomy and findings**, stands up **several** fitness APIs, **builds a small AutoPT agent**, lets that agent **name the main weakness class**, then tests the class black-box with ZAP, Nuclei, a HITL run, a **multi-agent swarm**, and one **overnight loop**. White-box and grey-box appear only as **definitions** in the background chapter; they are **not** run.

---

## 1. Motivation

Fitness and health apps store sensitive data: workouts, weight, heart rate, sleep, GPS of runs, sometimes wearable tokens. They are usually a **web or mobile client plus a REST API**, with several accounts that must not see each other’s records. One app is an anecdote. **Several apps** show whether a weakness is a product-family pattern.

Peng et al. (2026) showed that LLM AutoPT papers exploded without (1) a shared **architectural taxonomy** and (2) a fair comparison under one protocol. Their bake-off is far beyond a semester. What a master’s student *can* do is take that taxonomy as the **language of the method**, then answer a smaller, still new question:

> Across **multiple self-hosted fitness apps**, what **main weakness class** does a **new local AutoPT agent** name from black-box HTTP evidence, do ZAP, Nuclei, a HITL run, a **multi-agent swarm**, and an **overnight loop** confirm that class, and how much of the AI output is evidence rather than hallucination?

Peng et al. found that extra agents, huge Kali menus, and mismatched knowledge bases often **do not** raise scores, while flag-style hallucinations are common. This project **tests those claims** on a fitness corpus instead of assuming them. It uses:

1. one **traditional black-box DAST** (OWASP ZAP),
2. one **template-based black-box scanner** (Nuclei, HTTP templates only),
3. one **new AutoPT agent** (student-built, Peng’s six dimensions, Ollama) in three modes: **HITL single-agent**, **multi-agent swarm**, **overnight loop**.

The student does **not** pre-commit to “the main bug is BOLA.” The AI proposes one OWASP-API class; HTTP evidence across apps accepts or rejects that claim. A short fix list is applied on **one or two** representative forks (not every app), the **same black-box protocol** is retested there, confirmed issues are labelled with OWASP API Top 10 and MITRE ATT&CK, and a hardening checklist for the **class** is written for the whole family.

---

## 2. Problem statement

Security teams and small product companies do not know **which weakness class actually dominates** self-hosted fitness APIs, or **how much an open-source AI testing tool helps** at naming and confirming that class, compared with ordinary black-box scanners, when nobody has source, OpenAPI dumps, or insider maps in the tester’s hands.

Peng et al. already compared 13 AutoPT frameworks on **black-box web CTFs**. They explicitly set **white-box and grey-box out of their empirical scope**. This project **follows that same empirical boundary**. Existing fitness-app papers (e.g. Papageorgiou et al., 2018) study privacy practice, not AI testers. Vendor blogs mix knowledge levels, hide false-success rates, and usually show **one** product.

**Gap this project fills:** a small, reproducible, defensive case study that (a) speaks Peng’s taxonomy, (b) runs a **black-box-only** protocol on **multiple fitness products** rather than one CTF or one app, (c) lets a **new AutoPT agent** **define the main weakness class** before the deep campaign, (d) compares HITL, **swarm**, and **overnight** modes on a laptop with free local models.

---

## 3. Research questions

Keep exactly three questions.

**RQ1.** Under **black-box** conditions, which **main weakness class** does the new AutoPT agent name for this fitness-app family, and which of ZAP, Nuclei, HITL, the **swarm**, and the **overnight loop** **confirm** that class (with HTTP evidence) on how many of the running apps?

**RQ2.** What share of AI output is **confirmed** after human review — both the **family-level main-class claim** and the per-app findings — and how often does the LLM claim success without usable evidence (Peng et al.’s hallucination / false-success problem)?

**RQ3.** After a short hardening pass on **one or two** representative forks aimed at that **AI-defined main class**, which confirmed findings disappear on a **black-box retest**, and does the resulting checklist still make sense for the other apps that showed the same class?

No question requires writing exploits, a full kill-chain, grey-box or white-box campaigns, or testing third-party production apps (not Workout.cool production, not any public fitness SaaS).

---

## 4. Objectives

1. Deploy the **five** self-hosted fitness apps in §5 (target five; **minimum four** for a pass).
2. Bind each to `127.0.0.1` with **two synthetic user accounts** (unique ports; one stack at a time on 8 GB RAM).
3. **Build a new AutoPT agent** (thin orchestrator: facts file, small HTTP tool menu, Ollama) and classify it with Peng’s **six dimensions** (section 6.2).
4. Run the **black-box screen** on every running app (ZAP + Nuclei; no source, no OpenAPI in the prompt).
5. **AI-define the main weakness:** one HITL session of the new agent that may see only (i) public README/feature bullets, (ii) truncated ZAP/Nuclei *class* names, (iii) observed HTTP routes from normal registration. Output: **exactly one** OWASP API Top 10 class + a one-sentence defender meaning. Human locks that class for the rest of the semester (or records a later contradiction).
6. Run a **focused black-box campaign** of that class with the agent in **HITL** on every running app; run a **multi-agent swarm** and one **overnight loop** on **one** representative app.
7. Classify every finding: true positive / false positive / unverified claim.
8. Implement **5–8 concrete fixes** for the main class on **one or two** forks (defender work after scoring; not a grey-box test).
9. **Retest black-box** on those forks with ZAP, Nuclei, and HITL (swarm/overnight not required on retest).
10. Map confirmed findings to **OWASP API Security Top 10** and one **MITRE ATT&CK** technique.
11. Deliver a 20–30 page report and a **family** hardening checklist for the AI-defined class.

---

## 5. Targets: multiple open-source fitness apps

Each app is a **lab instrument**, not a product the student is shipping. All tests are on **the student’s Docker instances**. Public production sites are out of scope.

### 5.1 Corpus (the five main experiment apps)

The corpus is **these five**. They are the experiment, not a shortlist around some other product. A row is dropped only if it **fails to start** in weeks 2–4; the reason is recorded. A pass requires **≥ 4** running apps.

| # | Project | Repo (indicative) | What it is | Why it belongs in the main experiment |
| --- | --- | --- | --- | --- |
| 1 | **Workout.cool** | [Snouzy/workout-cool](https://github.com/Snouzy/workout-cool) | Modern MIT coaching platform (plans, exercise DB, progress). Docker / Compose. | First stack to bring up; TypeScript/Next; plans and history IDs. |
| 2 | **FitTrackee** | [SamR1/FitTrackee](https://github.com/SamR1/FitTrackee) | Self-hosted outdoor tracker (GPX, maps, workouts). Flask + Vue; Docker. | GPS/health-adjacent files and per-user activities. |
| 3 | **openGym** | [DuarteSantos8/openGym](https://github.com/DuarteSantos8/openGym) | Gym & body-weight tracker; passkeys; `docker compose up`. | Smaller surface; passkeys visible from the outside. |
| 4 | **FitnessTrack** | [Gman0909/FitnessTrack](https://github.com/Gman0909/FitnessTrack) | Progressive-overload strength logger; Docker + SQLite. | Light laptop target; easy two-account set logs. |
| 5 | **Endurain** | [endurain-project/endurain](https://github.com/endurain-project/endurain) (Codeberg is canonical) | Strava-class tracker (GPX/TCX/FIT, activity privacy, followers). Compose + PostgreSQL + Redis. | Heaviest stack — confirm RAM; skip with a written reason if it will not start. |

If an app does not start cleanly, substitute **one** extra self-hosted multi-user Docker fitness app (e.g. LibreFit) so the corpus still has at least four running instances. Never use closed commercial apps (Hevy, Strong, MyFitnessPal) or university gym production systems.

Optional version pair on **one** app only (if the supervisor wants a “known CVE class” story in the Peng 5.6.2 sense): pin one old lab image and one newer image that the maintainers mark as fixed, **one stack at a time**, still localhost. Not required for a pass.

### 5.2 Minimum features (every app that stays in the corpus)

- Login and at least two user accounts  
- Per-user objects (workouts, metrics, GPX, or plans) addressed by ID  
- At least one export, upload, or share path  
- HTTP interface on localhost (black-box testers need no source)

Source of a fork is used later to **apply fixes** on the representative app(s), not to feed the scanners.

### 5.3 How “multiple” stays inside a semester

| Layer | What runs | On how many apps |
| --- | --- | --- |
| Screen | ZAP + Nuclei | **Every** running app |
| AI main-class definition | New AutoPT agent, HITL, family-level | **Once** (uses truncated evidence from all screens) |
| Focused HITL test | New agent, single-agent HITL, locked class | **Every** running app, small call budget each |
| Swarm | New agent, 2–3 prompt-defined roles, shared facts file | **One** representative app |
| Overnight loop | Unattended run, localhost kill switch | **One** representative app, one night |
| Fix + retest | 5–8 fixes, then ZAP + Nuclei + HITL | **One or two** representative forks that showed the class |

Do **not** deep-fix five codebases. Breadth is the corpus; depth is the **class**.

---

## 6. Taxonomy from Peng et al. (the language of this project)

This project does **not** rerun their 13-framework XBOW experiment. It **reuses their definitions** so the report is comparable to the SoK.

### 6.1 Knowledge levels (Peng §2.1)

| Level | Peng’s definition | This project |
| --- | --- | --- |
| **White-box** | Source and architecture fully known (code audit / SAST as the *main* paradigm) | **Out of the empirical scope.** Named in the report so the boundary is explicit. No SAST campaign, no full code audit. |
| **Grey-box** | Partial prior knowledge (insider-like access: maps, source hints, planted credentials beyond normal registration) | **Out of the empirical scope.** Same cut as Peng’s bake-off. No Semgrep campaign, no source in prompts, no OpenAPI dump as tester input. |
| **Black-box** | Zero internals; only external interfaces | **The only empirical protocol.** ZAP, Nuclei, and the new AutoPT agent (HITL, swarm, overnight) see only localhost HTTP. No source, no architecture notes in the prompt. Public README bullets are allowed (anyone can read them). |

Peng’s AutoPT bake-off was **black-box only**. This project **keeps that empirical cut** and moves the target from CTF/XBOW to a **multi-app fitness corpus**, with ZAP, Nuclei, and a **new laptop AutoPT agent** (HITL + swarm + overnight) instead of 13 frameworks.

Classic human models they list (Kill Chain, PTES, NIST SP 800-115, ATT&CK) stay what they are in the SoK: **labels and background**, not a Caldera lab.

### 6.2 Six design dimensions (Peng §3) — how we classify *our* AI tool

| Dimension | What Peng asks | How the **new AutoPT agent** is classified **in this lab** |
| --- | --- | --- |
| **3.1 Architecture** | Who decides? One agent vs many; role = own window + authority | **Three scored modes of the same codebase:** (A) **HITL single-agent**; (B) **swarm** of 2–3 prompt-defined roles (planner / executor / reviewer) sharing one facts file; (C) **overnight** unattended loop. Peng §5.1 is now something we *measure*, not a reason to skip swarms. |
| **3.2 Plan** | Linear / tree / graph + feedback | HITL: linear ReAct or a small PTT (Deng). Swarm: roles hand off through the facts file. Overnight: same planner with a wall-clock stop. No graph rewrite engine. |
| **3.3 Memory** | Experience vs knowledge; compress; organize | **Experiential only:** a student-maintained **facts file** (structure-bound lite) + truncated tool output. Same file for HITL, swarm, and overnight. No HackTricks RAG (their §5.2: mismatched KB often hurts). |
| **3.4 Execution** | Whether / which / how; tool layers | **Small menu:** browser + `curl` + ZAP/Nuclei history. Overnight may call the same menu only. Paper §5.4: successful traces are atomic HTTP/Python, not 115 Kali tools. |
| **3.5 External knowledge** | Construct → retrieve → generate | **Two AI jobs, both lab-only:** (1) **define the main weakness class** from truncated black-box evidence; (2) test that class per app / mode. No Top-100 RAG dump. |
| **3.6 Benchmarks** | Testbed + metrics; contamination | **Testbed type:** *several* single-host product APIs, not XBOW CTF. **Success** = confirmed HTTP evidence, not “the swarm said this is the main bug.” Overnight success uses the same evidence rule. |

### 6.3 Findings we take as design rules (Peng §5–6)

1. **Memory first** — keep a facts file; do not rely on a long chat.  
2. **HITL vs swarm vs overnight is an empirical question** on this corpus — Peng §5.1 said extra roles often fail; we check whether that holds here.  
3. **More tools ≠ better** — small HTTP set; ZAP, Nuclei, one new agent (three modes, not three extra products).  
4. **KB only if it matches this app** — no generic payload wiki.  
5. **Hallucinations are structural** — never regex the model’s prose for “success” or “main weakness”; require a saved request/response (overnight included).  
6. **Do not treat SWE-bench fame as AutoPT skill** — local 3B/7B is the scientific object, not Opus.

---

## 7. Tools (required)

**T1** and **T2** are off-the-shelf scanners. **T3** is a **new AutoPT agent** the student writes. Swarm and overnight are **modes of T3**, not extra products.

| # | Tool / mode | Peng-aligned role | Knowledge level | Tokens |
| --- | --- | --- | --- | --- |
| **T1** | **OWASP ZAP** (automated / “quick” scan, localhost only) | Traditional **security-tool** DAST; no LLM. Baseline for “old tech.” | **Black-box** | None |
| **T2** | **Nuclei** (ProjectDiscovery; HTTP templates against the lab URL only) | Template-based black-box scanner; still no source. | **Black-box** | None |
| **T3-HITL** | **New AutoPT agent**, single-agent human-in-the-loop + **Ollama** (`llama3.2:3b` or `qwen2.5:7b`) | Student-built assistant: facts file + small HTTP menu; (A) define main weakness; (B) test that class per app. Fallback if the build slips: a 15-prompt notebook with the same RQs. | **Black-box** | Capped (section 9.0) |
| **T3-swarm** | Same agent, **2–3 roles** (planner / executor / reviewer) | Multi-agent swarm; roles share the facts file; no extra Kali zoo. **One** representative app. | **Black-box** | Capped |
| **T3-night** | Same agent, **overnight unattended loop** | Wall-clock bounded run with a localhost kill switch. **One** representative app, one night. | **Black-box** | Overnight budget (section 9.0) |

**What “new AutoPT agent” means (keep it small)**

- Python (or similar) orchestrator the student owns: prompt templates, facts-file I/O, a tiny tool wrapper (`curl` / saved HTTP), Ollama calls.  
- Deng et al. (PentestGPT PTT) is the **design reference**, not a fourth scored tool.  
- No new model training. No 115-tool router. No payloads in the public repo.

**Why ZAP + Nuclei + this agent, not Strix/CAI/Semgrep as extra products**

- Peng §5.4: atomic HTTP, not a Kali zoo.  
- Peng §2.1 / empirical cut: Semgrep is grey/white-box SAST — **named in §8.1, not executed**.  
- Swarm and overnight are in scope **as T3 modes** so Peng §5.1 can be checked on this corpus.

Do **not** add a fourth *product* (Strix, CAI, …) as a main condition. Mention others only in section 8.1.

---

## 8. Scope

### In scope

- **Multiple** Dockerized fitness apps on the laptop (corpus in §5)  
- Synthetic accounts only  
- **Black-box campaign only**  
- ZAP, Nuclei, and a **new AutoPT agent**  
- **Multi-agent swarm** (T3 mode, one app)  
- **Overnight loops** (T3 mode, one app, localhost kill switch)  
- **AI definition of the main weakness class** (one locked OWASP API ID)  
- Authn/authz, secrets, session, export/upload **as seen from HTTP**  
- Human confirmation (read responses; no exploit development)  
- Fix-and-retest of the **same black-box protocol** on 1–2 forks  
- OWASP API + ATT&CK **label table**  
- Peng taxonomy section in the report (2–3 pages), including why grey/white are not run  
- 20–30 page report  

### Out of scope

- **White-box** empirical work (full audit, SAST-as-main-paradigm, formal verification)  
- **Grey-box** empirical work (source in prompts, OpenAPI as tester input, Semgrep campaign, insider API map as a scored condition)  
- Testing only one app (unless four cannot be started — then document the failure; do not silently shrink the design)  
- Paid APIs as default; cloud GPUs; commercial AutoPT SaaS  
- Testing Workout.cool production, Endurain production, or any third-party live system  
- Full mobile RE, Frida, jailbreak, AD/Caldera  
- Real wearables or real health records  
- Exploit PoCs in the report  
- Garak full suites  

### 8.1 Tools considered, not executed

Half a page: **Semgrep** (grey-box SAST — excluded by the empirical cut), Aikido Android, Thorfinn, iosHunt, TrashiOS, Caldera AI, Strix/CAI unattended — named and excluded (knowledge level, licence, hardware, or Peng-style token cost). Optional stretch only if weeks 1–10 are done: 10 local promptfoo cases if an app has a chat feature (≤ 10 extra calls).

---

## 9. Method

### 9.0 Laptop and token rules (hard)

| Resource | Minimum | Comfortable |
| --- | --- | --- |
| RAM | 8 GB (3B model; **one** Docker stack at a time; ZAP *or* Ollama, not both) | 16 GB |
| Disk | 30 GB free (several images) | 50 GB |
| GPU | Not required | Optional |

| Rule | Limit |
| --- | --- |
| Default LLM | Ollama localhost, €0 |
| Call cap | **≤ 80 LLM calls** semester-wide |
| Split | ≤ **8** define-main-weakness + ≤ **8 per running app** focused PentestGPT + ≤ **20** retest on the 1–2 fixed forks + remainder buffer |
| Prompt size | ≤ 2 000 tokens; never paste a full ZAP or Nuclei dump |
| Free-tier cloud fallback | ≤ 30 calls then stop |
| Autonomous loops | Off |

Worked example: 5 running apps → 8 + 40 + 20 = 68, buffer for swarm / overnight / retest. If the cap would break, **cut HITL depth**, not the number of screened apps.

**Token log (required appendix):** date, tool, app ID, job (define-class / test / retest), model, call #, approx. tokens.

### 9.1 Black-box protocol (Peng §2.1)

**Screen (every running app)**

- Inputs: that app’s base URL, “authorized lab,” no source, no OpenAPI, no architecture notes.  
- Accounts: create users **as a normal registration flow** (still black-box). Do **not** paste source snippets.  
- Tools: ZAP automated pass; Nuclei HTTP templates.  
- Output: truncated finding-*class* list with HTTP evidence pointers (not full dumps).

**Define the main weakness (AI, once, family-level)**

- Inputs allowed: public README/feature bullets; truncated class names from all screens; observed route *patterns* from registration (e.g. “workouts/{id}”).  
- Inputs forbidden: source, OpenAPI files, exploit recipes, the student’s preferred class.  
- Output required: **exactly one** OWASP API Top 10 identifier, a one-sentence defender meaning, and which apps the model *claims* show it.  
- Human action: lock that class **or** write why the session is discarded (empty/garbage output) and rerun **once** inside the 8-call budget. Do not shop for a nicer class.

**Focused test (every running app)**

- PentestGPT may know the **locked class name** (that is the hypothesis under test). It still must not receive source or payloads.  
- Student executes only hypothesized *classes* of check; save HTTP traces.  
- Stop at the per-app call budget. Record “budget exhausted.”

**Fairness:** same two-user story, same junior day-one tool setup, sequential stacks on a small laptop.

### 9.2 Ground truth (not a pre-written 12-bug list)

The scientific object is the **AI-defined main class**, not a secret seed list written by the student in week 3.

| Item | Role |
| --- | --- |
| Locked OWASP API class | Family-level hypothesis (RQ1) |
| Per-app confirmed HTTP rows in that class | Support or reject the hypothesis |
| Other confirmed classes | Report as secondary; they do not rewrite the locked class mid-semester |
| Contradiction | If scanners later show a *different* class more often, that is a **result** (AI main-class claim failed), not a protocol rewrite |

Do not add new “main” classes after the definition session. Secondary findings stay in the table.

### 9.3 Metrics

| Metric | Definition |
| --- | --- |
| Main-class hit rate | Apps with ≥ 1 **confirmed** HTTP finding in the locked class / running apps |
| Tool agreement | Which of T1/T2/T3 contributed those confirmations |
| Precision | Confirmed / reported, per tool, pooled and per app |
| Evidence rate | Findings with a saved request/response |
| False-success count | LLM claims “done / critical / this is the main bug” with no evidence (Peng §5.6.3) |
| Definition quality | Locked class matches the most frequent **confirmed** class (yes/no) |
| Time | Hours per tool × app (screen vs focused) |
| LLM calls | Must stay inside 9.0 |
| Retest delta | Locked-class findings still open on the 1–2 fixed forks |
| Coverage by class | Locked class vs others (OWASP API) |

No significance tests. Transparent tables are the scientific level.

### 9.4 Labels (desk work)

One row per **confirmed** finding: app ID + OWASP API ID + closest ATT&CK technique (T1190, T1078, T1530, T1552, T1213 or “no close match”). No Caldera.

### 9.5 Fix and retest

Pick **one or two** forks that showed the locked class (prefer **Workout.cool** plus the lightest other hit). Smallest high-value changes for **that class** (e.g. ownership checks, auth on export, secrets out of the client, role changes locked, login throttle, debug off — whichever the locked class actually is). Then rerun **ZAP + Nuclei + HITL** on those forks only. Reading a fork to implement a fix is defender work; it does **not** open a grey-box scoring condition.

The checklist is written for **every** app in the corpus that shares the class, even if only 1–2 were patched.

---

## 10. Full strategy (phases, steps, and the goal of each)

This is the operational spine. Each step has a **goal** (why it exists) and a **done-when** test. Skip a stretch; do not skip a phase.

### Phase 0 — Frame the science (week 1)

| Step | What | Goal of this step |
| --- | --- | --- |
| 0.1 | Read Peng et al. (taxonomy + §5 findings) plus the other four papers in section 21 | Share vocabulary with the SoK; do not invent a private theory of agents |
| 0.2 | Write a 2-page protocol: three tools, **black-box only**, multi-app corpus, AI main-class rule, token cap, ethics | Get supervisor sign-off before any scan |
| 0.3 | Confirm Ollama replies on the laptop | Prove the free-token path works |

**Phase goal:** the project is a **Peng-taxonomy multi-app case study**, not a casual one-target demo.  
**Done when:** signed ethics page + protocol + `ollama run` screenshot.

### Phase 1 — Bring up the corpus (weeks 2–4)

| Step | What | Goal of this step |
| --- | --- | --- |
| 1.1 | `docker compose up` each §5 app in turn; two synthetic accounts on each | Prove the instruments run |
| 1.2 | Record image tag / commit hash per app | Reproducibility (Peng §4 hygiene) |
| 1.3 | Drop stacks that will not start; keep a dropout log | Honest corpus, still ≥ 4 |
| 1.4 | Create the empty **facts file** and token-log sheet | Memory-first (Peng §6) from day one |

**Phase goal:** a **set** of authorized, pinned, multi-user fitness systems.  
**Done when:** ≥ 4 apps accept two synthetic users on `127.0.0.1`.

### Phase 2 — Black-box screen, all apps (weeks 5–6)

| Step | What | Goal of this step |
| --- | --- | --- |
| 2.1 | Bind ports to `127.0.0.1`; synthetic data only | Containment and privacy |
| 2.2 | ZAP automated scan per app; keep evidenced rows | Traditional baseline **across** the family |
| 2.3 | Nuclei HTTP templates per app; same confirmation rule | Second non-LLM signal |
| 2.4 | One comparison sheet: app × tool × OWASP class | Input to the AI definition session |

**Phase goal:** what two ordinary black-box scanners see **without** internals, on every running app.  
**Done when:** ZAP and Nuclei tables exist for each app in the corpus.

### Phase 3 — AI defines the main weakness (week 7, first half)

| Step | What | Goal of this step |
| --- | --- | --- |
| 3.1 | One HITL session (≤ 8 calls): truncated screen classes + README bullets + observed routes | Let T3 **name** the family-level main class |
| 3.2 | Require output = one OWASP API ID + one sentence + claimed apps | Stop the model from listing everything |
| 3.3 | Lock the class (or one discard-and-rerun) | RQ1 hypothesis frozen |

**Phase goal:** the main weakness is **defined by the AI**, not by the student’s prior favourite.  
**Done when:** locked class is written in the facts file.

### Phase 4 — Focused AI test of that class (week 7, second half, into week 8)

| Step | What | Goal of this step |
| --- | --- | --- |
| 4.1 | PentestGPT per app (≤ 8 calls), class name allowed, no source | Test the locked hypothesis on each product |
| 4.2 | Student executes only hypothesized *classes* of check; save HTTP traces | Separate model speech from evidence (anti-hallucination) |
| 4.3 | Update facts file from confirmed HTTP only | Bind feedback to memory (Peng §3.2.4 / §6) |

**Phase goal:** measure whether the AI-named class is **real** on the corpus.  
**Done when:** per-app T3 table complete; call log inside 9.0.

### Phase 5 — Human review and labels (week 8)

| Step | What | Goal of this step |
| --- | --- | --- |
| 5.1 | TP / FP / unverified for every row | RQ2 |
| 5.2 | Count false-success (model stopped as if done, or named a class with no HTTP) | Operationalize Peng §5.6.3 |
| 5.3 | Score definition quality (locked class = most frequent confirmed class?) | RQ1 close |
| 5.4 | OWASP API + ATT&CK labels for confirmed rows only | Standard language, no extra lab |

**Phase goal:** a defensible family picture, not a tool export.  
**Done when:** label table has one row per confirmed issue; main-class hit rate is computed.

### Phase 6 — Harden the class on 1–2 forks (weeks 9–10)

| Step | What | Goal of this step |
| --- | --- | --- |
| 6.1 | Choose 1–2 apps that showed the locked class (Workout.cool preferred if it hit) | Depth without five parallel patches |
| 6.2 | Implement 5–8 small fixes for **that class** | Defender outcome for the family pattern |
| 6.3 | Commit fixes with messages that name the finding ID | Traceability |

**Phase goal:** close the find → fix loop on the **main** weakness, not on every secondary noise row.  
**Done when:** 5–8 fixes merged on the chosen lab branch(es).

### Phase 7 — Black-box retest (weeks 10–11)

| Step | What | Goal of this step |
| --- | --- | --- |
| 7.1 | ZAP again on the patched fork(s) | RQ3 traditional |
| 7.2 | Nuclei again | RQ3 template scanner |
| 7.3 | PentestGPT retest ≤ 20 calls total | RQ3 AI, same blindness as Phase 4 |
| 7.4 | Retest-delta table + checklist for the other apps | Show what disappeared vs what the family still needs |

**Phase goal:** prove upgrades of the **main class**, not only list bugs.  
**Done when:** before/after exists for the patched app(s); checklist covers the corpus.

### Phase 8 — Write and demo (weeks 12–14)

| Step | What | Goal of this step |
| --- | --- | --- |
| 8.1 | Report chapters (section 13) | 20–30 pages, taxonomy used correctly |
| 8.2 | Hardening checklist for the locked class on fitness APIs | Transferable defender output |
| 8.3 | 10–15 min demo: two accounts on two apps, before/after on one | Examiner-visible multi-app result |
| 8.4 | Buffer | Slips without dropping RQ3 |

**Phase goal:** a graded, citable semester report.  
**Done when:** PDF + tables + token log + demo.

### Strategy diagram (read top to bottom)

```
Frame (Peng taxonomy, ethics, Ollama)
        ↓
Stand up the five fitness apps (pass ≥ 4)
        ↓
BLACK-BOX SCREEN  —  ZAP + Nuclei  ×  every app
        ↓
AI DEFINES MAIN WEAKNESS  —  one locked OWASP API class
        ↓
FOCUSED BLACK-BOX TEST of that class  —  PentestGPT × every app
        ↓
Review, labels, hallucination count, hit rate
        ↓
Fix 5–8 issues of that class on 1–2 forks
        ↓
Retest BLACK-BOX on those forks
        ↓
Report + family checklist + demo
```

---

## 11. Expected results

The project succeeds if the student can say, with tables:

- The LLM locked **API:____** as the main weakness of this fitness-app family.  
- That class was confirmed on **k / n** running apps (or was not — still a result).  
- ZAP and Nuclei did / did not surface the same class; PentestGPT did / did not add authorization-style rows.  
- X findings confirmed, Y hallucinated / evidence-free (Peng RQ2), including whether the **definition session** itself was evidence-free.  
- After fixes on 1–2 forks, locked-class recall moved from A% to B% there.  
- Token total stayed under the cap.

A mixed result is acceptable: “the AI named broken object-level authorization as the main class; scanners mostly reported config noise; HTTP confirmed the class on 3 of 5 apps; half the AI claims lacked evidence.”

---

## 12. Deliverables

| Deliverable | Form |
| --- | --- |
| Lab corpus | Dockerized instances (pinned tags) for every running app + dropout log |
| Main-weakness card | Locked OWASP API class, prompt, model reply, lock date |
| Evaluation pack | Tables by **app × tool**, raw reports, **LLM call log** |
| Report | 20–30 pages |
| Taxonomy note | How T3 maps to Peng’s six dimensions (1–2 pages); grey/white named as excluded |
| Label table | OWASP API + ATT&CK |
| Hardening checklist | 2–4 pages for the **locked class** across the family |
| Demo | 10–15 min, at least two apps shown |

The catalog `AI-Pentesting-Tools-Research-Catalog.md` is background. This project **uses three tools**, it does not rescan the market.

---

## 13. Report outline

1. Introduction and RQs  
2. Background: fitness-app threats + **Peng taxonomy** (knowledge levels, six dimensions, findings we adopt; **why empirical work is black-box only**)  
3. Related work (five papers + tools not run)  
4. Targets: the five-app corpus, what started, what dropped  
5. Method: three tools, black-box protocol, **AI main-class definition**, metrics, ethics, token cap  
6. Strategy recap (Phase 0–8, one page)  
7. Results: RQ1–RQ3 tables (class lock, hit rate, hallucinations, retest)  
8. Discussion: what to upgrade first on this product family; what Peng predicted that we saw  
9. Limitations (laptop, weak local LLM, no grey-box, no white-box, fixes on 1–2 apps only)  
10. Conclusion  

Appendices: versions, prompts, finding IDs, token log, Nuclei template IDs used, main-weakness card.

---

## 14. Semester plan (14 weeks) and hours

| Weeks | Phase | Hours |
| --- | --- | --- |
| 1 | 0 Frame | 15 |
| 2–4 | 1 Corpus (5 stacks, sequential) | 50 |
| 5–6 | 2 Screen all apps (ZAP + Nuclei) | 40 |
| 7 | 3–4 AI main class + focused HITL | 25 |
| 8 | 5 Review + labels | 20 |
| 9–10 | 6 Fixes on 1–2 forks | 25 |
| 10–11 | 7 Black-box retest | 20 |
| 12–13 | 8 Report | 40 |
| 14 | Buffer, demo | 20 |
| **Total** | | **~255 hours** |

**Valves:** token cap, **screen-all / fix-few**, one locked class. Do not add a sixth app or a fourth product.

---

## 15. Scope of this semester project

| Out of this project | In this project |
| --- | --- |
| 13 frameworks × XBOW (Peng) | ZAP + Nuclei + new agent × **five fitness apps** × black-box |
| White-box and grey-box empirical work | Black-box only (Peng’s empirical cut) |
| Student-chosen “main bug” a priori | **AI-defined** main weakness class |
| Cloud GPUs / paid tokens | Laptop + Ollama ≤ 80 calls |
| New agent | Off-the-shelf HITL |
| Patch every app | Fix 1–2 forks; checklist for the family |
| 50–80 pages | 20–30 page report |

The **new** part is: Peng’s taxonomy + **several real fitness products** + an **AI-named main weakness** tested under black-box rules. The **simple** part is: evaluator and defender, not tool author.

---

## 16. Required skills

HTTP APIs, Docker, reading OWASP API Top 10, honest writing. No OSCP, no RE, no ML research. Supervisor in software security or SE is enough. 16 GB laptop preferred; 8 GB works sequentially (one stack at a time).

---

## 17. Ethics, privacy, legal

- Only self-hosted instances; **never** production fitness SaaS.  
- Synthetic names and health values only.  
- Prefer local Ollama so data never leaves the laptop.  
- No exploit recipes or payloads in the public report — **classes** and **fixes** only.  
- The AI main-class prompt asks for an OWASP identifier, not a working attack.  
- Private logs; public aggregated tables.  
- One-page ethics appendix signed in week 2.  
- Dual-use named as in Peng §8: we study testers to **harden** apps.

---

## 18. Risks and fallbacks

| Risk | Fallback |
| --- | --- |
| An app will not start | Dropout log; keep ≥ 4; optional LibreFit substitute |
| Endurain too heavy | Skip with RAM note; still a valid corpus |
| PentestGPT install fails | 15-prompt notebook; still T3 (define + test) |
| 8 GB RAM | 3B model; never two stacks + ZAP + Ollama together |
| Nuclei template noise | Restrict to HTTP/exposed-panels classes; state the filter |
| AI names an empty or garbage class | One rerun inside the 8-call budget; then lock or report “definition failed” (valid RQ2) |
| Almost no findings | Valid result; checklist still from claimed class + literature |
| Many hallucinations | Answers RQ2; count them |
| Temptation to pick BOLA by hand | Refuse: the locked class must come from the definition session |
| Temptation to add Semgrep or source-in-prompt | Refuse: grey-box is out of the empirical scope |
| Temptation to add a fourth agent | Refuse: breaks Peng’s “more tools ≠ better” rule and the token cap |

RQs stay the same.

---

## 19. Suggested titles (pick one)

1. *What Is the Main Weakness of Self-Hosted Fitness APIs? A Black-Box Multi-App Study with ZAP, Nuclei, and PentestGPT*  
2. *Applying the Peng et al. AutoPT Taxonomy Across Open-Source Fitness Apps: AI-Defined Weakness, Three Tools*  
3. *An LLM Names the Dominant Fitness-API Failure Class — Then Three Black-Box Tools Try to Confirm It*

Variant 1 is the clearest for a supervisor.

---

## 20. Supervision ask

Approve:

- the out-of-scope list,  
- laptop + free-token rules,  
- **three tools** and **black-box only** (white-box and grey-box out of the empirical scope),  
- **the five apps in §5** as the corpus (pass ≥ 4 running),  
- **AI-defined main weakness** (one locked OWASP API class),  
- fixes on 1–2 forks only,  
- ATT&CK/OWASP as labels only,  
- ethics (synthetic data, no production, no exploit publication),  
- Peng et al. as the **taxonomy source**, not as an experiment to replicate at scale.

**Week-2 kick-off:** first two apps up + image pins, Ollama proof, 2-page protocol.

---

## 21. One-paragraph abstract (official form)

This semester project applies the **architectural taxonomy** of Peng et al. (2026) to a **corpus of five self-hosted open-source fitness applications** (Workout.cool, FitTrackee, openGym, FitnessTrack, Endurain; pass if at least four run). Following the SoK, **white-box and grey-box are out of the empirical scope**. After a black-box screen with **OWASP ZAP** and **Nuclei**, a **new AutoPT agent** on a **local Ollama** model **defines the main weakness class** of the family (one OWASP API Top 10 identifier). That class is then tested under the same black-box rules on every running app, including a **HITL** pass, a **multi-agent swarm**, and one **overnight loop** on a representative target. Findings are confirmed only with HTTP evidence (to count hallucinations). A short hardening pass and retest run on **one or two** representative forks; the checklist is written for the **class** across the family. Paid APIs and GPUs are out of scope. Confirmed issues are labelled with OWASP API Top 10 and MITRE ATT&CK. The outcome is a measured multi-app case study: five apps, AI-named main weakness, black-box only, ≤ 80 interactive LLM calls plus a bounded overnight budget, 20–30 pages.

---

## 22. Immediate next steps

1. Confirm the one-semester format with the supervisor.  
2. Bring up **Workout.cool first**, then FitTrackee, openGym, FitnessTrack, Endurain; log dropouts; do not stop at one app.  
3. Install Ollama; then ZAP; then Nuclei; then build the new AutoPT agent (HITL first).  
4. Screen all running apps **before** the AI definition session.  
5. Lock **one** main weakness class from the AI; do not override it with a favourite.  
6. Keep the facts file and token log from the first call.  
7. After confirmed findings, fill OWASP/ATT&CK. Do not install Caldera. Do not add a grey-box or white-box campaign.

---

## 23. Supporting literature (five papers)

Same five research papers as before. Peng et al. now also **define the method language** (not only RQ2).

1. **Deng et al. (2024).** PentestGPT, USENIX Security. — T3, HITL/PTT, and the definition-session pattern.  
2. **Happe & Cito (2023).** ESEC/FSE. — LLMs for pentest steps.  
3. **Peng et al. (2026).** arXiv:2604.05719. — **Taxonomy (six dimensions; white/grey/black definitions; black-box empirical cut), findings (memory, tools, hallucination), ethics.**  
4. **Sun et al. (2011).** USENIX Security. — Access-control / two-account checks when the locked class is authorization.  
5. **Papageorgiou et al. (2018).** IEEE Access. — Why a fitness/health **family** is the target.

**Where they go**

| Paper | Use in the report |
| --- | --- |
| Deng et al. | Method: T3 |
| Happe & Cito | Background |
| Peng et al. | §2 of the report (taxonomy), RQ2, tool-count, no-RAG rule, success=evidence, empirical knowledge-level cut |
| Sun et al. | Authorization checks if that is the locked class |
| Papageorgiou et al. | Introduction and family checklist |

Labels only (not among the five papers): OWASP API Security Top 10 (2023); MITRE ATT&CK.

Do not expand the report into a second SoK of Aikido, Thorfinn, or Caldera.
