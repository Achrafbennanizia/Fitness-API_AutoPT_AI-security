# Sun, Xu, and Su (USENIX Security 2011) — what is in the paper, then a résumé

**Paper.** Fangqi Sun, Liang Xu, Zhendong Su (UC Davis). *Static Detection of Access Control Vulnerabilities in Web Applications.* 20th USENIX Security Symposium, 2011.

This note describes **the paper itself**. It is not a recipe for attacking a live site.

## What is inside the paper

Full USENIX Security paper, eight sections plus abstract.

| Part | What the authors put there |
| --- | --- |
| **Abstract** | Access-control bugs cause privilege escalation and are **application-specific**: there is no single sanitizer (unlike XSS/SQLi). The authors claim the first **static** analysis that infers **implicit** access assumptions from the app and then checks them. Idea: the UI already documents who should see which link. Build a **per-role sitemap** of explicit links, subtract sitemaps to find privileged pages, simulate a **force-browse** as the weaker role, flag pages whose response still looks privileged. Implemented for PHP; evaluation on real apps with known and new bugs and few false positives. |
| **§1 Introduction** | HTTP is stateless, so every request must re-check identity. “Security by obscurity” (hiding a URL) is not a check. Dynamic crawlers miss hidden pages. Prior static tools wanted specs nobody writes. Contributions: a definition of the bug; a role-based analysis with little spec (entry points + role state); an implementation; evaluation on unmodified PHP apps. Roadmap to §2–§8. |
| **§2 Illustrative example** | Tiny PHP app, roles admin `a` and user `b`. Shared `functions.php` holds the check. `user_delete.php` includes it; **`user_add.php` does not**. Sitemap for `a` includes add and delete; sitemap for `b` does not. Forced browse as `b`: delete is blocked, add succeeds. That missing include is the vulnerability. |
| **§3 Approach formulation** | Formal nouns. **Role** as a set of allowed accesses on a lattice (public ⊥ … admin ⊤). **Explicit link** vs **forced browsing**. Web application for a role: entries, states, explicit/implicit edges, reachable nodes. Assumption: if several roles can *explicitly* reach a node, required privilege is that of the **least** privileged of them. **Definition of a vulnerable node:** explicitly reachable for stronger role `a`, not for weaker `b`, yet some allowed path for `b` still contains `n`. Success of a force-browse: HTML (and redirects) look like the privileged role’s page. |
| **§4 Analysis algorithm** | Three procedures. **Detect:** build sitemaps Na and Nb, privileged = Na \ Nb, compare responses (CFG size + redirects). **Build sitemap:** BFS from role-specific entries, follow links/includes/redirects, skip infeasible branches given that role’s state. **Extract links:** walk a context-free approximation of HTML together with a DFA of link-carrying tags so the analysis terminates. |
| **§5 Implementation** | PHP string analyser lineage (Wassermann/Minamide, OCaml), extended with roles, Z3 for path feasibility, many PHP builtins, pairwise role comparison. Developers specify per role: **entry set** and **critical state** (session flags, cookies, selected parameters). Optional extra privileged nodes to catch Assumption-2 false negatives. |
| **§6 Evaluation** | Unmodified real PHP applications. The analyser is reported as **scalable**, finds **known and previously unreported** access-control bugs, and yields **few false positives**. Ground truth is a page that should have been blocked; a true positive is a missing check confirmed by fetching as the weak role. (Exact per-app tables are in the PDF.) |
| **§7 Related work** | Static/dynamic work on application logic and access control; why crawlers are shallow; why spec-heavy tools die; why taint/injection analyses do not transfer. |
| **§8 Conclusion** | First static, role-based detector of web access-control bugs by inferring intended sitemaps and testing forced browsing as a weaker role. Effective on real PHP with little specification. |

## Résumé

The paper is a **static program-analysis** result about **missing access checks** on multi-role web apps.

**Question.** Can we find privilege-escalation pages **before deployment**, without a full handwritten access-control spec?

**Insight.** The application already *shows* intended privilege in the links it emits to each role. A bug is when a weaker role can still open a URL the UI never offered and receive the privileged page.

**Method.** For each role, compute the sitemap of explicitly linked pages (static, path-sensitive). Privileged pages = sitemap(strong) minus sitemap(weak). For each such page, ask whether the weak role’s response is still the privileged HTML. If yes, the check is missing.

**Answer.** On the PHP apps they analysed, yes: known bugs plus new ones, with few false positives, at usable cost. The limitation is the setting: PHP, HTML sitemaps, role lattice (admin vs user), not REST “same role, other user’s object id,” and not SPAs.

**What it is not.** It is not an LLM paper, not a mobile/GDPR study, and not a black-box HTTP scanner.

## One line for this project

Cite Sun for **what an authorization finding is**: two principals, a URL the weaker one should not get, evidence = the weaker session still receives the object (in 2011, matching HTML; on fitness APIs, matching **status + body** on `…/{id}`). Do not run their OCaml analyser; white-box SAST is outside this lab’s empirical cut.
