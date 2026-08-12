# SPIKE-001 - Codex Native Methodology Surfaces

## Status

**Complete for Codex architecture selection. Official documentation and the first local empirical pass are complete.**

The empirical pass ran on **2026-08-12** with `OpenAI.Codex 26.803.10989.0` and `codex-cli 0.147.0-alpha.6.6` on Windows. It used the committed disposable fixture under [`fixtures/spike-001-codex`](fixtures/spike-001-codex/README.md), not an AWCP product implementation. The reproducible observations and native identifiers are recorded in [`SPIKE-001-CODEX-EVIDENCE.md`](SPIKE-001-CODEX-EVIDENCE.md).

This spike is limited to Codex. It validates the Codex integration contract before implementing the accepted local AWCP service, database or TUI. It does not implement an execution proxy, a custom agent runtime, a scheduler or an AWCP-owned model loop.

The question is:

> Can Codex participate in a strict, auditable flow for `Intent -> Work Package / Task -> Required Roles -> Role Execution -> Evidence -> Completion` while Codex keeps ownership of its conversation, agent loop and tools?

## Decision summary

**Yes, with a conditional and revised guarantee.** Codex exposes enough native surfaces for a viable strict integration:

- lifecycle hooks can inject context and block prompts, supported shell, patch and MCP tools, and normal root-turn stops;
- custom agents and subagents can materialize semantic roles with distinct instructions and permission defaults;
- `PreToolUse` and `PostToolUse` around `spawn_agent` expose the requested `agent_type` and returned child thread ID for role binding;
- MCP can expose the authoritative local AWCP work state to every supported local Codex client;
- sandboxing, approvals and command rules can enforce technical boundaries;
- App Server can list and read persisted Codex threads, turns and role lineage for historical TUI enrichment;
- `codex exec --json` provides structured events for AWCP-managed non-interactive runs.

The guarantee is not unconditional:

- ordinary project, user and plugin hooks must be reviewed and trusted and can be disabled;
- `PreToolUse` does not cover hosted tools such as Web Search and some specialized tool paths may opt out;
- Codex can be interrupted or closed by the human;
- instructions, skills and agent descriptions cannot by themselves force role execution;
- `SubagentStart` and `SubagentStop` are documented but did not fire in any tested CLI backend or mode;
- a second App Server process did not report trustworthy live status for a thread owned by another process;
- `SessionEnd` is advisory and is not a completion event.

Therefore AWCP must distinguish two guarantees:

1. **Work-state integrity:** the AWCP service rejects invalid transitions and never records completion without the required role evidence or an explicit authorized waiver. This can be guaranteed by AWCP itself.
2. **Codex-path enforcement:** Codex is prevented from progressing normally when the work contract is unsatisfied. This is guaranteed only while the required hooks are active and trusted, or when they are installed as managed hooks.

Disabling the Codex integration may permit ungoverned repository activity, but it must never manufacture a valid AWCP completion record.

## Scope

### In scope

- `AGENTS.md` and project instructions;
- skills and plugins;
- custom agents and subagents;
- hooks and their trust model;
- MCP configuration and tool policy;
- sandboxing, approvals, permission modes and command rules;
- App Server, Codex SDK and non-interactive mode as observation or execution surfaces;
- stable identifiers for client, session, turn, agent and execution attribution;
- a strict Codex-to-AWCP operating contract.

### Out of scope

- implementation of the local service, database, TUI, MCP server or hooks;
- database and API technology selection;
- replacing the Codex desktop app, CLI or IDE extension;
- implementing a custom model loop or multi-agent scheduler;
- multi-client portability beyond Codex.

## Guarantee vocabulary

| Guarantee | Meaning |
| --- | --- |
| `ENFORCEABLE` | The relevant runtime or authoritative service can reject the operation. |
| `ENFORCEABLE_IF_TRUSTED` | Codex can reject the operation while non-managed hooks are enabled and trusted. |
| `MANAGED_ENFORCEABLE` | Administratively managed Codex requirements can prevent the user from disabling the control. |
| `OBSERVABLE` | A supported interface exposes the event or identifier. |
| `INJECTABLE` | Codex can receive the requirement as model context. |
| `GUIDANCE_ONLY` | Codex can be instructed, but the instruction is not a technical boundary. |
| `UNSUPPORTED` | No supported native surface was found. |

## Native capability matrix

