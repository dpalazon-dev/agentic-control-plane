# Vision

## Status

This document describes the **problem, governed object and desired operating model** of Agentic Work Control Plane. It does not define an implementation architecture.

The project is currently in **research and architecture validation**. Mechanisms described here are hypotheses unless explicitly recorded as accepted decisions in [`DECISIONS.md`](DECISIONS.md).

---

## Problem

Coding agents are increasingly capable of carrying out substantial software work, but the **organization surrounding that execution** is still fragmented across:

- conversations and individual sessions;
- client-specific plans, todos and instructions;
- specifications disconnected from execution state;
- reasoning and decisions that are difficult to reconstruct later;
- acceptance criteria that are inconsistently connected to implementation;
- validation evidence that is often ephemeral;
- project knowledge that must repeatedly be reintroduced;
- agent responsibilities that are improvised inside a prompt or session rather than represented as part of the work itself.

The result is an asymmetry:

```text
execution capability ↑

while

work structure / continuity / governance / accountability ≠ necessarily ↑
```

A capable coding agent can produce code quickly, yet the developer may still struggle to answer:

- What are we trying to achieve?
- What work exists and why?
- How has it been decomposed into work packages and tasks?
- What depends on what?
- What is ready, blocked, active or complete?
- Which constraints apply?
- Which agent responsibilities are required for this work?
- Has implementation been independently tested and reviewed where required?
- What context should each participant receive?
- What permissions should apply to each participant?
- What evidence supports completion?
- What does the next session or agent need to know?

The project investigates whether these concerns justify a **shared control layer for software work performed with existing coding agents**.

The central question is:

> How can software work be persistently structured, assigned the right agent responsibilities, governed and verified while developers continue using their preferred coding agents normally?

---

## The governed object is work, not the agent fleet

This distinction remains fundamental.

```text
Agent Control Plane
    governs → agents / agent infrastructure

Agentic Work Control Plane
    governs → software work performed with agents
```

AWCP does not primarily manage agent deployment, inventory, lifecycle, fleet health, hosting or distributed scheduling.

It starts instead from the work:

```text
Intent
  ↓
Work Package
  ↓
Task
  ↓
required responsibilities
  ↓
execution
  ↓
evidence
  ↓
completion
```

Agents are important because the work may require **different agent roles** to participate. They are not, however, managed as an infrastructure fleet by AWCP.

---

## The missing organizational layer

A key part of the project is not merely persistent task storage. The work itself may require a particular **agentic organizational structure**.

For example:

```text
Implementation Task
├── Developer
├── Tester
└── Code Reviewer
```

```text
Architecture / Organization Task
├── Architect
└── Senior Engineer
```

A higher-risk implementation might require additional responsibilities such as security review, while a trivial change may require only a developer.

Therefore the intended model is not:

```text
Task → one generic coding agent
```

It is closer to:

```text
work type / risk / complexity
          ↓
derive required agent roles
          ↓
define responsibilities and required capabilities
          ↓
resolve those roles through the active coding environment
          ↓
collect evidence per responsibility
          ↓
evaluate completion
```

The goal is to make the **methodology executable**: the system should derive the organizational requirements of the work instead of relying on the human to remember a process checklist or manually summon every reviewer.

---

## Role ≠ capability ≠ executor ≠ model

The previous principle `Capability ≠ Agent Role ≠ Model` remains useful, but roles must not be reduced to capabilities.

The more complete distinction is:

```text
Work Type
≠ Agent Role
≠ Capability
≠ Executor Instance
≠ Model
```

### Agent Role

A semantic responsibility that must participate in a unit of work, for example:

```text
Developer
Tester
Code Reviewer
Architect
Senior Engineer
Researcher
Security Reviewer
```

This vocabulary is illustrative rather than a finalized catalog.

### Capability

What a role needs to be able to do, for example:

```text
implement
debug
test
review
research
reason
verify
document
```

### Executor

How the role is materialized in the current environment, potentially through:

- a native Claude Code subagent;
- an OpenCode agent;
- a Codex-supported mechanism;
- a Gemini CLI mechanism;
- a separate coding-agent session;
- an external deterministic tool where appropriate;
- a human when judgment or fallback is required.

### Model / tools / context / permissions

These are implementation policies of the resolved executor. A `Code Reviewer` role must not imply a permanent model choice or a globally fixed prompt.

This preserves portability while keeping **responsibility assignment first-class**.

---

## Role composition may be mandatory

Not every work item should pass through the same pipeline.

