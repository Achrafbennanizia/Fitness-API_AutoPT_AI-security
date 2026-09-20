# Master’s Semester Project Proposal

| | |
| --- | --- |
| **Programme** | Master’s degree — semester project |
| **Document type** | Project proposal (for supervisory approval) |
| **Academic year** | 2026–2027 |
| **Student** | Achraf |
| **Date** | 20 September 2026 |
| **Version** | 1.0 |
| **Status** | Submitted for approval |
| **Indicative load** | 15 ECTS · 240–280 hours · 12–14 working weeks |

---

**Title**

Black-Box Evaluation of Three Security Testing Tools Across Open-Source Fitness Applications: An AI-Defined Main Weakness, Using the Peng et al. AutoPT Taxonomy

**Field.** Application security; AI-assisted security testing; privacy of health-adjacent data.

**Empirical knowledge level.** Black-box only. White-box and grey-box methods are defined in the background chapter and are **not** executed.

**Test corpus.** Five self-hosted open-source fitness and health applications (Section 5). A pass requires at least four instances running on authorised localhost.

**Instruments.** OWASP ZAP; ProjectDiscovery Nuclei; a student-built AutoPT agent, evaluated in three modes: human-in-the-loop (HITL), multi-agent swarm, and one overnight loop.

**Taxonomy.** Peng, Li, You, et al. (2026), *Hackers or Hallucinators?*, arXiv:2604.05719.

**LLM backbones.** Local models and cloud LLMs are both allowed. They are backbones of the same agent (T3), not extra scored products. The report names the model and whether each call was local or cloud.

**Nature of work.** Applied research and a small, defensive laboratory study on authorised localhost instances. No production systems, no exploit publication.

---

## Abstract

This semester project applies the architectural taxonomy of Peng et al. (2026) to a corpus of five self-hosted open-source fitness applications (Workout.cool, FitTrackee, openGym, FitnessTrack, Endurain; at least four must run). The product family is motivated by Papageorgiou et al. (2018), who documented an alarming state of practice in freeware mHealth applications. Two-account evidence for access-control failures follows Sun et al. (2011). Human-in-the-loop method and truncated memory follow Deng et al. (2024). Sparring-partner use of language models and caution about unsupervised loops follow Happe and Cito (2023).

In line with Peng et al., white-box and grey-box work are outside the empirical scope. After a black-box screen with OWASP ZAP and Nuclei, a new AutoPT agent — using a **local LLM, a cloud LLM, or both** as backbones — names the main weakness class of the family as a single OWASP API Security Top 10 identifier. That class is then tested under the same black-box rules on every running application, including a HITL campaign, a multi-agent swarm, and one overnight loop on a representative target. Findings are accepted only with saved HTTP evidence, so that hallucinations and false-success claims can be counted. A short hardening pass and black-box retest are performed on one or two representative forks; the resulting checklist addresses the class across the family. Commercial AutoPT products are out of scope as scored tools. Confirmed issues are labelled with OWASP API Top 10 and MITRE ATT&CK. The intended outcome is a measured multi-application case study: five applications, an AI-named main weakness, black-box protocol only, and a 20–30 page report.

**Keywords:** black-box testing; API security; automated penetration testing (AutoPT); large language models; OWASP API Top 10; mHealth; human-in-the-loop; OWASP ZAP; Nuclei.

---

## Document control

| Version | Date | Author | Change |
| --- | --- | --- | --- |
| 1.0 | 20 September 2026 | Achraf | Proposal submitted for supervisory approval |

Related laboratory notes (not part of this approval text): Phase 1 corpus outcome, paper reading notes, and tool extract under `docs/`.

---

## Contents