| Surface | Verified Codex behavior | AWCP use | Honest guarantee |
| --- | --- | --- | --- |
| `AGENTS.md` | Codex builds a layered instruction chain from user and project files before work; deeper files override earlier guidance. | Short map to AWCP, project policy and deeper authoritative sources. Do not embed the complete methodology or work state. | `INJECTABLE`, `GUIDANCE_ONLY` |
| Skills | Skills can be invoked explicitly or selected implicitly when their description matches. | Reusable intake and role playbooks. | `INJECTABLE`, `GUIDANCE_ONLY` |
| Custom agents | Project or user agent profiles define a name, description and developer instructions and may set model, effort, sandbox, MCP and skills. | Named `developer`, `tester`, `code-reviewer`, `architect`, `critic` and `security-reviewer` executor profiles. | `INJECTABLE`; profile settings are enforceable only where the parent runtime permits them |
| Subagents | Codex can spawn, wait for, continue and close custom-agent threads. Tool hooks expose the requested agent type and returned child ID, while App Server exposes persisted parent/role lineage. | Materialize role separation and collect role-specific evidence. | `OBSERVABLE` through spawn-tool correlation and historical App Server data; spawning remains instruction-driven |
| Sandbox and approvals | Codex constrains filesystem, network and escalation behavior according to the active permission mode. Subagents inherit the parent session's live sandbox and permission mode. | Least privilege per session and role; read-only review where the effective mode supports it. | `ENFORCEABLE` at the technical boundary |
| Command rules | Experimental `prefix_rule` entries allow, prompt or forbid matching commands outside the sandbox; the most restrictive match wins. | Block or approve sensitive shell entry points. | `ENFORCEABLE` for matching command boundaries; not a workflow engine |
| Hooks | Codex runs deterministic commands at session, prompt, tool and root-stop lifecycle points. The tested build did not emit the documented subagent lifecycle events. | Mandatory participation, context injection, execution attribution and root completion gates. | `ENFORCEABLE_IF_TRUSTED`; `MANAGED_ENFORCEABLE` with requirements, excluding unobserved subagent events |
| MCP | Desktop, CLI and IDE clients on the same host share MCP configuration. A server may be local STDIO or HTTP, required at startup, tool-filtered and approval-configured. | Read and mutate authoritative AWCP work state through validated domain operations. | Availability is `ENFORCEABLE` with `required = true`; model invocation alone is not guaranteed |
| Plugin | An installed plugin may package skills, MCP configuration and lifecycle hooks. Plugin hooks use the normal trust review unless managed. | Distribute the Codex-specific AWCP integration as one versioned unit. | Packaging only; contained surfaces retain their own guarantees |
| App Server | JSON-RPC API can list/read stored threads, turns, items and descendant lineage. A separate process misreported a concurrently active foreign thread until it completed. | Historical TUI enrichment and optional managed-run integration. Live state must arrive through hooks or a process AWCP owns. | `OBSERVABLE` for persisted history; unsupported as a passive cross-process live source in the tested build |
| `codex exec --json` | Emits JSONL events including thread, turn and item lifecycle and supports resuming a session by ID. | Deterministic ingestion for future AWCP-originated automation. | `OBSERVABLE`; only for runs launched this way |
| Codex SDK | Starts and resumes local Codex threads programmatically. | Optional future execution mode for AWCP-originated jobs. | Strong control, but using it as the default would move AWCP toward owning execution |
| Config profiles and requirements | Profiles select reusable runtime settings; `requirements.toml` can constrain security-sensitive settings and managed hooks. | Installation modes and host policy, not semantic work state. | `ENFORCEABLE` for supported settings |
| Record & Replay | Converts a demonstrated workflow into a reusable skill. | Capture a mature role playbook after the method stabilizes. | Same as skills: `INJECTABLE`, `GUIDANCE_ONLY` |
| Native goal and plan state | App Server exposes the persisted goal also shown by `/goal`; plans appear as turn items. | Optional projection of the active objective and current execution plan. | `OBSERVABLE`; insufficient for AWCP work hierarchy, role evidence or completion |

## Hooks are the decisive surface

The earlier hypothesis treated hooks as optional checks. The official Codex contract is substantially stronger.

