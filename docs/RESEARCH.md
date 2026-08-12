# Research

## Status and scope

This document asks:

> **What parts of agentic software work are already solved, what can be composed, and what remains unsolved enough to justify an Agentic Work Control Plane?**

The current hypothesis is specifically about **daily software development with existing coding agents** such as Claude Code, Codex, OpenCode and Gemini CLI. It is not primarily about building custom agents on a new SDK/runtime.

It is not a catalog of AI-development tools and it does not assume that a new product needs to exist.

Research snapshot refreshed on **2026-08-12** using official documentation, official repositories and recent papers where possible. External systems move quickly; claims about current products must be revalidated during the relevant spike before becoming architecture.

### Evidence labels

- **FACT** — directly supported by a cited source.
- **INFERENCE** — interpretation of one or more facts.
- **HYPOTHESIS** — proposition this project still needs to test.
- **DECISION** — accepted project boundary; authoritative decisions live in [`DECISIONS.md`](DECISIONS.md).

---

# 1. Naming correction: Agent Control Plane is a different category

The initial project name, `agentic-control-plane`, was too broad and increasingly conflicts with an emerging industry meaning.

## 1.1 What current Agent Control Planes control

**FACT:** IBM defines an agent control plane as a system that deploys, operates, monitors and governs AI agents across an organization. Individual agents operate in a data plane where they execute tasks and interact with tools, while the control plane handles system-level governance and coordination.

Sources:

- [IBM — What is an Agent Control Plane?](https://www.ibm.com/think/topics/agent-control-plane)
- [IBM watsonx Orchestrate — Agent Control Plane](https://www.ibm.com/products/watsonx-orchestrate/agent-control-plane)

**FACT:** Microsoft Foundry Control Plane similarly centralizes management of AI agents, models and tools across an enterprise, including agent inventory, fleet management, observability, compliance, security and lifecycle operations.

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

That is not the primary object investigated by AWCP.

## 1.2 The object here is software work

AWCP instead asks whether software work performed through heterogeneous coding agents needs durable structure, explicit responsibility and governance independent of any single coding client.

```text
Agent Control Plane
    governs → agents / agent infrastructure

Agentic Work Control Plane
    governs → software work performed with agents
```

Candidate work concerns include:

```text
intent
work packages / tasks
dependencies
required agent roles
constraints
decisions
context requirements
permission requirements
evidence
verification
completion
continuity
```

**DECISION:** The project is framed as **Agentic Work Control Plane (AWCP)**.

This naming distinction does not prove novelty. It identifies the governed object more accurately.

---

# 2. Research baseline: software development is converging around explicit work artifacts

## 2.1 The reviewed evidence does not establish a single "AI Scrum"

**FACT:** A June 2026 comparative study of GitHub Spec Kit, OpenSpec, BMAD, GSD, Spec Kitty and Reversa found convergence away from isolated prompting and toward persistent artifacts, work contracts, traceability and human review. Its taxonomy compares specification, context, roles, execution, validation and portability, and reports that no evaluated framework strongly covers every dimension.

Source: [From Prompt to Process: a Process Taxonomy and Comparative Assessment of Frameworks Supporting AI Software Development Agents](https://arxiv.org/abs/2606.04967).

**FACT:** The same study describes BMAD as making familiar agile artifacts consumable by agents rather than replacing agile practices. The SDD technical report likewise treats agile user stories, acceptance criteria and Definition of Done as compatible specification artifacts.

**INFERENCE:** The defensible claim is not that the state of the art has proved there can be no replacement for Scrum or Kanban. It is narrower:

> The reviewed evidence does not identify or validate one general replacement. Current frameworks compose agent-oriented specification, context, roles, execution and validation with existing software-engineering practices in different ways.

**INFERENCE:** The emerging pattern is not a replacement ceremony framework but an increasingly explicit delivery chain:

```text
Intent
  ↓
Specification / work contract
  ↓
Persistent work structure
  ↓
Responsibility assignment
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

The important correction for AWCP is that **responsibility assignment cannot be reduced to generic capabilities**. A methodology may require a developer, tester and independent reviewer to participate distinctly even when their underlying tools overlap.

## 2.2 Harness engineering moves reliability outside the model

**FACT:** OpenAI's harness-engineering account describes an agent-first engineering environment in which human effort shifts toward specifying intent, structuring the environment and building feedback loops. Early failures were often caused not simply by model capability but by insufficient tools, abstractions and repository structure.

Source: [OpenAI — Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/).

**FACT:** Recent research on agentic harness engineering treats tools, interfaces, memory, execution constraints and feedback loops as important parts of a coding-agent harness. In the reported AHE experiments, gains concentrated in tools, middleware and long-term memory rather than the system prompt alone.

Sources:

- [Agentic Harness Engineering: Observability-Driven Automatic Evolution of Coding-Agent Harnesses](https://arxiv.org/abs/2604.25850)
- [AI Harness Engineering: A Runtime Substrate for Foundation-Model Software Agents](https://arxiv.org/abs/2605.13357)

**INFERENCE:** Reliability increasingly belongs to **model + harness + development environment**, not to the prompt alone.

This is directly relevant to AWCP because role-driven execution needs context, memory, permissions, verification and observability. However, needing those functions does not imply AWCP should implement them.

## 2.3 Spec-driven development is becoming infrastructure rather than documentation

**FACT:** The reviewed SDD technical report distinguishes three levels of rigor: `spec-first`, `spec-anchored` and `spec-as-source`. Its common workflow is `Specify -> Plan -> Implement -> Validate`; implementation is decomposed into reviewable tasks, and each phase produces an artifact that constrains the next.

Sources:

- [Spec-Driven Development: From Code to Contract in the Age of AI Coding Assistants](https://arxiv.org/abs/2602.00180)
- [Spec Kit Agents: Context-Grounded Agentic Workflows](https://arxiv.org/abs/2604.05278)

**INFERENCE:** AWCP should not equate persistent work with "a better PRD". The important pattern is the relationship between intent, decomposed work, responsibility, context, constraints, outcomes and evidence.

**INFERENCE:** AWCP should also not make the strongest specification discipline mandatory for every task. The SDD report recommends the minimum rigor that removes material ambiguity and warns that over-specification, specification rot, generated-artifact overload, bureaucracy and false confidence can erase the value of the method.

## 2.4 Critical assessment of the reviewed evidence

These sources support the direction of AWCP, but they do not prove the complete product hypothesis.

### From Prompt to Process

**FACT:** The paper contributes a useful six-dimension taxonomy and an explicit 0-2 scoring rubric. Its comparison gives the strongest total score to BMAD (`10/12`), followed by Spec Kitty (`9/12`), while finding a recurring tension between process depth and portability. Roles and validation are the most discriminating dimensions; specification is already common across the compared frameworks.

**FACT:** Its method is a directed, qualitative and non-exhaustive search, not a systematic review. The framework assessments are based mainly on official documentation, most frameworks lack independent academic evaluation, one author assigned the scores without a second coder, and the paper declares a conflict of interest around Reversa.

**INFERENCE:** The taxonomy is suitable as a structured comparison lens and falsification checklist. Its scores are not product benchmarks and should not be used as proof that AWCP is novel or superior.

Direct AWCP implications:

- adopt `specification / context / roles / execution / validation / portability` as an external evaluation lens;
- focus especially on roles, validation and portability, where the comparison finds the largest gaps;
- treat specification-code drift, extension supply-chain risk, platform dependence and lack of complete-process benchmarks as first-class risks;
- measure whether role decomposition improves outcomes or merely adds coordination overhead.

### OpenAI harness-engineering account

**FACT:** OpenAI reports that early limitations came from an underspecified environment and missing tools, abstractions and structure. Its operating loop decomposes work into design, code, review and test, requests additional agent reviews, exposes application behavior and observability to Codex, and mechanically enforces architectural invariants.

**FACT:** The team reports that one monolithic `AGENTS.md` failed because it consumed context, became stale and was hard to verify. Their replacement uses a short `AGENTS.md` as a map into structured repository knowledge, plans and mechanically checked documentation.

**FACT:** This is a first-party engineering account of one greenfield repository, not a controlled comparison. OpenAI explicitly says the resulting autonomy depends on that repository's specific structure and tooling and should not be assumed to generalize. Long-term architectural coherence remains unknown.

**INFERENCE:** This strongly supports AWCP-DEC-005: narrative instructions should direct agents toward authoritative state and deterministic checks, not attempt to contain the entire method. It also supports keeping project knowledge and work control structured, inspectable and mechanically verifiable.

### Spec-Driven Development: From Code to Contract

**FACT:** This eight-page technical report is primarily a practitioner guide and conceptual synthesis. It describes a four-phase workflow, three specification-authority levels and a decision framework for selecting rigor by context.

**FACT:** It says SDD may be excessive for throwaway prototypes, short-lived solo work, exploration and obvious CRUD requirements. It also warns that passing checks only proves conformance to the specification; a wrong specification can still produce wrong software.

**INFERENCE:** The report supports linked work artifacts and adaptive rigor, but it does not itself empirically validate contextual hooks, role separation or AWCP's completion model. Those claims need separate evidence.

Direct AWCP implications:

- derive the required work contract from ambiguity, longevity, risk and coordination needs;
- allow a lightweight `Intent + Task` path for small work instead of forcing a full work package;
- distinguish evidence that code matches a contract from evidence that the contract matches human intent;
- make specification change and re-approval explicit when validation reveals that the accepted intent was wrong.

### Agentic Harness Engineering

**FACT:** AHE represents harness components, rollout experience and edit decisions as observable artifacts. Every harness edit carries a predicted effect that the next evaluation round checks, allowing ineffective changes to be reverted.

**FACT:** On one ten-iteration campaign using 89 Terminal-Bench 2 tasks, AHE increased pass@1 from `69.7%` to `77.0%`; the reported Codex harness scored `71.9%`. On SWE-bench Verified, the frozen AHE harness reached the highest aggregate success in its comparison with fewer tokens than its seed. Component ablations found positive gains from memory, tools and middleware, while the system-prompt-only variant regressed from `69.7%` to `67.4%`.

**FACT:** The result has important limits: the system was optimized on one operating point; broader repositories and human-in-the-loop workflows were not tested; component effects were non-additive; regression prediction remained weak; and the authors describe AHE as a controlled research prototype without a complete guardrail stack.

**INFERENCE:** AHE supports the proposition that executable structure can outperform additional prompt prose. It does not validate AWCP's role taxonomy, role independence, work-state model or use of Codex native hooks. Its direct design lesson for AWCP is narrower: control changes and methodology changes should be observable, versioned, falsifiable and evaluated against outcomes.

Candidate later requirements derived from AHE:

- version methodology and role-policy changes;
- record the evidence and expected effect behind each policy change;
- compare predicted and observed effects on task outcomes;
- preserve rollback and auditability;
- track regressions explicitly rather than optimizing only aggregate success.

## 2.5 Consolidated evidence position

Taken together, the four sources support this chain:

```text
clear intent and proportional specification
  -> persistent, linked work artifacts
  -> role and responsibility structure where justified
  -> executable environment and technical boundaries
  -> observable execution and evidence
  -> validation against both contract and human intent
  -> versioned learning and correction
```

They do **not** establish:

- a universal replacement for Scrum or Kanban;
- one mandatory artifact sequence for every task;
- that more roles always improve quality;
- that a written specification is necessarily correct;
- that prompt instructions alone can guarantee the process;
- that AWCP must implement its own harness, context system, memory or agent runtime;
- that the AWCP product hypothesis is already empirically validated.

---

# 3. Core correction: work requires organizational structure, not only capabilities

The earlier AWCP hypothesis over-corrected away from role-centric multi-agent systems by treating capabilities as the main execution abstraction.

That loses an important property of software methodology: **different responsibilities may need to be represented and satisfied separately**.

## 3.1 Role-driven work

**DECISION:** Work type, risk, complexity and needs may derive a required composition of agent roles.

Illustratively:

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

A security-sensitive implementation may add a Security Reviewer. A trivial change may require only a Developer.

The research question is therefore not whether named roles should exist at all. It is:

> **Which role distinctions encode real independent responsibility, and which are merely persona theatre?**

## 3.2 Role is not model policy

The corrected distinction is:

```text
Work Type
≠ Agent Role
≠ Capability
≠ Executor Instance
≠ Model
```

A `Code Reviewer` is a semantic responsibility. It may require capabilities such as inspection, reasoning and verification, but it should not automatically mean a fixed model, prompt or permanent agent process.

Likewise, a `Tester` role is not equivalent to "run tests" if the methodology requires independent validation of requirements and behavior.

## 3.3 Independence matters

**HYPOTHESIS:** Some work classes require separation of responsibility.

For example:

```text
Developer implements
        ↓
Tester validates independently
        ↓
Code Reviewer challenges implementation independently
        ↓
completion becomes eligible
```

This can create stronger evidence than one executor implementing and self-approving everything.

The key research challenge is whether this structure can be materialized through existing coding clients without AWCP becoming a custom multi-agent runtime.

---

# 4. Closest direct comparables

## 4.1 OpenAI Symphony: work-to-agent execution orchestration

OpenAI Symphony is now the closest Codex-specific comparator for the execution side of the problem.

**FACT:** Symphony turns an issue tracker into the control plane for a long-running Codex orchestrator. It polls eligible issues, creates a dedicated workspace per issue, launches Codex through App Server, tracks attempts, retries failures and exposes operational status. Its repository-owned `WORKFLOW.md` supplies the execution policy and prompt.

Sources:

- [OpenAI - An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/)
- [OpenAI Symphony specification](https://github.com/openai/symphony/blob/main/SPEC.md)

The important architectural boundary in the specification is:

```text
issue tracker
    -> scheduler / runner
    -> per-issue workspace
    -> Codex App Server session
    -> retry / reconciliation / status
```

Symphony therefore provides strong falsification evidence against AWCP owning generic:

- tracker polling and task dispatch;
- agent-per-task process lifecycle;
- workspace isolation;
- retries, restart recovery and concurrency scheduling;
- the App Server execution loop.

These are real and useful capabilities, but they are **execution orchestration**, not the irreducible AWCP work-control hypothesis.

The product boundaries remain materially different:

```text
Symphony -> reads tracker work and owns managed Codex execution
AWCP      -> owns semantic work, required roles, evidence and completion
             while Codex retains its native interactive execution loop
```

Symphony uses issue state as the workflow state machine and generally assigns one running agent to each eligible issue. It does not establish a portable semantic contract for work-derived Developer/Tester/Reviewer responsibilities, independence between those responsibilities or evidence requirements attached to each role.

Its reported increase in landed pull requests is first-party operational evidence, not a controlled quality or correctness comparison. OpenAI also states that ambiguous or judgment-heavy work may still fit interactive Codex better, and that rigid agent state-machine nodes proved too limiting.

**INFERENCE:** Symphony validates work, rather than the conversation tab, as the durable coordination unit. It also validates App Server as a practical managed-run integration. It does not validate AWCP's role model, and it gives AWCP a reason to integrate with or remain compatible with external execution orchestrators rather than reproducing one.

## 4.2 Okto Pulse / Nexus: work and worker coordination

The work-versus-workers distinction makes OktoLabs especially relevant.

### Pulse organizes work; Nexus organizes workers

**FACT:** OktoLabs explicitly separates two layers:

- **Pulse** organizes work through specifications, tasks, acceptance criteria, validation and project knowledge.
- **Nexus** organizes workers through ownership, handoffs, approvals, shared context and durable coordination history.

Sources:

- [Okto Pulse](https://pulse.oktolabs.ai/)
- [Okto Nexus](https://nexus.oktolabs.ai/)

Their published separation can be summarized as:

```text
Pulse → work
Nexus → workers
```

This is useful evidence that **work structure** and **worker/agent coordination** are separable concerns.

### What this means for AWCP

Pulse already demonstrates much of the proposition that agent-assisted software work benefits from:

- local-first state;
- specifications and tasks;
- acceptance criteria;
- validation gates;
- traceability;
- persistent project knowledge;
- MCP access;
- a human-visible board.

Therefore AWCP cannot justify itself by persistent tasks, specs, evidence or UI alone.

The newer AWCP hypothesis adds questions such as:

- can work classes derive required agent-role composition?
- can role independence be expressed and verified?
- can the same work/role semantics map to Claude Code, Codex, OpenCode and Gemini CLI?
- can context and permissions be scoped per role using existing systems?
- can these guarantees exist without adopting a complete custom-agent runtime or mandatory worker-coordination platform?

**HYPOTHESIS:** Pulse/Nexus together may already solve a large part of the desired experience. They remain falsification candidates, not merely inspiration.

---

# 5. Work substrates

These systems matter because AWCP may need durable work, dependency, readiness and history semantics. The first question is whether AWCP should own any such substrate.

## 5.1 Beads / `bd`

Primary source: [gastownhall/beads](https://github.com/gastownhall/beads).

**FACT:** Beads provides structured persistent work/issue state for coding agents, including dependency relationships and ready-work queries.

Reusable patterns include:

- dependency-aware work graphs;
- ready/blocked calculation;
- durable machine-queryable work state;
- concurrency and claiming patterns;
- coding-agent bootstrap/integration patterns.

**INFERENCE:** Beads may already solve a substantial portion of AWCP's `Work` responsibility.

Remaining AWCP-specific questions include role requirements, role evidence, client-specific role realization and governance guarantees.

## 5.2 Backlog.md

Primary source: [MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md).

**FACT:** Backlog.md stores human-readable project-local work in Markdown and supports tasks, acceptance criteria, Definition of Done, milestones, dependencies, plans, comments and decisions, with CLI/MCP access for coding agents.

Reusable patterns include:

- machine-readable state that remains human-readable;
- acceptance criteria as explicit work contracts;
- local-first persistence;
- stable CLI/JSON interaction;
- multi-client discovery/integration.

**INFERENCE:** Backlog.md is a strong falsification test for the need for a custom AWCP work schema/database.

## 5.3 Task Master AI

Primary source: [eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master).

Task Master combines task/dependency management with AI-assisted decomposition, research and execution-oriented features.

Useful lessons include work decomposition, dependencies and coding-agent/task integration.

Boundary mismatch: model-provider configuration and execution loops move closer to runtime ownership than AWCP currently intends.

---

# 6. Spec and development-process systems

These projects increasingly provide structured work, methodology and governance around existing coding agents.

## 6.1 GitHub Spec Kit

Primary sources:

- [Spec Kit documentation](https://github.github.io/spec-kit/)
- [github/spec-kit](https://github.com/github/spec-kit)

**FACT:** Current Spec Kit documentation describes the project as an **extensible, intent-driven harness** that can guide coding agents across an SDLC or other process.

Its default flow is:

```text
Spec → Plan → Tasks → Implement
```

Potentially reusable:

- intent-centered artifact flow;
- templates/checklists and cross-artifact analysis;
- coding-client integration patterns;
- extensions/presets/workflows;
- portable process installation.

Remaining AWCP questions include:

- persistent ready/blocked work independent of a spec phase model;
- explicit role composition and independence semantics;
- role-specific context and permissions;
- cross-client guarantee semantics;
- evidence/completion across arbitrary work classes.

**HYPOTHESIS:** `Spec Kit + work substrate + client-native role/policy mechanisms` may be sufficient. AWCP must try to prove itself unnecessary before implementing equivalents.

## 6.2 Spec Kitty

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
- more opinionated lifecycle than AWCP has yet justified.

## 6.3 GSD / Get Shit Done

Primary sources:

- [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)
- [GSD architecture](https://github.com/gsd-build/get-shit-done/blob/main/docs/ARCHITECTURE.md)

GSD provides structured project state, research/planning/execution/verification phases and multiple coding-runtime support.

Useful patterns:

- file-based continuity;
- phase-specific context selection;
- verification as first-class work;
- multi-runtime integration.

Boundary mismatch: GSD owns a stronger process and specialized-agent orchestration architecture than AWCP currently intends.

## 6.4 BMAD Method

Primary source: [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD).

BMAD becomes **more relevant** after restoring roles as first-class responsibilities.

Useful research questions now include:

- which specialized roles encode genuinely distinct responsibility?
- which role compositions improve outcomes for particular work classes?
- how does complexity/risk adaptation alter the role structure?

However, AWCP should still avoid importing a large fixed persona catalog or mandatory workflow merely because BMAD provides one.

**INFERENCE:** BMAD is valuable as a role/methodology pattern library, not necessarily as AWCP's substrate.

## 6.5 Agent OS

Primary source: [buildermethods/agent-os](https://github.com/buildermethods/agent-os).

Useful patterns include standards discovery, specification improvement and contextual policy injection alongside existing coding tools.

It appears less focused on persistent dependency/readiness state, generalized role composition and heterogeneous enforcement guarantees.

---

# 7. Agent orchestration and supervision systems

These systems are no longer merely an anti-pattern category. AWCP needs **some orchestration semantics**, because required roles must be materialized and coordinated.

The boundary should instead be stated precisely.

AWCP may need to determine:

```text
this work requires Developer + Tester + Reviewer
Tester must run after implementation
Reviewer must be independent
these roles require these contexts/permissions
these outputs/evidence are expected
```

AWCP does **not necessarily** need to own:

```text
agent process lifecycle
model loops
agent-to-agent messaging
remote scheduling
worker fleet management
persistent worker daemons
```

Projects such as Maestro, Agent Deck, Gas Town, Ralph-style systems and Okto Nexus remain relevant because they contain reusable patterns for:

- session/worker materialization;
- ownership and handoffs;
- isolated execution;
- retries;
- parallelism;
- observability;
- multi-agent coordination.

OpenAI Symphony is a particularly direct Codex example: it owns tracker polling, dispatch, isolated workspaces, App Server sessions, retries and reconciliation. Those mechanisms should be treated as an external execution-orchestration option, not silently absorbed into AWCP's work-control core.

**HYPOTHESIS:** AWCP may be able to delegate actual worker orchestration to coding-client-native features or an external orchestrator while remaining authoritative for **which role structure the work requires**.

---

# 8. Existing coding agents are the target execution environment

Target clients include:

- Claude Code;
- Codex;
- OpenCode;
- Gemini CLI;
- potentially future equivalent coding agents.

This point is central: AWCP is designed around the user's **existing daily coding-agent workflow**, not around asking the user to migrate to a custom agent application.

The key research questions are:

1. How can AWCP participate automatically when enabled?
2. How can required roles be materialized through supported client-native mechanisms?
3. How can role-specific context be injected or selected?
4. How can role-specific permissions/policies be applied?
5. How can outputs/evidence be collected reliably?
6. How can independence between roles be achieved or at least represented honestly?

Potential surfaces include:

```text
hooks
permissions / policy engines
skills
plugins
instructions
native agents / subagents
MCP
CLI commands
structured output
events / telemetry
wrappers
```

A future adapter may need to report guarantees conceptually similar to:

```text
ENFORCEABLE
OBSERVABLE
INJECTABLE
GUIDANCE_ONLY
UNSUPPORTED
```

This vocabulary remains **OPEN**.

### Mandatory participation problem

These mechanisms are not equivalent:

```text
MCP tool available to the model
instruction telling the model to consult AWCP
client lifecycle hook
blocking policy / permission
native subagent mechanism
external wrapper
```

SPIKE-001 must measure actual behavior instead of inferring guarantees from feature names.

---

# 9. Context, memory, permissions and observability: required capabilities, not necessarily AWCP products

AWCP cannot work well without context and control infrastructure. But that does not mean those functions belong inside AWCP.

## 9.1 Context and memory

A Developer, Tester and Reviewer may need different context packages. AWCP may therefore need to express context requirements.

The preferred research direction is:

```text
AWCP decides what context a role needs
        ↓
existing client/local context system provides it
```

rather than:

```text
AWCP needs context
        ↓
AWCP builds another retrieval/memory platform
```

## 9.2 Permissions and sandboxing

Roles may need different authority. A reviewer may ideally be read-only while a developer can edit and execute tests.

Again, the first question is which existing client-native, OS-level or external control systems can enforce this.

## 9.3 Observability

AWCP needs enough execution evidence and status to control work transitions. Existing telemetry/tracing systems may already provide much of it.

A custom AWCP observability stack should only exist if the missing information is specifically work/role semantic state that existing systems cannot represent.

## 9.4 Agent Control Planes as reusable infrastructure

A local or enterprise Agent Control Plane could potentially provide identity, permission, policy or observability functions that AWCP consumes.

The categories are therefore not competitors by definition:

```text
AWCP
→ determines what the work / role requires

Agent Control Plane / context system / coding client
→ may provide the mechanism that satisfies the requirement
```

---

# 10. The likely ecosystem gap: infrastructure is often designed for custom agents

General agent frameworks and control infrastructure often expose excellent primitives for context, memory, permissions, state, checkpointing, observability and orchestration.

Frameworks such as:

- LangGraph;
- AutoGen / successor Microsoft agent frameworks;
- CrewAI;
- OpenAI Agents SDK;
- similar orchestration/runtime libraries;

are particularly natural when **building an agent application** whose runtime the developer owns.

AWCP is asking a different integration question:

> **Can those same classes of capability be reused around already-built coding agents without forcing the developer to replace Claude Code, Codex, OpenCode or Gemini CLI with a custom agent runtime?**

**HYPOTHESIS:** This integration problem may be a more meaningful gap than any individual context, memory, permission or orchestration feature.

If suitable local systems already exist, the AWCP product may remain a small local work-control service plus adapters and a TUI rather than a large platform.

---

# 11. Revised category map

The research now suggests several distinct but composable layers:

```text
┌───────────────────────────────────────────────┐
│ SOFTWARE WORK / METHODOLOGY                  │
│ intent · packages · tasks · role requirements│
│ constraints · evidence · completion          │
│                                               │
│ ← AWCP's primary semantic responsibility     │
└───────────────────────────────────────────────┘
                       │
               requirements / roles
                       ▼
┌───────────────────────────────────────────────┐
│ CODING-AGENT EXECUTION                       │
│ Claude Code · Codex · OpenCode · Gemini CLI  │
│ native agent loop · tools · edits            │
└───────────────────────────────────────────────┘
                       │
             may consume capabilities from
                       ▼
┌───────────────────────────────────────────────┐
│ AGENT INFRASTRUCTURE                         │
│ context · memory · permissions · sandbox     │
│ observability · policy · verification        │
└───────────────────────────────────────────────┘
                       │
          optional worker coordination through
                       ▼
┌───────────────────────────────────────────────┐
│ AGENT / WORKER ORCHESTRATION                 │
│ sessions · handoffs · isolated workers       │
│ scheduling · retries                         │
└───────────────────────────────────────────────┘
                       │
          optional fleet-level governance by
                       ▼
┌───────────────────────────────────────────────┐
│ AGENT CONTROL PLANE / ENTERPRISE OPS         │
│ identity · lifecycle · fleet · security      │
│ deployment · runtime health · cost           │
└───────────────────────────────────────────────┘
```

Products may combine layers. The analytical distinction helps AWCP decide what to **own**, what to **integrate**, and what to leave entirely outside scope.

The accepted product boundary now places a local AWCP service, its work-control database and its TUI in the first layer. Coding clients interact with that service but retain ownership of the execution layer and native agent loop.

---

# 12. What appears already solved or commoditized

These no longer look like strong standalone reasons to build AWCP:

- structured specifications;
- durable tasks and dependencies;
- ready/blocked calculation;
- human-readable local project state;
- generic MCP/CLI access;
- context retrieval as a general capability;
- generic agent memory products;
- permission/sandbox primitives;
- generic observability/tracing;
- tests, linters, scanners and CI verification;
- dashboards/TUIs;
- generic agent fleet governance;
- generic custom-agent SDKs and orchestration frameworks.
- task-to-agent dispatch, isolated workspaces, retries and App Server run loops for managed Codex execution.

AWCP should consume or compose these where possible.

---

# 13. What appears partially solved

## 13.1 Cross-client work continuity

Many systems support multiple coding agents, but portability often means installing equivalent instructions rather than proving one shared semantic work state across clients.

## 13.2 Role-driven methodology across heterogeneous coding agents

Many methodologies use specialized agents, while many coding clients expose some native form of agents/subagents. What is less clear is whether a **client-independent role requirement** can be expressed once and reliably materialized across heterogeneous clients.

## 13.3 Separation of responsibility

Review/testing stages are common, but the ability to state and enforce that the implementing executor cannot satisfy an independent review role may vary significantly by client/runtime.

## 13.4 Context and permission composition

The individual capabilities exist, but it remains uncertain whether AWCP can consistently request a role-specific context/permission profile from existing daily coding agents and external local systems.

## 13.5 Evidence-driven completion

Several systems have tests, validation and review concepts. A portable model connecting **role responsibility → evidence → completion** remains less standardized.

## 13.6 Adaptive organization

Risk/complexity-adaptive workflows exist. AWCP's specific hypothesis is:

```text
work characteristics
    ↓
required role composition
    ↓
role capabilities / context / permissions
    ↓
client-specific realization
```

This remains unvalidated.

## 13.7 Session attribution and operator inspection

Symphony demonstrates rich observation for Codex runs that the orchestrator itself launches. The partially solved case for AWCP is different: attributing work, role and evidence across ordinary interactive Codex sessions without taking ownership of those sessions.

---

# 14. What remains genuinely uncertain

## 14.1 Is there a reusable work-control abstraction independent of methodology implementation?

Can AWCP describe work and required responsibilities without becoming either a lowest-common-denominator task schema or another huge workflow DSL?

## 14.2 Which roles are real responsibilities rather than persona theatre?

The project needs evidence for a minimal role set and composition rules grounded in actual software work.

## 14.3 Can role composition be portable without runtime ownership?

This is one of the central risks. If independent Developer/Tester/Reviewer roles cannot be reliably materialized through existing coding clients, AWCP may need to weaken guarantees or revisit its boundary.

## 14.4 Can infrastructure be composed rather than rebuilt?

AWCP should attempt to use existing context, memory, permissions, sandboxing and observability systems. The unresolved issue is whether their integration surfaces fit existing coding agents rather than only custom runtimes.

## 14.5 What exact work state must AWCP own?

AWCP will own authoritative work-control state. The remaining question is its minimum schema and which specifications, repository artifacts, Git/PR/CI evidence, telemetry and context records should remain external references.

## 14.6 What does "done" mean across work types?

Implementation, research, debugging, migration, documentation and architecture work may require different roles and evidence.

---

# 15. Potential genuine gap

The strongest current hypothesis is:

> **Provide a small, local and agent-agnostic work-control product that persistently turns software work into explicit role-driven execution contracts, exposes that state through a TUI, and composes existing coding-agent capabilities to carry them out without replacing the developer's normal coding client.**

Potential differentiation, if validated, comes from the combination of:

1. **work-first semantics** rather than fleet-first semantics;
2. **role-driven methodology** — work derives the responsibilities that must participate;
3. **role portability** — responsibility is independent of client/model implementation;
4. **adaptive composition** rather than one mandatory global pipeline;
5. **separation-of-responsibility semantics** where required;
6. **role-specific context and permission requirements**;
7. **evidence attached to responsibilities and completion**;
8. **integration with existing coding agents**, not a required custom agent runtime;
9. **reuse of existing context/control/observability infrastructure** rather than rebuilding it;
10. **authoritative, human-readable local work state** shared by agent integrations and the TUI;
11. **traceability across agents and sessions** where the coding client exposes trustworthy identity and lifecycle signals.

The separate local product is now an accepted boundary. Research must still minimize its owned schema and infrastructure rather than treating every adjacent capability as part of AWCP.

---

# 16. Falsification criteria

AWCP should shrink to the smallest useful local product when existing tools can provide parts of the desired experience through composition.

Examples:

```text
AWCP core/TUI + Spec Kit + Beads + client-native roles/hooks/policies

AWCP core/TUI + Backlog.md + coding-client agents + CI evidence

AWCP core/TUI + reusable Okto Pulse/Nexus capabilities

AWCP core/TUI + coding-client-native agents + project memory + Git/CI

AWCP core/TUI + Symphony or another external runner for optional managed execution
```

The right research question is now:

> **What is the smallest authoritative local work-control core, TUI and integration set that gives us persistent, role-driven, governed and verifiable software work across the coding agents we already use?**

Only that irreducible work-control core should become owned AWCP architecture; adjacent context, permission, runtime and observability systems should still be composed where possible.

---

# 17. Research conclusion

## Already solved / commoditized

- structured specs and plans;
- durable tasks/dependencies;
- ready/blocked work;
- local/human-readable project state;
- generic context and memory systems;
- permission/sandbox primitives;
- observability/tracing systems;
- deterministic verification tooling;
- custom-agent frameworks;
- generic worker orchestration patterns;
- managed Codex dispatch, workspace isolation, retries and run observation;
- agent fleet governance.

## Partially solved

- cross-client continuity;
- role-driven methodology around existing coding agents;
- independent role realization;
- portable context/permission requirements;
- work governance across heterogeneous clients;
- evidence linked to specific responsibilities;
- adaptive role composition by work type/risk.

## Still uncertain

- minimal AWCP work/role model;
- minimum useful role taxonomy;
- role-composition rules;
- cross-client role materialization;
- role independence guarantees;
- integration with existing local context/control systems;
- mandatory AWCP participation while preserving native coding clients;
- exact work-control schema and external-reference boundary;
- storage, process-lifecycle, persistence and concurrency requirements;
- reliable coding-client, agent and session attribution.

## Potential genuine gap

A **thin local work-methodology control product** may be underserved: one that persistently tells existing coding agents not only *what work exists*, but **which distinct agent responsibilities must participate, under what context/permissions, and what evidence each must produce**; records execution and session provenance; and exposes the same state through a fast TUI while delegating context, permission, runtime and observability machinery to systems that already solve those problems.

The next phase should optimize for **composition and falsification**, not feature accumulation.
