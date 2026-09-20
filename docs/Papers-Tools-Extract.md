# Tools named in the five papers

Extract of **named tools, platforms, models, and analysers** in Papageorgiou et al. (2018), Sun et al. (2011), Happe & Cito (2023), Deng et al. (2024), and Peng et al. (2026).  

**Role** column: **used** = the authors ran it in their own experiment; **built** = they implemented it; **bench** = it is the testbed; **banned / contrast** = they mention it to exclude or compare; **discussed** = named in related work or taxonomy, not scored in *this* paper’s lab.

This is a reading index, not a how-to. No payloads or attack procedures.

---

## 1. Papageorgiou et al. (2018) — mHealth audit

The paper is an empirical **privacy/security study of freeware mHealth apps**. It emphasises **methods** (static APK inspection, dynamic traffic, functional tests, GDPR checklist, longitudinal re-check) more than a long brand list. Named or implied instruments:

| Name | Role | How it was used | Why |
| --- | --- | --- | --- |
| **Google Play / freeware app stores** | used | Source of popular wellbeing/mHealth APKs | Sample what millions actually install, not hospital EHRs |
| **Android (APK, manifest, components)** | used | Static look at permissions, exported components, backup flags, SDKs, hardcoded endpoints | See what the vendor shipped without needing a live account |
| **Device / emulator runtime** | used | Dynamic: run advertised features (log a session, sync, share, export) | Traffic and storage only appear at runtime |
| **TLS / HTTP traffic inspection** (proxy-class; paper describes interception of app traffic) | used | Watch first-party and third-party destinations, TLS vs cleartext, payload fields | Test whether notices match flows |
| **GDPR principles table** | used | Score consent, purpose, minimisation, storage, integrity, transparency, transfers | Legal layer on top of “we had TLS” |
| **App version history / updates** | used | Revisit the same apps over time | See if vendors fix issues (often they do not) |

**Not in this paper as scored products:** MobSF, Frida, ZAP, LLMs. Later mHealth papers use those brands; do not project them onto 2018 unless the PDF names them.

---

## 2. Sun, Xu, and Su (2011) — static access control

The “tools” are a **static analyser stack** for PHP, not a pentest distro.

| Name | Role | How it was used | Why |
| --- | --- | --- | --- |
| **Their analyser (unnamed product; OCaml)** | built / used | Infer per-role sitemaps, subtract privileged pages, compare weak-role vs strong-role HTML | Find missing access checks without a full handwritten spec |
| **Wassermann & Minamide PHP string analyser** | used (base) | Approximate possible HTML strings of PHP pages | Prior work analysed pages in isolation for injection; they add **roles and links** |
| **Z3** | used | Path feasibility (arithmetic) so dead `if (admin)` branches are not explored for the weak role | Scale: skip impossible HTML |
| **Custom string solver** | used | Complement Z3 on stringy PHP | PHP concatenates URLs in ways SMT-arith cannot |
| **PHP** | bench language | Unmodified real PHP apps | 2011 web stack they could analyse statically |
| **DFA / CFG constructions** (algorithms, not a GUI tool) | used | Extract `<a>`/`<form>`/`<iframe>` URLs from a grammar of HTML | Terminate link extraction; avoid enumerating infinite strings |

**Not used:** crawlers as the main finder (they argue crawlers miss hidden admin links); Semgrep; REST IDOR scanners.

---

## 3. Happe & Cito (2023) — LLM as sparring partner

Short paper: two prototypes plus ethics. Linux **privilege-escalation commands are not copied here**.

| Name | Role | How it was used | Why |
| --- | --- | --- | --- |
| **GPT-3.5 / ChatGPT** | used | High-level plans; low-level SSH loop brain | Then-available chat LLM |
| **AgentGPT** | used | High-level: plan a domain-admin-shaped engagement | Test whether models know the *genre* of a pentest plan (tactics/techniques) |
| **AutoGPT** | used | High-level: draft an external pentest plan (with a company’s approval) | Same; also showed hosted **ethical filters refusing** live phish/scan |
| **hackingBuddyGPT** (their SSH loop) | built / used | Model emits a shell command → run on lab guest → stdout back | Test low-level *procedures* on an **authorized** training VM |
| **SSH** | used | Channel to the guest | Closed loop without a human typing every command |
| **`lin.security` (vulnerable Linux training VM)** | bench | Deliberately broken guest; they report the loop often reached root **on that image** | Authorized lab, not production |
| **MITRE ATT&CK** | discussed / rubric | Grade whether a “colleague” speaks tactics → techniques → procedures | Coverage language; **not** a runtime that drives the agent |
| **llama.cpp / local Llama, StableLM, Dolly, Koala** | discussed | Named as future/local alternatives to cloud GPT | Data stays on prem; fine-tune possible; no vendor filter |
| **linpeas-class enumerators** | contrast | Compared as hardcoded checklists vs wandering LLM | Stability discussion: LLMs less deterministic |
| **BabyAGI-style summarisers / generative-agent “reflection”** | discussed | Vision: compress memory instead of stuffing 4k-token stdout | Context windows were small |

