# Agentic Work Control Plane

`agentic-work-control-plane` is a research project defining a **local, agent-agnostic companion control plane for persistent, governed and verifiable software work across existing coding agents**.

The project does **not** aim to control agents as managed infrastructure or replace their runtimes. Its primary object is the **work**: intent, work packages, tasks, dependencies, constraints, decisions, required agent roles, evidence and completion state.

AWCP is expected to include local software running alongside the coding client. That software owns a local database-backed work-control state and exposes a secondary TUI for quickly inspecting and lightly editing tasks, role assignments, execution history, agent/session attribution, decisions and evidence. Agents interact with the same control layer through client-supported integration surfaces; they do not run inside an AWCP-owned model runtime.

The core question is:

> How can software work be persistently structured, assigned the right agent responsibilities, governed and verified while developers continue using Claude Code, Codex, OpenCode, Gemini CLI or similar coding agents normally?

A central hypothesis is that work type, risk and complexity should determine the **required role composition** for each unit of work.

```text
Work
  ↓
required agent roles
  ↓
capabilities / responsibilities per role
  ↓
client-specific executor binding
  ↓
execution + evidence
  ↓
completion
```

For example, an implementation task may require `Developer + Tester + Code Reviewer`, while architecture/organization work may require `Architect + Senior Engineer`. These are semantic responsibilities of the work, not fixed models or permanent agent processes.

The Work Control Plane should also **reuse rather than reimplement** context management, memory, permissions, sandboxing, observability and other agent infrastructure wherever suitable local or client-native systems already provide them. The research problem is how to compose those capabilities around **existing daily coding agents**, rather than requiring users to build custom agents on a new runtime.

## Status

**Research and architecture validation.**  
**No implementation exists.**

Current Codex validation:

- [`docs/spikes/SPIKE-001-CODEX.md`](docs/spikes/SPIKE-001-CODEX.md) - completed Codex-native methodology and integration contract, backed by a first Windows dry run.
- [`docs/spikes/SPIKE-001-CODEX-EVIDENCE.md`](docs/spikes/SPIKE-001-CODEX-EVIDENCE.md) - runtime observations, native identifiers, limitations and revalidation rule.

The project deliberately follows:

`research → hypotheses → spikes → evidence → decisions → design → implementation`

No concrete work schema, context system, permission system, storage technology, process topology, integration protocol, language, API, TUI technology or role catalog has been selected.

## Why "Work Control Plane"?

```text
Agent Control Plane        → governs agents / agent infrastructure
Agentic Work Control Plane → governs the software work performed with coding agents
```

The Work Control Plane determines what work exists, persists its state and history, records which agents and sessions participated, derives which responsibilities must participate, tracks evidence and decides whether completion is justified. The coding client remains the primary interaction and execution surface; the AWCP TUI is the primary inspection surface for work-control state.

## What this is not

This project is not intended to become another coding client, IDE, chat interface, Jira clone, generic workflow engine, agent fleet manager, model runtime, custom-agent framework or prompt framework. Its TUI is a companion inspection and light-editing interface, not the place where the user must conduct coding-agent conversations.

It also does not assume that AWCP must own every supporting subsystem. Existing tools may remain authoritative for specifications, context, memory, permissions, Git, CI, tests, telemetry or other concerns. AWCP owns the work-control record and may reference those external artifacts rather than duplicate them.

## Read in this order

1. [`docs/VISION.md`](docs/VISION.md) — the problem, governed object and desired operating model.
2. [`docs/RESEARCH.md`](docs/RESEARCH.md) — what existing systems already solve and what gap, if any, remains.
3. [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — architectural hypotheses and boundaries still requiring validation.
4. [`docs/DECISIONS.md`](docs/DECISIONS.md) — accepted boundaries and explicitly open choices.
5. [`docs/spikes/SPIKE-001-CODEX.md`](docs/spikes/SPIKE-001-CODEX.md) — first Codex-only validation spike.

This repository is intentionally small until evidence justifies additional structure.