| Hook | Intended AWCP use | Empirical result in the tested build |
| --- | --- | --- |
| `SessionStart` | Register or refresh the Codex session and inject the active work contract. | `PASS`: emitted and injected deterministic context. |
| `UserPromptSubmit` | Resolve the active task, inject task context or block an ungoverned prompt. | `PASS`: injection reached the model; blocking produced a zero-token turn lifecycle. |
| `PreToolUse` | Reject supported mutations unless the task and active role permit them. | `PASS`: denied shell, `apply_patch` and MCP calls before side effects; also observed `spawn_agent`. |
| `PostToolUse` | Record execution observations and returned child IDs. It cannot undo side effects. | `PASS`: correlated allowed shell and `spawn_agent` calls using the same tool-use ID. |
| `PermissionRequest` | Apply deterministic approval policy or defer to the normal human prompt. | `NOT TESTED`: remains a documented candidate surface. |
| `SubagentStart` | Directly bind a child executor and inject its role contract. | `UNAVAILABLE IN TESTED BUILD`: registered but never emitted in exec, interactive CLI, v1 or `multi_agent_v2`. |
| `SubagentStop` | Directly gate a child role before it stops. | `UNAVAILABLE IN TESTED BUILD`: registered but never emitted in the same modes. |
| `Stop` | Continue the root turn when completion gates are missing. | `PASS`: one continuation occurred in the same turn; `stop_hook_active` prevented a loop. |
| `SessionEnd` | Record a lifecycle observation only. | `PASS` with a three-second timeout on Windows; reason was `other`. Never infer completion from it. |

Important limitations:

- documented subagent hook payloads cannot be an AWCP dependency until each supported Codex release emits them in acceptance tests;
- `Stop` does not reject a completed turn as a transaction would; a block asks Codex to continue with a focused prompt;
- `SessionEnd` may occur on normal close or after 30 minutes with no subscribers and is always advisory;
- transcript paths are convenient but the transcript format is explicitly unstable and must not become the integration contract;
- tool hooks cover shell/unified exec, `apply_patch`, MCP tools and most local function tools, but not every possible tool path.

## Identity and provenance model

AWCP should record native identifiers, not infer them from text or filesystem paths.

| AWCP concept | Codex identifier | Notes |
| --- | --- | --- |
| Coding client | integration source + observed App Server `sourceKind` when available | The pass observed `cli`, `exec` and `subAgent` source kinds. |
| Session | hook `session_id` or App Server `thread.sessionId` | A spawned child used its own session ID in the tested build. Do not infer ancestry from session equality. |
| Thread tree | App Server `thread.id` + `parentThreadId` | `parentThreadId` is the supported persisted relationship between root and descendant. |
| Turn | hook `turn_id` or App Server turn ID | Unit of user-to-agent work. |
| Executor | root-thread marker or child ID returned by `spawn_agent` | Bind the returned child ID from `PostToolUse`; reconcile it with App Server `thread.id`. |
| Executor profile | requested `agent_type` + App Server `agentRole` | Validate the requested type before spawn, then reconcile the persisted role after completion. |
| Tool execution | hook tool-use ID / App Server item ID | Useful correlation, not itself semantic evidence. |
| Work execution | AWCP-owned execution-attempt ID | Authoritative link among task, role, Codex identities and timestamps. |

The TUI may use App Server `thread/list`, `thread/read` and experimental turn/item pagination to enrich history without parsing rollout JSONL directly. The empirical pass recovered completed CLI, exec and subagent history, including `parentThreadId`, `agentRole` and child activity. During a separate process's active shell call, however, App Server reported the root as `notLoaded` and its turn as `interrupted`; it became complete only after the owner process finished. Hooks must therefore publish live lifecycle identity into AWCP, while App Server performs later reconciliation and history enrichment.

OpenAI Symphony provides a first-party operational precedent for the other App Server use case: a long-running orchestrator can create and observe Codex sessions programmatically, maintain per-task workspaces and reconcile retries. This confirms the technical viability of **managed execution**; it does not establish passive observation of an interactive desktop task owned by another process.

## Recommended Codex integration shape

```text
Codex desktop / CLI / IDE
  |
  | native hooks: deterministic gates and lifecycle identity
  | native MCP: explicit work-state operations
  | custom agents: role materialization
  v
Local AWCP service + authoritative database
  ^
  | App Server read APIs: optional Codex history enrichment
  |
AWCP TUI
```

The recommended distribution unit is a Codex plugin containing:

- plugin-bundled lifecycle hooks;
- an intake/methodology skill;
- optional role-specific skills;
- the registration for a local AWCP MCP server, or installation instructions for host configuration.

Custom agent profiles should initially be installed through Codex's documented user or project agent directories. The reviewed plugin documentation confirms packaging for skills, MCP and hooks, but does not establish plugin packaging as a supported custom-agent distribution contract.

`AGENTS.md` remains project policy, not the source of truth. The local service remains the source of truth, not MCP, hooks, the plugin or the TUI.