**Explicitly refused:** LLM phishing/vishing generators.

---

## 4. Deng et al. (2024) — PentestGPT

Measurement of chat LLMs + HITL system. Human **executes**; model **proposes**.

### 4.1 What they ran

| Name | Role | How it was used | Why |
| --- | --- | --- | --- |
| **GPT-3.5** (8k) | used | Naive HITL on the bench | Cheap/weaker chat baseline |
| **GPT-4** (32k) | used | Naive HITL + PentestGPT brain; live HTB spend ~**$131** | Strongest then-available chat model |
| **Bard / Gemini-class chat** | used | Same HITL protocol | Third commercial chat |
| **ChatGPT / Bard UI** (§4) | used | Interaction before the custom agent runtime | Measure off-the-shelf chat, not a hidden scanner |
| **PentestGPT** (Reasoning + Generation + Parsing, **PTT**) | built / used | Three sessions; human runs the next step | Repair context-loss: keep a task tree, truncate dumps |
| **Human executor on Kali 2023.1** | used | Runs proposed commands on a private lab net | Models cannot click Kali; fairness: tester must not add pentest insight |
| **Hack The Box / VulnHub machines (13)** | bench | Walkthroughs split into **182 sub-tasks** | Progressive score, not only root/no-root |
| **picoMini CTF** | used (practicality) | Show HITL on a live contest | Usability beyond the frozen bench |
| **nmap-class scanners** (as *model-chosen* tools) | used when the model asks | Human runs them; output truncated into the PTT | Common recon; paper reports models are good at this family |
| **sqlmap-class, targeted validators** | allowed | If the model asks for a **class-specific** checker | Distinguish “LLM skill” from “Nessus with a chat wrapper” |
| **Burp-class GUI** | allowed if unavoidable | Tester describes clicks/responses back to the model | Some web steps need a proxy UI |

### 4.2 What they banned or contrasted

| Name | Role | How / why |
| --- | --- | --- |
| **OpenVAS, Nexus, other end-to-end scanners as the *brain*** | banned | Would measure the scanner, not the LLM |
| **Juice Shop as the only bench** | contrast | Too narrow; no priv-esc stories |
| **Binary root/no-root scoring** | contrast | Throws away useful middle steps |

---

## 5. Peng et al. (2026) — *Hackers or Hallucinators?*

Two layers: **(A) systems they actually ran** on XBOW; **(B) tools/frameworks named in the SoK** (related work / taxonomy) that were **not** the 13+2 bake-off.

### 5.A Bake-off: subjects, brains, range, execution tools

**Why this set:** open source, architecturally distinct, end-to-end, census **1 Jan 2026**. Success = submitted string **equals** the XBOW flag.

#### AutoPT frameworks they scored (13 + 2 baselines)

| Name | Role | How / why in *this* paper |
| --- | --- | --- |
| **PentestGPT** (GH05TCREW autonomous fork) | used | PTT + reasoning/generation/parsing, made unattended | Famous HITL design, scored as AutoPT; **S=18** (weak memory on this bench) |
| **VulnBot** | used | Multi-agent, penetration task **graph**, staged recon/scan/exploit | Graph/macro-linear design; **S=27** |
| **CTFSOLVER** | used | Parallel pipeline, PoC-first, knowledge injection | Strongest OSS score (**S=88**); YAML PoCs helped on known vulns |
| **LuaN1ao** (LuaN1aoAgent) | used | Plan–execute–reflect, task/causal **graphs**, KB | Best Hard (**S=83**); KB removal **raised** score 83→90 |
| **Tinyctfer** | used | Single agent on **Claude Code**, Python SOP | Coding-agent runtime + AutoPT scaffolding; **S=68** |
| **XBow-Comp** (XBow-Competition) | used | **Kimi CLI** + skill library | Skills vs bare Kimi; **S=77**; KB slightly helped |
| **Cruiser** | used | Cross-session ReAct, light KB, scratchpad | KB removal **42→57** (mismatch hurts) |
| **CHYing** | used | **LangGraph** hierarchy, pre-recon skills | Multi-agent NL hand-off; **S=40**; many hallucinations |
| **SickHackShark** | used | Multi-agent, vuln-relationship graph, notes | **S=77**; notes as memory |
| **newmapta** | used | **CrewAI** + RAG memory | Orchestration tax; **S=54** |
| **sub-agent-autopt** | used | Planner + executor, sandbox, ReAct | **S=32** |
| **CyberStrikeAI** | used | Dual-agent, retrieval, compression; **30 vs 115 tools** ablation | Tool-pool size ~flat; unused summarizer → treated as single-agent; **S=55** |
| **H-Pentest** | used | Multi-planner, supervision, compression | **S=48** |
| **baseline-kimi** | used | Same short prompt, XBow-Comp **tools without skills** | Control: coding agent + terminal; **S=72** (beats most OSS) |
| **baseline-cc** (Claude Code) | used | Same prompt/tools as baseline-kimi | Cross-runtime control; **S=69** |

