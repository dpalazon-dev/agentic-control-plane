# SPIKE-002 - Local work-control state and existing substrates

## Status

**SOURCE-LEVEL COMPARISON COMPLETE. EMPIRICAL SUBSTITUTION TEST REQUIRED.**

No AWCP database, service, API or TUI was implemented in this spike.

The result is deliberately conservative: Pulse and Nexus together cover enough of the proposed product that AWCP must test them as a possible substitute before designing a custom work substrate. The local companion experience and inspectable authoritative state accepted in `AWCP-DEC-009` remain required outcomes; this spike does not assume that AWCP must physically implement every part of them.

---

## 1. Question

What state must AWCP own to guarantee this chain without becoming another task tracker, specification system, agent runtime or coordination bus?

```text
Intent
  -> Work Package / Task
  -> required roles
  -> executor binding
  -> role execution
  -> evidence
  -> completion
```

The spike compares:

- Beads;
- Backlog.md;
- GitHub Spec Kit;
- Okto Pulse;
- Okto Nexus;
- repository-native state;
- a provisional minimal AWCP representation.

---

## 2. Decision summary

1. **Do not implement a custom work database or TUI yet.** Pulse plus Nexus is a serious substitution candidate, not merely a source of ideas.
2. **Separate logical authority from physical storage.** AWCP needs one unambiguous completion decision and explicit source-of-truth rules. It does not need to copy task, specification, session or event content already governed by another local system.
3. **Treat the remaining AWCP-specific state as provisional.** The likely irreducible layer is work-derived role obligations, their bindings to native coding-client executions, role-scoped evidence and one completion evaluation.
4. **Require an empirical composition test.** Source inspection cannot prove that Pulse, Nexus and Codex compose into the required workflow or that their identifiers can be correlated reliably.
5. **Do not select storage technology.** SQLite, Dolt, Markdown, repository files and a custom schema remain implementation options only after the substitution test.

---

## 3. Required invariants

Any accepted substrate or composition must preserve these invariants.

### I1 - Stable work identity

Every governed unit has a stable identity. If the work lives in an external provider, AWCP records a provider, external ID and revision or other stable reference.

### I2 - Explicit work contract

The work contract exposes classification, risk, constraints, acceptance conditions and the policy version used to derive governance.

### I3 - Required roles are typed obligations

`Developer`, `Tester`, `Code Reviewer` or `Architect` are not free-text agent labels. Each required role is a separately satisfiable responsibility slot with a contract and status.

### I4 - Bindings identify real execution

A role binding identifies the coding client, logical executor and, when observable, the native thread, turn, agent and session identifiers. A provider-local session ID is not silently represented as a native Codex thread ID.

### I5 - Independence is evaluated over identity

An independent reviewer cannot satisfy the requirement when its effective executor identity violates the declared separation rule. A different role label alone is insufficient.

### I6 - Attempts and evidence are attributable

Execution attempts, evidence, findings, waivers and interruptions identify their work, role, executor, session and time. Evidence can be a stable reference to Git, CI, a test report or another authoritative artifact.

### I7 - Completion is derived

Work becomes complete only when every required role and completion condition is satisfied. A task provider's generic `done` status or a handoff's `completed` status cannot bypass the work contract.

### I8 - History is reconstructable

The system can answer who changed state, when, from which execution and on what grounds. Corrections append or supersede; they do not erase the history needed for audit.

### I9 - Concurrent writes are safe

Claims and completion transitions are atomic or revision-guarded. Repeated hook/MCP calls are idempotent. Stale executions and leases cannot produce duplicate ownership or false completion.

### I10 - Degradation is visible

Missing hooks, unavailable MCP services, unknown native IDs, interrupted clients, stale sessions or unsupported guarantees produce an explicit degraded, blocked, interrupted or stale state.

---

## 4. Queries the product must answer

### Agent and hook queries

