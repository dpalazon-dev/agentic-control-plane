# SPIKE-001 - Codex Native Methodology Surfaces

## Status

**Started.**

This spike is limited to **Codex**. It validates the methodology and Codex-side integration contract before implementing the accepted local AWCP service, database or TUI. It does not design an execution proxy, a custom runtime, an adapter daemon, a scheduler or an AWCP-owned agent loop.

The question is:

> Can Codex's native surfaces support a strict, auditable operating methodology for `Intent -> Work Package / Task -> Required Roles -> Role Execution -> Evidence -> Completion`?

## Scope

### In scope

- Codex instructions and `AGENTS.md`;
- Codex skills;
- Codex subagents;
- Codex permissions, sandboxing and approvals;
- Codex rules;
- Codex hooks;
- MCP configuration;
- Codex configuration profiles;
- Codex-visible evidence and completion discipline;
- native signals available for work, agent and session attribution;
- candidate mechanisms for reading work from and writing evidence to a future local AWCP service.

### Out of scope

- local AWCP service implementation;
- database or persistence implementation;
- custom execution middleware or proxy;
- custom agent orchestration runtime;
- custom scheduler;
- custom event bus;
- custom permission layer;
- custom context or memory system;
- custom observability platform;
- product UI or TUI.

## Native surfaces reviewed

| Surface | Native Codex support | AWCP use | Guarantee level |
| --- | --- | --- | --- |
| `AGENTS.md` | Codex loads layered project guidance before work. | Encode project-wide methodology, required artifacts, role rules, evidence rules and done criteria. | `INJECTABLE` / `GUIDANCE_ONLY` |
| Skills | Skills package instructions, resources and optional scripts; Codex can invoke them explicitly or by matching descriptions. | Encode reusable role playbooks such as Developer, Tester, Reviewer, Architect or Work Intake. Prefer instruction-only skills unless deterministic scripts are already justified. | `INJECTABLE` / `GUIDANCE_ONLY` |
| Subagents | Codex can delegate independent parts of work to subagents in app, CLI and IDE contexts. | Materialize role separation when a task requires distinct Developer, Tester, Reviewer, Architect or Senior Engineer responsibilities. | `OBSERVABLE` / `GUIDANCE_ONLY`; possibly stronger when the UI exposes distinct subagent threads |
| Sandbox and approvals | Codex combines sandbox mode with approval policy; defaults include no network access and workspace-limited writes in local clients. | Select conservative execution boundaries per role: Developer may write; Reviewer should normally inspect; high-risk operations require approval. | `ENFORCEABLE` at sandbox boundary; `GUIDANCE_ONLY` for semantic role intent |
| Rules | Rules control which commands Codex can run outside the sandbox; currently experimental. | Define deterministic command policy for unsafe or privileged commands where available. | `ENFORCEABLE` for supported command boundaries; experimental |
| Hooks | Hooks run deterministic scripts during the Codex lifecycle. | Candidate for lightweight pre-flight or post-action checks if future evidence shows need; do not use to create AWCP middleware. | `OBSERVABLE` / potentially `ENFORCEABLE` for local deterministic checks |
| MCP | Codex can connect to local or remote MCP servers and configure tool allow/deny lists and approval behavior. | Consume existing tools and potentially expose the local AWCP service to Codex. MCP may be an adapter surface; it is not the authoritative work-control state itself. | `INJECTABLE`; tool policy can be partly `ENFORCEABLE` |
| Config profiles | Codex config exposes settings such as sandbox, approval policy and MCP server/tool policy. | Define recommended local profiles for role-safe operation, without owning a runtime. | `ENFORCEABLE` where Codex config controls the host behavior |
| Record & Replay | Codex can turn demonstrated workflows into reusable skills where the feature is available; current docs describe a desktop recording flow. | Possible way to capture a team methodology as a skill after the manual process stabilizes. | `INJECTABLE` / `GUIDANCE_ONLY` |

## Key finding

Codex has enough native surfaces to express and partially enforce a strict operating methodology, but the guarantee must be stated honestly.

AWCP-style methodology can be:

- **injected** through `AGENTS.md`, skills, prompts and MCP instructions;
- **materialized** through subagents or separate Codex sessions;
- **constrained** at the technical boundary through sandboxing, approvals, rules and MCP tool policies;
- **observed** through Codex task/subagent threads, diffs, command output, test output and final summaries;
- **audited** through repository artifacts, commits, PRs and recorded evidence.

It cannot be truthfully described as fully deterministic role orchestration unless a native Codex surface actually enforces that property. A prompt saying "Reviewer must be independent" is a rule of methodology; a separate subagent/session plus review-only permissions is stronger evidence, but still not the same as a custom scheduler.

## Required future AWCP integration contract

