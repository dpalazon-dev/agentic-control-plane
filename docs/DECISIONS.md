# Decisions

## Status

This log intentionally begins with **very few accepted decisions**.

Only `AWCP-DEC-001` through `AWCP-DEC-006` are accepted. Everything listed under **Open questions and undecided choices** remains `OPEN`, even when other documents discuss it as a hypothesis or candidate.

The prefix changed from `ACP` to `AWCP` because the project boundary has been clarified from a generic/agent control plane to an **Agentic Work Control Plane**.

Decision status vocabulary:

- `ACCEPTED` — part of the current project boundary.
- `OPEN` — not decided.

---

## AWCP-DEC-001 — The governed object is software work, not the agent fleet

**Status:** ACCEPTED

### Decision

Agentic Work Control Plane is concerned primarily with the **software work performed with coding agents**: its intent, structure, constraints, decisions, capability requirements, evidence and completion state.

It is not an Agent Control Plane for deploying, registering, operating, monitoring or governing a fleet of AI agents as infrastructure.

### Consequence

Agent lifecycle, fleet inventory, deployment, model hosting, distributed scheduling, agent health and enterprise agent operations are outside the primary product boundary.

Agents, humans, CI and deterministic tools may be executors or contributors to work without becoming the core semantic object of the system.

---

## AWCP-DEC-002 — Existing coding clients remain the primary interaction and execution surface

**Status:** ACCEPTED

### Decision

Developers continue working through coding clients such as Claude Code, Codex, OpenCode and Gemini CLI. Those clients retain ownership of their normal conversational interface, agent loop and native tool execution.

Any future TUI or other Work Control Plane UI is secondary: it observes or lightly edits shared work state rather than replacing the coding client.

### Consequence

The project must integrate with coding clients rather than recreate them. It must not require a separate primary interface merely to use the work model.

---

## AWCP-DEC-003 — The system is local-first

**Status:** ACCEPTED

### Decision

Core software-work state and control should work locally by default.

### Consequence

A hosted service must not be required for the fundamental experience. This does not decide how local state is stored, synchronized, shared or optionally connected to remote systems.

---

## AWCP-DEC-004 — Work semantics are agent- and client-agnostic

**Status:** ACCEPTED

### Decision

Shared work concepts should describe semantic requirements of the software work rather than the private vocabulary or implementation model of a particular coding client, named agent or model.

Client-specific behavior belongs behind integration boundaries.

### Consequence

A concept such as `verification required`, `constraint`, `evidence` or `capability` must not automatically imply a specific Claude subagent, Codex mechanism, model, prompt or tool.

This does not guarantee feature parity across clients. The same semantic request may have different implementation guarantees on different hosts.

---

## AWCP-DEC-005 — Critical work governance must not rely exclusively on prompts

**Status:** ACCEPTED

### Decision

Where the host client or surrounding development environment exposes technical enforcement surfaces, critical work constraints should use them rather than relying exclusively on natural-language instructions.

### Consequence

The project must distinguish explicitly between **guidance**, **verification** and **enforcement**.

If a host can only receive an instruction but cannot technically block or guarantee the relevant behavior, the Work Control Plane must not describe that integration as deterministic enforcement.

---

## AWCP-DEC-006 — Reuse upstream capabilities before implementing equivalents

**Status:** ACCEPTED

### Decision

Before creating a subsystem or owning new state, determine whether an existing coding-client capability or external project already solves the problem sufficiently.

### Consequence

The burden of proof is on new Work Control Plane abstractions. Existing work substrates, spec systems, Git, CI, client permissions/hooks, verification tools and other supported primitives should be evaluated before equivalent functionality is built.

The Work Control Plane does not need to own a concern merely because it needs to reason about or observe it.

---

# Open questions and undecided choices

Everything below is **OPEN**.

## Product and semantic model

- `OPEN` — exact product scope;
- `OPEN` — whether a distinct Work Control Plane is necessary after composition experiments;
- `OPEN` — the minimum useful work model;
- `OPEN` — whether `Intent` is a first-class concept;
- `OPEN` — specification/work-contract representation;
- `OPEN` — work substrate;
- `OPEN` — Beads;
- `OPEN` — Backlog.md;
- `OPEN` — Spec Kit as a process/harness substrate;
- `OPEN` — Okto Pulse as a sufficiently close existing solution;
- `OPEN` — custom work model;
- `OPEN` — whether a dependency graph is required;
- `OPEN` — work granularity;
- `OPEN` — source-of-truth semantics;
- `OPEN` — decision representation beyond bootstrap documentation;
- `OPEN` — evidence model;
- `OPEN` — completion semantics;
- `OPEN` — risk model;
- `OPEN` — capability model;
- `OPEN` — capability vocabulary;
- `OPEN` — executor-resolution semantics;
- `OPEN` — repair/retry semantics;
- `OPEN` — human-approval model.

## Ownership and persistence

- `OPEN` — which state the Work Control Plane must own;
- `OPEN` — which state can remain authoritative upstream;
- `OPEN` — unified source of truth versus derived projection;
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
- `OPEN` — stale work/execution detection.

## Coding-client integration

- `OPEN` — integration mechanism per client;
- `OPEN` — common semantic adapter contract;
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
- `OPEN` — evidence collection mechanism;
- `OPEN` — enforcement capability matrix;
- `OPEN` — whether enabled participation can be made deterministic on every target client;
- `OPEN` — adapter capability vocabulary such as `ENFORCEABLE`, `OBSERVABLE`, `INJECTABLE`, `GUIDANCE_ONLY`, `UNSUPPORTED`.

## Execution boundary

- `OPEN` — whether the Work Control Plane ever invokes a model directly for narrow support functions;
- `OPEN` — whether model-assisted classification is useful or necessary;
- `OPEN` — how required capabilities resolve to available executors;
- `OPEN` — whether executor resolution is advisory or operational;
- `OPEN` — retry policy;
- `OPEN` — scheduling semantics, if any;
- `OPEN` — parallel-work semantics;
- `OPEN` — interaction with worktrees;
- `OPEN` — where work control ends and agent/session orchestration begins.

## Observation

- `OPEN` — event model;
- `OPEN` — authoritative versus derived observable state;
- `OPEN` — TUI technology;
- `OPEN` — CLI/JSON observation surfaces;
- `OPEN` — allowed human edits;
- `OPEN` — observability stack;
- `OPEN` — cost/telemetry integration.

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
