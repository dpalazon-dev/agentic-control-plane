# Architecture Hypotheses

## Status

This document records **architectural hypotheses to validate**. It is not an implementation architecture.

No language, database, daemon model, protocol, API, workflow engine, schema, TUI framework or storage technology is selected here. Accepted project decisions live only in [`DECISIONS.md`](DECISIONS.md).

Labels used below:

- **HYPOTHESIS** — plausible structure that still requires evidence.
- **OPEN** — unresolved question or design choice.
- **BOUNDARY** — consequence of an already accepted project decision.

## Initial conceptual model

**HYPOTHESIS**

```text
Human
  ↓
Existing Coding Client
Claude Code / Codex / OpenCode / Gemini CLI / ...
  ↓
Client-Specific Integration Adapter
  ↓
Agentic Control Plane Core
  ↓
Persistent Work State
```

This diagram expresses responsibility boundaries, not process topology.

In particular, **Control Plane Core does not mean daemon**. The eventual core could be invoked on demand, exposed through a process, composed from files and commands, or take another form. Process lifecycle and state ownership remain open.

The word **adapter** also does not imply a single protocol. Different clients expose different supported integration surfaces, and the eventual mechanism may differ per client.

## Conceptual responsibilities

The current hypothesis groups potential responsibilities into five areas:

```text
Work
Governance
Capabilities
Integration
Observation
```

These are analytical buckets. They are not yet modules, packages, services or APIs.

---

## Work

### Problem being investigated

Coding sessions need a way to understand not only *what the user just asked*, but potentially how that request relates to longer-lived project work.

### Candidate concepts

**HYPOTHESIS**

```text
Intent
Work
Dependency
State
Outcome
```

Possible responsibilities include:

- preserve the current intent beyond a single conversational turn;
- represent units of work at a useful granularity;
- express dependencies where they materially affect execution;
- determine whether work is ready, blocked, active or complete;
- connect completion to an explicit outcome rather than a conversational claim;
- preserve enough history to continue across sessions or clients.

None of these implies that a custom work graph is required.

### Open questions

- **OPEN:** Do we actually need a graph, or are simpler ordered/linked work records sufficient?
- **OPEN:** What is the useful granularity of `Work`?
- **OPEN:** Is `Intent` distinct from `Work`, or only metadata on a work item?
- **OPEN:** Who decomposes work: the human, current coding agent, an upstream tool, control-plane logic, or some combination?
- **OPEN:** How is `ready` or `blocked` determined without creating a workflow engine?
- **OPEN:** Which work state, if any, belongs in Git?
- **OPEN:** Can an upstream substrate such as Beads or Backlog.md provide this model sufficiently?
- **OPEN:** Does the control plane need to own work state at all, or can it project/query another source of truth?

---

## Governance

### Problem being investigated

As coding agents receive more execution autonomy, project rules must distinguish between guidance, enforceable constraints, required approvals and evidence of completion.

### Candidate concepts

**HYPOTHESIS**

```text
Constraint
Policy
Risk
Approval
QualityGate
Evidence
```

Possible responsibilities include:

- identify constraints relevant to the current work;
- classify whether a rule is advisory or technically enforceable;
- require human approval only where judgment or risk warrants it;
- define evidence expected before an outcome can be accepted;
- express quality gates in terms that can be evaluated by available client/tooling surfaces;
- preserve why a gate passed, failed or was overridden.

### Guidance vs enforcement

This distinction must remain explicit:

```text
guidance
    ≠
enforcement
```

A prompt, instruction file or contextual note may influence an agent. It does not by itself create a security or governance boundary.

Where a coding client exposes permissions, blocking hooks, policy engines, sandboxes or equivalent mechanisms, those mechanisms may be candidates for enforcement. Where it does not, the control plane must not pretend that guidance is enforceable.

### Open questions

- **OPEN:** Which governance rules can be applied technically on each coding client?
- **OPEN:** Which rules can only be checked after execution?
- **OPEN:** What belongs to the control plane versus repository CI, tests, linters or the coding client's own safety layer?
- **OPEN:** How is risk represented, if it needs representation at all?
- **OPEN:** When is human approval genuinely required?
- **OPEN:** What does `done` mean for different classes of work?
- **OPEN:** What constitutes sufficient `Evidence`?
- **OPEN:** Can evidence be derived from existing commands/events rather than creating a separate reporting system?

