# Agentic Work Control Plane

`agentic-work-control-plane` is a research project investigating a **local, agent-agnostic control plane for persistent, governed and verifiable software work across coding agents**.

The project does **not** aim to control agents as managed infrastructure. Its primary object is the **work** that coding agents perform: intent, specifications, work units, dependencies, constraints, decisions, required capabilities, evidence and completion state.

The core question is:

> How can different coding agents work against the same persistent, governed and verifiable model of software work without forcing developers to leave the coding client they already use?

The intended experience is simple:

```text
Human intent
    ↓
Existing coding client
Claude Code / Codex / OpenCode / Gemini CLI / ...
    ↓ executes against
Shared software-work model
    ↓
constraints · state · evidence · completion
```

The coding client remains the developer's primary interaction surface and owns its own agent loop. The Work Control Plane, if the hypothesis proves useful, supplies continuity and governance around the work without becoming another coding agent or agent runtime.

## Status

**Research and architecture validation.**  
**No implementation exists.**

The project deliberately follows:

`research → hypotheses → spikes → evidence → decisions → design → implementation`

No work substrate, storage model, runtime model, integration protocol, language, API, workflow representation, TUI technology or orchestration mechanism has been selected.

## Why "Work Control Plane"?

The term **Agent Control Plane** is increasingly used for systems that operate, monitor, secure and govern fleets of AI agents. That is a different problem.

This project does not primarily manage agent identity, deployment, lifecycle, fleet health, model configuration or distributed execution. It investigates whether **software work itself** needs a shared control layer that survives individual clients and sessions.

In shorthand:

```text
Agent Control Plane       → governs agents
Agentic Work Control Plane → governs software work performed with agents
```

## What this is not

This project is not intended to become another coding client, IDE, chat interface, Jira clone, generic workflow engine, multi-agent framework, agent fleet manager, model runtime, prompt framework or mandatory TUI.

It also does not assume that the Work Control Plane must own every piece of state. Existing tools may remain authoritative for specs, tasks, Git, CI, tests or other concerns if composition proves sufficient.

## Read in this order

1. [`docs/VISION.md`](docs/VISION.md) — the problem, governed object and desired experience.
2. [`docs/RESEARCH.md`](docs/RESEARCH.md) — what existing systems already solve and what gap, if any, remains.
3. [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — architectural hypotheses that still require validation.
4. [`docs/DECISIONS.md`](docs/DECISIONS.md) — accepted boundaries and explicitly open choices.

This repository is intentionally small until evidence justifies additional structure.
