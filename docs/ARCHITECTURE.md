# Architecture Hypotheses

## Status

This document records **architectural hypotheses to validate** for Agentic Work Control Plane. It is not an implementation architecture.

No language, database, daemon model, protocol, API, workflow engine, schema, TUI framework or storage technology is selected here. Accepted project decisions live only in [`DECISIONS.md`](DECISIONS.md).

Labels used below:

- **HYPOTHESIS** — plausible structure that still requires evidence.
- **OPEN** — unresolved question or design choice.
- **BOUNDARY** — consequence of an accepted project decision.

---

## 1. Architectural reframing

The previous mental model was too easy to read as a runtime stack:

```text
Coding Client
    ↓
Control Plane
    ↓
Persistent Work State
```

That representation is misleading because the Work Control Plane is not intended to sit *inside* or *under* the coding agent's execution loop.

The more accurate hypothesis is an **orthogonal work-control relationship**:

```text
                         Human
                           │
                           ▼
                  Existing Coding Client
             Claude / Codex / OpenCode / ...
                           │
                           │ executes / contributes
                           ▼
                  Repository + Tooling
                           │
                           │ outcomes / evidence
                           ▼

             ┌────────────────────────────┐
             │ Agentic Work Control Plane │
             │                            │
             │ intent                     │
             │ work structure             │
             │ constraints                │
             │ decisions                  │
             │ capability requirements    │
             │ evidence                   │
             │ completion                 │
             └────────────────────────────┘
                    ▲               │
                    │               │
             persistent state   relevant work
                    │           context / gates
                    └───────────────┘
```

The arrows are conceptual rather than a final data-flow topology.

**BOUNDARY:** The coding client owns its native agent loop and execution experience.

**BOUNDARY:** The Work Control Plane governs the semantic state and requirements of work, not the operational lifecycle of an agent fleet.

This means that "control" should be interpreted as **control of work state, admissible transitions, applicable constraints and completion claims**, not necessarily direct runtime control over an executor.

---

## 2. Primary architectural object: software work

**HYPOTHESIS:** The most useful shared abstraction is not `Agent`, `Session` or `Prompt`, but some minimal representation of **software work**.

Candidate semantic concepts include:

```text
Intent
Work
Dependency
Constraint
Decision
CapabilityRequirement
Evidence
Outcome
State
```

These names are provisional. The project must not create a full ontology before experiments demonstrate which distinctions are useful.

### Work as a contract boundary

A useful mental model may be:

```text
Human intent
    ↓
Work contract
    ↓
Executor contribution
    ↓
Observable outcome
    ↓
Evidence
    ↓
Completion decision
```

A `Work contract` here does not imply a specific schema. It simply means that execution should have an explicit enough statement of expected outcome, constraints and completion conditions to be inspected and verified.

### Open questions

- **OPEN:** What is the smallest useful representation of `Work`?
- **OPEN:** Is `Intent` distinct from `Work`?
- **OPEN:** Do specifications belong inside the work model or remain external referenced artifacts?
- **OPEN:** Is a dependency graph necessary, or are simpler relations sufficient?
- **OPEN:** Who creates and decomposes work?
- **OPEN:** Which state transitions must be explicit?
- **OPEN:** Which work state needs persistence?
- **OPEN:** Which state must the Work Control Plane own versus reference from elsewhere?

---

## 3. Conceptual responsibilities

The current hypothesis groups possible responsibilities into five analytical areas:

```text
Work
Governance
Capabilities
Integration
Observation
```

These are not modules or services.

---

## 4. Work

### Problem being investigated

Coding-agent sessions are effective execution contexts but poor universal project memory. The project needs to determine whether durable work semantics should exist independently from a particular session or client.

Possible responsibilities include:

- preserve relevant intent beyond a single conversational turn;
- represent work at a useful granularity;
- express dependencies where they affect readiness;
- expose ready, blocked, active and complete state where useful;
- connect work to decisions and constraints;
- connect completion to outcomes and evidence;
- make continuity possible across sessions and coding clients.

### Source-of-truth hypothesis

**HYPOTHESIS:** The Work Control Plane may not need to own the underlying work substrate.

Possible arrangements include:

```text
A. Work Control Plane owns minimal work state
B. Existing substrate is authoritative; AWCP queries/projects it
C. Multiple systems remain authoritative by concern
D. AWCP stores only control metadata around external artifacts
```

No arrangement is preferred yet.

### Open questions

- **OPEN:** Can Beads provide enough dependency/readiness semantics?
- **OPEN:** Can Backlog.md provide enough human-readable work state?
- **OPEN:** Can Spec Kit or another spec harness serve as the work contract layer?
- **OPEN:** Is Okto Pulse already sufficiently close to the complete work layer?
- **OPEN:** Is a custom representation justified at all?