Keep `AGENTS.md` small and navigational. OpenAI's harness-engineering account reports that a monolithic instruction file consumed scarce context, became stale and resisted mechanical verification; its replacement used a short file as a map into structured, checked sources of truth. AWCP task context should be injected from the authoritative service at the relevant lifecycle event rather than copied into a growing repository manual.

### Strict installation modes

#### Personal strict mode

- the user installs and enables the AWCP plugin;
- the user reviews and trusts its exact hook definitions;
- hooks remain enabled;
- the AWCP MCP server is enabled with `required = true`;
- the TUI reports integration health and refuses to present unattached work as governed.

Guarantee: `ENFORCEABLE_IF_TRUSTED`.

#### Managed strict mode

- administrators pin `[features].hooks = true` in `requirements.toml`;
- hooks are defined as managed hooks and their scripts are installed through device management;
- approved MCP server identities and restrictive command rules are also defined in requirements;
- managed hooks cannot be disabled in the normal hook browser.

Guarantee: `MANAGED_ENFORCEABLE` for the supported hook and policy boundaries.

## Strict operating protocol

### 0. Preconditions

A governed Codex run is healthy only when:

- the AWCP service is reachable;
- the required MCP server initialized;
- required hooks are active and trusted;
- the repository is associated with an AWCP project;
- Codex exposes a native session identifier.

If any precondition fails, AWCP records the integration as degraded and must not allow the affected work item to become complete.

### 1. Intent and task resolution

On `SessionStart`, the hook registers the Codex session and asks AWCP whether it already has an active execution for the current repository and session.

On `UserPromptSubmit`:

1. If a task is already bound, the hook injects its intent, constraints, active role and completion contract.
2. If no task is bound, Codex enters intake mode and may inspect or plan.
3. Before any mutation, Codex must use AWCP MCP operations to select an existing task or create/classify a new one.
4. `PreToolUse` rejects supported mutating operations while no eligible task and role binding exists.

This permits conversational intake without permitting unclassified implementation.

### 2. Work classification and role derivation

AWCP, not free-form chat text, persists:

- work class;
- risk and uncertainty;
- required roles;
- independence constraints;
- role-specific evidence requirements;
- completion gates.

The initial policy remains:

| Work class | Required roles |
| --- | --- |
| `trivial-edit` | Developer |
| `documentation` | Writer or Developer; Reviewer when normative or public |
| `research` | Researcher + Critic |
| `architecture` | Architect + Senior Engineer |
| `implementation` | Developer + Tester + Code Reviewer |
| `bugfix` | Developer + Tester + Code Reviewer |
| `refactor` | Developer + Tester + Code Reviewer |
| `test-only` | Tester + Code Reviewer |
| `security-sensitive` | Developer + Tester + Security Reviewer + Code Reviewer |

This table is a spike policy, not an accepted final taxonomy.

### 3. Executor binding

The main thread may satisfy the Developer or coordinating role. Required independent roles are delegated to distinct custom Codex agents or, when necessary, separate sessions.

Custom-agent permission defaults do not override the live parent session unconditionally: subagents inherit the parent's effective sandbox and permission mode. If a review role must be technically read-only and the effective parent mode cannot provide that boundary, AWCP must require a separate Codex session with the correct permissions or mark the independence guarantee as degraded.

For a subagent:

1. `PreToolUse` intercepts `spawn_agent`, validates the requested `agent_type` against one open role assignment and rejects an unauthorized role launch.
2. The custom-agent profile supplies that role's stable instructions; the delegated message supplies the task-specific contract, constraints and evidence schema.
3. `PostToolUse` binds the returned child thread ID to the pending role assignment.
4. The role runs with the least effective permission level available from Codex and records findings through the AWCP MCP server.
5. App Server later reconciles the child ID, `parentThreadId` and `agentRole` into the historical record.
6. The root `Stop` hook refuses completion while any required role assignment or evidence gate remains unsatisfied.

Codex deciding to spawn a subagent is still guidance-driven, and the tested build offers no direct child-stop gate. The hard gate is that the root `Stop` cannot accept completion while a required role remains unsatisfied. A human may explicitly waive a role only through an authorized AWCP transition that records the reason and degradation.

`Stop` exposes `stop_hook_active`. AWCP must use it to prevent blind continuation loops: after one automated continuation, the next failed gate should request a concrete repair or human decision and leave the work blocked if neither is possible.

### 4. Role execution controls

`PreToolUse` applies the following checks to supported local tools:

