# Agentic Work Control Plane

`agentic-work-control-plane` is a research project investigating a **local, agent-agnostic control plane for persistent, governed and verifiable software work across existing coding agents**.

The project does **not** aim to control agents as managed infrastructure or replace their runtimes. Its primary object is the **work**: intent, work packages, tasks, dependencies, constraints, decisions, required agent roles, evidence and completion state.

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

The project deliberately follows:

`research → hypotheses → spikes → evidence → decisions → design → implementation`

No work substrate, context system, permission system, storage model, runtime model, integration protocol, language, API, workflow representation, TUI technology or concrete role catalog has been selected.

## Why "Work Control Plane"?

```text
Agent Control Plane        → governs agents / agent infrastructure
Agentic Work Control Plane → governs the software work performed with coding agents
```

The Work Control Plane determines what work exists, which responsibilities must participate, which constraints and context apply, what evidence is required and whether completion is justified. The coding client remains the primary interaction and execution surface.

## What this is not

This project is not intended to become another coding client, IDE, chat interface, Jira clone, generic workflow engine, agent fleet manager, model runtime, custom-agent framework, prompt framework or mandatory TUI.

It also does not assume that AWCP must own every supporting subsystem. Existing tools may remain authoritative for specs, tasks, context, memory, permissions, Git, CI, tests, telemetry or other concerns if composition proves sufficient.

## Read in this order

1. [`docs/VISION.md`](docs/VISION.md) — the problem, governed object and desired operating model.
2. [`docs/RESEARCH.md`](docs/RESEARCH.md) — what existing systems already solve and what gap, if any, remains.
3. [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — architectural hypotheses and boundaries still requiring validation.
4. [`docs/DECISIONS.md`](docs/DECISIONS.md) — accepted boundaries and explicitly open choices.

This repository is intentionally small until evidence justifies additional structure.