---

## 5. Governance

### Problem being investigated

More autonomous execution increases the importance of knowing what an executor is allowed to do, what must be verified and when a completion claim is acceptable.

Candidate concepts:

```text
Constraint
Policy
Risk
Approval
QualityGate
Evidence
CompletionRule
```

Possible responsibilities include:

- determine which constraints apply to current work;
- distinguish advisory guidance from technically enforceable policy;
- express required approvals where risk or ambiguity warrants them;
- specify expected verification before completion;
- record evidence and overrides;
- prevent a work-state transition to complete when required evidence is missing, where technically possible.

### Three different guarantees

The architecture should distinguish at least:

```text
guidance
verification
enforcement
```

These are not interchangeable.

- **Guidance** tells an executor how it should behave.
- **Verification** checks an observable result before or after execution.
- **Enforcement** technically prevents or constrains an action or state transition.

A coding client may support one guarantee but not another.

### Open questions

- **OPEN:** Which governance belongs in AWCP versus Git/CI/tests/linters/client sandboxing?
- **OPEN:** Does risk need explicit representation?
- **OPEN:** What constitutes sufficient evidence for different work classes?
- **OPEN:** Is completion decided by deterministic gates, an agent judgment, a human judgment or some combination?

---

## 6. Capabilities

### Problem being investigated

Agentic-development systems often bind work semantics directly to named agents or workflow stages. AWCP should test whether a more portable abstraction is to describe **what capability the work requires** and leave executor realization separate.

### Capability requirement hypothesis

**HYPOTHESIS:** Work may carry semantic capability requirements independent from a particular executor.

```text
work
  ↓
requirements / risk / uncertainty
  ↓
required capability
  ↓
executor resolution
  ↓
contribution + evidence
```

Provisional capability examples:

```text
explore
research / reason
implement
debug
review
verify
document
```

The vocabulary is intentionally not accepted.

The key separation remains:

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

A `verify` requirement might be satisfied by:

- deterministic tests;
- CI;
- a native coding-client subagent;
- a second review pass;
- a specialized external tool;
- a human;
- a combination of the above.

### Executor is not necessarily an agent

This is a direct consequence of centering the architecture on work rather than agents.

Possible executors/contributors include:

```text
coding agent
human
test runner
linter
CI job
security scanner
external tool
```

### Open questions

- **OPEN:** Is an explicit capability model useful enough to justify itself?
- **OPEN:** Which capabilities remain stable across clients?
- **OPEN:** Who or what resolves capability requirements to executors?
- **OPEN:** Is executor resolution merely advisory to the current coding client?
- **OPEN:** At what point would executor resolution become orchestration and violate the runtime boundary?

---

## 7. Integration

### Boundary

**BOUNDARY:** Client-specific integration must implement shared work semantics using supported surfaces without pretending that all clients provide equivalent guarantees.

Potential surfaces include some subset of:

```text
hooks
permissions / policy engines
skills
plugins
instructions
subagents
MCP
CLI commands
structured output
events / telemetry
wrappers
```

No mechanism is selected.

### Semantic adapter hypothesis

**HYPOTHESIS:** An adapter may be better modeled around semantic capabilities than around a uniform protocol.

For a requested interaction, the adapter may need to expose what guarantee it can provide. A provisional vocabulary for investigation is:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
```

This vocabulary is not accepted architecture; SPIKE-001 should determine whether distinctions like these are useful.

### Example

Suppose the work requires:

```text
Constraint: tests must pass before completion
```

Different hosts might realize that as:

```text
client A → blocking lifecycle hook
client B → permission/policy integration
client C → post-execution verification only
client D → contextual instruction only
```

The semantic requirement remains stable while the available guarantee changes.

### The mandatory-participation problem

The desired system should participate automatically when enabled, but that is not yet established as a portable invariant.

There is a material difference between:

1. an MCP tool the model may choose to call;
2. instructions asking the model to consult work state;
3. a client-native lifecycle hook that invokes AWCP deterministically;
4. a policy/permission surface capable of blocking behavior;
5. an external wrapper that guarantees invocation but changes the launch boundary.

SPIKE-001 must determine which combinations are actually supported and acceptable for Claude Code, Codex, OpenCode and Gemini CLI.

### Open questions

- **OPEN:** What is the minimum semantic integration contract?
- **OPEN:** Which clients support deterministic pre/post lifecycle participation?
- **OPEN:** Which clients support only context/tool exposure?
- **OPEN:** Is MCP useful primarily as a query/action surface rather than an enforcement mechanism?
- **OPEN:** Are wrappers acceptable for any client?
- **OPEN:** How should degraded integration guarantees be surfaced?

---

## 8. Evidence and completion

Centering the architecture on work suggests that **evidence may be more important than execution telemetry**.

### Hypothesis

**HYPOTHESIS:** AWCP should retain or reference externally inspectable evidence that supports meaningful work-state transitions.

Potential evidence might include:

- test results;
- lint/type-check results;
- build output;
- changed files or commits;
- review findings;
- benchmark results;
- human approval;
- generated artifacts;
- external system responses.

This should not become a mechanism for storing hidden reasoning or chain-of-thought.

### Completion hypothesis

```text
agent says "done"
        ≠
