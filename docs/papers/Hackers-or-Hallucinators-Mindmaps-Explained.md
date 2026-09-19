# What each mind map means, and how tools were used

Companion to [Hackers-or-Hallucinators-Mindmaps.md](Hackers-or-Hallucinators-Mindmaps.md) and Peng et al., arXiv:2604.05719. The long section guide is [Hackers-or-Hallucinators-Paper-Sections-Explained.md](Hackers-or-Hallucinators-Paper-Sections-Explained.md).

The diagrams are **trees of the paper**, not attack playbooks. “Tools” here means what the **AutoPT agents** were allowed to call inside an educational CTF range.

---

## How to read a map

Each flowchart is a **hub → branches**. The circle/box at the top is the section. Children are the ideas that section actually argues. The prose under the diagram in the first file is extra detail; this file is the spoken explanation.

---

## Map 0 — Whole paper

**What it is saying:** this is not “we built a new hacker agent.” It is (1) a **taxonomy** of how LLM AutoPT systems are built, and (2) a **bake-off** of 13 open-source systems plus 2 simple coding-agent baselines, all on the same web CTF subset.

**Why the numbers matter:** two independent runs, image reset, >10B tokens, >1500 logs, 15+ people reading logs. The default brain is **DeepSeek-Chat-v3.2**. Other models appear only later, in the ablation.

**Ten findings in one sentence:** fancy multi-agent + huge tool menus + big knowledge bases often lose to a **single ReAct loop**, **good memory**, and **plain HTTP/Python tools**.

---

## Map 1 — Introduction

**Problem:** human pentests are slow and expensive; companies still need them for PCI DSS / DORA.

**LLM promise:** agents that plan, call tools, and keep going.

**Two holes in prior work:** no architectural SoK of *LLM* AutoPT; no fair comparison of many frameworks on one bench.

**What the authors contribute:** six design dimensions + 15 systems + KB/LLM ablations + public logs.

---

## Map 2 — Overview

**Scope lock:** **black-box only**. The agent does not get source code. It only sees what a remote web app returns.

White-box (SAST) and grey-box are mentioned so you do not mix them in.

Classic models (Kill Chain, ATT&CK, PTES) are **background**, not what they run in the lab.

**Motivation of the SoK:** old papers talk about DRL agents; LLM essays stay high-level; nobody ran many LLM frameworks on one range.

---

## Map 3 — Six dimensions (the taxonomy hub)

Every AutoPT system answers three questions:

| Question | Dimensions |
| --- | --- |
| Who decides? | 3.1 Architecture |
| How does it act? | 3.2 Plan + 3.4 Execution (tools) |
| What does it remember / look up? | 3.3 Memory + 3.5 Knowledge |
| How do we score it? | 3.6 Benchmarks |

The rest of Section 3 is just unpacking those boxes.

---

## Map 3.1 — Agent architecture

**Agent** = one LLM with its **own role, context window, and authority**. A summarizer with its own window counts as a second agent.

**Roles** are usually **prompted** (cheap, can drift). Some papers **fine-tune** (Pentest-R1, xOffense).

**Almost every multi-agent system** splits: planner / executor / summarizer. Some add recon, RAG retrieval, a supervisor, a reflector.

**Two collaboration styles:**

- Fixed pipeline: planner → interpreter → exec → summary (ARACNE-style).
- Supervisor assigns specialists (AutoPentest, BreachSeek).

**Single-agent:** one ReAct loop. In *this* experiment Tinyctfer, XBow-Comp (under DeepSeek), and CyberStrike behaved as single-agent because extra roles **never fired**.

**Lesson:** “multi-agent” on GitHub is not a performance guarantee. CTFSOLVER works because parallel workers share little and stop when one finds the flag. CHYing and H-Pentest fight themselves (unused Docker agent; three planners talking over each other).

---

## Map 3.2 — Agent plan

**Linear:** next step from the last observation (most ReAct agents). Fast on Easy; rabbit-holes on Hard.

**Tree (PentestGPT PTT):** keep candidate branches, score them, pick one.

**Graph (VulnBot PTG, LuaN1ao task+causal graphs):** nodes and edges you can rewrite after failure.

**Where the first plan comes from:**

1. Static recon script, then planner (CHYing) — only as good as that script (they skipped directory scan).
2. Agent explores then plans (CTFSOLVER).
3. Plan with almost no recon (parts of newmapta) — generic “recon then exploit” that does not help.

**Feedback** only works if memory keeps the clue. Cruiser’s reflector writes 4-step plans but the executor takes only step 1, so context fills with repeats.

---

## Map 3.3 — Agent memory

Three stores:

1. **In-context:** dump every HTTP response into the chat. Wins Easy. Drowns on long tasks.
2. **External notes/files:** Tinyctfer *writes* notes but almost never *reads* them. CHYing’s `add_memory` was not even registered.
3. **Structure-bound:** tree/graph nodes (LuaN1ao causal graph). Best for chains (challenge 022, 066).

**Compression:**

- CTFSOLVER mostly avoids overflow by splitting work (except fuzz dump on 088).
- CHYing keeps last 10 tool messages → forgets early recon.
- H-Pentest compresses at **6400 tokens** → too early.
- Claude Code / Kimi CLI compress late and keep last N full turns → more sensible.

---

## Map 3.4 — Agent execution (this is the tool theory map)

This map is the **paper’s tool theory**. Section 5.4 is what actually happened in the bake-off.

**Who holds the tools?**

- One executor with the whole menu (simple, can pick the wrong tool).
- Stage-bound specialists (recon tools only on the recon agent).

**Three tool layers** (plus a fourth they measure empirically):

| Layer | What it is | How the agent uses it |
| --- | --- | --- |
| **General** | Python interpreter, shell / bash | Write a small script or run `curl` / OS commands. This is the LLM’s native strength. |
| **Security** | Community scanners and testers (nmap, dirsearch, sqlmap, nuclei, …) | Encapsulate expert procedures so the model does not reinvent a scanner in Python. |
| **Specialized** | Persistent sessions and GUIs (Metasploit, netcat, Burp, Playwright) | Need a live session or a browser; harder for an LLM to drive. |
| **Intrinsic** (measured in Fig. 4) | plan, summary, knowledge, todos, formulate_hypotheses | Tools that manage the *agent itself*, not the target. |

**How calling works (3.4.3):**

1. **Function calling:** the model emits a JSON-like `{tool, args}`. Simple, tightly coupled. Used by CTFSOLVER, Cruiser, CHYing, SickHackShark, sub-agent, H-Pentest.
2. **MCP:** tools are servers; the agent is a client. Easier to swap Kali tools. Used by LuaN1ao, Tinyctfer, XBow-Comp, CyberStrike.
3. **Skills:** a named recipe (when to call which tools). Loaded on demand so 100 tools do not flood the prompt. XBow-Comp / CyberStrike / CHYing `SKILL.md` files.

**Safety in the paper:** Python and shell run in Docker / sandbox so a bad command does not wreck the host.

---

## Map 3.5 — External knowledge

Not a “tool” in the nmap sense, but agents **call a retrieve tool**.

**Built from:** CVE notes, payload lists, ATT&CK, PayloadsAllTheThings, YAML PoCs.

**Fetched by:** embeddings, BM25, or “run all YAML.”

**Empirical punchline:** mismatched retrieval **steers the agent wrong**. Removing the KB *raised* Cruiser 42→57 and LuaN1ao 83→90. CTFSOLVER’s **YAML PoC library** is the exception (helps challenge 026).

---

## Map 3.6 — Benchmark types in the literature

Five kinds of testbeds exist in the field. **This paper only uses one:** original **XBOW web CTFs** with canary strings (less memorization). Success = **flag**. They also log tokens, time, and tool traces.

---

## Map 4 — Experimental setup (how to reproduce)

**Fence:** educational CTF, web only, no real sites.

**Grid:** 22 XBOW IDs (9 Easy / 9 Medium / 4 Hard) × 15 systems × 2 runs.

**Success:** flag string matches.

**Hygiene:** wipe memory; restore the challenge VM.

**Scoring:** 2 / 3 / 5 points per successful attempt (max S = 130).

**Main LLM:** DeepSeek-Chat-v3.2 everywhere. Other LLMs only on CTFSOLVER and XBow-Comp.

This map does not name pentest tools; it names **lab tools**: Docker images, the XBOW range, the scoring sheet, the GitHub harness.

---

## Map 5 — The six research questions

| RQ | Question |
| --- | --- |
| 1 | Do architecture / plan / memory predict score vs coding-agent baselines? |
| 2 | Does a knowledge base help? |
| 3 | Does swapping the LLM change everything? |
| 4 | How do they actually use tools? |
| 5 | Tokens and time |
| 6 | Hard scenario types: chain (022), known CVE (026), fake flags (028) |

---

## Map 5.1 — Why the ranking looks like that

**Top:** CTFSOLVER 88, LuaN1ao 83, XBow-Comp 77, SickHackShark 77.  
**Baselines** (Kimi / Claude + short prompt + terminal): **72 and 69** — above most dedicated OSS.  
**Bottom:** PentestGPT 18, VulnBot 27 (rigid pipelines in this autonomous setup).

Single-agent ReAct keeps one story. Multi-agent wins only with **shared structured memory** (LuaN1ao) or **parallel independent tries** (CTFSOLVER). Hard tasks still fail almost always.