- a governed task is active;
- an execution attempt is open;
- the current executor is bound to the active role;
- the role permits that tool category and mutation class;
- prerequisite roles or approvals are satisfied;
- the requested operation does not violate task constraints.

Examples:

- a Reviewer bound as read-only cannot apply a patch;
- a Developer cannot mutate before task classification;
- completion-state mutation is rejected unless role evidence and gates are satisfied;
- sensitive commands remain subject to Codex sandbox, approvals and command rules as an independent boundary.

`PostToolUse` may record command, patch and MCP observations, but tool output is not automatically accepted as role evidence. The role or a deterministic verifier must submit evidence under the corresponding evidence requirement.

### 5. Evidence protocol

Each role contribution records:

- AWCP task, role-assignment and execution-attempt IDs;
- Codex session, turn and executor identifiers;
- start and end timestamps;
- inputs or stable references to them;
- decisions and rationale;
- evidence type, result and stable artifact reference;
- findings, disposition and unresolved risk;
- guarantee level and any degradation.

Minimum role evidence:

| Role | Required evidence |
| --- | --- |
| Developer | changed scope, rationale, build/test observations where applicable |
| Tester | checks selected, commands or reproducible procedure, result, remaining gaps |
| Code Reviewer | reviewed scope, findings or explicit no-findings result, residual risk |
| Architect | decision, tradeoffs, rejected alternatives, open questions |
| Researcher | sources, factual claims, inferences and uncertainty |
| Critic | challenged claims, missing evidence and unresolved uncertainty |
| Security Reviewer | reviewed threat surface, findings and mitigations |

Repository files, commits, PRs, test reports and CI remain authoritative for their own content. AWCP stores the work-control record and stable references needed to explain why the evidence satisfied a gate.

### 6. Completion

Work is eligible for completion only when the AWCP service validates all of the following:

- accepted intent is satisfied or explicitly narrowed;
- every required role is satisfied or explicitly waived by an authorized human;
- required independence constraints are satisfied;
- required evidence exists and is linked to the correct execution;
- tests/checks ran or an accepted skip reason exists;
- review findings are resolved or explicitly accepted;
- no blocking constraint or approval remains.

When Codex attempts to stop:

1. the `Stop` hook queries the AWCP completion decision;
2. if ineligible, it returns a focused continuation reason;
3. Codex continues in a new turn to execute the missing role, repair a finding or request human action;
4. only an eligible task may be represented by AWCP as complete.

A user interruption, process failure or session close records an interrupted or stale execution. `SessionEnd` never completes work.

## What this design guarantees

### Guaranteed by the AWCP service

- invalid work-state transitions are rejected;
- completion cannot be recorded without the current completion contract;
- evidence is linked to explicit task, role and execution identities;
- waivers and degraded guarantees remain visible and attributable;
- the TUI reads the same authoritative state as Codex integrations.

### Guaranteed while trusted hooks are active

- prompts can be blocked or enriched before the model receives them;
- supported local mutations can be denied before execution;
- supported tool calls can be attributed to session and turn;
- a requested custom-agent type can be validated before spawn and its returned child ID can be bound afterward;
- Codex cannot end a normal root turn cleanly while the corresponding AWCP gate says to continue.

### Not guaranteed by Codex native surfaces

- prevention of all possible activity after the user disables the integration;
- coverage of hosted tools or every specialized local tool path;
- automatic selection of the correct work item from arbitrary prose without confirmation;
- deterministic subagent spawning from instructions alone;
- direct enforcement of a subagent's own stop in the tested runtime;
- semantic independence merely because two role labels differ;
- completion when the human force-closes or interrupts Codex;
- a stable contract based on transcript-file parsing;
- passive real-time observation of a thread owned by another App Server process.

## Rejected primary integration shapes

### `AGENTS.md` or skills only

Rejected because they deliver methodology but cannot guarantee participation or completion gates.

### MCP only

Rejected because a required server can guarantee availability, not that the model invokes the correct domain operation at the correct time.

### App Server or SDK as the default execution path

Rejected for the primary interactive experience because it would make AWCP launch or own Codex conversations. OpenAI Symphony demonstrates that this shape is technically viable when a scheduler/runner is desired; the rejection is a product-boundary decision, not a capability limitation. It remains valid for optional managed jobs, external-orchestrator composition and TUI history enrichment.

### Transcript parsing

Rejected because Codex explicitly marks transcript format as unstable. Native hook fields and App Server APIs are the supported contracts.