work is complete
```

Completion may instead mean:

```text
expected outcome exists
+ required verification executed
+ required evidence exists
+ blocking constraints satisfied
+ required approvals resolved
```

The exact semantics must be discovered per work class rather than universalized prematurely.

---

## 9. Observation

If work state and governance persist outside a chat session, humans need direct visibility into that state.

**HYPOTHESIS:** AWCP should expose enough state for multiple observers or projections, potentially including:

```text
CLI
JSON / structured queries
TUI
other local tooling
```

Potentially observable information:

- intent;
- current work;
- dependencies and readiness;
- constraints and gates;
- required capabilities;
- current executor where known;
- evidence;
- completion state;
- pending human decisions;
- failures and unresolved verification;
- derived telemetry where useful.

The TUI remains optional and owns no independent state.

---

## 10. Persistence and concurrency

Persistence is justified only where durable work continuity or governance requires it.

Questions to validate before choosing storage or lifecycle technology:

- **OPEN:** which work/control state needs durability;
- **OPEN:** on-demand core versus resident process;
- **OPEN:** one active client versus concurrent clients;
- **OPEN:** locking or optimistic concurrency;
- **OPEN:** need for an event stream;
- **OPEN:** crash recovery semantics;
- **OPEN:** stale execution/work detection;
- **OPEN:** private local state versus Git-versioned state;
- **OPEN:** cross-platform filesystem/process behavior;
- **OPEN:** queries and invariants the storage layer must support.

A database should not be selected before these requirements exist.

---

## 11. Relationship to Agent Control Planes

Agent Control Planes and Agentic Work Control Plane may eventually coexist because they operate on different primary objects.

```text
                    Software Work
                         │
             Agentic Work Control Plane
                         │
                requirements / gates
                         │
                         ▼
                 Execution actors
              agents · humans · tools
                         ▲
                         │
               Agent Control Plane
                         │
       identity · lifecycle · fleet · runtime
```

This diagram does not mean AWCP should integrate with an enterprise Agent Control Plane. It only clarifies the abstraction boundary.

---

## 12. Candidate validation spikes

These are research experiments, not implementation plans.

### SPIKE-001 — Coding-client integration guarantees

Determine what can actually be injected, observed, verified and enforced through supported surfaces in Claude Code, Codex, OpenCode and Gemini CLI.

Expected output: an evidence-backed matrix of semantic integration guarantees.

### SPIKE-002 — Work substrate and ownership

Compare at least:

```text
Beads
Backlog.md
Spec Kit composition
Okto Pulse
simple repository files
minimal custom representation
```

Expected output: evidence for whether AWCP needs to own a work model at all.

### SPIKE-003 — Minimal adaptive work-control loop

Test the smallest useful sequence:

```text
human intent
  ↓
resolve relevant work state
  ↓
determine constraints / capability requirements
  ↓
current coding client executes
  ↓
collect / run verification
  ↓
record evidence
  ↓
accept, repair or escalate
```

The experiment should deliberately avoid building a workflow engine or agent runtime.

### SPIKE-004 — Persistence and concurrency

Test lifecycle and consistency requirements that would determine whether AWCP needs files, a database, an on-demand process, a daemon or some other mechanism.

---

## 13. Architecture discipline

Before introducing a concept, component or owned state, ask:

1. What observable work problem does it solve?
2. Does the coding client already solve it?
3. Does an existing work/spec tool already solve it?
4. Is the concern about **work** or are we accidentally managing **agents**?
5. Does AWCP need to own this state?
6. Does the state need to persist?
7. Is a new abstraction necessary?
8. Can the uncertainty be resolved by a smaller spike?
9. Are we preserving the coding client's execution ownership?
10. Is this serving a real developer workflow or an imagined platform?

Avoid especially:

- agent-fleet features disguised as work governance;
- multi-agent theatre;
- role names that merely wrap prompts;
- workflow engines before repeated workflows are demonstrated;
- dashboards before useful observable state exists;
- daemon-first architecture;
- database-first architecture;
- schemas before semantic invariants are known;
- MCP as a universal answer;
- forced worktrees;
- premature cross-client uniformity;
- hidden automation without inspectable state;
- autonomy without verification;
- owning state simply because integration is easier that way.
