# Architecture Hypotheses

## Status

This document records **architectural hypotheses to validate** for Agentic Work Control Plane. It is not an implementation architecture.

No language, database technology, service lifecycle, protocol, API, workflow engine, schema, TUI framework, context engine or permission system is selected here. Accepted project decisions live only in [`DECISIONS.md`](DECISIONS.md).

Labels:

- **HYPOTHESIS** — plausible structure that still requires evidence.
- **OPEN** — unresolved question or design choice.
- **BOUNDARY** — consequence of an accepted project decision.

---

## 1. Architectural reframing

AWCP is not a runtime stack underneath a coding agent. It is a work-control layer that should remain conceptually independent from whichever coding environment performs the work.

```text
                           Human
                             │
                             ▼
                    Existing Coding Client
              Claude / Codex / OpenCode / Gemini
                             │
                      executes through
                             ▼
                native agent/runtime mechanisms
                             │
                             ▼
                   Repository + Tooling

       ┌────────────────────────────────────────┐
       │       Agentic Work Control Plane       │
       │                                        │
       │ intent / work packages / tasks         │
       │ role requirements                      │
       │ constraints / context requirements     │
       │ permission requirements / decisions    │
       │ evidence / completion                  │
       └────────────────────────────────────────┘
                 │                     ▲
                 │ requirements        │ outcomes/evidence
                 ▼                     │
       ┌────────────────────────────────────────┐
       │ available integration infrastructure   │
       │                                        │
       │ client-native hooks / agents / policy  │
       │ context & memory systems               │
       │ permission / sandbox systems           │
       │ CI / tests / scanners / observability  │
       └────────────────────────────────────────┘
```

The arrows are conceptual rather than a final process topology. AWCP itself is expected to be a local companion process or service with a persistent database and a TUI projection. The exact process, API and database technology remain open.

**BOUNDARY:** Existing coding clients own their native interaction surface and agent loop.

**BOUNDARY:** AWCP governs software-work semantics and required agent responsibilities, not the operational lifecycle of an agent fleet.

**BOUNDARY:** AWCP owns the work-control semantics and final completion verdict. The authoritative local records may be physically supplied by proven work and worker providers, provided source-of-truth boundaries are explicit and no second editable truth is created.

**BOUNDARY:** AWCP is not an execution proxy. Model calls, conversations, agent loops and repository tool execution remain owned by the coding client.

**BOUNDARY:** AWCP should compose existing infrastructure for context, permissions, memory, sandboxing and observability where possible rather than implementing equivalent subsystems by default.

---

## 2. Primary semantic chain

The corrected architectural hypothesis is:

```text
Work
  ↓
Role Requirements
  ↓
Capabilities / Responsibilities
  ↓
Executor Binding
  ↓
Model + Tools + Context + Permissions
  ↓
Execution
  ↓
Evidence per responsibility
  ↓
Completion
```

This replaces the weaker capability-only formulation.

A role is not an implementation detail to eliminate. A role can be a **first-class responsibility slot required by the work**.

The implementation binding of that role remains portable.

---

## 3. Work hierarchy

**HYPOTHESIS:** AWCP may need to reason across more than one granularity of work.

Candidate hierarchy:

```text
Intent
  ↓
Work Package
  ↓
Task
```

The names and exact hierarchy remain open, but different levels may carry different organizational responsibilities.

Example:

```text
Work Package: redesign authentication architecture
├── Architect
└── Senior Engineer

Task: implement token rotation
├── Developer
├── Tester
├── Security Reviewer
└── Code Reviewer
```

This lets project-level design responsibilities coexist with task-level implementation responsibilities.

### Open questions

- **OPEN:** Is `WorkPackage` a necessary first-class level?
- **OPEN:** What is the smallest useful work hierarchy?
- **OPEN:** Which relationships require a graph versus simple parent/dependency links?
- **OPEN:** Who decomposes intent into work packages/tasks?
- **OPEN:** Which work state belongs in AWCP versus an external substrate?

---

## 4. Role requirements

### Problem being investigated

