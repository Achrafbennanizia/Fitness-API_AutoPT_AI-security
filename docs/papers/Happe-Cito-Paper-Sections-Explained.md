# Happe & Cito (ESEC/FSE 2023) — what is in the paper, then a résumé

**Paper.** Andreas Happe and Jürgen Cito (TU Wien). *Getting pwn’d by AI: Penetration Testing with Large Language Models.* ESEC/FSE ’23, pp. 2082–2086. DOI [10.1145/3611643.3613083](https://doi.org/10.1145/3611643.3613083). Also arXiv:2308.00121.

Five-page **ideas-plus-prototype** paper. This note describes **what they wrote**. It does not reproduce lab command sequences.

## What is inside the paper

| Part | What the authors put there |
| --- | --- |
| **Abstract** | Pentesting still costs specialist hours. GPT-3.5-class models might be **sparring partners**. Two use cases: **high-level** planning of an assignment, and **low-level** hunting on an already-accessed **authorized** lab VM. They wired GPT-3.5 to a vulnerable Linux guest over SSH (model proposes a command, it runs, output returns). They report that this loop could reach a root shell on that *training* guest, then discuss instability, hallucinations, safety filters, and dual-use. They refuse LLM phishing/vishing. Report writing is mentioned only as industry gossip. |
| **§1 Introduction** | Workforce gap (ISC2 2022 cited). Testers in their related interview study wanted human sparring partners. RQ: **to what extent can we automate security testing with LLMs?** Scope fence: no phishing study. MITRE **ATT&CK** is introduced as a *grading rubric* (tactics → techniques → procedures), not as a runtime controller. |
| **§2 Background** | Primer on ATT&CK’s TTP stack. Primer on LLMs / GPT-3.5, prompting, and the fact that small **local** runtimes (`llama.cpp` and similar) were already thinkable in 2023. Hosted models have alignment/moderation; local models would not. |
| **§3 LLM-based penetration testing** | Empirical core, two systems. **§3.1 High-level:** AgentGPT/AutoGPT asked to plan (e.g. a domain-admin-shaped engagement; an *approved* external pentest plan). Plans matched the *genre* of real consulting work; when pushed toward live phishing/scanning, ethical filters **refused**. **§3.2 Low-level:** closed SSH loop (`hackingBuddyGPT`) against the public `lin.security` training VM. The model is a low-privilege user aiming at root; commands execute on the lab guest; they report the loop **routinely** reached root on that image. Observations about the model’s *habits* (which families of check it tries) are in the paper; this note does not list procedures. |
| **§4 Discussion** | **§4.1 Grounding vs hallucination:** some next steps follow from the last command’s output; others come from priors (e.g. naming a famous kernel issue just because the OS is Linux) or from fictional files. They compare it to phoning a clever colleague who cannot see the screen. **§4.2 Stability:** single runs wander; over many runs the *distribution* of behaviours converges. Less deterministic than a hardcoded enumerator. **§4.3 Ethical moderation:** hosted GPT-3.5 filters barely stopped the lab loop; rephrasing (“verification commands”) often passed; local models would remove the filter. Dual-use framed like older open pentest tools. |
| **§5 A vision of AI-augmented pen-testing** | Research agenda, not a second experiment. **§5.1** Unify high- and low-level with shared memory. **§5.2** Compare cloud vs local models; ask how small is good enough. **§5.3** Memory, verification, reflection (context windows were 4k; stuffing stdout until it falls off is not enough). **§5.4** Better prompts, watched in a dual-use setting. |
| **§6 Final ethical considerations** | Private labs and criminals will use similar toys; weights leak; prompt-only use needs no CS degree. Attackers will explore LLM-assisted testing, including automation. Defenders should prepare. The paper’s stance is: study this **to harden**, keep a human in the loop, do not pretend the genie goes back. |

## Résumé

The paper is an **early peer-reviewed demonstration** that chat LLMs can assist authorized security testing, plus an ethics discussion. It is **not** a 13-machine benchmark (that is Deng) and **not** a 13-framework bake-off (that is Peng).

**Question.** Can GPT-3.5-class models help plan a pentest and drive a command loop on a lab VM?

**Method.** Two prototypes. Planning: task-planning agents (AgentGPT/AutoGPT) on high-level scenarios, including one with a company’s approval. Execution: SSH closed loop on a **deliberately vulnerable** training Linux guest.

**Answer.** High-level: models already know the **genre** of a pentest plan (tactics/techniques). Low-level: on that authorized guest, a closed loop can make progress, including to root, but it is **unstable**, sometimes **ungrounded**, and **hosted safety filters are weak**. ATT&CK is useful as a language to *grade* a colleague, not as the thing that should drive the agent. They keep a human in the loop and refuse social-engineering generation.

**What it is not.** Not a fitness-API study, not a GDPR audit, not a static sitemap analyser.

## One line for this project

Cite Happe for **LLM as sparring partner**, the split **plan vs loop**, ATT&CK as **labels after the fact**, and the ethics fence (**HITL**, no phishing, overnight autonomy is loaded). Do not copy the Linux privilege-escalation loop onto the fitness corpus.
