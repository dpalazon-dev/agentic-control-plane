# Decisions

## Status

This log intentionally contains only a small set of accepted conceptual boundaries.

`AWCP-DEC-001` through `AWCP-DEC-008` are currently accepted. Everything listed under **Open questions and undecided choices** remains `OPEN`.

Decision status vocabulary:

- `ACCEPTED` — part of the current project boundary.
- `OPEN` — not decided.

---

## AWCP-DEC-001 — The governed object is software work, not the agent fleet

**Status:** ACCEPTED

### Decision

Agentic Work Control Plane is concerned primarily with the **software work performed with coding agents**: intent, structure, constraints, decisions, required responsibilities, evidence and completion state.

It is not an Agent Control Plane for deploying, registering, operating or monitoring a fleet of AI agents as infrastructure.

### Consequence

Agent lifecycle, deployment, hosting, fleet health and distributed agent operations are outside the primary product boundary.

Agent roles may be first-class elements of the work model without making the agent fleet itself the governed object.

---

## AWCP-DEC-002 — Existing coding clients remain the primary interaction and execution surface

**Status:** ACCEPTED

### Decision

Developers continue working through coding clients such as Claude Code, Codex, OpenCode and Gemini CLI. Those clients retain ownership of their normal conversational interface, native agent loop and tool execution.

### Consequence

AWCP must integrate with already-built coding agents rather than require users to rebuild their daily development workflow on a custom agent SDK/runtime.

A future TUI or Work Control Plane UI is secondary: it observes or lightly edits shared work state rather than replacing the coding client.

---

## AWCP-DEC-003 — The system is local-first

**Status:** ACCEPTED

### Decision

Core software-work state and control should work locally by default.

### Consequence

A hosted service must not be required for the fundamental experience. This does not decide how local state is stored, synchronized, shared or optionally connected to remote systems.

---

## AWCP-DEC-004 — Work, role, capability, executor and model are distinct abstractions

**Status:** ACCEPTED

### Decision

AWCP must preserve the distinction:

```text
Work Type
≠ Agent Role
≠ Capability
≠ Executor Instance
≠ Model
```

A role such as `Developer`, `Tester`, `Code Reviewer` or `Architect` represents a semantic responsibility required by the work. It must not be collapsed into a generic capability or permanently bound to a particular client, model, prompt or agent process.

### Consequence

Client adapters may realize the same role differently. A role definition may imply required capabilities, context, permissions, inputs, outputs, evidence and independence constraints without fixing the runtime implementation.

---

## AWCP-DEC-005 — Critical work governance must not rely exclusively on prompts

**Status:** ACCEPTED

### Decision

Where the host client or surrounding development environment exposes technical enforcement surfaces, critical work constraints and role restrictions should use them rather than relying exclusively on natural-language instructions.

### Consequence

The project must distinguish explicitly between:

```text
guidance
verification
enforcement
```

If a host can only receive an instruction but cannot technically constrain the relevant behavior, AWCP must not describe that integration as deterministic enforcement.

---

## AWCP-DEC-006 — Reuse upstream infrastructure before implementing equivalents

**Status:** ACCEPTED

### Decision

Before creating a subsystem or owning new state, determine whether an existing coding-client capability, local system or external project already solves the problem sufficiently.

This applies explicitly to:

- work/spec substrates;
- context management;
- project memory;
- permissions and policy;
- sandboxing;
- observability and telemetry;
- verification tooling;
- agent-control infrastructure;
- client-native subagent/agent mechanisms.

### Consequence

AWCP may express semantic requirements for context, permissions, memory, verification or observability without implementing those systems itself.

The burden of proof is on new AWCP infrastructure. **Integrate, do not reimplement by default.**

---

## AWCP-DEC-007 — Work derives required agent-role composition

**Status:** ACCEPTED

### Decision

The methodology must be able to derive **required agent roles** from the type, risk, complexity and needs of a unit of work.

There is no single mandatory global agent pipeline. However, a given class of work may require a specific composition of responsibilities before it is eligible for completion.

Illustrative examples:

```text
implementation
→ Developer + Tester + Code Reviewer

architecture / organization
→ Architect + Senior Engineer
```

These examples do not define the final role taxonomy or policy table.

### Consequence

AWCP must be able to represent:

- required roles per work item or work level;
- role-specific responsibilities;
- required capabilities;
- context and permission requirements;
- expected evidence;
- ordering/dependency where necessary;
- separation-of-responsibility / independence constraints where necessary;
- completion conditions tied to satisfaction of required roles.

A role may be materialized through client-native agents/subagents or other supported mechanisms; AWCP does not thereby become a custom multi-agent runtime.

---

## AWCP-DEC-008 — Codex validation is methodology-first, not middleware-first

**Status:** ACCEPTED

### Decision

The first Codex integration validation will not create middleware, a custom runtime, a daemon, a scheduler, an adapter service or an AWCP-owned agent loop.

It will validate whether Codex's native surfaces can support a strict and auditable operating methodology for:

```text
Intent
→
Work Package / Task
→
required roles
→
role execution
→
evidence
→
completion
```

The methodology may be encoded through native Codex instructions, `AGENTS.md`, skills, subagents, permissions, sandboxing, rules, hooks, MCP configuration and explicit evidence requirements.

### Consequence

SPIKE-001 is Codex-only and must report actual guarantees honestly:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
```

If a requirement can only be expressed as instruction, it must not be described as deterministic enforcement.

The burden of proof remains on adding any AWCP-owned software.

---

# Open questions and undecided choices

Everything below remains **OPEN**.

## Work and methodology model

- `OPEN` — exact product scope;
- `OPEN` — whether a distinct Work Control Plane is necessary after composition experiments;
- `OPEN` — exact work hierarchy (`Intent`, `WorkPackage`, `Task`, or another model);
- `OPEN` — minimum useful work representation;
- `OPEN` — specification/work-contract representation;
- `OPEN` — dependency graph requirements;
- `OPEN` — work granularity;
- `OPEN` — work classification mechanism;
- `OPEN` — risk/complexity representation;
- `OPEN` — completion semantics across work types;
- `OPEN` — evidence model.

## Agent roles and methodology policy

- `OPEN` — final role vocabulary;
- `OPEN` — whether roles are global, project-configurable or both;
- `OPEN` — default role compositions per work class;
- `OPEN` — how role composition adapts to risk and complexity;
- `OPEN` — which roles require executor independence;
- `OPEN` — whether one executor may satisfy multiple compatible roles;
- `OPEN` — role inputs/outputs/contracts;
- `OPEN` — role-specific evidence requirements;
- `OPEN` — role ordering versus parallelism;
- `OPEN` — escalation when a client cannot realize a required role;
- `OPEN` — human roles/approvals versus agent roles.

## Capabilities and executor resolution

- `OPEN` — capability vocabulary;
- `OPEN` — whether capabilities need persistent representation;
- `OPEN` — mapping from roles to capabilities;
- `OPEN` — executor-resolution mechanism;
- `OPEN` — whether executor binding is advisory or operational per client;
- `OPEN` — retry/repair semantics;
- `OPEN` — use of deterministic tools as part of a role's evidence path.

## Context and memory

- `OPEN` — context-requirement representation;
- `OPEN` — project-memory provider(s);
- `OPEN` — whether AWCP must own any memory state;
- `OPEN` — integration with client-native memory/context;
- `OPEN` — integration with local external context-management systems;
- `OPEN` — context provenance and scoping;
- `OPEN` — role-specific context isolation.

## Permissions, policy and sandboxing

- `OPEN` — permission-requirement representation;
- `OPEN` — portable role permission semantics;
- `OPEN` — client-native permission/hook/policy mechanisms;
- `OPEN` — use of external local Agent Control Planes or policy systems;
- `OPEN` — sandbox integration;
- `OPEN` — whether separate role contexts are required to enforce independence;
- `OPEN` — enforcement guarantee matrix.

## Work substrate and persistence

- `OPEN` — Beads;
- `OPEN` — Backlog.md;
- `OPEN` — Spec Kit as a process/harness substrate;
- `OPEN` — Okto Pulse as a sufficiently close existing solution;
- `OPEN` — custom work model;
- `OPEN` — source-of-truth semantics;
- `OPEN` — which state AWCP must own versus reference;
- `OPEN` — repository files;
- `OPEN` — Git persistence;
- `OPEN` — SQLite or any other database;
- `OPEN` — daemon versus on-demand process;
- `OPEN` — concurrency, locking and crash recovery.

## Coding-client integration

- `OPEN` — mechanism per client;
- `OPEN` — common semantic adapter contract;
- `OPEN` — role materialization mechanism per client;
- `OPEN` — MCP;
- `OPEN` — hooks;
- `OPEN` — plugins;
- `OPEN` — skills;
- `OPEN` — instructions;
- `OPEN` — native subagents/agents;
- `OPEN` — wrappers;
- `OPEN` — CLI/API/events;
- `OPEN` — mandatory participation guarantees;
- `OPEN` — guarantee vocabulary such as `ENFORCEABLE`, `OBSERVABLE`, `INJECTABLE`, `GUIDANCE_ONLY`, `UNSUPPORTED`.

## Observability

- `OPEN` — reuse of client-native telemetry;
- `OPEN` — reuse of external local observability systems;
- `OPEN` — event model;
- `OPEN` — TUI technology;
- `OPEN` — cost/telemetry integration;
- `OPEN` — role-level execution visibility.

## Implementation technology

- `OPEN` — implementation language;
- `OPEN` — TypeScript;
- `OPEN` — Rust;
- `OPEN` — Python;
- `OPEN` — storage technology;
- `OPEN` — API technology;
- `OPEN` — Graphify integration;
- `OPEN` — Windows-specific runtime behavior.

These questions should move from `OPEN` only after research or spikes produce evidence strong enough to justify another explicit decision record.