Reliable agentic work may depend not just on **what capabilities happen to run**, but on whether distinct responsibilities were actually represented and satisfied.

For example, these are not semantically identical:

```text
one agent implements, tests and approves its own work
```

and

```text
Developer implements
Tester validates
Code Reviewer independently reviews
```

Even when all three use similar underlying capabilities.

### Role requirement hypothesis

**HYPOTHESIS:** Work type, risk, complexity, uncertainty and policy can derive a required role composition.

```text
work characteristics
       ↓
role policy / methodology
       ↓
required roles
       ↓
role-specific responsibilities and gates
```

Illustrative examples:

```text
trivial edit
→ Developer

small bug
→ Developer + Tester

implementation
→ Developer + Tester + Code Reviewer

security-sensitive implementation
→ Developer + Tester + Security Reviewer + Code Reviewer

architecture / organization
→ Architect + Senior Engineer
```

These examples are not yet a final taxonomy or policy table.

### Roles are semantic slots

Candidate roles may include:

```text
Developer
Tester
Code Reviewer
Architect
Senior Engineer
Researcher
Security Reviewer
Documentation Reviewer
```

A role should define a responsibility contract, not merely a persona prompt.

For example:

```text
Code Reviewer
├── purpose: challenge implementation quality independently
├── inputs: work contract + diff + relevant context
├── capabilities: inspect / reason / review / verify
├── permissions: preferably non-mutating unless remediation is explicitly delegated
├── output: findings + disposition + evidence
└── independence: may not be satisfied by the implementing executor when policy requires independence
```

The exact representation remains open.

### Separation of responsibility

**HYPOTHESIS:** Some role requirements need an independence constraint.

Examples:

- implementation and code review may need different executor contexts;
- security review may require a distinct reviewer;
- a test author and test-result verifier may occasionally need separation;
- human approval may be required for high-risk work.

This does not require a distributed multi-agent runtime. It requires the work model to express that one contribution cannot satisfy every responsibility.

### Open questions

- **OPEN:** Which role vocabulary is stable enough to standardize?
- **OPEN:** Are roles globally defined or project-configurable?
- **OPEN:** How much role policy should be conventional versus derived dynamically?
- **OPEN:** Which work classes require independence between roles?
- **OPEN:** Can one executor satisfy multiple compatible roles?
- **OPEN:** How should escalation occur when the active coding client cannot materialize a required role?

---

## 5. Capability requirements

Roles and capabilities are related but different.

```text
Work Type
≠ Agent Role
≠ Capability
≠ Executor Instance
≠ Model
```

A role may require capabilities such as:

```text
explore
research / reason
implement
debug
test
review
verify
document
```

For example:

```text
Developer
→ implement + debug + inspect repository

Tester
→ test + reproduce + validate requirements

Code Reviewer
→ inspect + reason + review + verify
```

**HYPOTHESIS:** Capability requirements are useful for determining whether a candidate executor can satisfy a role, but they do not replace the role itself.

### Open questions

- **OPEN:** Do capabilities need first-class persistence or can they be derived from role definitions?
- **OPEN:** Which capabilities are portable across coding clients?
- **OPEN:** How detailed should capability requirements become before they turn into tool-level implementation coupling?

---

## 6. Executor binding

AWCP should define required responsibilities without fixing how every client materializes them.

Conceptually:

```text
Required Role
    ↓
client adapter inspects available mechanisms
    ↓
Executor Binding
```

Possible bindings may include:

- a Claude Code subagent or supported isolated agent mechanism;
- an OpenCode configured agent;
- a Codex-supported agent/session mechanism;
- a Gemini CLI mechanism;
- a separate invocation/session when required;
- a deterministic external tool for a role component;
- a human fallback or approval path.

### Important boundary

AWCP may determine:

> `Code Reviewer` is required and must be independent from the implementing executor.

It does **not** automatically mean AWCP must implement:

- a model loop;
- an agent scheduler;
- agent-to-agent messaging;
- a persistent agent process;
- a custom multi-agent runtime.

The host integration should realize the requirement through supported mechanisms wherever possible.

### Open questions