Tinyctfer **loses to baseline-cc** because it **forced Python scripts** instead of a quick `curl`.

---

## Map 5.3 — LLM × framework

Same two frameworks, five brains.

- **Opus-4.6** best (99 / 106). It even **turns on** XBow’s sub-agent (which DeepSeek never used).
- **Gemini** strong until the **round cap**.
- **GPT-5.2** strong on SWE-bench, weak here: stops without a tool call, loops on `summary`, hallucinates flags.
- Style: GPT likes `python_execute`; DeepSeek likes `curl`.

So a “tool” only exists if **that model decides to call it**.

---

## Map 5.4 — Tools in the actual runs

This is the **empirical** tool map.

**Call volume ≠ score.** sub-agent averaged **801** Hard calls and scored 32. CTFSOLVER/LuaN1ao called fewer tools, scored 88/83.

**As difficulty rises, agents do not switch tool strategy.** They just **repeat the same mix more times**. SickHackShark’s mix of `write_todos` / `curl` / `python_execute` stays ~18–27% each from Easy to Hard.

**Successful traces are mostly atomic:** `curl`, HTTP `request`, `python_execute`, `shell_execute`. Domain scanners are often unused.

**LuaN1ao’s `formulate_hypotheses`** (11–20% of calls) is an *intrinsic* tool: it forces a new hypothesis when stuck. Highest Hard score (15).

**CyberStrike 30 tools vs 115 tools:** S = 55 vs 58. Extra Kali binaries did not matter.

**Baselines:** `kali_terminal` (Claude) or `curl` then native Kimi tools. No custom security module, still beat many AutoPT frameworks on Easy/Medium. Hard score only 5.

---

## Map 5.6 — Three challenge types

- **022 chain:** several bugs must be combined. 83.3% stall. Memory graphs help.
- **026 CVE:** 56.67% *name* the CVE then fail to **build a working request**. YAML PoCs help more than a general wiki.
- **028 fake flag:** 8/13 OSS systems treat base64-looking text as the flag and stop. Not fixed by swapping to Opus or GPT.

---

## Map 6 — Future work

Memory first; couple feedback to structure; **skills instead of 100-tool dumps**; handle STDIN and huge stdout; KB must match the scene; sandbox the agent; co-design LLM + framework; automate log audit.

---

## Map 7 — Conclusion

ReAct is enough for Easy/Medium. KB often hurts. Tool count unused. Coding agents with a tiny prompt beat most OSS. Chains need explicit memory. CVEs need live PoCs. Flag hallucination is structural. Open the harness and keep the bench alive.

---

## Map 8 — Ethics

Dual-use admitted. Only public CTFs. No new 0-days. Same spirit as publishing Metasploit: defenders need the map.

---

## Map A — System cards (who uses which tools)

This map is a **phone book**. Below is how each of the 13 + 2 **wired tools**.

### How “how” works in every system

Loop is always some form of:

1. LLM sees target URL + last tool output.  
2. It picks **one tool name + arguments** (function call or MCP).  
3. The host runs that tool in a **container**.  
4. Stdout/HTML comes back into context.  
5. Repeat until flag, round cap, or fake stop.

Differences are only: **which names are on the menu**, **who is allowed to call them**, and **whether a skill/KB is injected first**.

### Per-system tool wiring