- Resolve the active work contract for a repository and root Codex thread.
- List required, satisfied, blocked and unsatisfied roles.
- Validate a requested role before spawning an executor.
- Bind a returned Codex child thread to the role and execution attempt.
- Open, heartbeat, interrupt and close an attempt idempotently.
- Submit role-scoped evidence or findings.
- Evaluate whether completion is currently permitted and explain every blocker.
- Record an explicit waiver or downgraded guarantee with actor and reason.

### Human inspection queries

- What work is ready, active, blocked, stale or awaiting review?
- Why is a work item not complete?
- Which roles were required, and why were they derived?
- Which executor, coding client and native session/thread performed each role?
- When did every attempt start, stop or become stale?
- What evidence, findings, decisions and waivers support completion?
- Which authoritative external records contain the task, specification, code, tests and CI result?
- Is the Codex/Pulse/Nexus integration healthy enough to claim the configured guarantees?

These queries define the useful local inspection surface. Its technology does not define the data model.

---

## 5. Candidate comparison

| Concern | Beads | Backlog.md | Spec Kit | Pulse | Nexus |
|---|---|---|---|---|---|
| Durable tasks | Strong | Strong | Phase/artifact-oriented | Strong | Basic |
| Dependencies/readiness | Strong | Present | Workflow-oriented | Strong | Handoff DAG |
| Human-readable source | JSON/API plus Dolt | Strong Markdown | Strong repository artifacts | UI/API | UI/API |
| Claims/concurrency | Atomic claims; multi-writer server mode | File/Git-oriented | Run locks and atomic state files | Governed service writes | Atomic claims and leases |
| Specifications/contracts | Task fields | Task body, AC and DoD | Strong | Strong | Handoff criteria |
| Agent/session identity | Assignee and selected audit fields | Assignee | Workflow run | Agent/assignee records | Strong Nexus-local identity/session |
| Independent validation | Not a first-class work invariant | Not first-class | Can model process gates | Strong generic review controls | Anti-self-verification per handoff |
| Required semantic role set | No | No | Can describe a workflow | No general typed role-slot set found | Routing role, not work-derived role slots |
| Native Codex thread/turn lineage | No | No | No | No | No dedicated native client lineage found |
| Role-scoped evidence and completion | No | No | Workflow-specific | Strong task evidence, not general role slots | Result and verifier per handoff |
| Operator surface | CLI | TUI/web/CLI | CLI/artifacts | Web workbench | Web dashboard/REST/SSE |

`Strong` means strong for the candidate's own domain, not proven sufficient for AWCP.

### 5.1 Beads

The inspected Beads snapshot is a Dolt-backed dependency graph with ready/blocked calculation, atomic claiming, structured JSON, per-issue history and an optional ordered workspace event journal. Embedded mode is single-writer; server mode supports concurrent writers. `.beads/issues.jsonl` is an interchange export, not the source of truth.

Beads is a credible task/dependency/readiness provider. Its issue model also has extensible metadata, but hiding AWCP role and completion invariants inside arbitrary metadata would leave those invariants untyped and couple them to a foreign schema.

**Result:** viable provider; insufficient alone.

### 5.2 Backlog.md

Backlog.md provides Git-friendly Markdown tasks, acceptance criteria, Definition of Done, plans, notes, comments, final summaries, dependencies, parent/subtasks, semantic task types, CLI/MCP access and a terminal board.

It is the strongest candidate when repository readability and a lightweight terminal experience dominate. It does not provide transactional role satisfaction, execution-attempt lineage, native client session identity or a single role-aware completion gate.

**Result:** viable task and inspection provider; insufficient alone.

### 5.3 GitHub Spec Kit

Spec Kit provides linked specification artifacts and an extensible workflow engine with prompts, commands, shell steps, gates, conditions, loops and fan-out/fan-in. Workflow runs persist resumable state using atomic writes and locks.

Its workflow requirements are not a general permission or work-governance contract, and its run state is not a universal task/role/evidence ledger.