The accepted product boundary adds a persistent local service and TUI outside Codex. SPIKE-001 must therefore determine how much of the following contract Codex can satisfy natively:

1. identify or select the active AWCP task;
2. read its intent, constraints, required role and completion contract;
3. associate execution with the observable Codex client, agent/subagent and session identifiers;
4. record start, progress, decisions, handoffs and completion timestamps;
5. submit role-specific evidence and unresolved findings;
6. request or record a work-state transition without allowing an unsupported completion claim;
7. leave enough provenance for the TUI to answer who did what, when, in which session and why.

The exact API or protocol is not selected. MCP, hooks, skills, instructions, local commands and Codex-produced artifacts must be compared by their actual guarantee level. Missing or unstable session identity must be recorded as unsupported or degraded rather than inferred.

## Proposed Codex operating method

### 1. Intent intake

Every non-trivial Codex task starts by producing or confirming an explicit intent.

Required fields:

- outcome;
- non-goals;
- affected repository area;
- known constraints;
- risk level: `low`, `medium`, `high`;
- uncertainty level: `low`, `medium`, `high`.

Audit evidence:

- the user prompt, issue, PR, spec or short Markdown note that contains the intent;
- unresolved questions or accepted assumptions.

### 2. Work classification

Before editing, Codex classifies the work.

Initial classes:

- `trivial-edit`;
- `implementation`;
- `bugfix`;
- `refactor`;
- `test-only`;
- `documentation`;
- `research`;
- `architecture`;
- `security-sensitive`.

Audit evidence:

- class selected;
- risk and uncertainty;
- reason for the selected class.

### 3. Required role composition

The work class derives mandatory roles.

Initial policy:

| Work class | Required roles |
| --- | --- |
| `trivial-edit` | Developer |
| `documentation` | Developer or Writer; Reviewer when public or normative |
| `research` | Researcher + Critic |
| `architecture` | Architect + Senior Engineer |
| `implementation` | Developer + Tester + Code Reviewer |
| `bugfix` | Developer + Tester + Code Reviewer |
| `refactor` | Developer + Tester + Code Reviewer |
| `test-only` | Tester + Code Reviewer |
| `security-sensitive` | Developer + Tester + Security Reviewer + Code Reviewer |

Rules:

- A role is a responsibility slot, not a model or fixed prompt.
- A role may be satisfied by the main Codex thread, a Codex subagent, a separate Codex session, a human or a deterministic tool only when its responsibility contract is met.
- Required roles cannot be silently skipped. If Codex cannot materialize a role, it must record a degradation and ask for approval before completion.

### 4. Role contracts

#### Developer

Responsibilities:

- inspect the relevant code;
- make the smallest change that satisfies the work contract;
- avoid unrelated refactors;
- preserve user changes;
- produce implementation evidence.

Evidence:

- changed files;
- rationale for the change;
- build/lint/test command results when applicable.

#### Tester

Responsibilities:

- validate behavior against intent and acceptance criteria;
- prefer deterministic tests or reproducible checks;
- identify untested risk.

Evidence:

- tests added or selected;
- commands run;
- pass/fail result;
- remaining test gaps.

#### Code Reviewer

Responsibilities:

- review the diff independently from the implementation path when required;
- look for correctness, regressions, missing tests, unsafe scope and maintainability risks;
- state approval, findings or required repair.

Evidence:

- reviewed files/diff scope;
- findings or "no findings";
- residual risks.

#### Architect

Responsibilities:

- structure the approach;
- identify boundaries, tradeoffs and dependencies;
- prevent premature implementation.

Evidence:

- decision summary;
- rejected alternatives;
- open questions.

#### Senior Engineer

Responsibilities:

- challenge feasibility and operational impact;
- verify that the plan fits the existing system and maintenance constraints.

Evidence:

- feasibility review;
- risks and mitigations.

#### Researcher

Responsibilities:

- gather source-backed evidence;
- separate facts, inferences and hypotheses.

Evidence:

- sources used;
- factual claims;
- uncertainty.

#### Critic

Responsibilities:

- challenge the research conclusion;
- identify overclaims, missing sources and falsification paths.

Evidence:

- critique;
- unresolved uncertainties.

#### Security Reviewer

Responsibilities:

- inspect security-sensitive changes for threat, permission, secret, auth, data or sandbox impact.

Evidence:

- reviewed threat surface;
- findings or approval;
- required mitigations.

### 5. Role execution using Codex

Preferred order:

1. Main Codex thread performs intake, classification and role plan.
2. Main thread executes the Developer role only if implementation is required.
3. Tester role is delegated to a Codex subagent or separate session when meaningful independence is required.
4. Code Reviewer role is delegated to a distinct Codex subagent or separate session for implementation, bugfix and refactor work.
5. Main thread consolidates evidence and either completes, repairs or escalates.

