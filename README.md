# Agentic Control Plane

`agentic-control-plane` is a research project investigating a **local, agent-agnostic control plane for agentic software development**.

The core question is:

> How can different coding agents work against persistent, verifiable and governed work structure without forcing developers to leave the coding client they already use?

The intended experience is that developers continue working normally in Claude Code, Codex, OpenCode, Gemini CLI, or similar clients, while a client-independent layer may provide shared work state, governance, structured context, evidence and continuity where those capabilities prove useful.

## Status

**Research and architecture validation.**  
**No implementation exists.**

The project deliberately follows:

`research → hypotheses → spikes → evidence → decisions → design → implementation`

It has not yet selected a work substrate, storage model, runtime model, integration protocol, implementation language, API, workflow representation, TUI technology, or orchestration mechanism.

## What this is not

This project is not intended to become another coding agent, IDE, chat interface, Jira clone, generic workflow engine, multi-agent runtime, prompt framework, or mandatory TUI. Existing coding clients remain the developer's primary interaction surface.

The term **control plane** describes the problem boundary being investigated; it does **not** imply that the eventual system must be a daemon, long-running service, central scheduler, or model runtime.

## Read in this order

1. [`docs/VISION.md`](docs/VISION.md) — the problem, desired experience and boundaries.
2. [`docs/RESEARCH.md`](docs/RESEARCH.md) — what existing systems already solve and what remains uncertain.
3. [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — architectural hypotheses that still require validation.
4. [`docs/DECISIONS.md`](docs/DECISIONS.md) — the small set of decisions currently accepted; everything else remains open.

This repository is intentionally small until evidence justifies additional structure.