#### Backbone models (brains)

| Name | Role | How / why |
| --- | --- | --- |
| **DeepSeek-Chat-v3.2** | used (default) | Same brain on all 15 systems | Fair architecture comparison, not “who bought GPT-4” |
| **Claude Opus 4.6, GPT-5.2, Gemini Pro 3.1, DeepSeek-Reasoner-v3.2** | used (ablation) | Swap brain on CTFSOLVER and XBow-Comp | Test whether SWE-bench fame = AutoPT skill (GPT-5.2 was **weak** here) |

#### Range and calling layer

| Name | Role | How / why |
| --- | --- | --- |
| **XBOW** web-CTF subset (22 challenges) | bench | Original tasks, canaries, flag equality | Less write-up leakage than PicoCTF farms; web logic discriminates |
| **Kali / kali_terminal** | used | Shell for agents that live in a pentest distro | Classic PT toolbox |
| **curl / HTTP request tools** | used | Primary web interaction in logs | Fitness-API analogue of “talk to the app” |
| **Python execute / Jupyter kernel** (some agents) | used | Generate checks when a named PT binary is missing | Fallback; Peng: this **fails on Hard** |
| **nmap / Nuclei / Metasploit / Netcat / Burp / Playwright** | discussed + some logs | Taxonomy of execution layers; CHECKMATE turns Nuclei/Metasploit/NSE into planner actions | Show tool *classes*; CyberStrike ablation: **more Kali packages ≠ higher S** |
| **HackTricks** (and similar RAG corpora) | used inside some frameworks / ablated | Retrieved write-ups/payloads into the prompt | Often **hurt** when the retrieved app ≠ this target |
| **Milvus** (VulnBot) | discussed / in system | Vector store of successful tasks | Example of experience-DB memory |
| **MCP / function calling** | discussed | How tools are invoked | Calling convention, not a scanner |

#### Named in SoK but **not** in the 13+2 scoreboard (examples)

Peng **discusses** these so the taxonomy is complete. They were **not** all rerun under the XBOW protocol.

| Name | Why it appears |
| --- | --- |
| **ARACNE, AutoAttacker, PenHeal, cochise, PentestGPT-v2, RapidPen, HackSynth, PentestAgent, xOffense, CHECKMATE, Incalmo, EnIGMA, CTFAgent, RefPentester, AutoPentest, PTFusion, MAPTA, hackingBuddyGPT** | Architecture/plan/memory/knowledge examples |
| **AutoPT-Sim** | Simulator, not a multi-framework bake-off |
| **PicoCTF, OverTheWire, NYU CTF, InterCode-CTF, Cybench, VulnHub, HTB, Vulhub, AutoPenBench, PACEbench, GOAD** | Other *benchmarks* in the literature |
| **NodeZero, Pentera, Hadrian, Escape, Burp AI** | Commercial; **excluded** (not open / not rerunnable) |
| **ATT&CK, PTES, NIST SP 800-115, Kill Chain** | Human process models — labels, not AutoPT runtimes |

---

## 6. Cross-paper index (same name, different job)

| Tool / name | Papers | Job in each |
| --- | --- | --- |
| **PentestGPT** | Deng **built** HITL; Peng **scored** an autonomous fork | Deng: human executor + PTT. Peng: unattended on XBOW, low score |
| **hackingBuddyGPT** | Happe **built**; Peng **discusses** | Happe: SSH lab loop. Peng: example of HackTricks-guided execution |
| **Hack The Box / VulnHub** | Deng **bench**; Peng **discusses** as single-host benches | Deng’s 13 boxes vs Peng’s choice of XBOW instead |
| **GPT-3.5 / GPT-4** | Happe, Deng **used**; Peng uses **GPT-5.2** only in ablation | Different generations; do not mix scores |
| **ATT&CK** | Happe rubric; Peng process model / knowledge | Neither paper drives the agent *with* ATT&CK as a control plane |
| **nmap / Kali** | Deng (model-chosen, human-run); Peng (agent-called) | Same family, different autonomy |
| **Z3 / PHP analyser** | Sun only | Static sitemap, not LLM |
| **Android / Play Store** | Papageorgiou only | Client privacy, not AutoPT |

---

## 7. What this lab does *not* inherit as scored tools

From the proposal: **OWASP ZAP**, **Nuclei**, and a **student AutoPT agent** are the three scored instruments. They are **not** the Papageorgiou/Sun/Happe/Deng/Peng lab kits. Peng’s 13 frameworks and Deng’s HTB boxes stay in related work unless the supervisor adds a named extra.

See also: [`AI-Pentesting-Tools-Research-Catalog.md`](AI-Pentesting-Tools-Research-Catalog.md) (market landscape, not “tools the five papers ran”).