- **OPEN:** What is the minimum cross-client executor-binding contract?
- **OPEN:** Can all target clients materialize independent roles sufficiently?
- **OPEN:** When does invoking another client/session cross the boundary into runtime orchestration?
- **OPEN:** Is role binding advisory in some clients and enforceable in others?

---

## 7. Context management as a consumed capability

Different roles should not necessarily receive identical context.

For example:

```text
Developer
→ implementation context + relevant architecture + constraints

Tester
→ requirements + acceptance criteria + observed behavior

Code Reviewer
→ work contract + diff + architecture/policy context
```

This makes context management a necessary concern, but not necessarily an AWCP-owned subsystem.

### Context requirement hypothesis

**HYPOTHESIS:** AWCP may express a semantic `ContextRequirement` per work item or role and resolve it against available context infrastructure.

```text
role + work
    ↓
context requirement
    ↓
client-native context / memory system / local context service
    ↓
scoped context delivered to executor
```

Potential upstream providers could include coding-client-native memory/context mechanisms, project knowledge systems, local retrieval systems or future dedicated context-control products.

AWCP should not create a bespoke retrieval/memory platform unless experiments demonstrate a missing capability that cannot be composed.

### Open questions

- **OPEN:** What context requirement can be expressed portably?
- **OPEN:** How do we avoid duplicating native context selection?
- **OPEN:** How can context provenance be observed?
- **OPEN:** Does AWCP need to own any project memory, or only references/requirements?

---

## 8. Permission, policy and sandbox requirements as consumed capabilities

Roles may require different permissions.

Examples:

```text
Developer
→ repository write + test execution

Tester
→ test execution; repository write may be limited depending on policy

Code Reviewer
→ read/inspect; mutation may be disallowed

Architect
→ inspect project state; implementation permissions may be unnecessary
```

**HYPOTHESIS:** AWCP should express the required permission/policy profile semantically and rely on available enforcement systems to realize it.

Potential enforcement sources include:

- coding-client permissions;
- hooks;
- policy engines;
- sandbox boundaries;
- OS/container permissions;
- repository/CI controls;
- an existing local or enterprise agent control plane where appropriate.

The important distinction remains:

```text
guidance
verification
enforcement
```

If a host can only provide guidance, AWCP must not represent that role restriction as enforced.

### Open questions

- **OPEN:** What permission semantics are portable across clients?
- **OPEN:** Can role-specific permissions be changed safely within a session?
- **OPEN:** Which restrictions require separate executor contexts?
- **OPEN:** Can an external local control plane provide stronger guarantees without replacing the coding client?

---

## 9. Other infrastructure to compose rather than rebuild

The same rule applies to:

### Memory

AWCP needs continuity but should reuse a suitable project-memory system where available.

### Observability

AWCP may consume traces, cost, tool events or session metadata from existing systems. It should not build a telemetry platform merely to display a dashboard.

### Verification

Tests, linters, static analyzers, CI, security scanners and benchmarks are external capabilities whose evidence can satisfy work gates.

### Agent control planes

A genuine Agent Control Plane may manage identity, permissions, fleet policy or runtime observability. AWCP could potentially consume those capabilities while remaining responsible for **which work-role requirements need them**.

### Principle

```text
AWCP owns semantic coordination only where necessary.
Infrastructure remains upstream where possible.
```

---

## 10. Governance and completion

Candidate concepts include:

```text
Constraint
Policy
Risk
Approval
QualityGate
RoleRequirement
EvidenceRequirement
CompletionRule
```

Completion becomes role-aware:

```text
agent says "done"
        ≠
work is complete
```

A stronger formulation may be:

```text
required outcome exists
+ required roles contributed
+ independence constraints satisfied
+ required verification executed
+ required evidence exists
+ blocking constraints satisfied
+ required approvals resolved
= eligible for completion
```

This does not imply all work needs all conditions.

### Evidence should attach to responsibility

For example:

```text
Developer evidence
→ implementation diff / build result

Tester evidence
→ tests / reproduction results

Code Reviewer evidence
→ review findings / approval or required changes
```