Independence rule:

- For `implementation`, `bugfix`, `refactor` and `security-sensitive`, the executor that performed the main implementation should not be the only executor satisfying final review.
- If the host cannot provide a distinct subagent/session, the final response must mark review independence as degraded.

### 6. Context and permissions

Role-specific defaults:

| Role | Context | Permissions |
| --- | --- | --- |
| Developer | intent, relevant code, constraints, existing tests | workspace write; command execution within sandbox |
| Tester | intent, acceptance criteria, test/build docs, changed files | command execution; write only when adding tests is part of scope |
| Code Reviewer | intent, diff, relevant architecture/policy | read/inspect by default; edits only after explicit repair delegation |
| Architect | intent, repo structure, constraints, prior decisions | read/inspect |
| Security Reviewer | intent, diff, auth/data/permission context | read/inspect; command execution for scanners when approved |

Rules:

- Context must be scoped to the role's responsibility.
- Permissions must use Codex sandbox, approvals, rules and MCP tool policy where those controls exist.
- Where Codex can only guide behavior, the methodology must label the guarantee as guidance.

### 7. Evidence ledger

Every role contribution should leave evidence in the conversation, PR, commit message or work artifact.

Minimum evidence:

- `Intent`: what was requested and accepted;
- `Work`: classification, risk and role plan;
- `Developer`: changed files and implementation rationale;
- `Tester`: commands/checks and results;
- `Reviewer`: findings or approval;
- `Completion`: why the work is eligible to close.

For repository work, the final Codex response should include:

- files changed;
- verification performed;
- role evidence summary;
- known gaps or degraded guarantees.

### 8. Completion rule

Work is not complete merely because code changed or Codex says it is done.

Completion requires:

- intent satisfied or explicitly narrowed;
- required roles executed or degraded with human approval;
- required evidence exists;
- tests/checks run or skipped with reason;
- review findings resolved or accepted;
- no known blocker remains.

## Recommended project-level `AGENTS.md` rules

These are candidate rules for a future repository `AGENTS.md` or skill, not code:

```md
# Agentic Work Methodology

For non-trivial work, follow this sequence before claiming completion:

1. Restate the Intent, non-goals, constraints, risk and uncertainty.
2. Classify the work.
3. Derive required roles from the work class.
4. State how each required role will be satisfied in Codex.
5. Execute roles in order, using subagents or separate sessions where independence is required and available.
6. Record evidence for each role.
7. Do not mark work complete until required role evidence exists.

If a required role cannot be executed independently, say so explicitly as a degraded guarantee.

For implementation, bugfix and refactor work, default required roles are Developer, Tester and Code Reviewer.
```

## Proposed guarantee vocabulary for Codex

| Guarantee | Meaning |
| --- | --- |
| `ENFORCEABLE` | Codex or the OS/tool boundary can technically prevent or require behavior. |
| `OBSERVABLE` | The behavior is visible in Codex threads, tool output, diffs, logs or artifacts. |
| `INJECTABLE` | The requirement can be loaded into Codex context. |
| `GUIDANCE_ONLY` | Codex can be instructed, but the host does not technically enforce it. |
| `UNSUPPORTED` | No native Codex surface found for the requirement. |

## Current conclusion

For Codex, the first viable integration shape does not replace or proxy the native runtime. It combines the future local AWCP product with a strict operational methodology delivered through:

- `AGENTS.md` for baseline rules;
- optional instruction-only skills for reusable role playbooks;
- subagents or separate sessions for role separation;
- Codex sandbox, approvals, rules and MCP tool policy for technical boundaries;
- explicit evidence and completion rules in the task transcript and repository artifacts;
- a future client adapter that reads and writes the authoritative local AWCP work state through the strongest validated native surface.

The next validation step should be a dry run on two realistic Codex tasks:

1. implementation task: `Developer + Tester + Code Reviewer`;
2. architecture task: `Architect + Senior Engineer`.

The spike should measure which guarantees are actually enforceable, observable or merely guidance.

## Sources

- [OpenAI Docs - Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [OpenAI Docs - Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [OpenAI Docs - Agent approvals and security](https://learn.chatgpt.com/docs/agent-approvals-security)
- [OpenAI Docs - Rules](https://learn.chatgpt.com/docs/agent-configuration/rules)
- [OpenAI Docs - Hooks](https://learn.chatgpt.com/docs/hooks)
- [OpenAI Docs - Build skills](https://learn.chatgpt.com/docs/build-skills)
- [OpenAI Docs - Model Context Protocol](https://learn.chatgpt.com/docs/extend/mcp)
- [OpenAI Docs - Configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference)
- [OpenAI Docs - Record & Replay](https://learn.chatgpt.com/docs/extend/record-and-replay)