### Repository artifacts as the sole state

Rejected because they do not provide authoritative cross-session task, role, execution, timing and completion state required by AWCP-DEC-009.

## Empirical validation results

The pass exercised a disposable Git repository with a deterministic hook fixture. Raw transcripts are intentionally not an integration artifact because Codex documents their format as unstable. The evidence record retains native thread IDs and observable outcomes.

| Test | Result | Architectural consequence |
| --- | --- | --- |
| Session and prompt context injection | `PASS` | Hooks can attach the active work contract before model execution. |
| Prompt block | `PASS` | The turn lifecycle existed, but model usage remained zero. Intake can be rejected before inference. |
| Shell, `apply_patch` and MCP denial | `PASS` | `PreToolUse` stopped each tested side effect. The shell path used Codex's canonical `Bash` hook name on Windows. |
| Allowed tool correlation | `PASS` | `PreToolUse` and `PostToolUse` shared session, turn and tool-use IDs. |
| Custom `tester` role spawn | `PASS` | The requested `agent_type` and returned child ID are sufficient for initial executor binding. |
| `SubagentStart` / `SubagentStop` | `UNAVAILABLE` | Neither hook fired in exec, interactive CLI, v1 or `multi_agent_v2`; they cannot be part of the current guarantee. |
| Child permission inheritance | `PASS` | A child declaring `workspace-write` could not exceed a read-only parent. Permission-sensitive roles may need separate sessions. |
| Root `Stop` continuation | `PASS` | One continuation stayed in the same turn; `stop_hook_active` supplied loop protection. |
| Historical App Server inspection | `PASS` | Completed roots and descendants exposed turns, `parentThreadId`, `agentRole` and source kind. |
| Passive live App Server inspection | `FAIL` | A foreign active thread appeared `notLoaded` / `interrupted`; hooks must supply live events. |
| Untrusted project hooks | `PASS` as degraded behavior | Codex continued without running them. AWCP must show the run as ungoverned or degraded. |
| Required MCP unavailable | `PASS` as hard precondition | Codex exited before creating a thread. |
| `SessionEnd` on Windows | `PASS` with caveat | A three-second hook timeout was required in the fixture; the event remains advisory. |

Not yet tested: `PermissionRequest`, administratively managed requirements/hooks, a real AWCP MCP service, Desktop-specific source behavior, unified exec as a distinct case, and regression behavior after a Codex upgrade.

## Exit decision

SPIKE-001 is closed for the **Codex integration architecture**. The selected contract is:

1. hooks publish live root lifecycle and enforce prompt, supported-tool and root-completion gates;
2. the required AWCP MCP server performs authoritative work-state operations;
3. custom agents materialize roles, with `spawn_agent` tool correlation binding child executors;
4. App Server reconciles persisted history and role lineage after or around execution, but is not the passive live event source;
5. AWCP's service and database alone decide whether work is complete.

Product implementation still requires acceptance tests for the untested items above and must rerun this fixture for every supported Codex release. A regression in any required native surface changes the run to degraded; it must not weaken the authoritative completion contract.

## Sources

- [OpenAI Docs - Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [OpenAI Docs - Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [OpenAI Docs - Hooks](https://learn.chatgpt.com/docs/hooks)
- [OpenAI Docs - Model Context Protocol](https://learn.chatgpt.com/docs/extend/mcp)
- [OpenAI Docs - Agent approvals and security](https://learn.chatgpt.com/docs/agent-approvals-security)
- [OpenAI Docs - Rules](https://learn.chatgpt.com/docs/agent-configuration/rules)
- [OpenAI Docs - Build skills](https://learn.chatgpt.com/docs/build-skills)
- [OpenAI Docs - Build plugins](https://learn.chatgpt.com/docs/build-plugins)
- [OpenAI Docs - Record and Replay](https://learn.chatgpt.com/docs/extend/record-and-replay)
- [OpenAI Docs - Codex App Server](https://learn.chatgpt.com/docs/app-server)
- [OpenAI Docs - Non-interactive mode](https://learn.chatgpt.com/docs/non-interactive-mode)
- [OpenAI Docs - Codex SDK](https://learn.chatgpt.com/docs/codex-sdk)
- [OpenAI Docs - Configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference)
- [OpenAI Docs - Managed configuration](https://learn.chatgpt.com/docs/enterprise/managed-configuration)
- [OpenAI - Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/)
- [OpenAI - An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/)
- [OpenAI Symphony specification](https://github.com/openai/symphony/blob/main/SPEC.md)