| System | Call style | What it actually puts in the agent’s hands | How it uses them in the paper’s story |
| --- | --- | --- | --- |
| **CTFSOLVER** | Function calling | `python`; HTTP `request` (explorer + actioner); `extract`; `fuzz_idor`; `fuzz_lfi`; `distinguish` (diff two responses); `page`; plus `plan`, `summary`, `knowledge` | Explorer browses with `request`. If YAML PoCs match, exploitation agent takes the flag. Else solutioner plans and actioner probes. `distinguish` compares pages (authz). Parallel solutioners, not a giant Kali list. |
| **LuaN1ao** | MCP | `python_exec`, `shell_exec`, `http_request`, `dirsearch_scan`; intrinsic `formulate_hypotheses`, `retrieve_knowledge`, `think`, `reflect_on_failure`, `complete_mission` | Executor hits HTTP + directory scan via MCP. When stuck it **must** call `formulate_hypotheses`. RAG (`PayloadsAllTheThings`) is a retrieve tool — and often *hurt* score. |
| **Tinyctfer** | MCP on Claude Code | Terminal; sandboxed `execute_code`; browser + proxy MCP; notes, TodoWrite, Glob/Grep/Read | Prompt says: capture traffic → read source → test features → then scanners. In practice it **wraps playwright, caido, sqlmap, ffuf inside Python**. That extra script step is why it lost to baseline-cc’s raw curl. |
| **XBow-Comp** | MCP on Kimi CLI | `Bash`, **`kali_terminal`**, terminal history; `SearchWeb`, `FetchURL`; Task (sub-agent), Think, todos, CTF skills/notes, `submit_answer`, file tools | Default loop: **READ → PLAN → DO → NOTE → SUBMIT**. First moves are **`curl` through the Kali terminal**. Skills (`get_ctf_skill`) are optional docs. Sub-agent almost unused until Opus. |
| **Cruiser** | Function calling (JSON thought/tool/args) | `run_command`, `run_python`; `dirsearch`; `fenjing` (SSTI); `fuzz_xss`; `sqlmap`; `submit_flag` | Decision agent emits one JSON tool call per turn. Reflector comments after. More “named security tools” than CTFSOLVER — still mid pack; KB made it worse. |
| **CHYing** | LangChain function calling | `execute_command` (Kali Docker), `execute_python_POC`, `submit_flag`, `add_memory` (broken) | After a **fixed recon script**, Main Agent should send hard jobs to Docker Agent and scripts to PoC Agent. Logs: **Docker Agent almost never called** → they mostly wrote Python PoCs. Skills loaded by keyword from hints. |
| **SickHackShark** | Function calling | `curl`, `execute_python_code_command`, Kali OpenAPI spec, `write_todos`, notes, `task` (sub-agents), glob/grep/files | Main agent sees curl + Python + Kali spec. Sub-agents for recon / confirm / flag hunt. Todos stay a **large share of calls** even on Hard (busywork). Notes *are* re-injected (helps chains). |
| **newmapta** | CrewAI tools | DirectorySearcher, Katana crawler, SQLMap, RawHttpTool (paper narrative) | Manager assigns gather vs verify vs exploit. Classic **scanner-heavy** design; weak first plan without enough recon → S=54. |
| **sub-agent** | Function calling | `local_curl`, `run_command`, `write_file` in a sandbox | Planner/executor split. Huge call counts, little strategy change with difficulty. |
| **CyberStrike** | MCP | **30-tool “lite” vs 115-tool “full”** Kali zoo (nmap, nuclei, sqlmap, ffuf, hydra, …) plus `execute-python-script`, `exec`, RAG `search_knowledge_base`, `list_skills` | CTF role is meant to see a subset (`*` in the card). Empirically **115 ≈ 30**. Unused binaries. Memory agent never reached the token trigger. |
| **H-Pentest** | Function calling | `execute_python`, `directory_scan`, `query_knowledge`; **pre-pass uses Nuclei + login brute + page parse** (not all exposed as worker tools) | Worker lives in a code sandbox. Supervisors talk every 3 rounds. Tiny tool menu + early compression → dies on Medium/Hard. |
| **PentestGPT** (autonomous fork) | Generation module emits commands | Classic idea: LLM writes the next CLI line; parser runs it | Tree (PTT) + three modules. In **this** harness it scored **18** — the fork did not match human-in-the-loop PentestGPT. |
| **VulnBot** | Graph-staged executors | Recon / scan / exploit tool groups per phase | If recon is thin, later graph edits cannot save the run (S=27). |
| **baseline-kimi / baseline-cc** | Same as XBow-Comp **minus skills** | Kali terminal, curl, python, file tools | Short prompt: Analysis → Thought → **one** Action → Terminate with flag. **No** sqlmap/nuclei wrapper required. Model picks curl or a script. That freedom is the point of RQ1. |

---

## Tools the *authors* used (not the agents)

To run the science, not to pentest:

- **XBOW** cyber range + canary strings  
- Each framework’s own Docker / Kali container  
- **DeepSeek / Claude / GPT / Gemini** APIs  
- Spreadsheets for 2/3/5 scoring  
- **Manual log review** (15+ people, 4 months)  
- Public repo: `github.com/simon-p-j-r/LLM4Pentest`

---

## One picture of “how tools were used” in the bake-off

```
LLM  --function call or MCP-->  host
                                  |-- general: python / bash / curl
                                  |-- security: nmap, dirsearch, sqlmap, nuclei, ...
                                  |-- specialized: browser, proxy, metasploit (rarely decisive here)
                                  |-- intrinsic: todos, notes, plan, summary, KB retrieve, formulate_hypotheses
                                  v
                         stdout back into the prompt
```

**What the measurements say they *really* used:**  
the first line (curl / python / shell) **plus** a few intrinsic calls (todos, hypotheses, summary).  
The long Kali lists were mostly **inventory**, not **behavior**.

That is why Map 5.4 exists separately from Map 3.4: 3.4 is the catalogue; 5.4 is the audit of what was actually invoked.