1. [Motivation](#1-motivation)  
2. [Problem statement](#2-problem-statement)  
3. [Research questions](#3-research-questions)  
4. [Objectives](#4-objectives)  
5. [Targets: corpus of open-source fitness applications](#5-targets-corpus-of-open-source-fitness-applications)  
6. [Taxonomy and related findings](#6-taxonomy-and-related-findings)  
7. [Tools](#7-tools)  
8. [Scope](#8-scope)  
9. [Method](#9-method)  
10. [Work plan](#10-work-plan)  
11. [Expected results](#11-expected-results)  
12. [Deliverables](#12-deliverables)  
13. [Report outline](#13-report-outline)  
14. [Semester timetable](#14-semester-timetable)  
15. [Required skills](#15-required-skills)  
16. [Ethics, privacy, and legal constraints](#16-ethics-privacy-and-legal-constraints)  
17. [Risks and mitigations](#17-risks-and-mitigations)  
18. [Request for approval](#18-request-for-approval)  
19. [References](#19-references)  

Appendix A. [Kick-off checklist](#appendix-a-kick-off-checklist)

---

## 1. Motivation

Fitness and health applications store sensitive data: workouts, weight, heart rate, sleep, GPS traces of runs, and sometimes wearable tokens. They are typically a web or mobile client plus a REST API, with several accounts that must not see one another’s records. Papageorgiou et al. [5] measured popular freeware mHealth and wellbeing applications and reported an “alarming state of practice”: weak authentication, mishandling of sensitive data, and policies that did not match observed behaviour. That result motivates (i) a **fitness and health product family**, (ii) a **hardening checklist** as a defender deliverable, and (iii) the exclusion of production SaaS and real health records. A single application is anecdotal. Several self-hosted applications show whether a weakness is a family-level pattern.

The typical family defect is not a capture-the-flag flag. Sun et al. [4] showed that access-control failures are application-specific: hiding a link is not an enforcement check. The appropriate unit of evidence is **two roles (or two users) and an object URL**. Their static PHP analyser is not executed here (white-box and grey-box are out of empirical scope). The finding that is reused is: a confirmed row is a weaker session that still receives another user’s object. That two-account HTTP protocol is specified in Sections 5.2 and 9.1.

Language-model testers are already plausible, but they are not a substitute for evidence. Happe and Cito [2] showed that GPT-class models can act as sparring partners (high-level plans; a low-level command loop on an authorised laboratory virtual machine), while documenting instability, invented commands, and dual-use risk. They refused phishing content and kept a human in the loop. Deng et al. [1] measured that off-the-shelf chat loses global context (context rot, last-turn bias, fabricated tool flags) and that a HITL split—task tree, truncated dumps, human executor—raises sub-task completion relative to naive GPT-3.5. Their live Hack The Box run still cost approximately USD 131 of GPT-4; cost and model identity are therefore reported, but this project does not fix a vendor or a euro ceiling. Peng et al. [3] showed that the subsequent wave of AutoPT papers lacked (1) a shared architectural taxonomy and (2) a fair comparison under one protocol. Their bake-off exceeds a semester. What a master’s student can complete is to take that taxonomy as the **language of the method** and answer a smaller, still original question:

> Across multiple self-hosted fitness applications, which main weakness class does a new AutoPT agent name from black-box HTTP evidence; do ZAP, Nuclei, a HITL campaign, a multi-agent swarm, and an overnight loop confirm that class; and how much of the AI output is evidence rather than hallucination?

Peng et al. found that extra agents, large Kali menus, and mismatched knowledge bases often do not raise scores, while flag-style hallucinations are common. This project tests those claims on a fitness corpus rather than assuming them. It uses:

1. one traditional black-box DAST scanner (OWASP ZAP);
2. one template-based black-box scanner (Nuclei, HTTP templates only);
3. one new AutoPT agent (student-built, classified on Peng’s six dimensions, local and/or cloud LLM) in three modes: HITL single-agent, multi-agent swarm, overnight loop.

The student does not pre-commit to a favourite class such as broken object-level authorisation. The agent proposes one OWASP API class; HTTP evidence across applications accepts or rejects that claim. A short fix list is applied on one or two representative forks (not every application). The same black-box protocol is retested there. Confirmed issues are labelled with OWASP API Top 10 and MITRE ATT&CK. A hardening checklist for the class is written for the whole family.

This proposal is sized so that the work can be finished in one semester without repeating Peng et al.’s multi-billion-token comparison. Local and cloud LLMs are interchangeable backbones of T3 (Section 9.0), not extra scored products.

---

## 2. Problem statement

Security teams and small product organisations lack evidence on **which weakness class actually dominates** self-hosted fitness APIs, and on **how much an open-source AI testing tool helps** at naming and confirming that class, compared with ordinary black-box scanners, when the tester has no source, no OpenAPI specification, and no insider maps.

The five papers already answer pieces of this question, not the joint question:

| Source | Established result | What it does not establish (this project) |
| --- | --- | --- |
| Papageorgiou et al. [5] | Consumer mHealth applications mishandle sensitive data; a family-level state of practice is worth studying | No LLM tester; Play Store APKs rather than self-hosted APIs; static and dynamic APK methods that this laboratory does not score |
| Sun et al. [4] | Missing access checks are a first-class web-application class; two roles plus force-browse is the evidence shape | Static sitemaps / SAST — out of empirical scope; not fitness APIs; no AI |
| Happe and Cito [2] | LLMs can propose pentest steps on an authorised laboratory; overnight autonomy is ethically loaded | Short prototype, one VM, no multi-application family, no ZAP/Nuclei baseline |
| Deng et al. [1] | Naive chat fails on long engagements; HITL plus truncated memory works; score sub-tasks, not model prose | HTB/VulnHub boxes and a GPT-4 budget; not a fitness-API corpus |
| Peng et al. [3] | Black-box AutoPT taxonomy; extra agents, tools, and RAG often fail; flag hallucination is common | Thirteen frameworks × XBOW CTF, more than 10 billion tokens — not a semester, not this product family |

Peng et al. explicitly set white-box and grey-box outside their empirical scope. This project follows that empirical boundary. Vendor material mixes knowledge levels, rarely reports false-success rates, and usually demonstrates a single product.

**Gap.** A small, reproducible, defensive case study that (a) uses Peng’s taxonomy, (b) runs a black-box-only protocol on multiple fitness products rather than one CTF or one application, (c) lets a new AutoPT agent define the main weakness class before the focused campaign, and (d) compares HITL, swarm, and overnight modes (Happe’s plan versus loop; Deng’s HITL versus Peng’s swarm warning), with local and/or cloud LLMs as T3 backbones.

---

## 3. Research questions

Three questions, and only these three, structure the empirical work.

**RQ1.** Under black-box conditions, which main weakness class does the new AutoPT agent name for this fitness-application family, and which of ZAP, Nuclei, HITL, the swarm, and the overnight loop confirm that class (with HTTP evidence) on how many of the running applications?

**RQ2.** What share of AI output is confirmed after human review — both the family-level main-class claim and the per-application findings — and how often does the model claim success without usable evidence (Peng et al.’s hallucination / false-success problem)?

**RQ3.** After a short hardening pass on one or two representative forks aimed at that AI-defined main class, which confirmed findings disappear on a black-box retest, and does the resulting checklist still apply to the other applications that showed the same class?

No research question requires writing exploits, a full kill-chain, grey-box or white-box campaigns, or testing third-party production applications.

---

## 4. Objectives

1. Deploy the five self-hosted fitness applications in Section 5 (target five; minimum four for a pass).
2. Bind each instance to `127.0.0.1` with two synthetic user accounts (unique ports; one stack at a time if memory requires it).
3. Build a new AutoPT agent (thin orchestrator: facts file, small HTTP tool menu, local and/or cloud LLM) and classify it with Peng’s six dimensions (Section 6.2).
4. Run the black-box screen on every running application (ZAP and Nuclei; no source and no OpenAPI in the prompt).
5. Define the main weakness with the agent: one HITL session that may see only (i) public README or feature bullets, (ii) truncated ZAP/Nuclei class names, (iii) observed HTTP routes from normal registration. Required output: exactly one OWASP API Top 10 class and a one-sentence defender meaning. The human locks that class for the remainder of the semester, or records a later contradiction.
6. Run a focused black-box campaign of that class with the agent in HITL on every running application; run a multi-agent swarm and one overnight loop on one representative application.
7. Classify every finding as true positive, false positive, or unverified claim.
8. Implement five to eight concrete fixes for the main class on one or two forks (defender work after scoring; not a grey-box test condition).
9. Retest black-box on those forks with ZAP, Nuclei, and HITL (swarm and overnight are not required on retest).
10. Map confirmed findings to OWASP API Security Top 10 and one MITRE ATT&CK technique.
11. Deliver a 20–30 page report and a family hardening checklist for the AI-defined class.

---

## 5. Targets: corpus of open-source fitness applications

Each application is a laboratory instrument, not a product the student is shipping. All tests run on the student’s Docker instances. Public production sites are out of scope.

### 5.1 Corpus

These five applications constitute the experiment. A row is dropped only if it fails to start in weeks 2–4; the reason is recorded. A pass requires at least four running applications.

| # | Project | Repository (indicative) | Description | Role in the experiment |
| --- | --- | --- | --- | --- |
| 1 | Workout.cool | [Snouzy/workout-cool](https://github.com/Snouzy/workout-cool) | MIT coaching platform (plans, exercise database, progress). Docker Compose. | First stack; TypeScript/Next; plan and history identifiers. |
| 2 | FitTrackee | [SamR1/FitTrackee](https://github.com/SamR1/FitTrackee) | Self-hosted outdoor tracker (GPX, maps, workouts). Flask and Vue; Docker. | GPS- and health-adjacent files; per-user activities. |
| 3 | openGym | [DuarteSantos8/openGym](https://github.com/DuarteSantos8/openGym) | Gym and body-weight tracker; passkeys; Compose. | Smaller surface; passkeys visible from the outside. |
| 4 | FitnessTrack | [Gman0909/FitnessTrack](https://github.com/Gman0909/FitnessTrack) | Progressive-overload strength logger; Docker and SQLite. | Light stack; two-account set logs. |
| 5 | Endurain | [endurain-project/endurain](https://github.com/endurain-project/endurain) (Codeberg is canonical) | Strava-class tracker (GPX/TCX/FIT, activity privacy, followers). Compose, PostgreSQL, Redis. | Heaviest stack; skip with a written reason if it will not start. |

If an application does not start cleanly, one extra self-hosted multi-user Docker fitness application (for example LibreFit) may be substituted so that the corpus still has at least four running instances. Closed commercial applications (Hevy, Strong, MyFitnessPal) and university gym production systems are excluded.

Optional version pair on one application only (if the supervisor requires a “known CVE class” story in the sense of Peng §5.6.2): pin one older laboratory image and one newer image that the maintainers mark as fixed, one stack at a time, still on localhost. Not required for a pass.

Bring-up outcome (19 September 2026): [`Phase-1-Lab-Log.md`](Phase-1-Lab-Log.md). That log is an operational annex, not a change of scientific scope.

### 5.2 Minimum features (every application that remains in the corpus)

- Login and at least two user accounts (Sun: two sessions are the instrument).
- Per-user objects (workouts, metrics, GPX, or plans) addressed by identifier.
- At least one export, upload, or share path (Papageorgiou: export and share are where health-adjacent data leave the account boundary).
- HTTP interface on localhost (black-box testers need no source).

Source of a fork is used later to apply fixes on the representative application(s), not to feed the scanners. Sun’s analyser remains in the background chapter.

### 5.3 Allocation of effort across applications

| Layer | What runs | On how many applications |
| --- | --- | --- |
| Screen | ZAP and Nuclei | Every running application |
| AI main-class definition | New AutoPT agent, HITL, family-level | Once (truncated evidence from all screens) |
| Focused HITL test | New agent, single-agent HITL, locked class | Every running application |
| Swarm | New agent, two or three prompt-defined roles, shared facts file | One representative application |
| Overnight loop | Unattended run, localhost kill switch | One representative application, one night |
| Fix and retest | Five to eight fixes, then ZAP, Nuclei, and HITL | One or two representative forks that showed the class |

Depth is the class. Breadth is the corpus. Five codebases are not all patched in depth.

---

## 6. Taxonomy and related findings

This project does not rerun Peng et al.’s thirteen-framework XBOW experiment. It reuses their definitions so that the report is comparable to that survey.

### 6.1 Knowledge levels (Peng §2.1)

| Level | Peng’s definition | This project |
| --- | --- | --- |
| White-box | Source and architecture fully known (code audit / SAST as the main paradigm) | Out of the empirical scope. Named in the report so the boundary is explicit. No SAST campaign, no full code audit. |
| Grey-box | Partial prior knowledge (insider-like access: maps, source hints, planted credentials beyond normal registration) | Out of the empirical scope. Same cut as Peng’s bake-off. No Semgrep campaign, no source in prompts, no OpenAPI dump as tester input. |
| Black-box | Zero internals; only external interfaces | The only empirical protocol. ZAP, Nuclei, and the new AutoPT agent (HITL, swarm, overnight) see only localhost HTTP. No source, no architecture notes in the prompt. Public README bullets are allowed (anyone can read them). |

Peng’s AutoPT bake-off was black-box only. This project keeps that empirical cut and moves the target from CTF/XBOW to a multi-application fitness corpus, with ZAP, Nuclei, and a new AutoPT agent (HITL, swarm, overnight) instead of thirteen frameworks.

Classic human models listed in the survey (Kill Chain, PTES, NIST SP 800-115, ATT&CK) remain labels and background, not a Caldera laboratory.

### 6.2 Six design dimensions (Peng §3) — classification of the student agent

| Dimension | What Peng asks | How the new AutoPT agent is classified in this laboratory |
| --- | --- | --- |
| 3.1 Architecture | Who decides? One agent versus many; role = own window plus authority | Three scored modes of the same codebase: (A) HITL single-agent; (B) swarm of two or three prompt-defined roles (planner / executor / reviewer) sharing one facts file; (C) overnight unattended loop. Peng §5.1 is measured, not used as a reason to skip swarms. |
| 3.2 Plan | Linear / tree / graph plus feedback | HITL: linear ReAct or a small penetration-testing task tree (Deng). Swarm: roles hand off through the facts file. Overnight: same planner with a wall-clock stop. No graph rewrite engine. |
| 3.3 Memory | Experience versus knowledge; compress; organise | Experiential only: a student-maintained facts file (structure-bound, lite) plus truncated tool output. Same file for HITL, swarm, and overnight. No HackTricks RAG (Peng §5.2: mismatched knowledge bases often hurt). |
| 3.4 Execution | Whether / which / how; tool layers | Small menu: browser, `curl`, ZAP/Nuclei history. Overnight may call the same menu only. Peng §5.4: successful traces are atomic HTTP/Python, not a large Kali inventory. |
| 3.5 External knowledge | Construct → retrieve → generate | Two AI jobs, both laboratory-only: (1) define the main weakness class from truncated black-box evidence; (2) test that class per application and mode. No generic Top-100 payload dump. |
| 3.6 Benchmarks | Testbed and metrics; contamination | Testbed: several single-host product APIs, not XBOW CTF. Success = confirmed HTTP evidence, not “the swarm named this as the main bug.” Overnight success uses the same evidence rule. |

### 6.3 Findings adopted as design rules (Peng §5–6)

1. **Memory first.** Keep a facts file; do not rely on a long chat transcript.
2. **HITL versus swarm versus overnight is an empirical question** on this corpus. Peng §5.1 reported that extra roles often fail; this project checks whether that holds here.
3. **More tools are not necessarily better.** Small HTTP set; ZAP, Nuclei, one new agent (three modes, not three extra products).
4. **Knowledge bases only if they match this application.** No generic payload wiki.
5. **Hallucinations are structural.** Never treat the model’s prose as success or as the main weakness; require a saved request and response (overnight included).
6. **Do not treat software-engineering-bench fame as AutoPT skill.** The scientific object is the student-built agent plus the named backbone(s), local and/or cloud, not a claim about frontier coding agents in general.

### 6.4 How the other four papers support the same design

Peng et al. supply the vocabulary. The other four papers justify design choices. None of them is a sixth scored tool.

| Finding (citation) | Design choice it supports |
| --- | --- |
| mHealth freeware already fails known privacy and security practice; data are sensitive by nature and by law [5] | Corpus = fitness/health APIs; synthetic users only; no production SaaS; family checklist as the defender output |
| Access control has no single sanitiser; success = weaker role still receives the privileged page or object [4] | Two accounts on every application; confirm with HTTP status and body, not “the model said IDOR”; if the AI locks authorisation, the focused campaign is this pairwise check |
| LLMs help as sparring partners, not as unsupervised attackers; high-level plan is not a low-level loop; refuse social-engineering dual-use [2] | T3-HITL is the main scored mode; swarm and overnight are measured, not assumed better; no phishing content; ATT&CK only as labels after confirmation |
| Naive chat loses the global picture; HITL plus task tree plus truncated tool output raises sub-task completion; unattended pentest remains difficult; GPT-4 HTB spend was about USD 131 [1] | Facts file / small task tree; never paste full ZAP dumps; human executes hypothesised *classes* of check; progressive evidence rows; report model and local versus cloud |
| Extra agents, large Kali menus, mismatched RAG often do not help; flag hallucination is structural [3] | One agent, three modes; small HTTP menu; no HackTricks; success = saved request/response |

The project is small because the literature already identifies which knobs matter, not because the scientific framing was skipped.

### 6.5 Literature findings inherited (results to cite, not experiments to rerun)

**Papageorgiou et al. (2018)** — domain and privacy  
- A majority of sampled freeware mHealth applications failed well-known security and GDPR-era practice.  
- Recurring classes: weak or missing authentication, records not bound to the logged-in user, unprotected data at rest or in transit, third-party telemetry, policies that do not match behaviour.  
- Longitudinal observation: vendors often did not fix the same issues over time. A checklist is therefore a legitimate semester output.

**Sun et al. (2011)** — what an authorisation finding is  
- Access-control bugs have no single sanitiser (unlike XSS or SQL injection).  
- Intended privilege is visible in which links a role is shown; a bug is when a weaker role can still force-browse the hidden URL and obtain the privileged response.  
- On REST fitness APIs, “HTML looks the same” translates to the same status and the same object body for user B on user A’s `…/{id}`.

**Happe and Cito (2023)** — LLM as tester  
- High level: models already know the genre of a pentest plan (tactics and techniques).  
- Low level: a closed command loop can act on an authorised laboratory VM, but is unstable (invented flags, safety-filter leakage, rambling without memory).  
- Ethics: keep a human in the loop; refuse phishing and vishing; ATT&CK is a grading rubric, not a runtime.

**Deng et al. (2024)** — HITL works; naive chat does not  
- Off-the-shelf GPT-3.5, GPT-4, and Bard propose tools but lose the plot (context rot, last-turn bias, fabricated tool flags).  
- PentestGPT (reasoning / task tree, generation, parsing; human executor) raised sub-task completion by 228.6% versus naive GPT-3.5 on a 13-machine / 182-sub-task bench.  
- Live HTB: 4 of 10 boxes at approximately USD 131 of GPT-4 — cost is part of the result.  
- Score progressive sub-tasks (a confirmed HTTP class counts), not a binary “rooted / not.”

**Peng et al. (2026)** — AutoPT architecture findings (re-checked here on fitness APIs)  
- Single-agent ReAct often matched or beat multi-agent graphs on Easy/Medium; extra roles remain a hypothesis.  
- Memory is the real differentiator; mismatched knowledge bases often hurt (ablations improved when RAG was removed).  
- Thirty-tool versus 115-tool variants scored almost the same — hence a small HTTP menu.  
- Minimal coding-agent prompts beat most dedicated open-source frameworks. This project still builds T3 in order to classify it; Strix, CAI, and similar products are not scored.  
- Eight of thirteen open-source frameworks hallucinated flags; chained-bug traces rarely closed the full chain (16.67%); knowing a CVE identifier did not imply a working payload (56.67% knew the identifier and still failed).  
- Success in their bake-off is flag equality. Success here is saved HTTP — the same anti-hallucination idea.

### 6.6 Techniques executed versus catalogues used as labels

Happe’s stack is tactic → technique → procedure. This laboratory executes a short list of black-box HTTP procedures. It labels confirmed rows with OWASP API and one ATT&CK technique after the fact (Peng: ATT&CK is not the control plane).

**A. Techniques executed (black-box, localhost, two synthetic users)**

| Laboratory technique | Ancestor | What is done |
| --- | --- | --- |
| Automated DAST crawl/scan | Industry baseline | OWASP ZAP quick/automated scan against `127.0.0.1` |
| Template HTTP matching | Nuclei | HTTP templates only; no exploit packs |
| Truncated HITL / task tree | Deng et al. | Model names the class of the next check; the human runs `curl` or the browser; dumps go to the facts file, not the full prompt |
| Family-level class naming | Happe (high-level) and Deng (director) | One session: exactly one OWASP API identifier for the whole corpus |
| Two-account object swap (force-browse) | Sun et al. | User B requests user A’s workout, GPX, plan, or metric identifier; compare status and body |
| Authentication and session probes | Papageorgiou (weak authentication) | Registration, login, cookie/token reuse, logout — HTTP only |
| Export, upload, or share path | Papageorgiou (data leaving the account) | Unauthenticated or cross-user export/download if the interface offers it |
| Facts-file memory | Deng task tree and Peng memory | Structured rows: finding → evidence pointer → status; shared by HITL, swarm, overnight |
| Pairwise before/after | Deng progressive score and RQ3 | Same black-box checks on the patched fork |

Metasploit is not used. Password-spray campaigns are not the main story (Deng: brute-force addiction is a failure mode to log if the model requests it). Active Directory and Kerberos examples from Happe remain background.

**B. Catalogues used only as labels (after HTTP confirmation)**

OWASP API Security Top 10 (2023) is the class vocabulary the agent must name (exactly one identifier for RQ1):

| ID | Name | Typical fitness-API HTTP check if this class is locked |
| --- | --- | --- |
| API1 | Broken Object Level Authorization | Sun swap on `/workouts/{id}`, GPX, plans |
| API2 | Broken Authentication | Token and cookie handling; session-fixation-style HTTP |
| API3 | Broken Object Property Level Authorization | Extra JSON fields (email, GPS, tokens) in another user’s object |
| API4 | Unrestricted Resource Consumption | Only if evidenced (no stress-test as a goal) |
| API5 | Broken Function Level Authorization | User hits an administrator-only route the UI hides |
| API6 | Unrestricted Access to Sensitive Business Flows | Mass export or share if evidenced |
| API7 | SSRF | Out of expected main class; secondary only |
| API8 | Security Misconfiguration | Debug, default secrets, directory listing — often seen by ZAP/Nuclei |
| API9 | Improper Inventory Management | Shadow or old routes if evidenced |
| API10 | Unsafe Consumption of APIs | Secondary; third-party calls if visible in HTTP |

MITRE ATT&CK techniques (one per confirmed row, or “no close match”):

| ATT&CK | Name | When to attach |
| --- | --- | --- |
| T1190 | Exploit Public-Facing Application | Broken object or function authorisation; misconfiguration on the HTTP API |
| T1078 | Valid Accounts | Abuse of a normal login or session (not stolen production credentials) |
| T1530 | Data from Cloud Storage Object | Export or download of GPX, backups, object stores if present |
| T1552 | Unsecured Credentials | Tokens or secrets in responses, clients, or misconfiguration |
| T1213 | Data from Information Repositories | Bulk history or metrics readable across users |
| T1110 | Brute Force | Only if the model requests it and HTTP shows no throttle — log as RQ2 / failure mode; not the campaign |

Procedures (the concrete `curl` lines) remain in the private evidence log. The public report prints classes and fixes, not exploit recipes.

---

## 7. Tools

T1 and T2 are off-the-shelf scanners. T3 is a new AutoPT agent written by the student. Swarm and overnight are modes of T3, not extra products.

| ID | Tool / mode | Role in Peng’s terms | Knowledge level | LLM |
| --- | --- | --- | --- | --- |
| T1 | OWASP ZAP (automated / “quick” scan, localhost only) | Traditional security-tool DAST; no LLM. Baseline for non-LLM scanning. | Black-box | None |
| T2 | Nuclei (ProjectDiscovery; HTTP templates against the laboratory URL only) | Template-based black-box scanner; still no source. | Black-box | None |
| T3-HITL | New AutoPT agent, single-agent human-in-the-loop | Student-built assistant: facts file plus small HTTP menu; (A) define main weakness; (B) test that class per application. Fallback if the build slips: a 15-prompt notebook with the same research questions. | Black-box | Local and/or cloud (Section 9.0) |
| T3-swarm | Same agent, two or three roles (planner / executor / reviewer) | Multi-agent swarm; roles share the facts file; no extra Kali inventory. One representative application. | Black-box | Same T3 backbones |
| T3-night | Same agent, overnight unattended loop | Wall-clock kill switch. One representative application, one night. | Black-box | Same T3 backbones |

**Definition of the new AutoPT agent.** A Python (or similar) orchestrator owned by the student: prompt templates, facts-file I/O, a small tool wrapper (`curl` / saved HTTP), LLM calls to a **local** runtime (for example Ollama) and/or a **cloud** chat API. Deng et al. (PentestGPT task tree) is the design reference, not a fourth scored tool. There is no new model training, no 115-tool router, and no payloads in the public repository. Changing backbone (local ↔ cloud, or one vendor to another) does not add a fourth product: it is the same T3 codebase. The report names the model identifier and local versus cloud on every call.

**Why ZAP, Nuclei, and this agent, and not Strix, CAI, or Semgrep as extra products.** Peng §5.4: atomic HTTP, not a Kali inventory. Peng §2.1: Semgrep is grey/white-box SAST — named in Section 8.1, not executed. Swarm and overnight are in scope as T3 modes so that Peng §5.1 can be checked on this corpus. Other products may be mentioned only in Section 8.1.

---

## 8. Scope

### 8.1 In scope

- Multiple Dockerized fitness applications on localhost (corpus in Section 5)
- Synthetic accounts only
- Black-box campaign only
- ZAP, Nuclei, and a new AutoPT agent
- Multi-agent swarm (T3 mode, one application)
- Overnight loops (T3 mode, one application, localhost kill switch)
- Local and/or cloud LLMs as T3 backbones (same protocol; recorded in the call log)
- AI definition of the main weakness class (one locked OWASP API identifier)
- Authentication, authorisation, secrets, session, export, and upload as seen from HTTP
- Human confirmation (read responses; no exploit development)
- Fix-and-retest of the same black-box protocol on one or two forks
- OWASP API and ATT&CK label table
- Peng taxonomy section in the report (two to three pages), including why grey-box and white-box are not run
- 20–30 page report

### 8.2 Out of scope

- White-box empirical work (full audit, SAST as main paradigm, formal verification)
- Grey-box empirical work (source in prompts, OpenAPI as tester input, Semgrep campaign, insider API map as a scored condition)
- Testing only one application (unless four cannot be started — then document the failure; do not silently shrink the design)
- Commercial AutoPT SaaS (CAI, Strix, and similar) as scored products
- Cursor Cloud Agents as T3
- Testing Workout.cool production, Endurain production, or any third-party live system
- Full mobile reverse engineering, Frida, jailbreak, Active Directory / Caldera
- Real wearables or real health records
- Exploit proofs of concept in the report
- Full Garak suites
- Replication of Peng et al.’s thirteen-framework XBOW campaign
- Student-chosen “main bug” a priori
- Patching every application in the corpus
- A 50–80 page thesis-length document

### 8.3 Tools considered, not executed

Approximately half a page in the report: Semgrep (grey-box SAST — excluded by the empirical cut); Aikido Android; Thorfinn; iosHunt; TrashiOS; Caldera AI; Strix/CAI unattended — named and excluded (knowledge level, licence, hardware, or Peng-style token cost). Optional stretch only if weeks 1–10 are complete: ten local promptfoo cases if an application has a chat feature (at most ten extra calls).

The catalog [`AI-Pentesting-Tools-Research-Catalog.md`](AI-Pentesting-Tools-Research-Catalog.md) is background. This project uses three tools; it does not rescan the market. Section-by-section reading notes for the five papers are in [`papers/`](papers/README.md).

---

## 9. Method

### 9.0 LLM backbones (local and cloud)

T3 may call **local** models (for example via Ollama or another on-machine runtime) and **cloud** chat APIs. Both are in scope. They are backbones of the same agent, not two scored products.

| Rule | Practice |
| --- | --- |
| Allowed backbones | Local LLM, cloud LLM, or both during the semester |
| Recording | Every call: date, tool mode, application identifier, job (define-class / test / retest / swarm / overnight), model identifier, local versus cloud |
| Prompt size | Truncated evidence only; never paste a full ZAP or Nuclei dump (Deng et al.) |
| Switching | Changing backbone does not open a new experimental condition; log the date and model |
| Overnight | Allowed with a wall-clock kill switch on localhost |

**Call log (required appendix):** as in the recording row above. Cost, if a cloud API is used, may be noted but is not a scientific limit of this proposal.

### 9.1 Black-box protocol (Peng §2.1)

**Screen (every running application)**

- Inputs: that application’s base URL, “authorised laboratory,” no source, no OpenAPI, no architecture notes.
- Accounts: create users as a normal registration flow (still black-box). Do not paste source snippets. Two sessions exist so a later authorisation check has Sun’s shape even if the AI locks a different class.
- Tools: ZAP automated pass; Nuclei HTTP templates.
- Output: truncated finding-class list with HTTP evidence pointers (not full dumps) — Deng’s parser rule: compress so the model cannot drown in the last scan.

**Define the main weakness (AI, once, family-level)**

- Inputs allowed: public README or feature bullets; truncated class names from all screens; observed route patterns from registration (for example `workouts/{id}`).
- Inputs forbidden: source, OpenAPI files, exploit recipes, the student’s preferred class.
- Output required: exactly one OWASP API Top 10 identifier, a one-sentence defender meaning, and which applications the model claims show it.
- Human action: lock that class, or write why the session is discarded (empty or garbage output) and rerun once. The class is not selected by shopping among outputs.

**Focused test (every running application)**

- The agent may know the locked class name (that is the hypothesis under test). It still must not receive source or payloads (Happe/Deng: the human is the executor).
- The student executes only hypothesised classes of check and saves HTTP traces. If the locked class is access control, the default check is Sun’s pairwise object URL (user B requests user A’s `…/{id}`).
- Stop when the focused checks for the locked class are done, or record why the session ended without a confirmed HTTP row.

Fairness: the same two-user story, the same junior day-one tool setup, sequential stacks if the host cannot run them together.

### 9.2 Ground truth

The scientific object is the AI-defined main class, not a secret seed list written by the student in week 3.

| Item | Role |
| --- | --- |
| Locked OWASP API class | Family-level hypothesis (RQ1) |
| Per-application confirmed HTTP rows in that class | Support or reject the hypothesis |
| Other confirmed classes | Report as secondary; they do not rewrite the locked class mid-semester |
| Contradiction | If scanners later show a different class more often, that is a result (the AI main-class claim failed), not a protocol rewrite |

New “main” classes are not added after the definition session. Secondary findings remain in the table.

### 9.3 Metrics

| Metric | Definition |
| --- | --- |
| Main-class hit rate | Applications with at least one confirmed HTTP finding in the locked class / running applications |
| Tool agreement | Which of T1, T2, T3 contributed those confirmations |
| Precision | Confirmed / reported, per tool, pooled and per application |
| Evidence rate | Findings with a saved request/response |
| False-success count | LLM claims “done / critical / this is the main bug” with no evidence (Peng §5.6.3) |
| Definition quality | Locked class matches the most frequent confirmed class (yes/no) |
| Time | Hours per tool × application (screen versus focused) |
| LLM calls | Count and backbone (local versus cloud), logged (Section 9.0) |
| Retest delta | Locked-class findings still open on the one or two fixed forks |
| Coverage by class | Locked class versus others (OWASP API) |

No significance tests. Transparent tables are the scientific level of this project.

### 9.4 Labels (desk work)

One row per confirmed finding (catalogues in Section 6.6 B):

`application ID | laboratory technique used (Section 6.6 A) | OWASP API ID | ATT&CK technique | privacy relevance (workout / GPS / metrics / none)`

Allowed ATT&CK identifiers: T1190, T1078, T1530, T1552, T1213, T1110 (rare), or “no close match.” No Caldera. Papageorgiou’s privacy-relevance column is why a broken-object finding on GPX is not the same as a debug header.

### 9.5 Fix and retest

Select one or two forks that showed the locked class (prefer Workout.cool plus the lightest other hit). Apply the smallest high-value changes for that class (for example ownership checks, authentication on export, secrets out of the client, role changes locked, login throttle, debug off — whichever the locked class actually is). Then rerun ZAP, Nuclei, and HITL on those forks only. Reading a fork in order to implement a fix is defender work; it does not open a grey-box scoring condition.

The checklist is written for every application in the corpus that shares the class, even if only one or two were patched.

---

## 10. Work plan

Each step has a purpose and a completion criterion. Stretch items may be skipped; phases may not.

### Phase 0 — Frame the science (week 1)

| Step | Activity | Purpose |
| --- | --- | --- |
| 0.1 | Read Peng et al. (taxonomy and §5 findings) plus Deng, Happe, Sun, and Papageorgiou (map in Section 6.4) | Shared vocabulary; each paper licenses one design choice, not a sixth tool |
| 0.2 | Write a two-page protocol: three tools, black-box only, multi-application corpus, AI main-class rule, ethics | Supervisory sign-off before any scan |
| 0.3 | Confirm a local LLM and/or a cloud LLM responds through T3 | Prove at least one backbone before Phase 2 |

**Phase objective.** The project is a Peng-taxonomy multi-application case study, not a one-target demonstration.  
**Completion.** Signed ethics page, protocol, and a screenshot of a successful T3 call (local and/or cloud).

### Phase 1 — Bring up the corpus (weeks 2–4)

| Step | Activity | Purpose |
| --- | --- | --- |
| 1.1 | `docker compose up` each Section 5 application in turn; two synthetic accounts on each | Prove the instruments run |
| 1.2 | Record image tag / commit hash per application | Reproducibility (Peng §4 hygiene) |
| 1.3 | Drop stacks that will not start; keep a dropout log | Honest corpus, still at least four applications |
| 1.4 | Create the empty facts file and token-log sheet | Memory-first (Peng §6) from day one |

**Phase objective.** A set of authorised, pinned, multi-user fitness systems.  
**Completion.** At least four applications accept two synthetic users on `127.0.0.1`.

Operational record: [`Phase-1-Lab-Log.md`](Phase-1-Lab-Log.md).

### Phase 2 — Black-box screen, all applications (weeks 5–6)

| Step | Activity | Purpose |
| --- | --- | --- |
| 2.1 | Bind ports to `127.0.0.1`; synthetic data only | Containment and privacy |
| 2.2 | ZAP automated scan per application; keep evidenced rows | Traditional baseline across the family |
| 2.3 | Nuclei HTTP templates per application; same confirmation rule | Second non-LLM signal |
| 2.4 | One comparison sheet: application × tool × OWASP class | Input to the AI definition session |

**Phase objective.** What two ordinary black-box scanners see without internals, on every running application.  
**Completion.** ZAP and Nuclei tables exist for each application in the corpus.

### Phase 3 — AI defines the main weakness (week 7, first half)

| Step | Activity | Purpose |
| --- | --- | --- |
| 3.1 | One HITL session: truncated screen classes, README bullets, observed routes | Let T3 name the family-level main class |
| 3.2 | Require output = one OWASP API identifier, one sentence, claimed applications | Prevent an undifferentiated list of every class |
| 3.3 | Lock the class (or one discard-and-rerun) | RQ1 hypothesis frozen |

**Phase objective.** The main weakness is defined by the AI, not by a prior student preference.  
**Completion.** Locked class is written in the facts file.

### Phase 4 — Focused AI test of that class (week 7, second half, into week 8)

| Step | Activity | Purpose |
| --- | --- | --- |
| 4.1 | HITL agent per application, class name allowed, no source | Test the locked hypothesis on each product |
| 4.2 | Student executes only hypothesised classes of check; save HTTP traces | Separate model speech from evidence |
| 4.3 | Update facts file from confirmed HTTP only | Bind feedback to memory (Peng §3.2.4 / §6) |

**Phase objective.** Measure whether the AI-named class is real on the corpus.  
**Completion.** Per-application T3 table complete; call log as in Section 9.0.

### Phase 5 — Human review and labels (week 8)

| Step | Activity | Purpose |
| --- | --- | --- |
| 5.1 | True positive / false positive / unverified for every row | RQ2 |
| 5.2 | Count false-success (model stopped as if done, or named a class with no HTTP) | Operationalise Peng §5.6.3 |
| 5.3 | Score definition quality (locked class = most frequent confirmed class?) | Close RQ1 |
| 5.4 | OWASP API and ATT&CK labels for confirmed rows only | Standard language, no extra laboratory |

**Phase objective.** A defensible family picture, not a tool export.  
**Completion.** Label table has one row per confirmed issue; main-class hit rate is computed.

### Phase 6 — Harden the class on one or two forks (weeks 9–10)

| Step | Activity | Purpose |
| --- | --- | --- |
| 6.1 | Choose one or two applications that showed the locked class (Workout.cool preferred if it hit) | Depth without five parallel patches |
| 6.2 | Implement five to eight small fixes for that class | Defender outcome for the family pattern |
| 6.3 | Commit fixes with messages that name the finding identifier | Traceability |

**Phase objective.** Close the find-and-fix loop on the main weakness, not on every secondary noise row.  
**Completion.** Five to eight fixes merged on the chosen laboratory branch(es).

### Phase 7 — Black-box retest (weeks 10–11)

| Step | Activity | Purpose |
| --- | --- | --- |
| 7.1 | ZAP again on the patched fork(s) | RQ3, traditional scanner |
| 7.2 | Nuclei again | RQ3, template scanner |
| 7.3 | HITL retest | RQ3, AI, same blindness as Phase 4 |
| 7.4 | Retest-delta table and checklist for the other applications | What disappeared versus what the family still needs |

**Phase objective.** Show upgrades of the main class, not only a list of defects.  
**Completion.** Before/after exists for the patched application(s); checklist covers the corpus.

### Phase 8 — Write and demonstrate (weeks 12–14)

| Step | Activity | Purpose |
| --- | --- | --- |
| 8.1 | Report chapters (Section 13) | 20–30 pages; taxonomy used correctly |
| 8.2 | Hardening checklist for the locked class on fitness APIs | Transferable defender output |
| 8.3 | 10–15 minute demonstration: two accounts on two applications, before/after on one | Examiner-visible multi-application result |
| 8.4 | Buffer | Slips without dropping RQ3 |

**Phase objective.** A graded, citable semester report.  
**Completion.** PDF, tables, token log, demonstration.

### Strategy (overview)

```
Frame (Peng taxonomy, ethics, local and/or cloud LLM)
        ↓
Stand up the five fitness applications (pass: at least four)
        ↓
BLACK-BOX SCREEN  —  ZAP + Nuclei  ×  every application
        ↓
AI DEFINES MAIN WEAKNESS  —  one locked OWASP API class
        ↓
FOCUSED BLACK-BOX TEST of that class  —  HITL agent × every application
        ↓
Review, labels, hallucination count, hit rate
        ↓
Fix five to eight issues of that class on one or two forks
        ↓
Retest BLACK-BOX on those forks
        ↓
Report + family checklist + demonstration
```

---

## 11. Expected results

The project succeeds if the report can state, with tables:

- the identifier of the OWASP API class locked by the LLM as the main weakness of this family;
- that class was confirmed on *k* of *n* running applications (or was not — still a valid result);
- whether ZAP and Nuclei surfaced the same class, and whether the agent added authorisation-style rows;
- counts of confirmed findings versus hallucinated or evidence-free claims (RQ2), including whether the definition session itself was evidence-free;
- after fixes on one or two forks, locked-class recall moved from *A*% to *B*% there;
- token and backbone log complete (local versus cloud, model identifiers);

A mixed result is acceptable. Example: the agent named broken object-level authorisation as the main class; scanners mostly reported configuration noise; HTTP confirmed the class on three of five applications; half of the AI claims lacked evidence.

---

## 12. Deliverables

| Deliverable | Form |
| --- | --- |
| Laboratory corpus | Dockerized instances (pinned tags) for every running application, plus dropout log |
| Main-weakness card | Locked OWASP API class, prompt, model reply, lock date |
| Evaluation pack | Tables by application × tool, raw reports, LLM call log |
| Report | 20–30 pages |
| Taxonomy note | How T3 maps to Peng’s six dimensions (1–2 pages); grey-box and white-box named as excluded |
| Label table | OWASP API and ATT&CK |
| Hardening checklist | 2–4 pages for the locked class across the family |
| Demonstration | 10–15 minutes, at least two applications shown |

---

## 13. Report outline

1. Introduction and research questions  
2. Background: fitness-application threats (Papageorgiou et al.) + access-control evidence shape (Sun et al.) + Peng taxonomy (knowledge levels, six dimensions, findings adopted; why empirical work is black-box only)  
3. Related work (five papers with the Section 6.4 map + tools not run)  
4. Targets: the five-application corpus, what started, what dropped ([`Phase-1-Lab-Log.md`](Phase-1-Lab-Log.md))  
5. Method: three tools, findings-to-techniques map (Sections 6.5–6.6), black-box protocol, AI main-class definition, metrics, ethics, LLM backbones  
6. Work-plan recap (Phases 0–8, one page)  
7. Results: RQ1–RQ3 tables (class lock, hit rate, hallucinations, retest)  
8. Discussion: what to upgrade first on this product family; what Peng et al. predicted that was observed  
9. Limitations (chosen LLM backbone, no grey-box, no white-box, fixes on one or two applications only)  
10. Conclusion  

Appendices: versions, prompts, finding identifiers, token log, Nuclei template identifiers used, main-weakness card.

---

## 14. Semester timetable

| Weeks | Phase | Hours |
| --- | --- | --- |
| 1 | 0 Frame | 15 |
| 2–4 | 1 Corpus (five stacks, sequential) | 50 |
| 5–6 | 2 Screen all applications (ZAP and Nuclei) | 40 |
| 7 | 3–4 AI main class and focused HITL | 25 |
| 8 | 5 Review and labels | 20 |
| 9–10 | 6 Fixes on one or two forks | 25 |
| 10–11 | 7 Black-box retest | 20 |
| 12–13 | 8 Report | 40 |
| 14 | Buffer, demonstration | 20 |
| **Total** | | **~255 hours** |

Controls that keep the project inside one semester: screen all applications / fix few; one locked class. A sixth application or a fourth scored product is not added.

---

## 15. Required skills

HTTP APIs, Docker, reading OWASP API Top 10, and honest scientific writing. OSCP, reverse engineering, and machine-learning research are not required. Supervision in software security or software engineering is sufficient.

---

## 16. Ethics, privacy, and legal constraints

- Only self-hosted instances; never production fitness SaaS.
- Synthetic names and health values only.
- Local LLMs keep traces on the machine. Cloud LLMs are allowed; send only truncated synthetic laboratory traffic (no real names, no real health values, no full dumps) and record in the ethics appendix that prompts left the machine.
- No exploit recipes or payloads in the public report — classes and fixes only.
- The AI main-class prompt asks for an OWASP identifier, not a working attack.
- Private logs; public aggregated tables.
- One-page ethics appendix, signed in week 2.
- Dual-use is named as in Peng §8 and Happe §6: testers are studied in order to harden applications. No phishing or vishing copy (Happe already refused that slice).
- The overnight loop is in scope because Happe flagged unsupervised loops as the risky shape and Peng asked whether extra autonomy helps. It is measured on one application with a kill switch, not treated as the default.

---

## 17. Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| An application will not start | Dropout log; keep at least four; optional LibreFit substitute |
| Endurain too heavy | Skip with RAM note; corpus remains valid |
| Agent implementation fails | 15-prompt notebook; still T3 (define and test) |
| Host cannot run several stacks at once | Run one Docker stack at a time |
| Local LLM unavailable or too weak | Switch T3 to a cloud LLM; log the switch; 15-prompt notebook remains a fallback |
| AI names an empty or garbage class | One rerun; then lock or report “definition failed” (valid RQ2) |
| Nuclei template noise | Restrict to HTTP / exposed-panels classes; state the filter |
| Almost no findings | Valid result; checklist still from claimed class and literature |
| Many hallucinations | Answers RQ2; count them |
| Temptation to pick a favourite class by hand | The locked class must come from the definition session |
| Temptation to add Semgrep or source-in-prompt | Grey-box is out of the empirical scope |
| Temptation to add a fourth agent product | Breaks Peng’s “more tools ≠ better” finding |

The research questions remain unchanged under these mitigations.

---

## 18. Request for approval

The student requests supervisory approval of:

1. the in-scope and out-of-scope lists (Section 8);
2. local and/or cloud LLMs as T3 backbones (Section 9.0);
3. three instruments and black-box-only empirical work (white-box and grey-box out of the empirical scope);
4. the five applications in Section 5 as the corpus (pass: at least four running);
5. AI-defined main weakness (one locked OWASP API class);
6. fixes on one or two forks only;
7. ATT&CK and OWASP used as labels only;
8. ethics (synthetic data, no production, no exploit publication);
9. Peng et al. as the taxonomy source, not as an experiment to replicate at scale; Deng, Happe, Sun, and Papageorgiou as design evidence (Section 6.4), not extra laboratories.

**Week-2 kick-off expected by the supervisor:** first two applications up with image pins; T3 backbone proof (local and/or cloud); two-page protocol.

---

## 19. References

[1] G. Deng, Y. Liu, V. Mayoral-Vilches, P. Liu, Y. Li, Y. Xu, T. Zhang, Y. Liu, M. Pinzger, and S. Rass, “PentestGPT: Evaluating and harnessing large language models for automated penetration testing,” in *Proc. 33rd USENIX Security Symposium*, 2024, pp. 847–864.

[2] A. Happe and J. Cito, “Getting pwn’d by AI: Penetration testing with large language models,” in *Proc. 31st ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE)*, 2023, pp. 2082–2086, doi: 10.1145/3611643.3613083.

[3] Peng, Li, You, et al., “Hackers or hallucinators? A comprehensive analysis of LLM-based automated penetration testing,” arXiv:2604.05719, 2026.

[4] F. Sun, L. Xu, and Z. Su, “Static detection of access control vulnerabilities in Web applications,” in *Proc. 20th USENIX Security Symposium*, 2011.

[5] A. Papageorgiou, M. Strigkos, E. Politou, E. Alepis, A. Solanas, and C. Patsakis, “Security and privacy analysis of mobile health applications: The alarming state of practice,” *IEEE Access*, vol. 6, pp. 9390–9403, 2018, doi: 10.1109/ACCESS.2018.2799522.

**Standards used as labels only (not among the five research papers):** OWASP API Security Top 10 (2023); MITRE ATT&CK.

**Where each paper is used in this proposal**

| Paper | Finding that supports this proposal | Sections |
| --- | --- | --- |
| Deng et al. [1] | Memory and HITL beat naive chat; count sub-tasks and cost | Method T3, Sections 9.0–9.1, RQ2 |
| Happe and Cito [2] | Sparring partner and ethics fence | HITL versus overnight, labels, ethics |
| Peng et al. [3] | Taxonomy, black-box cut, swarm/tool/RAG/hallucination results | Section 6, RQ1–RQ2, tool count |
| Sun et al. [4] | Two-account object check is the authorisation evidence | Corpus, focused test, RQ3 fixes if that class locks |
| Papageorgiou et al. [5] | Fitness/health family is a serious privacy target | Motivation, ethics, checklist |

The report is not expanded into a second survey of Aikido, Thorfinn, or Caldera.

---

## Appendix A. Kick-off checklist

1. Confirm the one-semester format with the supervisor (this document).
2. Bring up Workout.cool first, then FitTrackee, openGym, FitnessTrack, Endurain; log dropouts; do not stop at one application.
3. Install ZAP and Nuclei; confirm a local and/or cloud LLM; build the new AutoPT agent (HITL first).
4. Screen all running applications before the AI definition session.
5. Lock one main weakness class from the AI; do not override it with a favourite.
6. Keep the facts file and call log from the first LLM call.
7. After confirmed findings, fill OWASP/ATT&CK. Do not install Caldera. Do not add a grey-box or white-box campaign.
