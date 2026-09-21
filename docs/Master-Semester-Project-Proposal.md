# Which Weakness Shows Up Across Self-Hosted Fitness Apps?

*A black-box comparison using ZAP, Nuclei, and a small AI tester (plain-language version)*

Master's semester project proposal, Achraf, 20 September 2026 (rewritten for clarity, v1.1)

| Item | Detail |
| --- | --- |
| Programme | Master's degree, semester project |
| Document type | Project proposal, for supervisor approval |
| Academic year | 2026-2027 |
| Load | 15 ECTS, about 250 hours, 12-14 working weeks |

---

## What this project is, in plain terms

I'm testing five self-hosted, open-source fitness apps (Workout.cool, FitTrackee, openGym, FitnessTrack, and Endurain, with at least four needing to actually run) using three tools: OWASP ZAP, Nuclei, and a small AI-assisted tester I build myself. I only test from the outside, the way a stranger with no source code and no inside knowledge would. This is the "black-box" approach described by Peng et al. (2026).

Health apps have a poor track record with sensitive data (Papageorgiou et al., 2018), which is why I'm studying five apps as a group instead of picking on one. Access-control bugs, where one user can see another user's data, are proven with a simple test: create two accounts and check whether account A can read account B's information (Sun et al., 2011). Giving an AI assistant a person to work with, plus short notes instead of one long chat, works better than letting it run unsupervised (Deng et al., 2024). Happe and Cito (2023) treated the AI as a sparring partner, not an unsupervised attacker.

After running ZAP and Nuclei on all five apps, my AI tester (using a local model, a cloud model, or both) picks one main weakness for the whole group, described using an OWASP API Security Top 10 category. I then check whether that weakness actually holds up, first with me driving one AI conversation by hand, then with a few AI "roles" working together, then with one unsupervised overnight run on a single app. A finding only counts if I saved the actual request and response, which is how I catch the tool claiming success when it found nothing. I then fix the problem on one or two apps, retest, and write a checklist any team building a fitness app could use. Confirmed issues get labeled with OWASP API Top 10 and MITRE ATT&CK codes. The final report runs 20-30 pages.

*Keywords: black-box testing; API security; automated penetration testing; large language models; OWASP API Top 10; mobile health apps; human in the loop; OWASP ZAP; Nuclei.*

---

## 1. Why this project

Fitness apps store things people want kept private: workouts, weight, heart rate, sleep, GPS routes from runs, and sometimes tokens from connected wearables. Most are built the same way, a website or phone app talking to an API, with several accounts that should never see each other's data.

A 2018 study (Papageorgiou et al.) looked at popular free health apps and called the state of the industry "alarming": weak logins, sensitive data handled carelessly, and privacy policies that didn't match what the apps actually did. That's why this project studies five apps rather than one. A single broken app is a story. Five apps breaking the same way is a pattern, and a pattern is what a checklist can actually fix.

The typical bug here isn't a flashy exploit. Sun et al. (2011) showed that access-control bugs are proven one way: create two accounts and check whether account B can still reach account A's data through a hidden link. I won't run their code-scanning tool, since that would mean reading the source code and would break the black-box rule. I'll do the two-account check by hand instead.

AI tools can already suggest what to test, but a suggestion isn't proof. Happe and Cito (2023) used a language model as a sparring partner on an authorized lab machine: it proposed a plan, and a human ran the actual commands from there. They also found it invented commands, got unstable over long sessions, and needed a person watching to keep it from crossing lines (it refused to draft phishing content, for instance, and they kept that refusal). Deng et al. (2024) showed that a plain chatbot loses track of a long testing session: its context fills up, it fixates on the last message, and it invents command-line flags that don't exist. Breaking the work into small steps, keeping short notes instead of a long transcript, and having a person actually run each command fixed most of that and clearly raised how many sub-tasks got finished, compared with an unstructured chatbot. Their own live test on Hack The Box machines cost about $131 in GPT-4 usage, which matters because it shows that "automated" AI testing still has a real cost.

Peng et al. (2026) pointed out that most papers claiming "AI does penetration testing" don't even agree on shared vocabulary, and ran a genuinely massive comparison, thirteen frameworks and over ten billion tokens, that's far beyond what one semester could repeat. What I'm borrowing from them is their vocabulary, not their scale. The actual question I'm asking:

> Across several self-hosted fitness apps, tested only from the outside, what's the one weakness a small AI tester keeps naming? Do a standard scanner, a template scanner, and three different ways of running the AI tester (a person driving it, a few AI roles cooperating, one unsupervised overnight run) actually confirm that weakness? And how much of what the AI reports is real evidence versus confident-sounding guesswork?

Peng et al. found that adding more AI "roles," bigger tool menus, and mismatched reference material often doesn't help, and that AI testers frequently claim results they never actually verified. I'm checking those claims myself on fitness apps rather than assuming they hold. Three things get tested: OWASP ZAP, a standard scanner; Nuclei, HTTP-based rule matching and nothing fancier; and a small AI tester I build myself, run three different ways (person-driven, cooperating AI roles, unsupervised overnight).

