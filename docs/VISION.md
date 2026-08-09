# Vision

## Status

This document describes the **problem and desired experience**, not an implementation design.

The project is currently in **research and architecture validation**. All mechanisms described here are hypotheses unless they are explicitly listed as accepted decisions in [`DECISIONS.md`](DECISIONS.md).

## Problem

Coding agents are increasingly capable of carrying out substantial software work, but the structure that surrounds that work is often fragmented across:

- conversations and individual sessions;
- client-specific instructions and configuration;
- ephemeral plans and task lists;
- local reasoning that is difficult to reconstruct later;
- ad-hoc prompts that mix intent, policy, process and implementation detail;
- evidence of completion that is not consistently persisted or connected to the work it is meant to prove.

This creates a mismatch between increasingly autonomous execution and the developer's ability to understand, govern and continue that execution over time.

The project therefore investigates whether there is value in a **persistent, shared work layer** that different coding clients can participate in without becoming the user's primary interaction surface.

The central question is:

> How can different coding agents work against persistent, verifiable and governed work structure without forcing developers to leave the coding client they already use?

An initial formulation of the vision is:

> Developers should continue using their preferred coding agent while a local, agent-agnostic control plane transparently provides persistent work structure, governance, adaptive orchestration and verifiable completion.

This is a hypothesis, not a closed specification.

## Desired experience

Ideally, the developer continues to interact with the coding client in the normal way:

```text
developer talks normally to coding agent
        ↓
agent can understand relevant project/work state
        ↓
control-plane mechanisms determine relevant structure, capabilities and gates
        ↓
agent executes using the coding client's native abilities
        ↓
evidence updates persistent work state
        ↓
human intervenes when judgment, approval or ambiguity actually requires it
```

The developer should be able to inspect what the system believes is happening: current intent, work, dependencies, constraints, decisions, requested capabilities, evidence, verification status and unresolved human decisions where those concepts prove necessary.

**Transparent does not mean invisible.** Automation should reduce interaction overhead without making important state transitions or decisions impossible to inspect.

## Why investigate this layer?

The hypothesis is not that coding clients are missing an agent loop. They already have one.

The hypothesis is that useful project-level concerns may exist **outside any single client session**:

- continuity of work across sessions and clients;
- explicit work dependencies and readiness;
- durable decisions and constraints;
- deterministic enforcement where a client exposes suitable mechanisms;
- evidence attached to completion claims;
- verification and repair expectations;
- selection of execution capabilities according to the type and risk of work;
- a shared state that humans and agents can both inspect.

Whether the control plane should own each of these concerns remains an open research question.

## Initial principles

### Existing coding clients remain primary

Claude Code, Codex, OpenCode, Gemini CLI and future coding clients remain the normal user interaction surface. The project should integrate with them rather than recreate them.

### Local-first

Core project/work control should be able to function locally by default. A hosted service must not be a prerequisite for the basic model.

### Agent/client-agnostic core

Concepts that are genuinely shared across clients should not be polluted by one client's internal terminology or lifecycle. Client-specific behavior belongs at an integration boundary.

### Machine-native and human-readable

State should be structured enough for deterministic tools and agents to query and update, while remaining inspectable and, where safe, correctable by a human.

### Verifiable completion

"Done" should not mean only that an agent says it is done. Where practical, completion should be backed by explicit outcomes and evidence appropriate to the work.

### Transparency over hidden automation

The system may automate heavily, but significant work state, gates, decisions and failures should remain observable.

### Native capabilities before custom machinery

If a coding client or upstream project already provides a reliable permission, hook, verification, state or integration primitive, the control plane should prefer composing it over reimplementing it.

### Deterministic enforcement where possible

Critical governance should not rely exclusively on natural-language instructions when the host client exposes enforceable permissions, hooks, policy engines, sandboxes or equivalent mechanisms.

### Guidance and enforcement are different

A prompt or instruction can guide behavior. A permission rule, blocking hook or sandbox boundary can enforce behavior. The system must not claim enforcement when it only provides guidance.

### Agent responsibility is not model policy

A responsibility such as review, research or verification is a semantic requirement of the work. It should not automatically imply a particular model, persona, prompt or dedicated agent.

### Capability is not agent is not model

A work item may require a capability such as exploration, implementation, debugging, review or verification. How that capability is fulfilled may depend on the coding client and its available mechanisms.

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

### Adaptive structure, not mandatory agent pipelines

The amount of structure and the capabilities required should be allowed to vary with the type, risk, uncertainty and needs of the work. Agents are available execution capabilities, not a mandatory sequence of personas through which every task must pass.

### Minimal abstractions

New abstractions must earn their existence by solving an observed problem that is not already sufficiently solved upstream.

## Anti-vision

The project is **not** trying to create:

- another Claude Code, Codex, OpenCode, Gemini CLI or Cursor;
- an IDE or chat interface;
- a replacement agent runtime or its own primary agent loop;
- a Jira or Kanban product for agents;
- a generic workflow engine;
- a generic multi-agent framework;
- an "AI company simulation" or fixed collection of role-playing agents;
- a swarm by default;
- a distributed fleet manager;
- a long-running scheduler as a product goal;
- a prompt framework whose critical controls exist only as text;
- an enterprise platform before concrete local problems justify one;
- a mandatory TUI.

The project should also avoid reproducing internal functions already owned by the coding client, such as model execution, conversational agent loops, tool calling or client UI.

## The TUI, if it exists

A TUI is a secondary hypothesis: an optional local **observer into the control plane**.

It may eventually project state such as current intent, work dependencies, ready/blocked/running work, active execution capabilities, pending decisions, gates, evidence, failures, progress and available cost/telemetry data.

It must not become the source of truth, a required runtime dependency, the primary user interface or a second project-management state model.

## Boundary with `portable-opencode`

`portable-opencode` and `agentic-control-plane` solve different problems.

`portable-opencode` is an OpenCode-specific environment concerned with installing, configuring, reproducing and maintaining an opinionated OpenCode + OpenRouter setup.

`agentic-control-plane` investigates a client-independent work and governance layer that should make conceptual sense even if `portable-opencode` did not exist.

The new project may reuse lessons, patterns or eventually an integration produced by `portable-opencode`, but it does not inherit its configuration contracts, model presets, observability stack, Graphify policies, agent definitions, CLI lifecycle, platform setup or implementation choices by default.

## Success criterion for the research phase

The research phase succeeds even if it proves that a new control plane is unnecessary.

A valid outcome would be evidence that existing tools can already be composed into the desired experience with sufficiently little glue. The purpose of this phase is to reduce uncertainty, not to justify building a predetermined product.
