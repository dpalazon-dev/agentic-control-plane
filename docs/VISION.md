# Vision

## Status

This document describes the **problem, governed object and desired experience** of Agentic Work Control Plane. It does not define an implementation architecture.

The project is currently in **research and architecture validation**. Mechanisms described here are hypotheses unless they are explicitly recorded as accepted decisions in [`DECISIONS.md`](DECISIONS.md).

---

## Problem

Coding agents are becoming capable of carrying out increasingly substantial software work, but the **work surrounding execution** is still fragmented across:

- conversations and individual sessions;
- client-specific plans, todos and instructions;
- specification documents disconnected from execution state;
- issue trackers designed primarily around human coordination;
- reasoning and decisions that are difficult to reconstruct later;
- acceptance criteria that are inconsistently connected to implementation;
- validation evidence that is often ephemeral;
- project knowledge that must repeatedly be reintroduced to a new session or coding client.

The result is an asymmetry:

```text
execution capability ↑

while

work continuity / traceability / governance ≠ necessarily ↑
```

A coding agent can often produce code quickly, yet a developer may still struggle to answer basic project-level questions:

- What are we actually trying to achieve?
- What work currently exists and why?
- What depends on what?
- What is ready, blocked, active or complete?
- Which constraints apply to this work?
- Which decisions produced the current direction?
- What capabilities does this work require?
- What evidence supports a completion claim?
- What does the next coding session need to know?

The project investigates whether these concerns justify a **shared control layer for software work performed with coding agents**.

The central question is:

> How can different coding agents work against the same persistent, governed and verifiable model of software work without forcing developers to leave the coding client they already use?

---

## The governed object is work, not agents

This distinction is fundamental.

The emerging industry use of **Agent Control Plane** refers primarily to operating and governing agents themselves: inventory, deployment, identity, permissions, lifecycle, fleet observability, model/tool access, cost and operational health.

Agentic Work Control Plane investigates a different object:

```text
Agent Control Plane
    governs → agents

Agentic Work Control Plane
    governs → software work performed with agents
```

The project therefore does not begin from questions such as:

- Which agents are deployed?
- How healthy is the agent fleet?
- Which model version does each agent use?
- Where should an agent run?
- How should agents be scheduled across infrastructure?

It begins from questions such as:

- What outcome is intended?
- What work is necessary?
- What is the state of that work?
- What rules and decisions constrain it?
- What capabilities are required to perform it?
- What must be verified?
- What evidence demonstrates completion?

Agents, humans, deterministic tools and CI may all become **executors or contributors** to work. They are not necessarily the primary semantic object of the system.

---

## Desired experience

The developer should continue using Claude Code, Codex, OpenCode, Gemini CLI or another coding client normally.

Conceptually:

```text
                    Human
                      │
                      ▼
              Existing coding client
                      │
                      │ executes / contributes
                      ▼
                 Software work
                      ▲
                      │ structured / governed by
                      │
          Agentic Work Control Plane

       intent · dependencies · constraints
       decisions · capabilities · evidence
       verification · completion · continuity
```

The Work Control Plane is therefore **adjacent to execution**, not a replacement execution runtime.

A typical desired interaction could look like:

```text
human expresses intent through normal coding client
        ↓
relevant persistent work context is resolved
        ↓
work requirements / constraints / gates are made available
        ↓
coding client executes using its native agent loop and tools
        ↓
verification produces evidence
        ↓
work state is updated
        ↓
next session or client can continue from explicit state
```

The human should be able to inspect this state without needing to operate a second primary interface.

**Transparent does not mean invisible.** The goal is low interaction overhead with high inspectability.

---

## The core product hypothesis

The project is testing whether useful value exists in a small, client-independent semantic layer around software work.

A working formulation is:

> **A local, agent-agnostic control plane for persistent, governed and verifiable software work across coding agents.**

This formulation implies three important separations.

### 1. Work ≠ conversation

A conversation may create, update or discuss work, but the lifetime of meaningful project work should not necessarily equal the lifetime of a chat session.

### 2. Work ≠ executor

A work requirement should not be permanently coupled to one coding client, named agent, model or persona.

For example, `verification required` is a property of the work. It might later be satisfied by tests, a coding-agent review pass, a dedicated reviewer, CI or a human.

### 3. Work control ≠ agent runtime

The Work Control Plane may determine that a constraint applies, that evidence is missing or that a capability is required. It should not therefore assume ownership of the model loop that performs the work.

---

## Candidate work concerns

The following are research candidates, not a committed domain model.

### Intent

Why does this work exist and what outcome is expected?

### Specification / contract

What must be true of the result?

### Work structure

What units of work exist, how are they related and what is currently actionable?

### Decisions