I'm not deciding in advance what the main bug will be. The AI tester picks one OWASP category on its own, and I then check the real apps to see whether that category actually holds up. Once I know which apps show the problem, I fix it on one or two of them, retest, label the confirmed issues with OWASP and MITRE ATT&CK codes, and write a checklist covering the whole app family.

All of this has to fit inside one semester, so I'm not repeating Peng et al.'s enormous comparison. Local and cloud AI models both count as valid ways to run the same tester (see section 9.0).

---

## 2. What's missing right now

Small teams building fitness apps are missing two answers: which weakness actually shows up across this kind of app, and how much a small, open AI tester actually helps find and confirm it, compared with ordinary scanners, when nobody hands it the source code, an API specification, or inside knowledge.

Each of the five papers I'm drawing on answers part of this, not the whole thing:

| Paper | What it already showed | What it doesn't cover (and this project does) |
| --- | --- | --- |
| Papageorgiou et al. | Free health apps mishandle sensitive data; worth looking at as a family | No AI tester; looked at app-store apps, not self-hosted APIs |
| Sun et al. | Missing access checks are a real bug class; two accounts plus a hidden URL is the proof | Used source-code analysis, which is out of scope here; not fitness apps; no AI involved |
| Happe and Cito | AI can suggest pentest steps in an authorized lab; unsupervised AI raises ethical questions | One machine, one app; no scanner baseline; no family of apps |
| Deng et al. | Plain chat fails on long jobs; a person in the loop plus short notes works; measure finished sub-tasks, not prose | Tested on Hack The Box / VulnHub machines and cost real money; not fitness APIs |
| Peng et al. | Gave the field a shared vocabulary; more AI roles, tools, or reference material often don't help; AI testers invent success | Their comparison used thirteen frameworks and over ten billion tokens, far bigger than one semester, and not this app family |

Peng et al. didn't run source-code-based tests in their own comparison either, and I'm following that same line. Vendor blog posts often blur that distinction, rarely count when the AI claims a false success, and usually only cover one product.

What this project adds: a small, defensive, repeatable case study that speaks Peng's vocabulary, tests several fitness apps from the outside, lets the AI name the main weakness before I go looking for it, and compares a person-driven session against cooperating AI roles and an unsupervised overnight run. Local and cloud models are both allowed.

---

## 3. Research questions

- **RQ1.** Tested only from the outside, which main weakness does the AI tester name for this family of fitness apps, and how many running apps do ZAP, Nuclei, the person-driven session, the cooperating AI roles, and the overnight run actually confirm it on (with saved evidence)?
- **RQ2.** Once I review the results, what share of them holds up, both the overall claim and the per-app findings, and how often does the AI claim success with no real evidence behind it?
- **RQ3.** After a short round of fixes aimed at that one weakness on one or two apps, which confirmed findings disappear on a retest, and does the resulting checklist still make sense for the apps I didn't patch?

None of these require writing exploits, chaining bugs into a full attack, reading source code, or testing anyone's live production system.

---

## 4. Objectives