---

## Capabilities

### Problem being investigated

Many current agentic methodologies encode execution as a sequence of named agents or personas. That risks coupling a semantic need of the work to a particular prompt, model or client implementation.

### Capability-driven hypothesis

**HYPOTHESIS**

```text
work
  ↓
semantic classification
  ↓
required capabilities
  ↓
executor resolution
```

Candidate capability names for experiments might include:

```text
explore
research / reason
build
debug
review
verify
document
```

The set is intentionally provisional.

The core distinction is:

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

For example, a requirement for independent verification might be fulfilled by:

- a native subagent in one client;
- a second pass in the current client;
- a deterministic test/linter/CI command;
- an external specialized tool;
- a human reviewer;
- some combination of these.

The semantic requirement should not automatically become a permanent `VerifierAgent` abstraction.

### Adaptive orchestration hypothesis

**HYPOTHESIS:** The structure required for a piece of work should derive from its type, uncertainty, risk and verification needs rather than from a mandatory global pipeline.

This does not yet imply a classifier, rule engine, LLM router, workflow DSL or scheduler. The smallest useful experiment should first test whether capability-based reasoning produces better execution decisions than a fixed workflow.

### Open questions

- **OPEN:** Is an explicit capability model useful enough to justify a new abstraction?
- **OPEN:** Which capabilities are semantic and stable across clients?
- **OPEN:** Can capability resolution mostly reuse native client functionality?
- **OPEN:** Who resolves an executor?
- **OPEN:** Does resolution require a model, deterministic rules, user choice, or a mixture?
- **OPEN:** How should cost, latency, risk and confidence influence resolution, if at all?
- **OPEN:** How can repair/retry occur without the control plane becoming an agent runtime?

---

## Integration

### Boundary

**BOUNDARY:** Existing coding clients remain the user's primary interaction surface. Client-specific behavior belongs behind an integration boundary rather than leaking into the shared conceptual model.

### Supported-surface hypothesis

**HYPOTHESIS:** Useful integration can be built by composing only surfaces that each coding client officially supports, such as some subset of:

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

No assumption is made that every client supports every surface or that similarly named surfaces provide equivalent guarantees.

### Integration asymmetry

A central architectural risk is **capability asymmetry across clients**.

One client may expose synchronous pre-tool hooks capable of blocking an operation. Another may expose sandbox/approval configuration but no equivalent generic hook lifecycle. Another may expose a plugin API with a different stability contract.

Therefore:

- integration portability must be defined semantically, not as identical mechanisms;
- the core may request `enforce constraint X`, but an adapter must report whether that is actually enforceable on its host;
- unsupported capabilities must degrade explicitly rather than silently;
- client adapters must not rely on undocumented internals merely to achieve apparent parity.

### The "must run" problem

The desired system should participate automatically when enabled, but **OPEN:** whether that can be guaranteed uniformly across clients is not yet established.

There is an important difference between:

1. an optional tool the model may choose to call;
2. instructions that tell the model to consult the control plane;
3. a client-native lifecycle hook that invokes it deterministically;
4. a permission/policy surface that can block an action;
5. an external wrapper that ensures execution but changes the launch/runtime boundary.

SPIKE-001 must determine which of these are available and acceptable per client before "always executes" can become a real invariant.

### Open questions

- **OPEN:** What is the minimum integration contract shared by all target clients?
- **OPEN:** Is MCP useful for querying state but insufficient for mandatory lifecycle behavior?
- **OPEN:** Which clients provide deterministic pre/post action hooks?
- **OPEN:** Which policies can be installed at project, user or managed scope?
- **OPEN:** Do adapters need a wrapper for any client, and would that violate the desired transparent experience?
- **OPEN:** How are client versions/capabilities discovered without brittle assumptions?
- **OPEN:** How should adapter degradation be surfaced to humans and agents?

---

## Observation

### Problem being investigated