**Result:** viable specification and process provider; insufficient alone.

### 5.4 Okto Pulse

Pulse is the strongest work-layer falsifier. The pinned `v0.3.1` source describes a local-first SDLC workbench with structured ideation, refinement, specifications, tasks, tests and bugs; governance gates; evidence and validation; project knowledge; web UI; API; and MCP. Its source includes required task validation, evidence thresholds and an enforceable reviewer-separation mode.

Pulse already covers much of the experience AWCP originally proposed. Its agent/task model nevertheless uses assignment and validation concepts rather than a general work-derived set of semantic role obligations whose individual satisfaction determines completion.

**Result:** serious work-layer substitute; must be tested, not wrapped reflexively.

### 5.5 Okto Nexus

The inspected `okto-nexus 0.1.3` source distribution provides a local SQLite-WAL coordination bus with logical agents, roles/capabilities, authenticated Nexus sessions, append-only events, messages, tasks, artifacts, policies, approvals and claimable handoffs. Handoffs support leases, dependencies, acceptance criteria, capability/agent-based verification and an anti-self-verification rule.

Its `role` is an agent-profile and routing attribute. A handoff can target a role, capability or agent, but no general aggregate was found that derives a required role composition from one work contract and prevents aggregate completion until every role slot is satisfied. Nexus session IDs identify Nexus sessions, not automatically the native Codex thread/turn IDs from SPIKE-001.

**Result:** serious worker/session/coordination substitute; must be composed empirically with Pulse and Codex.

### 5.6 Simple repository state

Repository files are inspectable, diffable and portable, but concurrent claims, leases, idempotent event ingestion, stale attempts and atomic completion become custom protocol design. Markdown alone does not remove the need for a control service once multiple agents and hooks write concurrently.

**Result:** useful artifact and configuration format; not sufficient as the assumed authority.

---

## 6. Provisional minimum AWCP-specific model

This is a falsifiable semantic boundary, not an approved schema.

| Record | Purpose |
|---|---|
| `WorkReference` | Stable pointer to the authoritative external or native work item and revision. |
| `WorkContract` | Classification, risk, constraints, role policy version and completion policy. |
| `RoleRequirement` | Semantic responsibility slot, contract, order/dependencies and independence rule. |
| `ExecutorBinding` | Role-to-executor resolution with client and observable native identifiers. |
| `ExecutionAttempt` | Start/heartbeat/end state for one binding and actual execution. |
| `EvidenceSubmission` | Evidence or finding attributed to one role and attempt, usually by stable reference. |
| `CompletionEvaluation` | Derived verdict, blockers, policy version and grounds. |
| `ControlTransition` | Append-only transition, waiver, degradation or supersession record. |

The model intentionally excludes task descriptions, full specifications, source code, transcripts, test output and CI logs when another authority already owns them.

---

## 7. Source-of-truth boundary

| Concern | Preferred authority |
|---|---|
| Intent/specification/task content | Selected work/spec provider |
| Dependencies and ready/blocked calculation | Selected work provider |
| Required role composition and completion policy | AWCP semantic authority, unless a candidate proves equivalent behavior |
| Worker identity, presence, routing and handoffs | Nexus or another selected coordination provider |
| Native Codex thread/turn/agent identity | Codex hooks and persisted App Server history |
| Code and repository artifacts | Git/repository |
| Test and CI execution records | Test/CI systems |
| Role-scoped evidence relation | AWCP semantic authority or a proven equivalent provider relation |
| Human inspection | One composed view over the authoritative records; no second editable truth |

The completion evaluator may read several authorities, but only one component may issue the final AWCP completion verdict for a work contract.

---

## 8. Required empirical substitution test

Run Pulse and Nexus in an isolated local environment only after reviewing and explicitly accepting their licenses and operating terms. Connect the Codex fixture from SPIKE-001 without modifying either product first.

### Scenario A - implementation