Which decisions changed the interpretation, scope or execution of the work, and why?

### Constraints and policy

Which rules apply to this work, and which of them are guidance versus technically enforceable?

### Capabilities

What kind of ability is required to progress the work?

### Evidence

What observable result supports a claim about implementation, validation or completion?

### Completion

Under which conditions can the work legitimately transition to done?

### Continuity

What state must survive so another session, client or executor can continue without reconstructing the project from chat history?

The project must still prove which of these concepts deserve first-class representation.

---

## Initial principles

### Existing coding clients remain primary

Claude Code, Codex, OpenCode, Gemini CLI and similar tools remain the developer's normal interaction surface.

### Govern work, do not manage an agent fleet

The project should not drift into agent deployment, registry, fleet health, remote runtime operations or enterprise agent lifecycle management.

### Local-first

Core work state and control should function locally by default. A hosted service must not be required for the fundamental experience.

### Agent/client-agnostic work semantics

The semantic meaning of work should not depend on Claude Code, Codex, OpenCode or another client. Client-specific mechanisms belong behind integration boundaries.

### Machine-native and human-readable

Important work state should be structured enough for tools and agents to query reliably while remaining inspectable and understandable by a developer.

### Persistent where persistence solves a real problem

Cross-session continuity is important, but this does not imply that every event, prompt or intermediate thought should become durable state.

### Verifiable completion

`Done` should not mean only that an executor claims success. Where practical, completion should be tied to explicit expected outcomes and evidence.

### Evidence over hidden reasoning

The system should not attempt to persist or reproduce private chain-of-thought. It should retain useful externally inspectable artifacts: decisions, actions, tests, outputs, failures, approvals and evidence.

### Guidance and enforcement are different

Natural-language instructions can guide. Permissions, hooks, policy engines, sandboxes, CI gates or equivalent supported mechanisms may enforce. The system must represent that difference honestly.

### Native capabilities before custom machinery

If a coding client or existing project already solves a concern adequately, reuse or compose it before creating another subsystem.

### Capability ≠ Agent Role ≠ Model

A semantic requirement of the work must not automatically become a permanent named agent or fixed model assignment.

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

### Adaptive structure, not mandatory pipelines

The amount of process required should derive from work type, risk, uncertainty and verification needs rather than forcing every request through the same agent sequence.

### Minimal ownership

The Work Control Plane should own only state whose ownership is necessary to provide its guarantees. It may query, reference or project state owned by Git, CI, a work substrate or another system.

---

## Anti-vision

The project is **not** trying to create:

- another Claude Code, Codex, OpenCode, Gemini CLI or Cursor;
- an agent runtime or primary model loop;
- an Agent Control Plane for enterprise fleets;
- an agent registry or deployment platform;
- an IDE or chat interface;
- a Jira or Kanban clone;
- a generic project-management platform;
- a generic workflow engine;
- a generic multi-agent framework;
- a fixed collection of persona agents;
- a swarm by default;
- a distributed scheduler;
- a mandatory worktree strategy;
- a prompt framework whose critical rules exist only as prose;
- a mandatory TUI;
- a second source of truth merely because one is convenient to implement.

---

## Observation and the optional TUI

If meaningful work state exists outside conversations, humans need a way to inspect it.

A TUI remains only one possible projection of the Work Control Plane. It may eventually show:

- current intent;
- work and dependencies;
- ready / blocked / active / completed work;
- applicable constraints and gates;
- requested capabilities and resolved executors;
- pending human decisions;
- evidence and verification results;
- failures and repair state;
- derived progress or telemetry where useful.

It must not become the primary product surface or own a second state model.

---

## Boundary with `portable-opencode`

`portable-opencode` and Agentic Work Control Plane remain separate projects.

`portable-opencode` is an OpenCode-specific environment concerned with installing, configuring, reproducing and maintaining an opinionated OpenCode + OpenRouter setup.

Agentic Work Control Plane investigates a client-independent model for structuring and governing software work across coding clients.

`portable-opencode` could eventually consume, expose or implement an integration for the Work Control Plane, but no architecture, configuration, model presets, Graphify policy, agent definitions, observability stack or CLI design is inherited automatically.

---

## Success criterion for the research phase

The project succeeds if it determines the smallest truthful answer to the problem.

That answer might be:

1. a distinct Work Control Plane is justified;
2. only a very thin semantic/integration layer is necessary;
3. an existing work substrate plus coding-client integrations is sufficient;
4. a project such as Spec Kit, Pulse or another system already solves the problem adequately;
5. the category itself is not useful enough to justify implementation.

The purpose of this phase is not to defend the product idea. It is to discover what, if anything, must exist between **human intent**, **software work** and **coding-agent execution**.