1. Get the five apps from Section 5 running (five is the goal, four is still a pass).
2. Bind each copy to my own machine (127.0.0.1) with two made-up user accounts each (different ports, or one app running at a time if memory is tight).
3. Build a small AI tester (short notes, a small set of HTTP actions, local and/or cloud model) and describe it using Peng et al.'s six design dimensions (Section 6.2).
4. Run ZAP and Nuclei against every running app, without giving them source code or an API specification.
5. Ask the tester, once, for the single main weakness. It only sees public README notes, short scanner category names, and routes visible during normal signup. It must answer with exactly one OWASP API Top 10 category and one sentence explaining why. I keep that category for the rest of the semester unless something clearly contradicts it later.
6. Check for that weakness on every running app with a person driving the AI session. On one representative app, also try cooperating AI roles and one unsupervised overnight run.
7. Mark every result as confirmed, false, or unverified.
8. Apply five to eight concrete fixes for that one weakness on one or two app copies.
9. Retest those copies with ZAP, Nuclei, and the person-driven AI session (cooperating roles and the overnight run aren't required on the retest).
10. Label every confirmed finding with an OWASP API Top 10 category and a MITRE ATT&CK technique.
11. Write a 20-30 page report and a hardening checklist for the app family.

---

## 5. The five fitness apps

Each app is a test target, not something I'm building or shipping. All tests run against my own Docker copies. Public production sites are never touched.

### 5.1 The set

These five apps are the actual experiment. I only drop one if it genuinely won't start during weeks 2-4, and I write down why. A pass needs at least four running apps.

| # | App | What it is | Why it's included |
| --- | --- | --- | --- |
| 1 | Workout.cool | Coaching platform: plans, exercises, progress tracking. Runs via Docker Compose. | First app to set up; modern web stack; has plan and history IDs to test. |
| 2 | FitTrackee | Outdoor activity tracker: GPS routes, maps, workouts. | Involves GPS and health-adjacent files, per-user activity data. |
| 3 | openGym | Gym and bodyweight tracker with passkey login. | Smaller surface, and passkey login is visible from the outside. |
| 4 | FitnessTrack | Strength-training logger. | Lightweight stack, easy to set up two accounts and compare logs. |
| 5 | Endurain | Activity tracker with GPX/TCX/FIT files, privacy settings, and followers. | Heaviest stack of the five; dropped with a written reason if it won't run. |

If one app won't start, I may swap in one extra self-hosted, multi-user fitness app (for example LibreFit) so at least four are still running. Closed commercial apps like Hevy, Strong, and MyFitnessPal, and any university production system, are out of scope.

### 5.2 What every remaining app needs to offer

- Login and at least two user accounts (this is what makes the two-account authorization test possible).
- Per-user data, such as workouts, metrics, GPX files, or plans, addressed by an ID.
- At least one export, upload, or sharing feature, since that's often where health-related data leaves the account.
- An HTTP interface reachable on localhost, so the testers never need the source code.

I only read source code later, to apply fixes on the one or two copies I patch. The scanners and the AI tester never see it.

### 5.3 How far I go on how many apps

| Step | What runs | On how many apps |
| --- | --- | --- |
| First pass | ZAP and Nuclei | Every running app |
| Name the main weakness | AI tester, person-driven, looking at the whole family | Once, using short notes gathered from all apps |
| Focused test | Same AI tester, person-driven, checking the chosen category | Every running app |
| Cooperating AI roles | Two or three AI roles sharing the same notes | One representative app |
| Overnight run | Unattended, stopped by a timer | One representative app, one night |
| Fix and retest | Five to eight fixes, then ZAP, Nuclei, and the person-driven AI session | One or two apps that showed the weakness |

I go wide across all five apps, but deep on just one weakness. I'm not deeply patching every codebase.

---

## 6. What I'm taking from the research papers

I'm not repeating Peng et al.'s huge thirteen-framework comparison. I'm reusing their definitions so the report reads clearly against that survey.

### 6.1 How much the tester is allowed to know

| Level | What it means | What I do |
| --- | --- | --- |
| White-box | Full source code and architecture are known; the main method is a code audit or static analysis. | Not used. I name it here so the boundary is explicit. |
| Grey-box | Partial inside knowledge: architecture hints, source snippets, or planted credentials beyond a normal signup. | Not used. No source, no API spec, and no map handed to any tool. |
| Black-box | Only the outside interface is visible. | The only level I test at. ZAP, Nuclei, and my AI tester only ever see localhost HTTP traffic and whatever a normal visitor could read. |

Peng et al.'s own comparison was black-box only. I'm keeping that and moving the target from CTF challenges to real fitness apps, using ZAP, Nuclei, and one small tester instead of their thirteen frameworks. Kill Chain, PTES, NIST SP 800-115, and ATT&CK stay as background reading and labeling vocabulary, not as a full attack-emulation lab.

### 6.2 How I'm describing my own AI tester

Peng et al. suggest describing any AI security tester along six dimensions. Here's how mine is set up:

| Dimension | Peng's question | How my tester handles it |
| --- | --- | --- |
| Who decides | One AI conversation, or several cooperating roles? | Three ways to run the same program: (A) one conversation with me driving it; (B) two or three cooperating roles (plan / run / review) sharing one notes file; (C) unattended overnight. Peng found extra roles often don't help, so I'm checking that here rather than assuming it. |
| How it plans | A straight line, a tree, or a graph, with feedback? | Person-driven: a simple loop or a small task list. Cooperating roles: they pass information through the shared notes file. Overnight: the same planner, just stopped by a timer. |
| Memory | Its own experience, or a big reference wiki? | Just its own experience: a notes file I maintain, plus short tool output. Same file across all three modes. No large hacking-wiki dump, since Peng found the wrong reference material often hurts results. |
| What it can call | A wide toolset or a narrow one? | A short menu: browser, curl, and ZAP/Nuclei history. Peng found that useful results came from ordinary HTTP and Python, not a huge tool list. |
| Where its knowledge comes from | Built in, fetched, or generated on the spot? | Two jobs only: name the main weakness from short notes, and test that category on each app. No generic exploit-payload library. |
| How I score it | What counts as success? | Success means a saved HTTP request and response, not a confident-sounding claim. Same rule for the overnight run. |

### 6.3 Ground rules I'm taking from Peng et al.

- Keep written notes. Don't rely on a long chat history to remember things correctly.
- Whether cooperating AI roles beat a single AI conversation is something I measure here, not something I assume going in.
- More tools aren't automatically better, so I'm using a short HTTP toolset and one AI tester run three ways, not three separate products.
- Reference material only helps if it actually matches the app; I'm not loading in a generic hacking wiki.
- The AI claiming success is common and often wrong, so every finding needs a saved request and response, including from the overnight run.
- A well-known coding model isn't automatically a good security tester, so I report exactly which model produced each result.

Each rule maps directly onto how I run this project rather than staying abstract.

### 6.4 Why the other four papers matter here

Peng et al. give me the vocabulary. The other four papers explain why the project is built the way it is. None of them is a fourth scored tool.

| What the paper found | What I do because of it |
| --- | --- |
| Free health apps already fail basic privacy and security practice, and the data involved is sensitive by nature (Papageorgiou et al.) | I test fitness/health apps specifically, use only made-up accounts, avoid production apps entirely, and produce a checklist for the whole family. |
| There's no single fix for access control; success means the weaker account still gets the privileged data (Sun et al.) | I test with two accounts on every app, confirm with the actual HTTP response rather than the AI's wording, and this is the default check whenever authorization is the named weakness. |
| AI works best as a sparring partner, not an unsupervised attacker; a high-level plan isn't the same as a low-level command loop; social-engineering content should be refused (Happe and Cito) | The person-driven session is my main scored mode. Cooperating roles and the overnight run are measured, not assumed to be better. No phishing-style content is generated. ATT&CK labels are only applied after a finding is confirmed. |
| Plain chat loses track of long jobs; a person in the loop plus a small task list improves results; unattended pentesting is genuinely hard; a live GPT-4 test cost about $131 (Deng et al.) | I use a notes file and a small task list, never paste a full scanner report into the AI, personally run the kind of check the AI names, count confirmed evidence rather than transcript length, and report which model I used and its cost if it's a cloud model. |
| Extra roles, large tool lists, and mismatched reference material often don't help; AI testers regularly invent success (Peng et al.) | One tester, run three different ways; a short HTTP toolset; no generic hacking-wiki dump; success is only counted when I have a saved request and response. |

This project stays small because the existing research already points to which choices matter. The reading isn't decoration; it's the reason the design looks the way it does.

### 6.5 Findings I'm citing, not re-running

**Papageorgiou et al. (2018), on the app category itself:** most of the free health apps they studied failed well-known security and privacy practice. Common problems included weak or missing logins, data not properly tied to the logged-in user, unprotected data in storage or in transit, third-party tracking, and privacy policies that didn't match actual behavior. A checklist is a reasonable output for a project this size.

**Sun et al. (2011), on what counts as an authorization finding:** access-control bugs don't have one universal fix, unlike something like SQL injection. The intended access rule shows in which links a role is shown; the bug is when a lower-privileged account can still open the hidden link and get the same response. On a fitness API, that means the same status code and the same data for user B requesting user A's object by ID.

**Happe and Cito (2023), on using an AI as a tester:** at a high level, AI models already know what a pentest plan looks like. At a low level, a closed command loop can act on an authorized lab machine, but it's unstable, inventing flags, leaking through filters, and rambling without memory. Ethically, they kept a person in the loop, refused phishing-style content, and treated ATT&CK as a grading reference rather than something the AI runs directly.

**Deng et al. (2024), on why a person in the loop matters:** plain GPT-3.5, GPT-4, and Bard can propose useful tools but lose track of the job. Their own tool, which uses a small task list, generation, and parsing, with a human running the actual commands, raised completed sub-tasks by 228.6% over a naive GPT-3.5 baseline across a 13-machine, 182-task benchmark. Their live Hack The Box test finished 4 of 10 machines at roughly $131 in GPT-4 usage. Cost is part of the result, and scoring partial progress (not just "fully solved or not") is what let them measure improvement at all.

**Peng et al. (2026), on tester architecture:** a single AI conversation with a simple loop often matched or beat several cooperating AI roles on easier tasks, so "more roles helps" stays a hypothesis rather than a fact. What actually mattered was memory quality, and the wrong reference wiki measurably hurt results. Giving the AI 30 tools versus 115 tools barely changed outcomes, which is why I'm using a short toolset. Plain coding-assistant prompts beat most dedicated open-source pentest frameworks, which is why I'm still building and describing my own tester rather than adopting a commercial one. Eight of thirteen frameworks they tested invented findings; full attack chains rarely completed (16.67%); and knowing a vulnerability's ID didn't mean the AI could actually exploit it (56.67% knew the ID and still failed). Their definition of success was an exact flag match. Mine is a saved HTTP request and response: same underlying idea, don't score talk.

### 6.6 What I actually run, versus what I only use as labels

Happe's model goes tactic to technique to procedure. I run a short list of black-box HTTP procedures. Once a finding is confirmed, I attach an OWASP API category and, where it fits, one ATT&CK technique. ATT&CK doesn't drive what the tester does; it's applied afterward.

**A. What I actually run (black-box, localhost, two made-up accounts):**

| What I run | Where it comes from | What I actually do |
| --- | --- | --- |
| Automated scan | Industry-standard baseline | OWASP ZAP's automated scan against 127.0.0.1 |
| Template-based HTTP matching | Nuclei | HTTP templates only, no exploit packs |
| Person-driven, short-memory AI session | Deng et al. | The AI names the kind of check to try next; I run curl or the browser myself; results go into short notes, not back into the AI's context in full |
| Naming the family-wide weakness | Happe (high-level planning) and Deng (task direction) | One session, one required output: exactly one OWASP API category for the whole set of apps |
| Two-account object swap | Sun et al. | User B requests user A's workout, GPX file, plan, or metric by ID; I compare the status code and response body |
| Login and session checks | Papageorgiou et al. (weak authentication) | Signup, login, cookie or token reuse, logout, checked over HTTP only |
| Export, upload, or sharing checks | Papageorgiou et al. (data leaving the account) | Unauthenticated or cross-user export/download attempts, if the app offers that feature |
| Shared notes file | Deng's task list and Peng's memory findings | Rows of finding, evidence pointer, and status; used across all three ways of running the tester |
| Before/after comparison | Deng's progressive scoring and RQ3 | Same black-box checks re-run after the fix |

I'm not using Metasploit, and password spraying isn't a main focus (if the AI suggests brute-forcing logins, I log that as a failure mode rather than acting on it). Active Directory and Kerberos examples from Happe's paper stay as background reading.

**B. Reference lists used only as labels, after a finding is already confirmed:**

The OWASP API Security Top 10 (2023) is the vocabulary the AI tester has to use when naming the one main weakness:

| ID | Category | Typical check if this is the category we keep |
| --- | --- | --- |
| API1 | Broken Object Level Authorization | The two-account swap on workouts, GPX files, or plans |
| API2 | Broken Authentication | Token and cookie handling |
| API3 | Broken Object Property Level Authorization | Extra fields (email, GPS, tokens) visible in another user's object |
| API4 | Unrestricted Resource Consumption | Only if I actually see evidence of it; no stress-testing as a goal |
| API5 | Broken Function Level Authorization | A regular user reaching an admin-only route the UI normally hides |
| API6 | Unrestricted Access to Sensitive Business Flows | Mass export or sharing, if I see evidence of it |
| API7 | Server-Side Request Forgery | Unlikely to be the main finding; secondary at most |
| API8 | Security Misconfiguration | Debug mode, default secrets, directory listings, usually caught by ZAP or Nuclei |
| API9 | Improper Inventory Management | Old or forgotten routes, if I see evidence of them |
| API10 | Unsafe Consumption of APIs | Secondary; third-party calls visible in the HTTP traffic |

MITRE ATT&CK technique, attached only to confirmed findings (or marked "no close match"):

| Technique | Name | When it applies |
| --- | --- | --- |
| T1190 | Exploit Public-Facing Application | Broken object or function authorization, or misconfiguration on the API |
| T1078 | Valid Accounts | Misuse of a normal login or session, not stolen production credentials |
| T1530 | Data from Cloud Storage Object | Export or download of GPX files, backups, or object storage |
| T1552 | Unsecured Credentials | Tokens or secrets visible in responses, clients, or misconfiguration |
| T1213 | Data from Information Repositories | Bulk history or metrics readable across accounts |
| T1110 | Brute Force | Only if the AI suggests it and HTTP shows no throttling; logged as a failure mode, not pursued as a campaign |

The messy curl commands stay in a private log. The public report only prints the category and the fix, never a step-by-step recipe.

---

## 7. Tools

The first two are ordinary scanners. The third is the small AI tester I build. Cooperating roles and the overnight run are two more ways of running that same tester, not two more products.

| ID | Tool / mode | What it is | Knowledge level | AI model used |
| --- | --- | --- | --- | --- |
| T1 | OWASP ZAP (automated scan, localhost only) | Standard scanner, no AI involved | Black-box | None |
| T2 | Nuclei (HTTP templates, localhost only) | Template-based scanner, still no source code | Black-box | None |
| T3, person-driven | My own tester, one conversation, I run the HTTP myself | Short notes plus a small toolset; names the main weakness, then tests it per app. If the program breaks, a 15-question fallback list covers the same ground. | Black-box | Local and/or cloud |
| T3, cooperating roles | Same program, two or three roles (plan / run / review) | They share the same notes file; no extra tool menu | Black-box | Same as above |
| T3, overnight | Same program, unattended | Stopped by a timer; one representative app, one night | Black-box | Same as above |

"The tester I write" means a small program of my own: prompts, a notes file, a thin wrapper around curl and saved HTTP traffic, and calls to a local runtime (for example Ollama) and/or a cloud chat API. Deng et al.'s task-list design is the reference I'm building on, not a separate fourth tool. No model training, no giant tool router, and no exploit payloads in the public repository. Switching between a local model and a cloud model, or between vendors, doesn't count as a new tool; the report just names which model produced each result.

Why these three, and not commercial AI-pentest products or a source-code scanner as extras: Peng et al. found that a short HTTP toolset works about as well as a huge one. Semgrep and similar tools require reading source code, which breaks the black-box rule (they're named in Section 8.3 instead). Cooperating roles and the overnight run are included specifically so I can check Peng's claim about extra autonomy on this app family, not because I assume they'll help.

---

## 8. Scope

### 8.1 In scope

- Several Dockerized fitness apps running on localhost (Section 5)
- Made-up accounts only
- Black-box testing only
- ZAP, Nuclei, and the AI tester I build
- Cooperating AI roles, tested on one app
- One unsupervised overnight run, on one app, stopped by a timer
- Local and/or cloud models for the AI tester, with every call logged
- The AI naming the single main weakness (one OWASP API category, kept for the rest of the semester)
- Login, authorization, secrets, sessions, export, and upload, as seen from the outside
- Fixing and retesting the same way on one or two app copies
- OWASP API and ATT&CK labels on confirmed findings
- A short taxonomy section in the report explaining why grey-box and white-box testing aren't used
- A 20-30 page report

### 8.2 Out of scope

- White-box testing (full code audits, static analysis as the main method, formal verification)
- Grey-box testing (source code or API specs handed to the tester, a Semgrep-style scan, or insider maps used as a scored input)
- Testing only one app, unless fewer than four can be started, in which case I document why rather than quietly shrinking the project
- Commercial AI-pentest products, scored as tools
- Testing any app's live production system
- Full mobile reverse engineering, jailbreaking, or Active Directory attack simulation
- Real wearable devices or real health records
- Publishing exploit proof-of-concept code
- Repeating Peng et al.'s full thirteen-framework comparison
- Picking the "main weakness" myself before the AI names one
- Patching every app in the set
- A full 50-80 page thesis

### 8.3 Tools I considered but won't run

About half a page in the final report names tools like Semgrep (requires source code), and several mobile-specific and enterprise attack-emulation tools, explaining briefly why each is out (knowledge level, licensing, hardware, or cost). If time allows after week 10, I may add ten local test cases against an in-app chat feature, but this is optional and dropped first if the schedule slips.

---

## 9. Method

### 9.0 Local and cloud models

The AI tester can call local models (through something like Ollama) and cloud chat APIs. Both are allowed and both drive the same tester, not two separate experiments.

| Rule | What I actually do |
| --- | --- |
| Which models | Local, cloud, or both, over the course of the semester |
| Logging | Every call: date, mode, app, task, model name, and whether it ran locally or in the cloud |
| Prompt size | Short evidence only, never a full scanner dump pasted into the prompt |
| Switching models | Not a new experiment, just a logged event |
| Overnight run | Allowed, stopped by a timer, localhost only |

### 9.1 Black-box testing steps

**First pass, on every running app:** give the AI only that app's base URL and the fact that it's an authorized lab, nothing about the source or architecture. Create two accounts through normal signup (this stays black-box). Run ZAP's automated scan and Nuclei's HTTP templates. The result is a short list of finding categories with pointers to evidence, not full scan dumps, so the AI has something manageable to work from later.

**Naming the main weakness, once, across the whole family:** the AI is only allowed public README notes, short category names from the scans, and route patterns visible during signup. It's not allowed source code, API specs, exploit recipes, or my own guess. It has to answer with exactly one OWASP API category, one explanatory sentence, and which apps it thinks show it. I either keep that answer or, if the session produced nothing usable, discard it and run once more. I don't shop around for a different answer I like better.

**Focused test, on every running app:** the AI may know the category name (that's the working hypothesis), but it still doesn't get source code or ready-made payloads. I run only the kind of check it suggests and save the evidence. If the category is authorization-related, the default check is Sun's two-account URL swap.

### 9.2 What counts as ground truth

I'm measuring the category the AI actually named, not a secret bug list I wrote for myself beforehand. The category kept from the naming session is the main hypothesis (RQ1); confirmed per-app HTTP findings in that category support or reject it; other confirmed findings are secondary and don't get promoted to "main" partway through. If the scanners end up showing a different category more often, that's a valid result (the AI's claim didn't hold), not a reason to change the plan.

### 9.3 Metrics

| Metric | What it means |
| --- | --- |
| Main-category hit rate | Apps with at least one confirmed finding in the chosen category, divided by apps running |
| Tool agreement | Which of ZAP, Nuclei, and the AI tester actually contributed each confirmation |
| Precision | Confirmed findings divided by reported findings, per tool and per app |
| Evidence rate | Share of findings backed by a saved request and response |
| False-success count | Times the AI claimed a finding, or claimed it was "done," with no usable evidence |
| Category quality | Whether the chosen category matches the most frequently confirmed one |
| Time | Hours spent per tool per app |
| AI calls | Count, plus local versus cloud, from the call log |
| Retest change | Chosen-category findings still open after the fix |
| Coverage by category | Chosen category versus everything else, using OWASP API |

No statistical significance testing. Clear tables match the scale of this project.

### 9.4 Labeling confirmed findings

Each confirmed finding gets one row: which app, which check produced it, the OWASP API category, the ATT&CK technique, and whether it touches privacy-sensitive data such as workouts, GPS, or metrics. Allowed ATT&CK codes are the six listed in Section 6.6, or "no close match."

### 9.5 Fixing and retesting

I pick one or two app copies that showed the chosen category (Workout.cool first if it's affected, plus whichever other app is easiest to patch), and apply the smallest changes that actually close that category: ownership checks, login requirements on export routes, secrets moved server-side, locked-down role changes, login throttling, and debug mode turned off. I then rerun ZAP, Nuclei, and the person-driven AI session on those copies only. Reading source code to apply the fix is defender work, not a grey-box test; the checklist still applies to every app in the set that shares the same weakness, even the ones I didn't patch.

---

## 10. Work plan

Each phase has a clear purpose and a clear "done" condition. Optional extras can slip; the core phases can't.

### Phase 0, week 1: set the frame

| Step | What I do |
| --- | --- |
| 0.1 | Read the five papers (map in Section 6.4) to build shared vocabulary |
| 0.2 | Write a two-page protocol covering the three tools, black-box scope, multiple apps, and ethics |
| 0.3 | Confirm that a local and/or cloud model responds through my tester |

*Goal: a Peng-taxonomy case study across several apps, not a single-target demo.*
*Done when: signed ethics page, protocol written, and one successful AI test call (local or cloud).*

### Phase 1, weeks 2-4: bring the apps up

| Step | What I do |
| --- | --- |
| 1.1 | Start each app from Section 5 in Docker, with two made-up accounts each |
| 1.2 | Record the exact image tag or commit hash used for each app |
| 1.3 | Drop any app that won't start, and keep a written log of why |
| 1.4 | Set up the notes file and the AI-call log from day one |

*Goal: authorized, version-pinned, multi-user fitness systems running locally.*
*Done when: at least four apps accept two made-up users on localhost.*

### Phase 2, weeks 5-6: first pass on every app

| Step | What I do |
| --- | --- |
| 2.1 | Bind all ports to localhost; made-up data only |
| 2.2 | Run ZAP's automated scan on each app, keeping only evidenced results |
| 2.3 | Run Nuclei's HTTP templates on each app, same evidence rule |
| 2.4 | Build one comparison sheet: app by tool by OWASP category |

*Goal: see what two ordinary scanners find, with no inside knowledge, across the whole family.*
*Done when: ZAP and Nuclei tables exist for every app in the set.*

### Phase 3, first half of week 7: the AI names the main weakness

| Step | What I do |
| --- | --- |
| 3.1 | Run one person-driven session: short scan summaries, README notes, and observed routes only |
| 3.2 | Require exactly one OWASP category, one sentence, and which apps it's claimed on |
| 3.3 | Keep that answer, or discard and rerun once if the session produced nothing usable |

*Goal: let the AI pick the family-wide category, rather than me picking a favorite.*
*Done when: the chosen category is written down in the notes file.*

### Phase 4, second half of week 7 into week 8: test that weakness everywhere

| Step | What I do |
| --- | --- |
| 4.1 | Run the person-driven tester on each app, allowed to know the category name but not the source |
| 4.2 | Personally run only the kind of check it suggests, and save the HTTP evidence |
| 4.3 | Update the notes file from confirmed evidence only |

*Goal: check whether the named category actually holds up across the app family.*
*Done when: a per-app results table is complete, with the AI-call log up to date.*

### Phase 5, week 8: review and label

| Step | What I do |
| --- | --- |
| 5.1 | Mark every finding as confirmed, false, or unverified |
| 5.2 | Count how often the AI claimed success with no evidence |
| 5.3 | Check whether the chosen category matches the most frequently confirmed one |
| 5.4 | Add OWASP API and ATT&CK labels to confirmed findings |

*Goal: turn raw results into a defensible picture of the app family, not just a scanner export.*
*Done when: every confirmed issue has a label, and the hit rate is calculated.*

### Phase 6, weeks 9-10: fix the chosen weakness

| Step | What I do |
| --- | --- |
| 6.1 | Pick one or two apps that showed the chosen category |
| 6.2 | Implement five to eight targeted fixes for that category |
| 6.3 | Commit changes with messages that reference the specific finding |

*Goal: close the main finding on a small number of apps, rather than patching everything shallowly.*
*Done when: five to eight fixes are merged into the chosen app branch or branches.*

### Phase 7, weeks 10-11: retest

| Step | What I do |
| --- | --- |
| 7.1 | Rerun ZAP on the patched copy or copies |
| 7.2 | Rerun Nuclei |
| 7.3 | Rerun the person-driven AI session, with the same restrictions as before |
| 7.4 | Build the before/after table and finish the checklist for the rest of the apps |

*Goal: show that the fixes actually worked, from the outside, not just on paper.*
*Done when: a before/after table exists for the patched apps, plus a checklist for the whole set.*

### Phase 8, weeks 12-14: write it up and demonstrate it

| Step | What I do |
| --- | --- |
| 8.1 | Write the report chapters (Section 13) |
| 8.2 | Finish the hardening checklist for the chosen category |
| 8.3 | Prepare a 10-15 minute demo showing two accounts on two apps, before and after the fix |
| 8.4 | Keep a buffer for delays without dropping RQ3 |

*Goal: a complete, graded semester report.*
*Done when: final PDF, tables, call log, and demo are all ready.*

---

## 11. What a good outcome looks like

The project succeeds if the final report can state, with tables:

- which OWASP API category the AI named as the main weakness for this app family
- whether that category was confirmed on k of n running apps, or wasn't, since either is a valid result
- whether ZAP and Nuclei agreed with the AI, and whether the AI added authorization-style findings the scanners missed
- how many findings were confirmed versus invented or unsupported (RQ2), including whether the naming session itself lacked evidence
- how many chosen-category findings remained after fixing one or two apps
- a complete AI-call log, showing local versus cloud use and which models were involved

A mixed result is fine. For example: the AI named broken object-level authorization as the main weakness; the scanners mostly found configuration noise; HTTP testing confirmed the weakness on three of five apps; and about half of the AI's claims lacked real evidence.

---

## 12. Deliverables

| Deliverable | What it is |
| --- | --- |
| Lab set | Docker copies of every running app, pinned to a specific version, plus a log of any that didn't start |
| Main-weakness record | The chosen OWASP category, the prompt used, the AI's reply, and the date |
| Evaluation pack | Tables by app and tool, raw scanner reports, and the AI-call log |
| Report | 20-30 pages |
| Taxonomy note | One to two pages explaining how my tester maps to Peng's six dimensions, and why grey-box and white-box testing were excluded |
| Label table | OWASP API and ATT&CK codes for confirmed findings |
| Hardening checklist | Two to four pages covering the chosen weakness across the app family |
| Demonstration | 10-15 minutes, showing at least two apps |

---

## 13. Report outline

1. Introduction and research questions
2. Background: fitness-app threats (Papageorgiou et al.), what an access-control finding looks like (Sun et al.), and the Peng taxonomy (knowledge levels, six dimensions, why testing stays black-box)
3. Related work: the five papers, mapped as in Section 6.4, plus tools considered and not run
4. Targets: the five apps, what started and what didn't
5. Method: the three tools, what's actually run versus only used as labels, the black-box protocol, how the AI names the main category, metrics, ethics, and model choice
6. Work-plan recap (one page)
7. Results: RQ1 through RQ3, with the chosen category, hit rate, false-success count, and retest outcome
8. Discussion: what to fix first in this app family, and what Peng et al. predicted that actually showed up here
9. Limitations: model choice, no grey-box or white-box testing, fixes applied to only one or two apps
10. Conclusion

Appendices: tool versions, prompts used, finding IDs, the AI-call log, Nuclei template IDs, and the main-weakness record.

---

## 14. Semester timetable

| Weeks | Phase | Hours |
| --- | --- | --- |
| 1 | 0: Set the frame | 15 |
| 2-4 | 1: Bring up the apps | 50 |
| 5-6 | 2: First pass on every app | 40 |
| 7 | 3-4: AI names the weakness, then focused testing | 25 |
| 8 | 5: Review and label | 20 |
| 9-10 | 6: Fix one or two apps | 25 |
| 10-11 | 7: Retest | 20 |
| 12-13 | 8: Write the report | 40 |
| 14 | Buffer and demo | 20 |
| **Total** | | **~255** |

What keeps this inside one semester: scan every app but only fix a couple, and stick to one chosen weakness instead of chasing every finding.

---

## 15. Ethics, privacy, and legal notes

- Only self-hosted copies are tested, never production fitness apps.
- All accounts and health values are made up.
- Local models keep everything on my own machine. Cloud models are allowed, but only short, synthetic lab data is sent, never a full scan dump, and I record in the ethics appendix whenever a prompt leaves the machine.
- No exploit recipes or working payloads appear in the public report, only categories and fixes.
- The naming prompt asks the AI for an OWASP category, not a working attack.
- Detailed logs stay private; only aggregated tables are published.
- A one-page ethics appendix gets signed in week 2.
- I'm studying AI testers in order to help defenders, not attackers, so no phishing- or social-engineering-style content gets generated.
- The overnight run happens on exactly one app, with a timer, because Happe and Cito flagged unsupervised AI as the riskier setup, and Peng et al. asked whether that extra autonomy actually helps.

---

## 16. References

[1] G. Deng, Y. Liu, V. Mayoral-Vilches, P. Liu, Y. Li, Y. Xu, T. Zhang, Y. Liu, M. Pinzger, and S. Rass, "PentestGPT: Evaluating and harnessing large language models for automated penetration testing," in *Proc. 33rd USENIX Security Symposium*, 2024, pp. 847-864.

[2] A. Happe and J. Cito, "Getting pwn'd by AI: Penetration testing with large language models," in *Proc. 31st ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering*, 2023, pp. 2082-2086.

[3] Peng, Li, You, et al., "Hackers or hallucinators? A comprehensive analysis of LLM-based automated penetration testing," arXiv:2604.05719, 2026.

[4] F. Sun, L. Xu, and Z. Su, "Static detection of access control vulnerabilities in Web applications," in *Proc. 20th USENIX Security Symposium*, 2011.

[5] A. Papageorgiou, M. Strigkos, E. Politou, E. Alepis, A. Solanas, and C. Patsakis, "Security and privacy analysis of mobile health applications: The alarming state of practice," *IEEE Access*, vol. 6, pp. 9390-9403, 2018.

The OWASP API Security Top 10 (2023) and the MITRE ATT&CK matrix are used as labeling standards, not counted among these five research papers.

---

## Appendix A. Kickoff checklist

1. Confirm the one-semester format with the supervisor using this document.
2. Bring up Workout.cool first, then FitTrackee, openGym, FitnessTrack, and Endurain, logging any that don't start.
3. Install ZAP and Nuclei, confirm a local and/or cloud model works, and build the tester, starting with the person-driven mode.
4. Scan every running app before running the naming session.
5. Keep whichever weakness the AI names, without overriding it with a personal favorite.
6. Maintain the notes file and the AI-call log from the very first call.
7. Once findings are confirmed, fill in the OWASP and ATT&CK labels, without adding a grey-box or white-box round.