If significant work state and governance move outside a conversation, humans need a way to inspect that state without changing their primary coding interface.

### Projection hypothesis

**HYPOTHESIS:** The core should expose enough state or events to be observed through multiple projections, potentially including:

```text
CLI
structured output (for example JSON)
TUI
other local tooling
```

The TUI, if built, should be only one projection.

Potentially observable information includes:

- current intent;
- work and dependencies;
- ready / blocked / running state;
- required capabilities and chosen executors;
- pending human decisions;
- constraints and quality gates;
- evidence and verification results;
- failures and repair attempts;
- progress;
- telemetry or cost data when available from upstream tools.

### Open questions

- **OPEN:** What events are genuinely useful enough to justify an event model?
- **OPEN:** Can observation begin as on-demand state queries instead of a continuous event stream?
- **OPEN:** What state is authoritative versus derived?
- **OPEN:** What edits, if any, should an observer surface allow?
- **OPEN:** How are conflicts handled if a human edits state while a client is executing?

---

## Persistence and concurrency

Persistence is a requirement at the conceptual level only insofar as the project is investigating **cross-session work continuity**. Its implementation remains open.

Questions to validate before selecting storage or lifecycle technology:

- **OPEN:** on-demand core versus resident process;
- **OPEN:** one active client versus concurrent clients;
- **OPEN:** locking or optimistic concurrency requirements;
- **OPEN:** need for an event stream;
- **OPEN:** crash recovery semantics;
- **OPEN:** stale execution detection;
- **OPEN:** state ownership;
- **OPEN:** private local state versus Git-versioned state;
- **OPEN:** Windows process/filesystem behavior;
- **OPEN:** queries and invariants that a storage mechanism must support.

A database should not be selected before these questions produce concrete requirements.

## Source of truth

**OPEN:** The project does not yet know whether it needs one unified source of truth.

Possible arrangements include, without preference:

- a control-plane-owned minimal work model;
- an upstream work substrate used directly;
- repository files;
- Git-versioned and private state split by concern;
- a derived projection over multiple authoritative systems.

The term `Persistent Work State` in the conceptual diagram means only that continuity must exist somewhere if the hypothesis proves useful. It does not select a storage format or ownership model.

## Candidate validation spikes

These are expected research experiments, not designs and not yet separate documents.

### SPIKE-001 — Client integration surfaces

Determine what can actually be observed, injected and enforced through supported surfaces in Claude Code, Codex, OpenCode and Gemini CLI.

Expected output: an evidence-backed capability matrix distinguishing guidance from enforcement.

### SPIKE-002 — Work substrate

Compare at least Beads, Backlog.md, simple repository files and a minimal custom representation.

Expected output: evidence for whether the control plane needs to own a work model at all.

### SPIKE-003 — Adaptive control loop

Test the smallest possible loop:

```text
user intent
  ↓
classify work
  ↓
determine required capability
  ↓
resolve / guide executor
  ↓
verify
  ↓
repair, retry or escalate
  ↓
record outcome
```

Expected output: evidence for whether capability-driven execution is a useful abstraction. Do not build a workflow engine to run this experiment.

### SPIKE-004 — Persistence and concurrency

Test the lifecycle and consistency requirements that would determine storage and process architecture.

Expected output: requirements for runtime/persistence choices, not a premature implementation.

## Architecture discipline

Before introducing a component or abstraction, ask:

1. What observable problem does it solve?
2. Does the coding client already solve it?
3. Does an upstream tool already solve it?
4. Does the control plane need to own this state?
5. Does the state need to persist?
6. Is a new abstraction necessary?
7. Can the uncertainty be resolved by a smaller spike first?
8. Is the design serving a real developer workflow or a hypothetical platform?

Avoid especially:

- multi-agent theatre;
- role names that merely wrap prompts;
- dashboards before useful observable state exists;
- a daemon before background state is demonstrated as necessary;
- a database before queries and invariants are known;
- schemas before the semantic model is stable enough to justify them;
- MCP as a universal answer;
- a workflow DSL before repeated workflows are demonstrated;
- premature cross-platform uniformity;
- autonomy without verification.