However, once the system classifies a unit of work, some roles may become **required before completion**.

Examples:

```text
Trivial edit
→ Developer

Small bug
→ Developer
→ Tester

Core implementation
→ Developer
→ Tester
→ Code Reviewer

Security-sensitive implementation
→ Developer
→ Tester
→ Security Reviewer
→ Code Reviewer

Architecture change
→ Architect
→ Senior Engineer
→ Developer / downstream implementation roles as needed
```

These are examples, not accepted policies.

The important principle is:

> **No mandatory global agent pipeline, but potentially mandatory role composition per class of work.**

Some roles may also require **separation of responsibility**. For example, the executor that implemented a change may not be allowed to satisfy an independent review requirement merely by reviewing its own output.

---

## Desired experience

The developer continues using Claude Code, Codex, OpenCode, Gemini CLI or another coding client normally.

Alongside that client, AWCP provides a local companion experience. Persistent local systems hold authoritative task, role, execution, decision, evidence and completion records under explicit source-of-truth rules. A secondary local UI or TUI makes the composed state quickly inspectable and lightly editable without becoming a replacement chat or coding interface. AWCP may implement this experience only where existing products cannot satisfy the required invariants.

Conceptually:

```text
                         Human
                           │
                           ▼
                  Existing Coding Client
                           │
                    participates in
                           ▼
              ┌─────────────────────────┐
              │     SOFTWARE WORK       │
              │                         │
              │ intent                  │
              │ work packages / tasks   │
              │ required roles          │
              │ constraints             │
              │ decisions               │
              │ evidence / completion   │
              └───────────┬─────────────┘
                          ▲
                          │ governed by
                          │
              Agentic Work Control Plane
```

The coding client owns its normal interaction and agent loop. AWCP owns the role/completion semantics and requires durable local authorities for the records the coding environment works against. Client integrations let agents read assigned work and write execution status, decisions and evidence back to those composed authorities.

A typical desired interaction could look like:

```text
human expresses intent normally
        ↓
intent is resolved into persistent work
        ↓
work is classified by type / risk / complexity
        ↓
required roles and gates are derived
        ↓
relevant context, policies and permissions are resolved
        ↓
roles are materialized using the current coding agent's native mechanisms
        ↓
execution / review / verification occurs
        ↓
evidence updates persistent work state
        ↓
completion is accepted, repaired or escalated
```

The human should be able to inspect this process without operating a second primary interface.

**Transparent does not mean invisible.**

---

## Compose agent infrastructure; do not rebuild it by default

AWCP necessarily depends on concerns such as:

- context selection and delivery;
- project memory;
- permissions;
- policy enforcement;
- sandboxing;
- tool access;
- observability;
- telemetry;
- verification tooling;
- possibly agent identity or session information.

That does **not** mean AWCP should implement these subsystems.

The preferred direction is:

```text
AWCP semantic requirement
        ↓
resolve against available infrastructure
        ↓
client-native capability / local external system / existing tool
```

For example, AWCP may determine that a `Code Reviewer` needs read-only repository access and a bounded context package. The permission mechanism and context engine should be supplied by the coding client or an existing local system when possible.

Likewise, persistent memory may be provided by an existing context/memory system; observability may come from an existing local stack; permissions may be enforced by native client policies or a reusable control-plane component.

**Integrate, do not reimplement** is therefore a core design discipline.

---

## The specific integration gap being investigated

A large part of modern agent infrastructure is designed for developers who are **building custom agents** on top of an SDK, orchestration framework or hosted control plane.

That is not the primary target here.

AWCP is specifically concerned with the daily development experience of users who already work through:

```text
Claude Code
Codex
OpenCode
Gemini CLI
future equivalent coding agents
```

The question is whether existing context, memory, permission, governance and observability systems can be composed around these **already-built coding agents** without requiring the user to replace them with a custom agent runtime.

That integration boundary may be one of the most important genuine gaps to validate.

---

## Candidate work concerns

These remain research candidates rather than a final domain model:

- `Intent` — why the work exists and the intended outcome;
- `WorkPackage / Work / Task` — units and decomposition of work;
- `Dependency` — readiness/blocking relationships;
- `RoleRequirement` — which agent responsibilities must participate;
- `CapabilityRequirement` — what each role needs to do;
- `ExecutorBinding` — which client, agent or human is assigned to satisfy a role;
- `ExecutionRecord` — an attempt by an executor, including observable client/session identity and timestamps;
- `StateTransition` — an auditable change in work or role state and its grounds;
- `Constraint / Policy` — rules affecting the work;
- `ContextRequirement` — what information a role needs;
- `PermissionRequirement` — what operations a role may perform;
- `Decision` — durable changes in direction or interpretation;
- `Evidence` — observable support for a claim;
- `Outcome / Completion` — conditions under which work can transition to done.

