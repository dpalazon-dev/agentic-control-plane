# Research

## Status and scope

This document asks one question:

> **What can we reuse, and what remains unsolved?**

It is not a catalog of AI-development tools and it is not evidence that a new product must exist.

The research snapshot was refreshed on **2026-08-09** using project documentation, official repositories and recent papers where possible. External systems are evolving quickly; claims about them should be revalidated during the relevant spike before they become architecture.

### Evidence labels

- **FACT** — directly supported by a cited primary source or paper.
- **INFERENCE** — interpretation derived from the cited evidence.
- **HYPOTHESIS** — proposition that `agentic-control-plane` still needs to test.
- **DECISION** — accepted project boundary; authoritative decisions live in [`DECISIONS.md`](DECISIONS.md).

---

# 1. Research baseline

## 1.1 There is convergence, but not a single replacement for Scrum

**FACT:** A June 2026 comparative study of GitHub Spec Kit, OpenSpec, BMAD, GSD, Spec Kitty and Reversa found convergence away from isolated prompting and toward persistent artifacts, work contracts, traceability and human review. Its six-dimensional taxonomy covers specification, context, roles, execution, validation and portability. The authors also report that no evaluated framework strongly covered all six dimensions, exposing a trade-off between process depth and portability.

Source: [From Prompt to Process: a Process Taxonomy and Comparative Assessment of Frameworks Supporting AI Software Development Agents](https://arxiv.org/abs/2606.04967).

**INFERENCE:** The useful emerging object is not a single "AI Scrum" ceremony set. It is a development system composed from mechanisms that make intent, context, work, execution and verification explicit enough for agents to operate reliably.

A useful synthesis for this project remains:

```text
Intent
  ↓
Specification / work contract
  ↓
Persistent work structure
  ↓
Agent execution
  ↓
Automated verification
  ↓
Evidence
  ↓
Merge / outcome
  ↓
Persistent project memory
```

This is a description of convergence, not a proposed ACP workflow.

## 1.2 Harness engineering moves reliability outside the model

**FACT:** OpenAI describes an agent-first engineering experience in which human effort shifts from directly writing code toward designing environments, specifying intent and building feedback loops. The report explicitly notes that early failures were often caused by an underspecified environment lacking the tools, abstractions and internal structure needed by the agent.

Source: [Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/).

**FACT:** Recent research formalizes the coding harness as the layer mediating models, tools and execution environments. Agentic Harness Engineering (AHE) reports that improvements came primarily from tools, middleware and long-term memory rather than from the system prompt alone, and emphasizes observability of components, experience and decisions.

Source: [Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses](https://arxiv.org/abs/2604.25850).

**FACT:** Another 2026 harness paper proposes eleven recurring runtime responsibilities: task specification, context selection, tool access, project memory, task state, observability, failure attribution, verification, permissions, entropy auditing and intervention recording.

Source: [AI Harness Engineering: A Runtime Substrate for Foundation-Model Software Agents](https://arxiv.org/abs/2605.13357).

**INFERENCE:** The user's original intuition is directionally consistent with current research: reliability is increasingly a property of the **model + harness + environment**, not the model or prompt in isolation. However, those papers generally study or define harnesses around an agent runtime. ACP is asking a narrower architectural question: can useful harness-level responsibilities be projected **across existing coding clients without owning their agent loop?**

## 1.3 Spec-driven development is becoming process infrastructure

**FACT:** Contemporary Spec-Driven Development treats specifications as increasingly authoritative artifacts rather than disposable prompting material. The 2026 SDD survey distinguishes spec-first, spec-anchored and spec-as-source levels of rigor.

Source: [Spec-Driven Development: From Code to Contract in the Age of AI Coding Assistants](https://arxiv.org/abs/2602.00180).

**FACT:** Experimental work around Spec Kit has tested repository-grounding hooks between specification, planning, tasks and implementation, with phase-level validation against repository evidence.

Source: [Spec Kit Agents: Context-Grounded Agentic Workflows](https://arxiv.org/abs/2604.05278).

**INFERENCE:** Specifications alone are not the interesting architectural endpoint. The stronger pattern is a chain of linked artifacts plus grounding, execution and verification. ACP should therefore avoid equating "persistent work structure" with "write a better PRD".

---

# 2. Work substrates

Work substrates are relevant because ACP may need durable units of work, dependencies, readiness and history. The first question is not which one to adopt; it is whether ACP should own such a substrate at all.

## 2.1 Beads / `bd`

Primary source: [gastownhall/beads](https://github.com/gastownhall/beads).

**FACT — problem solved:** Beads describes itself as a distributed graph issue tracker and persistent structured memory for coding agents.

**FACT — source of truth / persistence:** Current Beads uses a Dolt-backed, versioned data model rather than plain Markdown task files.

**FACT — work model:** It provides issue/work records, dependency relationships and graph links.

**FACT — ready work:** `bd ready` lists tasks without open blockers.

**FACT — concurrency:** Hash-based IDs, claim operations and the underlying versioned data model are explicitly designed for multi-agent/multi-branch use.

**FACT — agent integration:** Current setup supports client-oriented installation patterns for Codex and Claude, including instructions/hooks where appropriate.

**What ACP could reuse:**

- dependency-aware work graph semantics;
- ready/blocked calculation;
- atomic claiming/concurrency ideas;
- persistent agent memory patterns;
- machine-readable CLI behavior;
- client bootstrap patterns.

**What remains missing for ACP:**

- Beads is principally a work/memory substrate, not a client-neutral governance layer;
- it does not by itself define ACP's capability semantics, cross-client enforcement contract or evidence model;
- adopting it as source of truth would import a substantial storage and synchronization choice before ACP knows its required queries and invariants.

**INFERENCE:** Beads may already solve a large fraction of `Work`. That is an argument for testing it in SPIKE-002, not for wrapping it or reimplementing it now.

## 2.2 Backlog.md

Primary source: [MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md).

**FACT — problem solved:** Backlog.md is a Markdown-native task manager and Kanban visualizer designed for collaboration between humans and AI agents.

**FACT — source of truth / persistence:** Work is stored as human-readable project-local Markdown, with Git optional.

**FACT — work model:** It supports task descriptions, acceptance criteria, Definition of Done, milestones, dependencies, plans, comments and decisions.

**FACT — agent integration:** It exposes CLI and MCP workflows and provides setup guidance for multiple coding agents including Claude Code, Codex and Gemini CLI.

**FACT — UI:** It includes terminal board and local browser views.

**What ACP could reuse:**

- the idea that machine-readable work state can remain directly human-readable;
- acceptance criteria and DoD as explicit work contracts;
- local-first task persistence;
- stable JSON/CLI query surfaces;
- integration instructions that allow agents to discover the work protocol.

**What remains missing for ACP:**

- it is intentionally a task/project-management substrate rather than a generalized governance/control layer;
- MCP/instructions make the work model available to agents but do not prove mandatory lifecycle participation;
- execution capability routing, client-specific enforcement and evidence semantics are not its central abstraction.

**INFERENCE:** Backlog.md is a strong test of whether ACP can avoid inventing its own work schema while preserving human readability.

## 2.3 Task Master AI

Primary source: [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master).

**FACT — problem solved:** Task Master provides AI-assisted task management, dependencies, tags/workstreams, research commands, MCP/CLI integration and model configuration.

**FACT — model/runtime boundary:** Several Task Master operations invoke AI providers directly. Its newer loop functionality can run Claude Code iteratively for automated task execution.

**What ACP could reuse:**

- task decomposition and dependency patterns;
- separation of main/research/fallback model responsibilities as a reference pattern;
- ready/blocking work concepts;
- practical lessons from integrating task state with coding clients.

**What conflicts with ACP's boundary:**

- direct model-provider configuration is not intended as ACP's primary responsibility;
- an execution loop that launches the coding agent moves toward owning orchestration/runtime behavior ACP explicitly wants to avoid.

**INFERENCE:** Task Master is useful comparative evidence but is not the desired architectural layer.

## Work-substrate conclusion

**Partially solved:** persistent tasks, dependencies, ready work, acceptance criteria and local/machine-readable state already have credible implementations.

**Still uncertain:** whether ACP needs a separate `Work` abstraction, whether a graph is necessary, and whether ACP should own or merely query/project an existing substrate.

---

# 3. Spec and development methodology systems

These projects matter because they increasingly provide process, artifacts, context and some governance around existing coding agents.

## 3.1 GitHub Spec Kit

Primary sources: [Spec Kit documentation](https://github.github.io/spec-kit/) and [github/spec-kit](https://github.com/github/spec-kit).

**Important update:** Earlier descriptions of Spec Kit as primarily a spec-generation toolkit are now incomplete.

**FACT:** As of the July 2026 documentation, GitHub describes Spec Kit as an **"extensible, intent-driven harness"** that can guide any supported coding agent across an SDLC or other process.

**FACT — default work/process:** Its default SDD sequence is `Spec → Plan → Tasks → Implement`, with linked Markdown artifacts.

**FACT — portability:** Current documentation advertises 35 coding-agent integrations and explicitly supports switching between agents.

**FACT — extension surface:** It now has extensions, presets, workflows and bundles; community extensions include governance-oriented examples such as CI and architecture guards.

**FACT — local/offline:** Current docs state that it can operate offline/behind firewalls and across Windows, macOS and Linux.

**What ACP could reuse:**

- integration-adapter architecture across many coding clients;
- intent-centered artifact flow;
- templates/checklists/cross-artifact analysis;
- extensibility and installation patterns;
- governance extensions as evidence that control concerns can be layered around an existing coding client.

**What is not yet shown to be equivalent to ACP:**

- a general persistent work/dependency substrate independent of a spec workflow;
- a client-neutral contract for deterministic enforcement across heterogeneous host capabilities;
- explicit evidence attached to arbitrary work completion as a core semantic primitive;
- a minimal project-level control state designed to survive arbitrary client/session switching;
- capability-driven resolution independent of named workflow stages.

**INFERENCE:** Spec Kit is currently one of the closest systems to the ACP hypothesis and must be treated as a serious reuse/composition candidate, not merely inspiration. SPIKE-001 and SPIKE-002 should actively try to falsify the need for ACP by seeing how far Spec Kit plus an existing work substrate can go.

## 3.2 Spec Kitty

Primary source: [Priivacy-ai/spec-kitty](https://github.com/Priivacy-ai/spec-kitty).

**FACT:** Spec Kitty describes a repo-native flow:

```text
spec → plan → tasks → next → review → accept → merge
```

**FACT — persistent state:** Specs, plans, work packages, acceptance criteria, review state and merge decisions live in the repository.

**FACT — governance:** It explicitly frames itself around governed software factories, visible review gates and auditable delivery state.

**FACT — portability:** It integrates with Claude Code, Codex, Gemini, OpenCode and other coding agents.

**FACT — execution model:** It uses isolated Git worktrees for parallel implementation and has an explicit runtime progression through work-package lanes.

**FACT — UI:** It offers a local dashboard.

**What ACP could reuse:**

- repo-native, inspectable governance records;
- work-package lifecycle and explicit `next` semantics;
- acceptance/review/merge trail;
- separation between the coding agent and external mission state;
- multi-client integration patterns.

**What conflicts with ACP's current boundary:**

- Spec Kitty intentionally owns a stronger delivery methodology;
- worktrees are a central execution primitive, whereas ACP explicitly does not want to impose them;
- its mission/work-package lifecycle is more opinionated than ACP has yet justified;
- it approaches a governed workflow/runtime, while ACP is investigating a thinner semantic control layer.

**INFERENCE:** Spec Kitty demonstrates that much of the desired *experience* is possible today. ACP's differentiation, if any, cannot simply be "persistent agent work + governance + dashboard". It would have to be a thinner, more composable and less workflow-owning layer.

## 3.3 GSD / Get Shit Done

Primary sources: [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) and its [architecture documentation](https://github.com/gsd-build/get-shit-done/blob/main/docs/ARCHITECTURE.md).

**FACT:** GSD is a context-engineering and spec-driven system supporting multiple coding runtimes including Claude Code, OpenCode, Gemini CLI and Codex.

**FACT — persistent state:** It maintains structured project files such as project vision, requirements, roadmap, state, plans, summaries and research so work survives context resets.

**FACT — execution:** Its architecture uses thin orchestrators that spawn specialized agents for research, planning, execution, verification and debugging.

**FACT — verification:** Plans can contain explicit verification and done criteria, and the workflow includes plan checking and post-execution verification.

**What ACP could reuse:**

- file-based state and handoff patterns;
- context selection by work phase;
- verification as a first-class phase rather than an afterthought;
- multi-runtime installation/translation patterns;
- thin-orchestrator principle.

**What conflicts with ACP's boundary:**

- GSD owns an opinionated methodology and agent orchestration model;
- named specialized agents are part of its execution architecture;
- it is intentionally a process layer that moves work through phases, while ACP is testing whether capabilities can be resolved adaptively without a fixed pipeline.

**INFERENCE:** GSD is especially relevant evidence for persistence and context continuity, but ACP should not recreate its workflow under different names.

## 3.4 BMAD Method

Primary source: [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD).

**FACT:** BMAD provides a full AI-driven development lifecycle, 12+ specialized agent personas and 34+ workflows, with scale-adaptive planning and role-based collaboration.

**What ACP could reuse:**

- risk/complexity-adaptive planning as a pattern;
- workflow outputs that progressively build context;
- explicit test/architecture specializations.

**What conflicts with ACP's boundary:**

- role/persona-centric orchestration is a primary abstraction;
- a large workflow catalog would violate ACP's current minimalism;
- `Agent responsibility ≠ model policy` and `Capability ≠ Agent ≠ Model` deliberately avoid making named agents the semantic core.

**INFERENCE:** BMAD is useful as a process-pattern library, not as ACP's substrate.

## 3.5 Agent OS

Primary source: [buildermethods/agent-os](https://github.com/buildermethods/agent-os).

**FACT:** Agent OS focuses on discovering/deploying codebase standards and shaping better specs while working alongside existing AI coding tools.

**What ACP could reuse:**

- standards discovery and context injection;
- the idea that policy/context can be selected according to current work rather than loading everything globally.

**What remains outside its scope:**

- persistent work dependencies/readiness;
- generalized execution evidence;
- cross-client enforcement and capability resolution.

## Methodology-system conclusion

**Already solved well enough to reuse:** structured spec/plan/task artifacts, context packaging, client-specific installation, staged verification patterns and many human-review mechanisms.

**Partially solved:** portability of process across coding agents and repository-native governance.

**Potential ACP question:** can those mechanisms be composed without adopting a complete methodology or owning execution flow?

---

# 4. Agent orchestration and supervision systems

These systems overlap visually with the original TUI idea but often operate at a different layer: they manage sessions, agent processes or multi-agent runtimes.

## 4.1 Maestro

Primary source: [RunMaestro/Maestro](https://github.com/RunMaestro/Maestro).

**FACT:** Maestro is an agent orchestration command center supporting Claude Code, Codex and OpenCode. It describes itself as a pass-through to existing providers while running tasks non-interactively, and provides parallel worktree execution, auto-run and playbooks.

**Useful patterns:**

- preserving native provider configuration while supervising execution;
- task-to-session mapping;
- visibility over parallel agent work.

**Boundary mismatch:**

- Maestro becomes a task/session execution surface;
- it launches and manages agent work non-interactively;
- worktrees and parallel session orchestration are central features.

**INFERENCE:** Maestro is closer to an orchestration runtime/session manager than to ACP's proposed thin semantic control plane.

## 4.2 Agent Deck

Primary source: [asheshgoplani/agent-deck](https://github.com/asheshgoplani/agent-deck).

**FACT:** Agent Deck is a terminal session manager/command center for multiple coding agents. It tracks session status, groups/switches sessions, manages MCP attachment, supports worktrees and offers cost/status observation.

**Useful patterns:**

- cross-agent status normalization;
- local observation of heterogeneous clients;
- extracting telemetry from client-specific surfaces;
- separating an observer UI from the coding agents themselves.

**Boundary mismatch:**

- the TUI/session manager is the product's central interaction surface;
- it manages agent sessions and can supervise fleets;
- ACP explicitly does not want its TUI to become necessary or primary.

**INFERENCE:** Agent Deck is more relevant to a future ACP observer/integration adapter than to ACP's semantic core.

## 4.3 Gas Town / Gas City

Primary source: [gastownhall/gascity](https://github.com/gastownhall/gascity).

**FACT:** Gas City extracts reusable orchestration infrastructure from Gas Town into an SDK with runtime providers, work routing, Beads-backed tracking, declarative configuration and a controller/supervisor loop.

**Useful patterns:**

- work routing separated from runtime providers;
- explicit orchestration primitives;
- Beads as an external work substrate;
- health/reconciliation concepts.

**Boundary mismatch:**

- Gas City intentionally is an orchestration-builder SDK;
- it owns a supervisor/controller loop and multiple execution runtimes;
- this is precisely the runtime responsibility ACP currently wants to leave to existing coding clients.

## 4.4 Ralph-style loops

Ralph-style loops are a pattern rather than one canonical implementation: repeatedly provide a task to an agent, execute, inspect results, and continue until a stop/verification condition is met.

**Reusable idea:** verification/repair loops should be explicit and bounded.

**Risk for ACP:** implementing the loop itself would move ACP toward owning the agent runtime. SPIKE-003 should instead test whether ACP can **request or guide** repair through the host client's existing mechanisms.

## Orchestration conclusion

Session/fleet management and multi-agent execution are already well-populated solution spaces. ACP should resist competing there unless research falsifies its current boundary.

---

# 5. Coding-agent clients and runtimes

The most important integration fact is not that these clients all "support agents". It is that they expose **different control surfaces with different guarantees**.

## 5.1 Claude Code

Primary sources: [Hooks reference](https://code.claude.com/docs/en/hooks) and [Permissions](https://code.claude.com/docs/en/permissions).

**FACT:** Claude Code exposes lifecycle hooks, including pre/post tool events and permission-related events. Pre-tool hooks can block tool calls, modify inputs, request approval or add context.

**FACT:** Permission rules and hooks have explicit precedence; a blocking hook can prevent an operation even when another rule would otherwise allow it.

**FACT:** Claude Code also supports subagents and project/user/plugin configuration scopes.

**ACP implication:** Claude Code appears to expose strong deterministic integration surfaces for SPIKE-001, including a real distinction between contextual guidance and tool-level enforcement.

## 5.2 Gemini CLI

Primary sources: [Gemini CLI hooks](https://geminicli.com/docs/hooks/) and [Policy engine](https://geminicli.com/docs/reference/policy-engine/).

**FACT:** Gemini CLI hooks execute synchronously inside the agent loop and can inject context, validate/block actions, enforce policies and log interactions.

**FACT:** Its policy engine can allow, deny or require user confirmation for tool execution with prioritized rules.

**Important current limitation:** Gemini's documentation currently notes that workspace-tier policy rules are non-functional and recommends user/admin tiers instead.

**ACP implication:** Gemini provides strong primitives, but even apparently suitable surfaces can have scope/version limitations. Integration capabilities need runtime/version validation, not marketing-level checkboxes.

## 5.3 OpenCode

Primary sources: [Permissions](https://opencode.ai/docs/permissions) and [Agents](https://opencode.ai/docs/agents).

**FACT:** OpenCode exposes granular `allow / ask / deny` permissions, including command/path-level rules and per-agent overrides.

**FACT:** It exposes primary agents and subagents with configurable tool access.

**ACP implication:** OpenCode has deterministic permission surfaces and rich agent configuration. Its exact hook/plugin lifecycle and stability should be validated separately rather than assumed equivalent to Claude/Gemini.

## 5.4 Codex

Primary sources: [Running Codex safely at OpenAI](https://openai.com/index/running-codex-safely/) and [Harness engineering](https://openai.com/index/harness-engineering/).

**FACT:** OpenAI documents sandboxing, approval policies, network controls, rules, managed configuration and agent-native telemetry/audit trails as mechanisms used to govern Codex execution.

**FACT:** Project/repository instructions and environment design are central parts of the Codex harness model.

**ACP implication:** Codex clearly exposes meaningful governance surfaces, but SPIKE-001 must establish whether it exposes a generic deterministic lifecycle hook surface equivalent to Claude/Gemini or whether ACP integration must rely on a different composition of rules, sandboxing, instructions, MCP/skills and telemetry.

## 5.5 Cross-client implication

**FACT:** An empirical 2026 study of agentic coding-tool configuration found distinct configuration cultures across tools, with context files dominating and advanced mechanisms such as skills/subagents still relatively shallowly adopted. It also identifies `AGENTS.md` as an emerging interoperable convention.

Source: [Configuring Agentic AI Coding Tools: An Exploratory Study](https://arxiv.org/abs/2602.14690).

**INFERENCE:** "Agent agnostic" cannot mean "one identical integration implementation". It should mean that the core semantics are independent of client internals while adapters translate those semantics to whatever supported capabilities each host actually has.

This yields a likely capability negotiation problem:

```text
core requests semantic behavior
        ↓
adapter reports supported mechanism / guarantee
        ↓
behavior is enforced, guided, observed, or declared unsupported
```

That is a hypothesis for SPIKE-001, not an accepted API design.

---

# 6. Coding-agent runtimes: OpenHands and SWE-agent

OpenHands and SWE-agent are relevant because they demonstrate how much reliability can live in a dedicated software-agent runtime/harness.

Primary sources: [OpenHands documentation](https://docs.openhands.dev/) and [SWE-agent documentation](https://swe-agent.com/latest/).

**FACT:** These projects provide their own execution/runtime abstractions around software-engineering agents, including controlled environments/tool interfaces and agent trajectories/workflows.

**What ACP can learn:**

- environment isolation and tool-interface design matter;
- execution trajectories are useful evidence;
- verification and tool constraints can be built into the harness rather than left to prompting.

**Why they are not equivalent:** ACP explicitly does not want to create the agent runtime that executes the coding model. It wants existing clients to remain responsible for that loop.

---

# 7. General agent frameworks

These frameworks are important chiefly to prevent an abstraction-layer mistake.

## 7.1 LangGraph

Primary source: [LangGraph persistence documentation](https://docs.langchain.com/oss/python/langgraph/persistence).

**FACT:** LangGraph provides graph/workflow execution, persisted checkpoints, human-in-the-loop interruption, replay/time travel and fault-tolerant state for agents/workflows built on its runtime.

**Layer mismatch:** It is a framework for **building the agent/workflow runtime**. ACP is investigating control around already-existing coding runtimes.

## 7.2 AutoGen and Microsoft Agent Framework

Primary sources: [microsoft/autogen](https://github.com/microsoft/autogen) and [Microsoft Agent Framework](https://learn.microsoft.com/en-us/agent-framework/).

**Current correction:** AutoGen is now explicitly in **maintenance mode**. Microsoft directs new users to Microsoft Agent Framework, its production-oriented successor.

**FACT:** Microsoft Agent Framework provides agents, tools, memory/persistence, workflows and hosting primitives.

**Layer mismatch:** These primitives are for constructing and hosting agent applications. Adopting them as ACP's core would strongly pull the project toward owning its own runtime and agent loop.

## 7.3 CrewAI

Primary source: [CrewAI documentation](https://docs.crewai.com/).

**FACT:** CrewAI provides agents/crews plus flows with persisted state, routing, guardrails, callbacks and human-in-the-loop mechanisms.

**Layer mismatch:** Like LangGraph and Microsoft Agent Framework, CrewAI is designed to implement the agentic application/workflow itself.

## General-framework conclusion

**Already solved:** durable graph/workflow runtimes, multi-agent messaging, checkpointing, routing, human-in-the-loop and hosted execution all exist in mature generic frameworks.

**ACP implication:** Unless later evidence changes the project boundary, these frameworks are references for mechanisms, not candidate foundations for ACP's core. Using one too early would likely turn ACP into the multi-agent runtime it explicitly does not want to become.

---

# 8. Comparative synthesis

The relevant landscape is easier to understand by **layer** than by product name.

| Layer | Representative systems | What is largely solved | What ACP should not duplicate prematurely |
|---|---|---|---|
| Coding client/runtime | Claude Code, Codex, OpenCode, Gemini CLI | Agent loop, model interaction, tool execution, permissions/safety to varying degrees | Another coding agent or chat runtime |
| Work substrate | Beads, Backlog.md, Task Master | Tasks, dependencies, readiness, persistent work records | A custom issue tracker before proving need |
| Spec/process harness | Spec Kit, Spec Kitty, GSD, BMAD, Agent OS | Structured intent/specs/plans, context packaging, verification patterns | A giant new methodology/workflow catalog |
| Session/orchestration | Maestro, Agent Deck, Gas City | Session supervision, multi-agent execution, parallelism, worktrees, fleet visibility | A session manager or distributed scheduler |
| Generic agent framework | LangGraph, Microsoft Agent Framework, CrewAI | Agent/workflow construction, persistence, routing, HITL | Owning a general agent runtime |
| Candidate ACP layer | not yet proven | Cross-client semantic work/governance composition | Must be validated rather than assumed |

This table is a conceptual map, not a feature scorecard.

---

# 9. What appears already solved or commoditized

The following capabilities should carry a high burden of proof before ACP implements equivalents.

## Already solved / commoditized

### Structured specification and planning artifacts

Spec Kit, Spec Kitty, GSD, BMAD and others already provide mature patterns for translating intent into specs, plans and tasks.

### Persistent task/dependency substrates

Beads and Backlog.md already provide durable work state with dependencies and machine-readable interfaces using very different persistence models.

### Client-native agent loops and tool execution

Claude Code, Codex, OpenCode and Gemini CLI already own the primary coding-agent interaction and execution loop.

### Generic multi-agent orchestration runtimes

LangGraph, Microsoft Agent Framework, CrewAI, Gas City and related systems already provide runtime orchestration primitives.

### Session-management UIs

Agent Deck and Maestro already demonstrate rich local supervision/management experiences for multiple coding agents.

### Basic verification mechanics

Tests, linters, CI, client hooks and methodology-specific verifier stages already exist. ACP does not need to invent verification execution; its interesting question is how verification requirements and evidence are associated with work.

---

# 10. What is partially solved

## Cross-client process portability

Spec Kit and GSD demonstrate that workflows/instructions can be translated across many clients. But portability of a process is not the same as portability of **enforcement guarantees**.

## Persistent work + methodology

Spec Kitty, GSD and others connect persistent artifacts to execution. However, they generally own a stronger methodology than ACP currently wants.

## Governance

Claude/Gemini/OpenCode/Codex all expose meaningful native safety/governance mechanisms, and Spec Kitty/Spec Kit add process-level gates. What is not standardized is a client-neutral semantic contract that can say what is truly enforceable on each host.

## Evidence and traceability

Several systems preserve summaries, reviews, trajectories or mission state. Recent harness research emphasizes auditable episode evidence. The open question is whether ACP needs a small general `Evidence` concept linking work, gates and outcomes across clients.

## Shared persistent context

GSD, Beads, repository instruction files and client-specific memories all address continuity. The unresolved question is which state genuinely needs to be shared across clients rather than reconstructed from repository/project state.

---

# 11. What remains uncertain

These are research questions, not gaps we can claim as facts.

## Can deterministic participation be portable?

The project wants the control plane to participate when enabled rather than being an optional MCP tool the model may ignore. Claude and Gemini expose strong lifecycle hooks; other clients may require different mechanisms. We do not yet know whether a sufficiently transparent, supported, deterministic integration exists for every target client without introducing a wrapper that changes the normal user experience.

## Does ACP need to own persistent work state?

It may be enough to compose Spec Kit/GSD-style artifacts with Beads/Backlog.md and expose a thin normalization layer. A custom work model is not justified until SPIKE-002 disproves that composition.

## Is a graph necessary?

Dependencies are useful, but a graph database or graph-native schema is not implied. The useful invariant may be much smaller: "work can declare blockers and query readiness."

## Is capability-driven orchestration a useful abstraction?

The distinction `Capability ≠ Agent ≠ Model` is conceptually attractive, but it has not yet demonstrated operational value. SPIKE-003 must test whether it produces better, simpler behavior than host-native agents/workflows or direct execution.

## Can governance remain thin?

There is a risk that modeling constraints, policies, approvals, risk, quality gates and evidence turns ACP into a policy/workflow platform. The minimum semantics must be discovered from real use cases rather than designed top-down.

## What state belongs in Git versus local/private storage?

Repository-native state improves inspectability and portability, but execution state, locks, transient telemetry or sensitive local data may not belong in Git. This cannot be decided before concurrency and query requirements are known.

## Does a resident process exist at all?

The term "control plane" can bias design toward a daemon. There is currently no evidence that background state or scheduling is required. SPIKE-004 must determine whether an on-demand core is sufficient.

---

# 12. Potential genuine gap

**HYPOTHESIS, not market claim:** The research sampled so far has not identified a project that clearly combines all of the following while maintaining ACP's boundaries:

1. developers keep their existing coding client as the primary interface;
2. a small local, client-agnostic semantic layer persists project/work control state across sessions and clients;
3. the layer does not own the model invocation or primary agent loop;
4. it does not require a specific spec methodology, worktree strategy or fixed multi-agent pipeline;
5. it can express work/governance/evidence needs independently of a particular agent role or model;
6. client adapters translate those semantic needs into supported native surfaces;
7. the system distinguishes deterministically enforced controls from guidance-only behavior;
8. humans can inspect the same state agents use without a mandatory project-management UI.

However, the apparent gap is **narrower than the original idea first suggested**.

Spec Kit has moved significantly toward an extensible, agent-portable harness. Spec Kitty already combines repo-native mission state, governance, review and cross-agent integration. GSD provides persistent state, multi-runtime context engineering and verification. Beads/Backlog.md solve large parts of persistent work. Client-native hooks/policies solve substantial parts of enforcement.

Therefore the likely opportunity, if it exists, is not to recreate those systems. It is to test whether a **minimal composition/control contract between them and heterogeneous coding clients** adds enough value to justify a distinct project.

A useful falsification target is:

> If Spec Kit or GSD + Beads/Backlog.md + native client enforcement surfaces can deliver the desired experience with thin configuration and no new semantic core, ACP should shrink dramatically or stop.

---

# 13. Research implications for the first spikes

## SPIKE-001 — Client integration surfaces should go first

Why first: the core promise depends on being able to participate through existing clients without replacing them. If supported client surfaces cannot provide sufficient observation/injection/control, much of the architecture changes.

The spike should empirically record, per client:

- lifecycle events available;
- context injection;
- project/user/admin scope;
- permission and blocking semantics;
- MCP invocation guarantees;
- skill/plugin mechanisms;
- subagent control;
- structured output/telemetry;
- whether execution can be mandatory when ACP is enabled;
- whether the integration depends on prompts;
- Windows behavior;
- version/stability status.

Each capability should be marked something like:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
UNKNOWN
```

This is a proposed research vocabulary, not an accepted schema.

## SPIKE-002 — Try to avoid owning Work

Test Beads, Backlog.md, simple repository files and a deliberately tiny custom representation against concrete queries:

- what is ready?
- what blocks this?
- what is the expected outcome?
- who/what is working on it?
- what evidence closes it?
- can two clients update state safely?
- can a human inspect/correct it?
- can the agent query it cheaply?

Do not choose storage on aesthetics.

## SPIKE-003 — Falsify capability-driven orchestration

Use a few representative work types with different risk/uncertainty characteristics and compare:

- direct host-agent execution;
- a fixed workflow;
- capability-driven selection.

The capability abstraction survives only if it reduces coupling or improves correctness/verification without recreating an orchestration framework.

## SPIKE-004 — Let lifecycle requirements choose persistence

Only after observing real integration and concurrent updates should the project test:

- on-demand versus resident core;
- locking/concurrency;
- event requirements;
- crash recovery;
- transient versus durable state;
- Git/private-state split.

---

# 14. Current research conclusion

The initial thesis should be narrowed from:

> "We need a new methodology/control plane for agentic coding."

To:

> **"Modern agentic development is converging on persistent artifacts, structured work, harness-level context/governance and verification. Existing tools solve many of these concerns separately or inside opinionated runtimes. We need to test whether a small local, client-agnostic semantic control layer can compose those capabilities across existing coding clients without becoming another runtime, methodology or project manager."**

That statement is consistent with the evidence while remaining falsifiable.

The immediate research priority is therefore not feature design. It is to validate the two hardest boundaries:

1. **cross-client supported integration and enforcement**, and
2. **whether existing work substrates can remain the source of truth**.

Everything beyond that should remain provisional until those questions produce evidence.

---

# 15. Primary references

## Research / concepts

- [From Prompt to Process: a Process Taxonomy and Comparative Assessment of Frameworks Supporting AI Software Development Agents](https://arxiv.org/abs/2606.04967)
- [Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/)
- [Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses](https://arxiv.org/abs/2604.25850)
- [AI Harness Engineering: A Runtime Substrate for Foundation-Model Software Agents](https://arxiv.org/abs/2605.13357)
- [Spec-Driven Development: From Code to Contract in the Age of AI Coding Assistants](https://arxiv.org/abs/2602.00180)
- [Spec Kit Agents: Context-Grounded Agentic Workflows](https://arxiv.org/abs/2604.05278)
- [Configuring Agentic AI Coding Tools: An Exploratory Study](https://arxiv.org/abs/2602.14690)

## Work substrates

- [Beads](https://github.com/gastownhall/beads)
- [Backlog.md](https://github.com/MrLesk/Backlog.md)
- [Task Master AI](https://github.com/eyaltoledano/claude-task-master)

## Spec / methodology / harness systems

- [GitHub Spec Kit](https://github.github.io/spec-kit/)
- [Spec Kitty](https://github.com/Priivacy-ai/spec-kitty)
- [GSD / Get Shit Done](https://github.com/gsd-build/get-shit-done)
- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD)
- [Agent OS](https://github.com/buildermethods/agent-os)

## Orchestration / supervision

- [Maestro](https://github.com/RunMaestro/Maestro)
- [Agent Deck](https://github.com/asheshgoplani/agent-deck)
- [Gas City](https://github.com/gastownhall/gascity)

## Coding clients

- [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code permissions](https://code.claude.com/docs/en/permissions)
- [Gemini CLI hooks](https://geminicli.com/docs/hooks/)
- [Gemini CLI policy engine](https://geminicli.com/docs/reference/policy-engine/)
- [OpenCode permissions](https://opencode.ai/docs/permissions)
- [OpenCode agents](https://opencode.ai/docs/agents)
- [Running Codex safely at OpenAI](https://openai.com/index/running-codex-safely/)

## General runtimes / frameworks

- [LangGraph](https://docs.langchain.com/oss/python/langgraph/)
- [Microsoft Agent Framework](https://learn.microsoft.com/en-us/agent-framework/)
- [AutoGen](https://github.com/microsoft/autogen)
- [CrewAI](https://docs.crewai.com/)
- [OpenHands](https://docs.openhands.dev/)
- [SWE-agent](https://swe-agent.com/latest/)