This may improve traceability over a single undifferentiated `done` status.

---

## 11. Integration with existing coding agents

This is one of the project's central technical risks.

Many agent infrastructure systems assume the developer is building a **custom agent runtime** on top of an SDK or framework. AWCP instead wants to work with already-built daily coding agents.

Target environments include:

```text
Claude Code
Codex
OpenCode
Gemini CLI
```

Potential supported surfaces include:

```text
hooks
permissions / policy engines
skills
plugins
instructions
subagents / native agents
MCP
CLI commands
structured output
events / telemetry
wrappers
```

No mechanism is selected.

### Semantic adapter hypothesis

**HYPOTHESIS:** Adapters should translate AWCP semantic requirements into client-specific mechanisms.

For example:

```text
AWCP requirement:
Code Reviewer role + independent context + read-only policy

Claude adapter:
→ supported native mechanism A

OpenCode adapter:
→ supported native mechanism B

Codex adapter:
→ supported native mechanism C or explicit degradation
```

A provisional guarantee vocabulary remains useful for investigation:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
```

### Mandatory participation problem

AWCP should participate automatically when enabled, but the available guarantee may differ by client.

An MCP tool that the model *may* call is not equivalent to a deterministic lifecycle integration.

SPIKE-001 must determine what can actually be invoked, injected, enforced and observed on each target client.

---

## 12. Local inspection surface and observation

Humans need visibility into the work-control state without replacing the coding-client interface.

The composed local UI/TUI should project:

- intent / work hierarchy;
- dependencies and readiness;
- required roles;
- assigned/resolved executors;
- coding client, agent and session attribution where observable;
- execution attempts and timestamps;
- current role status;
- relevant context sources;
- permission/enforcement guarantees;
- constraints and gates;
- evidence by role;
- unresolved review findings;
- human approvals;
- completion state;
- derived telemetry when available.

Other projections may include CLI output, structured API responses or local tooling.

The inspection surface remains secondary to the coding client. It may be supplied by AWCP or a proven local provider, but owns no independent state and must use the same authoritative records as agent integrations.

---

## 13. Persistence and ownership

**BOUNDARY:** AWCP requires durable local authority for its work-control responsibilities. This is necessary for continuity across coding clients, agents and sessions and for reconstructing why work changed state. Logical authority does not imply that AWCP must implement or duplicate every physical record.

The composed durable record should support or reference:

- intent, work packages, tasks and dependencies;
- constraints, classification, risk and lifecycle state;
- required roles and executor bindings;
- observable client, agent and session identifiers;
- execution attempts, timestamps and transitions;
- decisions, approvals, evidence, findings and completion grounds.

External specifications, repository artifacts, Git commits, PRs, CI runs, telemetry and context systems may remain authoritative for their own content. AWCP may store stable references and the control metadata needed to connect them to work.

Questions before choosing storage and process topology:

- **OPEN:** exact work-control schema and invariants;
- **OPEN:** which external artifacts are copied, summarized or referenced;
- **OPEN:** service startup and lifecycle model while coding clients are active;
- **OPEN:** concurrency and locking requirements;
- **OPEN:** crash/stale execution semantics;
- **OPEN:** private versus Git-versioned state;
- **OPEN:** query patterns required by agents and the TUI;
- **OPEN:** database, API and migration technology.

Persistent local database-backed state is required. A custom AWCP database is not: Pulse, Nexus or another selected provider may supply part or all of the physical state if the empirical substitution test proves the required invariants. No technology should be selected until that test is complete.

---

## 14. Revised validation spikes

### SPIKE-001 — Codex-native methodology surfaces

First instance: [`spikes/SPIKE-001-CODEX.md`](spikes/SPIKE-001-CODEX.md).

This Codex-only, methodology-first spike is complete for architecture selection. It found that strict and auditable role-driven work can be connected to the later local AWCP service through trusted root lifecycle hooks, required MCP work-state operations, custom-agent spawn correlation and historical App Server reconciliation. The tested Codex build did not emit documented subagent lifecycle hooks, and a separate App Server process was not a reliable live-state source for a foreign active thread.

Output: a Codex-specific capability/guarantee matrix, empirical evidence record and operating rule set for:

```text
Intent
  ↓
