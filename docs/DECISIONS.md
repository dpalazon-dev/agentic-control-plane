# Decisions

## Status

This log intentionally begins with **very few accepted decisions**.

Only `ACP-DEC-001` through `ACP-DEC-006` are accepted. Everything listed under **Open questions and undecided choices** remains `OPEN`, even when other documents discuss it as a hypothesis or candidate.

Decision status vocabulary:

- `ACCEPTED` — part of the current project boundary.
- `OPEN` — not decided.

---

## ACP-DEC-001 — The control plane does not replace coding clients

**Status:** ACCEPTED

### Decision

Existing coding agents remain the user's primary interaction surface.

The project will investigate a layer that integrates with clients such as Claude Code, Codex, OpenCode and Gemini CLI rather than recreating their chat interface, agent loop, IDE/TUI experience or model execution runtime.

### Consequence

Client-specific functionality must be treated as an integration concern. The control plane should add project-level structure only where it creates value beyond what the coding client already provides.

---

## ACP-DEC-002 — The system is local-first

**Status:** ACCEPTED

### Decision

Core project/work state and control should work locally by default.

### Consequence

A hosted service must not be required for the fundamental control-plane experience. This does not decide how local state is stored, synchronized or shared.

---

## ACP-DEC-003 — The core is agent/client agnostic

**Status:** ACCEPTED

### Decision

Client-specific behavior belongs behind integration boundaries rather than contaminating the shared conceptual model.

### Consequence

The core should describe semantic needs such as work, constraints, capabilities or evidence without assuming that every coding client implements those needs through the same mechanism.

This does not guarantee feature parity across clients.

---

## ACP-DEC-004 — The TUI is an optional observer

**Status:** ACCEPTED

### Decision

The TUI, if implemented, projects control-plane state. It is not the primary interface and owns no independent project/work state.

### Consequence

The control plane must remain useful without a TUI. Observation and light editing, if eventually supported, must operate on the same authoritative state used by agents and other interfaces.

---

## ACP-DEC-005 — Critical governance must not rely exclusively on prompts

**Status:** ACCEPTED

### Decision

Where a coding client exposes technical enforcement surfaces, critical constraints should use them rather than relying exclusively on natural-language instructions.

### Consequence

The project must distinguish explicitly between **guidance** and **enforcement**. If a host cannot technically enforce a constraint, the system must not represent prompt compliance as deterministic enforcement.

---

## ACP-DEC-006 — Reuse upstream capabilities before implementing equivalents

**Status:** ACCEPTED

### Decision

Before creating a subsystem, determine whether an existing project or coding-client capability already solves the problem sufficiently.

### Consequence

The burden of proof is on new control-plane abstractions. Existing work substrates, spec systems, client permissions/hooks, verification tools and orchestration primitives should be evaluated before equivalent functionality is built.

---

# Open questions and undecided choices

Everything below is **OPEN**.

## Product and semantic model

- `OPEN` — exact product scope;
- `OPEN` — whether a distinct control plane is necessary after composition experiments;
- `OPEN` — work substrate;
- `OPEN` — Beads;
- `OPEN` — Backlog.md;
- `OPEN` — custom work model;
- `OPEN` — whether a dependency graph is required;
- `OPEN` — work granularity;
- `OPEN` — source-of-truth semantics;
- `OPEN` — specification representation;
- `OPEN` — research/decision representation beyond these bootstrap documents;
- `OPEN` — evidence model;
- `OPEN` — risk model;
- `OPEN` — capability model;
- `OPEN` — capability names;
- `OPEN` — workflow representation;
- `OPEN` — adaptive routing mechanism;
- `OPEN` — review/repair semantics;
- `OPEN` — human-approval model.

## Persistence and lifecycle

- `OPEN` — simple repository files;
- `OPEN` — Git as persistence or partial persistence;
- `OPEN` — private versus versioned state;
- `OPEN` — SQLite;
- `OPEN` — any other database;
- `OPEN` — daemon;
- `OPEN` — on-demand process;
- `OPEN` — process lifecycle;
- `OPEN` — concurrency model;
- `OPEN` — locking;
- `OPEN` — event stream;
- `OPEN` — crash recovery;
- `OPEN` — state ownership.

## Integration

- `OPEN` — client integration mechanism per client;
- `OPEN` — common adapter contract;
- `OPEN` — MCP;
- `OPEN` — hooks;
- `OPEN` — plugins;
- `OPEN` — skills;
- `OPEN` — instruction files;
- `OPEN` — wrappers;
- `OPEN` — CLI protocol;
- `OPEN` — API;
- `OPEN` — events;
- `OPEN` — context injection mechanism;
- `OPEN` — enforcement capability matrix;
- `OPEN` — whether enabled participation can be made deterministic on every target client.

## Implementation technology

- `OPEN` — implementation language;
- `OPEN` — TypeScript;
- `OPEN` — Rust;
- `OPEN` — Python;
- `OPEN` — storage technology;
- `OPEN` — API technology;
- `OPEN` — TUI technology;
- `OPEN` — Graphify integration;
- `OPEN` — observability stack.

## Runtime behavior

- `OPEN` — whether the control plane ever invokes models directly;
- `OPEN` — whether any model-assisted classification is needed;
- `OPEN` — executor resolution mechanism;
- `OPEN` — retry policy;
- `OPEN` — scheduling semantics;
- `OPEN` — parallel execution semantics;
- `OPEN` — interaction with worktrees;
- `OPEN` — Windows-specific runtime behavior.

These questions should move from `OPEN` only after research or spikes produce evidence strong enough to justify an explicit decision record.