```text
Task
  -> Developer
  -> Tester
  -> independent Code Reviewer
  -> completion
```

### Scenario B - architecture/organization

```text
Work Package
  -> Architect
  -> independent Senior Engineer / Critic
  -> human decision when required
  -> completion
```

### Pass conditions

1. Work classification can produce explicit required role slots.
2. Each slot has a separate lifecycle and cannot be accidentally satisfied by another status.
3. Independence is enforced over effective executor identity.
4. Codex root and child thread identifiers can be correlated to the corresponding role execution.
5. Evidence is attributable per role and execution attempt.
6. The Codex `Stop` gate can obtain one deterministic completion verdict.
7. A human can inspect when, why, by which agent and session, with which evidence, the work changed state.
8. Interrupted or unavailable integrations fail visibly rather than reporting completion.

### Interpretation

- If all conditions pass through configuration and supported APIs, a custom AWCP substrate is unnecessary. AWCP may reduce to a methodology, configuration and integration package, or cease to be a separate product.
- If only native Codex lineage and role aggregation are missing, AWCP should be a thin semantic overlay over Pulse/Nexus.
- If the work model, role obligations or completion verdict cannot be represented safely, a minimal owned substrate becomes justified.

---

## 9. Operational and adoption cautions

- Pulse and Nexus are fast-moving products; versions and MCP surfaces must be pinned and revalidated.
- The pinned Pulse source exposes a very broad MCP surface. The experiment must measure context cost and whether Codex can reliably select the necessary operations.
- Pulse and Nexus use Elastic License 2.0 plus project-specific terms. Local evaluation and any later integration, redistribution or competing-product use require an explicit license review.
- No terms were accepted and neither service was initialized or run during this source-level spike.
- Product marketing demonstrates intended flows, not proof that the exact AWCP invariants are enforced. Runtime evidence must decide.

---

## 10. Evidence snapshot

Inspected on **2026-08-12**:

- Beads commit [`4ad99760`](https://github.com/gastownhall/beads/commit/4ad99760b8954c19345feb34b7e44c2c91a940c3)
- Backlog.md commit [`32d7948b`](https://github.com/MrLesk/Backlog.md/commit/32d7948b3e80b0fcd3015612ec53f44399816cac)
- Spec Kit commit [`c1bceb62`](https://github.com/github/spec-kit/commit/c1bceb625cd40c2de87a73493a49b4419f77ab00)
- Okto Pulse `v0.3.1`, commit [`827fa691`](https://github.com/OktoLabsAI/okto-pulse/commit/827fa691085f34d574b4c7d7cdb4ed21f761e2dd)
- Okto Pulse Core `v0.3.1`, commit [`d9d96140`](https://github.com/OktoLabsAI/okto-pulse-core/commit/d9d96140baaf9f57f04aca2fcfc8196e65b10b58)
- `okto-nexus 0.1.3` official PyPI source distribution, SHA-256 `47351fe8afc52975651af6eb5af90820b8f148c86cdc7f17a2ea29cc5300118c`

Primary sources:

- [Beads](https://github.com/gastownhall/beads)
- [Backlog.md](https://github.com/MrLesk/Backlog.md)
- [Spec Kit documentation](https://github.github.io/spec-kit/)
- [Spec Kit workflows](https://github.com/github/spec-kit/blob/main/docs/reference/workflows.md)
- [Okto Pulse](https://oktolabs.ai/platform/pulse/)
- [Okto Pulse source](https://github.com/OktoLabsAI/okto-pulse)
- [Okto Nexus](https://oktolabs.ai/platform/nexus/)
- [okto-nexus on PyPI](https://pypi.org/project/okto-nexus/)

---

## 11. Exit decision

SPIKE-002 closes the source-level substrate comparison. It does **not** authorize product implementation.

The next architecture-changing evidence must come from the Pulse + Nexus + Codex substitution test. Until then, the provisional AWCP-specific model is a test oracle, not a database design.