Work Package / Task
  ↓
Required Roles
  ↓
Role Execution
  ↓
Evidence
  ↓
Completion
```

No custom runtime, execution proxy, adapter daemon, scheduler, database or product UI should be created during this spike. The spike defines requirements for the later local product; it does not deny that product's accepted existence.

### Later spike — Multi-client integration and infrastructure surfaces

For Claude Code, Codex, OpenCode and Gemini CLI, determine what AWCP can actually:

- inject as context;
- invoke deterministically;
- materialize as separate roles/agents;
- constrain through permissions/policy;
- observe;
- receive as structured evidence;
- integrate with external local context/control systems.

Expected output: a real capability/guarantee matrix.

### SPIKE-002 — Local work-control state and persistence

Source comparison: [`spikes/SPIKE-002-WORK-SUBSTRATE.md`](spikes/SPIKE-002-WORK-SUBSTRATE.md).

The source-level comparison is complete. Beads, Backlog.md and Spec Kit are credible providers for narrower work concerns. Pulse and Nexus together are a serious substitute for most of the proposed local product: Pulse governs work and validation; Nexus provides agents, sessions, handoffs, claims and coordination history.

The comparison did not find a general aggregate for work-derived semantic role obligations, native Codex thread/turn lineage or role-scoped aggregate completion. These are provisional gaps, not permission to implement them. `AWCP-DEC-011` requires an empirical Pulse + Nexus + Codex substitution test first.

Output: required invariants, agent/TUI query inventory, candidate matrix, source-of-truth boundaries and a provisional minimal semantic model used only as the test oracle.

### SPIKE-003 — Role-driven adaptive orchestration

Use the smallest useful methodology loop as the empirical Pulse + Nexus + Codex substitution test:

```text
human intent
  ↓
create / resolve work
  ↓
classify type / risk / complexity
  ↓
derive required roles
  ↓
resolve context + permissions + capabilities
  ↓
bind roles through current coding client
  ↓
execute contributions
  ↓
verify role-specific evidence
  ↓
accept, repair or escalate
```

The experiment should compare at least two work classes, for example implementation and architecture/organization.

It should test whether role composition adds real reliability/clarity and whether the accepted local companion experience can be supplied by existing products without implementing a custom AWCP substrate or agent runtime.

Pass/fail conditions are defined in [`spikes/SPIKE-002-WORK-SUBSTRATE.md`](spikes/SPIKE-002-WORK-SUBSTRATE.md). The experiment must not modify Pulse or Nexus before establishing the supported baseline, and it must not initialize either product until its license and operating terms have been reviewed explicitly.

### SPIKE-004 — Persistence and concurrency

Determine lifecycle and consistency requirements only after the work/role model has been exercised.

---

## 15. Architecture discipline

Before adding a subsystem, ask:

1. What observable software-work problem does it solve?
2. Does the coding client already provide it?
3. Does a local context/control/memory/observability system already provide it?
4. Is this a semantic requirement AWCP should own, or infrastructure AWCP should consume?
5. Does the work require a distinct **role**, or only a capability/tool?
6. Does this role need independence from another role?
7. Can the current coding client materialize it natively?
8. What guarantee is actually available: guidance, verification or enforcement?
9. Does the state need persistence?
10. Can a smaller spike resolve the uncertainty first?

Avoid especially:

- reducing roles to generic capabilities;
- fixed model assignments masquerading as roles;
- persona agents that add no distinct responsibility;
- one mandatory pipeline for all work;
- multi-agent theatre;
- building a custom agent runtime merely to obtain orchestration;
- building a context engine before testing existing ones;
- building a memory system before testing existing ones;
- building a permission/sandbox layer before testing existing ones;
- building observability before consuming existing telemetry;
- MCP as a universal answer;
- daemon-first architecture;
- database-first architecture;
- hidden automation without inspectable work state;
- autonomy without independent verification where the work requires it.