The project must still prove which concepts deserve first-class representation.

---

## Initial principles

### Existing coding clients remain primary

Users continue working through their normal coding agents.

### Govern work, not an agent fleet

Agent fleet operations remain outside the primary scope.

### Roles are first-class work requirements

Work type, risk and complexity may derive mandatory agent roles and responsibility separation.

### Roles are portable semantics, not fixed implementations

`Developer`, `Tester` or `Reviewer` describe responsibility. They do not imply a particular client, model, prompt or runtime mechanism.

### Adaptive structure, not one global pipeline

Different work requires different role compositions and gates.

### Context and permissions are requirements, not necessarily owned subsystems

AWCP may express what context or permission profile a role needs while delegating delivery/enforcement to existing infrastructure.

### Native and upstream capabilities before custom machinery

Reuse coding-client and local-system capabilities wherever they sufficiently meet the requirement.

### Machine-native and human-readable

Important work state should remain both reliably queryable and inspectable by humans.

### Verifiable completion

`Done` should depend on required responsibilities and evidence, not merely an executor's claim.

### Separation of responsibility where needed

Independent testing/review should remain meaningfully independent when the work policy requires it.

### Guidance, verification and enforcement are different

The system must represent the guarantee actually available from the host environment.

### Deliberate ownership

AWCP owns the durable work-control semantics necessary to organize and audit work across agents and sessions. Existing local systems may physically own tasks, specifications, worker sessions, events or evidence when they expose sufficient guarantees. AWCP must reference or compose those authorities and must not create a duplicate editable truth.

---

## Anti-vision

The project is **not** trying to create:

- another Claude Code, Codex, OpenCode, Gemini CLI or Cursor;
- a custom agent runtime or primary model loop;
- an enterprise Agent Control Plane or fleet manager;
- a generic multi-agent framework;
- a fixed global agent pipeline;
- a prompt-only persona framework;
- its own context engine merely because context is required;
- its own memory system merely because continuity is required;
- its own permission/sandbox system merely because governance is required;
- its own observability platform merely because execution should be visible;
- a Jira/Kanban clone;
- a generic workflow engine;
- an IDE or chat interface;
- a replacement TUI through which coding-agent conversations must occur;
- a second source of truth without demonstrated need.

---

## Local TUI and work inspection

If meaningful work structure exists outside conversations, humans need direct visibility into it.

The local TUI should provide a fast view of:

- current intent;
- work packages and tasks;
- dependencies and readiness;
- required roles and their status;
- resolved executors;
- coding client, agent and session attribution where observable;
- execution attempts and timestamps;
- relevant context sources;
- permission/enforcement guarantees;
- pending human decisions;
- quality gates;
- evidence;
- failures and repair state;
- progress and available telemetry.

The inspection surface is part of the required AWCP experience, but remains secondary to the coding client. It may be an AWCP TUI or a proven composed provider UI/TUI. In either case it reads and lightly edits the same authoritative state used by agent integrations and owns no independent state.

---

## Boundary with `portable-opencode`

`portable-opencode` and Agentic Work Control Plane remain separate projects.

`portable-opencode` configures and maintains an opinionated OpenCode + OpenRouter environment. AWCP investigates a portable work-control model across coding agents.

`portable-opencode` could later become an especially capable AWCP adapter or distribution because it controls more of its OpenCode environment, but AWCP does not inherit its implementation decisions by default.

---

## Success criterion for the research phase

The project succeeds if it discovers the smallest truthful local product architecture that provides this experience.

Possible outcomes include:

1. Pulse, Nexus or another composition already supplies the complete local experience and AWCP reduces to methodology/configuration or is unnecessary as a separate product;
2. a thin AWCP semantic overlay supplies only role aggregation, native-client lineage and completion evaluation over existing providers;
3. a minimal AWCP service, persistent store, TUI and client adapter are justified by demonstrated missing invariants;
4. some desired role/governance guarantees must be weakened because coding clients cannot expose or enforce them;
5. part of the vision is invalidated if essential guarantees require replacing the coding-client runtime.

The purpose is to discover the irreducible layer between **human intent**, **organized agentic software work** and **existing coding-agent execution**.
