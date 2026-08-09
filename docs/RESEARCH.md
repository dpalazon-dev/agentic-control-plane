# Research

## Status and scope

This document asks:

> **What parts of agentic software work are already solved, what can be composed, and what remains unsolved enough to justify an Agentic Work Control Plane?**

It is not a catalog of AI-development tools and it does not assume that a new product needs to exist.

Research snapshot refreshed on **2026-08-09** using official documentation, official repositories and recent papers where possible. External systems are moving quickly; claims about current products must be revalidated during the relevant spike before becoming architecture.

### Evidence labels

- **FACT** — directly supported by a cited source.
- **INFERENCE** — interpretation of one or more facts.
- **HYPOTHESIS** — proposition this project still needs to test.
- **DECISION** — accepted project boundary; authoritative decisions live in [`DECISIONS.md`](DECISIONS.md).

---

# 1. Naming correction: Agent Control Plane is a different category

The initial project name, `agentic-control-plane`, was too broad and increasingly conflicts with an emerging industry meaning.

## 1.1 What current Agent Control Planes control

**FACT:** IBM defines an agent control plane as the system that deploys, operates, monitors and governs AI agents across an organization. Individual agents operate in a data plane where they execute tasks and interact with tools, while the control plane handles system-level governance and coordination.

Sources:

- [IBM — What is an Agent Control Plane?](https://www.ibm.com/think/topics/agent-control-plane)
- [IBM watsonx Orchestrate — Agent Control Plane](https://www.ibm.com/products/watsonx-orchestrate/agent-control-plane)

**FACT:** Microsoft Foundry Control Plane similarly centralizes management of AI agents, models and tools across an enterprise. Its documented concerns include agent inventory, fleet management, observability, compliance, security and lifecycle operations.

Sources:

- [Microsoft Foundry Control Plane overview](https://learn.microsoft.com/en-us/azure/foundry/control-plane/overview)
- [Manage agents at scale in Microsoft Foundry Control Plane](https://learn.microsoft.com/en-us/azure/foundry/control-plane/how-to-manage-agents)

**INFERENCE:** `Agent Control Plane` is converging on a category whose primary managed object is the **agent estate**:

```text
agents
models
tools
identity
permissions
deployment
runtime health
cost
fleet operations
policy
```

That is not the primary object investigated by this project.

## 1.2 The object here is software work

The project instead asks whether software work performed through heterogeneous coding agents needs durable structure and governance independent of any single coding client.

A useful category distinction is:

```text
Agent Control Plane
    governs → agents / agent infrastructure

Agentic Work Control Plane
    governs → software work performed with agents
```

Candidate work concerns are:

```text
intent
specification / work contract
work units
dependencies
constraints
decisions
capability requirements
evidence
verification
completion
continuity
```

**DECISION:** The project is therefore reframed as **Agentic Work Control Plane (AWCP)**.

This naming distinction does not prove that the category is novel. It only identifies the object of control more accurately.

---

# 2. Research baseline: software development is converging around explicit work artifacts

## 2.1 No single "AI Scrum" is emerging

**FACT:** A June 2026 comparative study of GitHub Spec Kit, OpenSpec, BMAD, GSD, Spec Kitty and Reversa found convergence away from isolated prompting and toward persistent artifacts, work contracts, traceability and human review. Its taxonomy compares specification, context, roles, execution, validation and portability, and reports that no evaluated framework strongly covers every dimension.

Source: [From Prompt to Process: a Process Taxonomy and Comparative Assessment of Frameworks Supporting AI Software Development Agents](https://arxiv.org/abs/2606.04967).

**INFERENCE:** The useful emerging pattern is not a new ceremony framework but an increasingly explicit delivery chain:

```text
Intent
  ↓
Specification / work contract
  ↓
Persistent work structure
  ↓
Execution
  ↓
Verification
  ↓
Evidence
  ↓
Outcome / merge
  ↓
Persistent project knowledge
```

This is evidence of convergence, not an AWCP workflow design.

## 2.2 Harness engineering moves reliability outside the model

**FACT:** OpenAI's harness-engineering account describes an agent-first engineering environment in which human effort shifts toward specifying intent, structuring the environment and building feedback loops. Early failures were often caused not simply by model capability but by insufficient tools, abstractions and repository structure.

Source: [OpenAI — Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/).

**FACT:** Recent research on agentic harness engineering treats tools, middleware, memory, task state, observability, verification and intervention handling as important parts of a reliable coding-agent system.

Sources:

- [Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses](https://arxiv.org/abs/2604.25850)
- [AI Harness Engineering: A Runtime Substrate for Foundation-Model Software Agents](https://arxiv.org/abs/2605.13357)

**INFERENCE:** Reliability increasingly belongs to the system formed by **model + harness + development environment**, not to the prompt alone.

However, these harnesses often assume ownership of or proximity to the agent runtime. AWCP asks a narrower question:

> Can project-level work structure and governance be made persistent and portable **without owning the coding agent's loop?**

## 2.3 Spec-driven development is becoming infrastructure rather than documentation

**FACT:** Recent work on Spec-Driven Development distinguishes increasingly authoritative uses of specifications and studies linked artifacts across specification, planning, tasks, implementation and verification.

Sources:

- [Spec-Driven Development: From Code to Contract in the Age of AI Coding Assistants](https://arxiv.org/abs/2602.00180)
- [Spec Kit Agents: Context-Grounded Agentic Workflows](https://arxiv.org/abs/2604.05278)

**INFERENCE:** AWCP should not equate persistent work with "a better PRD". The important pattern is the relationship between intent, executable work, constraints, outcomes and evidence.

---

# 3. The closest direct comparable: Okto Pulse

The reframing around **work rather than workers** makes OktoLabs especially important.

## 3.1 Pulse organizes work; Nexus organizes workers

**FACT:** OktoLabs explicitly separates two layers:

- **Pulse** organizes the work through specifications, tasks, acceptance criteria, validation and project knowledge.
- **Nexus** organizes the workers through ownership, handoffs, approvals, shared context and durable coordination history.

Source: [Okto Pulse](https://pulse.oktolabs.ai/).

Their published formulation is effectively:

```text
Pulse → work
Nexus → workers
```

This independently mirrors the distinction AWCP is now making between a **Work Control Plane** and an **Agent Control Plane / agent coordination layer**.

## 3.2 Pulse capabilities

**FACT:** OktoLabs describes Pulse as a local-first, spec-driven project board/workbench for AI-assisted software work with native MCP support.

Sources:

- [OktoLabs — About](https://oktolabs.ai/about/)
- [Okto Pulse](https://pulse.oktolabs.ai/)
- [okto-pulse on PyPI](https://pypi.org/project/okto-pulse/)

Documented characteristics include:

- local-first state;
- structured ideation, refinement, specifications, tasks, tests and bugs;
- acceptance criteria and validation gates;
- traceability between artifacts;
- persistent project knowledge;
- MCP-native agent access;
- a human-visible board;
- explicit evidence/validation concepts.

**INFERENCE:** Pulse is currently one of the closest implementations to the *experience* AWCP is investigating.

This changes the burden of proof. AWCP cannot justify itself merely by saying:

> "Agents need persistent tasks, specifications, governance, evidence and a local UI."

Pulse already demonstrates a coherent implementation of much of that proposition.

## 3.3 What still needs comparison

Pulse is intentionally opinionated and spec-driven. Its published workflow includes explicit stages such as ideation, refinement, specification, sprint, tasks and validation.

AWCP currently hypothesizes a potentially thinner layer in which:

- the work substrate may be external;
- no single methodology is mandatory;
- capabilities may be derived from work rather than fixed workflow stages;
- the existing coding client remains the primary interaction surface;
- critical integration may need stronger lifecycle participation than voluntary MCP tool usage;
- work semantics should remain portable even if different clients provide different guarantees.

**HYPOTHESIS:** A meaningful AWCP gap exists only if experiments show that these differences matter enough to justify a distinct layer rather than configuring or extending Pulse.

SPIKE-002 must therefore treat Pulse as a **falsification candidate**, not merely inspiration.

---

# 4. Work substrates

These systems matter because AWCP may need durable work, dependency, readiness and history semantics. The first question is not which substrate to adopt; it is whether AWCP should own one at all.

## 4.1 Beads / `bd`

Primary source: [gastownhall/beads](https://github.com/gastownhall/beads).

**FACT:** Beads provides structured persistent work/issue state for coding agents, including dependency relationships and ready-work queries.

Relevant reusable patterns include:

- dependency-aware work graphs;
- ready/blocked calculation;
- durable machine-queryable work state;
- concurrency and claiming patterns;
- coding-agent bootstrap/integration patterns.

**INFERENCE:** Beads may already solve a substantial portion of AWCP's candidate `Work` responsibility.

What it does not automatically answer is whether AWCP needs:

- work governance beyond issue state;
- evidence semantics;
- client-neutral enforcement guarantees;
- a capability requirement layer;
- explicit cross-client continuation semantics.

**Research consequence:** test Beads directly before inventing a work graph.

## 4.2 Backlog.md

Primary source: [MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md).

**FACT:** Backlog.md stores human-readable project-local work in Markdown and supports tasks, acceptance criteria, Definition of Done, milestones, dependencies, plans, comments and decisions, with CLI/MCP access for coding agents.

Relevant reusable patterns:

- machine-readable state that remains directly human-readable;
- acceptance criteria as explicit work contract;
- local-first persistence;
- stable CLI/JSON interaction;
- multi-client agent discovery/integration.

**INFERENCE:** Backlog.md is a strong falsification test for the claim that AWCP needs a custom work schema or database.

## 4.3 Task Master AI

Primary source: [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master).

Task Master combines task/dependency management with AI-assisted decomposition, research and execution-oriented features.

Useful lessons:

- work decomposition patterns;
- dependencies and ready work;
- integration between task state and coding agents.

Boundary mismatch:

- model-provider configuration and model invocation are more central than AWCP currently intends;
- execution loops move toward owning the runtime/orchestration boundary.

**INFERENCE:** useful comparative evidence, but not the target abstraction.

---

# 5. Spec and development-process systems

These projects increasingly provide structured work and governance around existing coding agents.

## 5.1 GitHub Spec Kit

Primary sources:

- [Spec Kit documentation](https://github.github.io/spec-kit/)
- [github/spec-kit](https://github.com/github/spec-kit)

**FACT:** Current Spec Kit documentation describes the project as an **extensible, intent-driven harness** that can guide coding agents across an SDLC or other process.

Its default flow is:

```text
Spec → Plan → Tasks → Implement
```

Current documentation also advertises broad coding-agent portability and extension mechanisms.

**INFERENCE:** Treating Spec Kit merely as a spec generator is obsolete. It is a serious composition candidate for AWCP.

Potentially reusable:

- intent-centered artifact flow;
- templates/checklists and cross-artifact analysis;
- coding-client integration patterns;
- extensions/presets/workflows;
- portable process installation.

Remaining AWCP questions:

- persistent ready/blocked work independent of a spec phase model;
- cross-client guarantee semantics for enforcement;
- evidence as a general work primitive;
- capability requirements independent of named process stages;
- minimal control state across arbitrary client/session switching.

**HYPOTHESIS:** `Spec Kit + existing work substrate + native client enforcement` may be enough. AWCP must try to prove itself unnecessary before implementing equivalents.

## 5.2 Spec Kitty

Primary source: [Priivacy-ai/spec-kitty](https://github.com/Priivacy-ai/spec-kitty).

Spec Kitty demonstrates a repo-native governed delivery flow with specifications, work packages, review, acceptance and merge state across multiple coding agents.

Useful patterns:

- auditable repo-native work records;
- explicit work progression;
- visible review/acceptance gates;
- multi-client integration.

Boundary mismatch:

- stronger methodology ownership;
- worktree-centric execution;
- more opinionated work-package lifecycle than AWCP has justified.

**INFERENCE:** It demonstrates that persistent governed work around existing agents is feasible, but does not establish that AWCP's thinner compositional approach is necessary.

## 5.3 GSD / Get Shit Done

Primary sources:

- [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)
- [GSD architecture](https://github.com/gsd-build/get-shit-done/blob/main/docs/ARCHITECTURE.md)

GSD provides structured project state, research/planning/execution/verification phases and support for multiple coding runtimes.

Useful patterns:

- file-based continuity across context resets;
- phase-specific context selection;
- verification as first-class work;
- multi-runtime translation/integration.

Boundary mismatch:

- opinionated process ownership;
- specialized-agent orchestration;
- stronger ownership of execution progression than AWCP intends.

## 5.4 BMAD Method

Primary source: [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD).

BMAD is valuable as evidence for complexity/risk-adaptive process and explicit role specialization, but its persona/workflow-heavy architecture conflicts with AWCP's current principle:

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

**INFERENCE:** treat BMAD as a process-pattern library, not a substrate.

## 5.5 Agent OS

Primary source: [buildermethods/agent-os](https://github.com/buildermethods/agent-os).

Useful patterns include standards discovery, specification improvement and contextual policy injection alongside existing coding tools.

It appears less focused on persistent work readiness/dependencies, generalized evidence and heterogeneous enforcement guarantees.

---

# 6. Agent orchestration and supervision systems

These projects are important primarily as a **boundary test**.

They often manage workers, sessions or agent loops rather than the semantic work itself.

Examples include:

- Maestro;
- Agent Deck;
- Gas Town;
- Ralph-style iterative loops;
- session/worktree supervisors;
- multi-agent coordination buses.

Their useful patterns may include:

- visibility into active agent execution;
- handoffs and ownership;
- parallel work isolation;
- retry/recovery;
- multi-agent scheduling;
- agent/session lifecycle.

But those concerns belong closer to:

```text
worker coordination / execution plane
```

than to AWCP's primary object:

```text
software work contract / governance / evidence
```

### Okto Nexus as an especially clear boundary example

**FACT:** Okto Nexus describes itself as coordinating who does the work through shared context, ownership, handoffs and approvals, while Pulse structures what must be built.

Source: [Okto Nexus](https://nexus.oktolabs.ai/).

This provides a useful conceptual test:

```text
AWCP-like concern → what work exists, what it requires, what proves completion

Nexus-like concern → which worker owns it, handoffs, coordination, worker communication
```

**HYPOTHESIS:** AWCP may need to expose information useful to orchestration systems without becoming one itself.

---

# 7. Coding-agent runtimes

Target clients/runtimes include:

- Claude Code;
- Codex;
- OpenCode;
- Gemini CLI;
- potentially OpenHands, SWE-agent and future tools where relevant.

They are not competitors to AWCP in the same sense as Pulse or Spec Kit. They own execution surfaces AWCP intends to preserve.

The crucial research question is not whether they can code. It is:

> **What supported lifecycle, context, permission, policy, hook, plugin, skill, MCP, event and output surfaces do they expose for work control?**

AWCP requires an explicit distinction between semantic portability and mechanism parity.

A future adapter might need to report guarantees conceptually similar to:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
```

This vocabulary remains **OPEN**.

### The mandatory-participation problem

A major uncertainty is whether AWCP can participate automatically whenever enabled without replacing the normal coding-client launch/runtime boundary.

These mechanisms are not equivalent:

```text
MCP tool available to the model
instruction telling the model to query work
client lifecycle hook
blocking policy / permission
external wrapper
```

SPIKE-001 must measure actual behavior rather than infer guarantees from feature names.

---

# 8. General agent frameworks are a different abstraction layer

Frameworks such as:

- LangGraph;
- AutoGen / successor Microsoft agent frameworks;
- CrewAI;
- OpenAI Agents SDK;
- similar orchestration/runtime libraries;

are useful when building an agent application or controlling its execution graph.

AWCP currently intends to work **with already-existing coding agents** whose runtimes it does not own.

Therefore these frameworks may contribute patterns for state machines, checkpointing, tool policies or observability, but they are not direct equivalents unless AWCP later decides to own an agent loop—which is currently outside its accepted boundary.

---

# 9. Emerging category map

The research now suggests several distinct layers that should not be collapsed under "agentic tooling":

```text
┌──────────────────────────────────────────────┐
│ SOFTWARE WORK / DELIVERY                    │
│ intent · specs · tasks · constraints        │
│ evidence · completion · project knowledge   │
│                                              │
│ Pulse / Spec systems / work substrates      │
│ ← AWCP hypothesis lives primarily here      │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ CODING-AGENT EXECUTION                      │
│ Claude Code · Codex · OpenCode · Gemini CLI │
│ agent loop · tools · context · edits        │
└──────────────────────────────────────────────┘
                      │
           may coordinate workers through
                      ▼
┌──────────────────────────────────────────────┐
│ AGENT / WORKER ORCHESTRATION                │
│ sessions · ownership · handoffs · routing   │
│ Nexus · Maestro · multi-agent systems       │
└──────────────────────────────────────────────┘
                      │
           may be operated/governed by
                      ▼
┌──────────────────────────────────────────────┐
│ AGENT CONTROL PLANE / ENTERPRISE OPS        │
│ fleet · identity · lifecycle · security     │
│ observability · cost · deployment           │
│ IBM / Microsoft Foundry control planes      │
└──────────────────────────────────────────────┘
```

The exact topology differs by product. The value of the diagram is categorical: **work, execution, worker coordination and fleet operations are separate concerns even when products combine them.**

---

# 10. What appears already solved or commoditized

The following no longer look like strong standalone reasons to build AWCP:

### Structured specifications

Spec Kit, Spec Kitty, GSD, Pulse and others already provide mature patterns.

### Persistent task/work records

Beads, Backlog.md, Pulse and conventional issue systems already cover substantial ground.

### Dependency and ready-work calculation

Existing work substrates already implement this.

### Human-readable local project state

Markdown-first and local-first systems demonstrate multiple viable approaches.

### Agent access through MCP/CLI/instructions

This is broadly available as an integration pattern.

### Dashboards / boards / TUIs

Visibility alone is not a product gap.

### Named specialized agents

Many frameworks already implement role/persona-driven pipelines. Recreating them is not differentiation.

### Generic agent fleet governance

IBM, Microsoft and other platforms are explicitly building this category. It is outside AWCP's primary scope anyway.

---

# 11. What appears partially solved

## 11.1 Cross-client work continuity

Many systems support multiple coding agents, but portability often means "we generate/install the right instructions for each client" rather than a proven semantic guarantee that one client can continue another's work state safely.

## 11.2 Work governance

Specs, acceptance criteria, review states and quality gates are common. The unresolved question is how much of that can be made technically enforceable across heterogeneous coding clients without owning the runtime.

## 11.3 Evidence-driven completion

Several systems have tests, validation and review concepts. A portable semantic model that connects arbitrary work requirements to evidence and completion may still be less standardized.

## 11.4 Adaptive structure

Risk/complexity-adaptive workflows exist, but many systems still encode process primarily through named stages or agent roles.

The AWCP hypothesis of:

```text
work characteristics
    ↓
required capabilities / gates
    ↓
client-specific realization
```

remains unvalidated.

## 11.5 Human-readable and machine-native state

Existing systems show this is feasible. The unresolved question is not feasibility but the **minimal semantic core** required for interoperability and governance.

---

# 12. What remains genuinely uncertain

These are the questions that currently justify research.

## 12.1 Is there a reusable work-control abstraction independent of methodology?

Could the same semantic work object survive across:

- Spec Kit;
- Beads;
- Backlog.md;
- Pulse;
- a simple repository;
- different coding clients;

without becoming the lowest-common-denominator abstraction that helps nobody?

## 12.2 Can critical work control be portable without runtime ownership?

The product vision requires coding clients to remain primary. That makes heterogeneous integration guarantees the central architectural risk.

## 12.3 Does AWCP need to own work state?

It may be enough to own only:

```text
control metadata
constraints
cross-system references
evidence links
completion state
```

while specs/tasks remain authoritative elsewhere.

Or even that may be unnecessary.

## 12.4 Is capability-driven reasoning useful?

The distinction:

```text
WORK CAPABILITY ≠ AGENT ROLE ≠ MODEL
```

is conceptually attractive but unproven. A spike must show that it leads to better, simpler or more portable work control than fixed workflows.

## 12.5 What does "done" mean across work types?

Implementation, research, debugging, migration, documentation and architecture work may require very different evidence. A universal completion model may be a mistake.

---

# 13. Potential genuine gap

The strongest remaining hypothesis is narrower than the project's original formulation.

It is **not**:

> Build a control plane for coding agents.

It is closer to:

> **Provide a small, local and agent-agnostic semantic control layer for software work, so heterogeneous coding agents can participate in the same persistent work state, constraints and evidence model without requiring the control layer to own their execution runtime.**

Possible differentiation, if validated, would come from the combination of:

1. **work-first semantics** rather than agent-first semantics;
2. **methodology independence** rather than one mandatory SDLC pipeline;
3. **executor independence** — agent, human or deterministic tool;
4. **portable governance semantics** with explicit differences between guidance, verification and enforcement;
5. **evidence-backed completion**;
6. **minimal ownership/composability** with existing work/spec systems;
7. **cross-client continuity** without replacing the coding client.

None of these points is yet sufficient evidence that a new implementation should exist.

---

# 14. Falsification criteria

AWCP should not be built as a separate system if experiments show that a small composition of existing tools provides the desired experience.

Examples that could falsify or radically shrink the project:

```text
Spec Kit + Beads + native client hooks/policies

Backlog.md + supported client integration + CI evidence

Okto Pulse configured/extended to avoid unwanted methodology coupling

coding-client-native project memory + Git/CI with minimal glue
```

A useful research program should therefore ask:

> **What is the smallest composition that already gives us persistent, governed and verifiable software work across coding agents?**

Only the remaining irreducible gap should become owned AWCP architecture.

---

# 15. Research conclusion

## Already solved / commoditized

- structured specs and plans;
- durable tasks and dependencies;
- ready/blocked work in existing substrates;
- Markdown/local-first project state;
- MCP/CLI agent access;
- many review and verification patterns;
- coding-client portability at the installation/instruction level;
- dashboards and work visualization;
- agent fleet governance as a separate enterprise category.

## Partially solved

- cross-client continuity;
- persistent work governance;
- evidence-linked completion;
- adaptive process by risk/type;
- multi-client integration around one work model;
- human/agent sharing of structured work artifacts.

## Still uncertain

- minimal AWCP semantic model;
- whether AWCP must own any work substrate;
- portable enforcement guarantees;
- mandatory participation while preserving native coding clients;
- capability-driven work control;
- evidence/completion semantics across work types;
- persistence and concurrency requirements.

## Potential genuine gap

A **thin work-control layer** between durable software-work semantics and heterogeneous coding-agent execution may remain underserved.

But Okto Pulse, Spec Kit and existing work substrates make the bar substantially higher than the original hypothesis suggested.

The next phase must therefore optimize for **falsification and composition**, not feature design.
