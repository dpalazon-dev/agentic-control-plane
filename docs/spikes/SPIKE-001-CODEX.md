# SPIKE-001 - Codex Native Methodology Surfaces

## Status

**Official documentation review complete. Local empirical validation pending.**

This spike is limited to Codex. It validates the Codex integration contract before implementing the accepted local AWCP service, database or TUI. It does not implement an execution proxy, a custom agent runtime, a scheduler or an AWCP-owned model loop.

The question is:

> Can Codex participate in a strict, auditable flow for `Intent -> Work Package / Task -> Required Roles -> Role Execution -> Evidence -> Completion` while Codex keeps ownership of its conversation, agent loop and tools?

## Decision summary

**Yes, with a conditional guarantee.** Codex exposes enough native surfaces for a viable strict integration:

- lifecycle hooks can inject context and block prompts, supported local tools, subagent stops and normal turn stops;
- custom agents and subagents can materialize semantic roles with distinct instructions and permission defaults;
- MCP can expose the authoritative local AWCP work state to every supported local Codex client;
- sandboxing, approvals and command rules can enforce technical boundaries;
- App Server can list and read persisted Codex threads and their lineage for a secondary inspection UI;
- `codex exec --json` provides structured events for AWCP-managed non-interactive runs.

The guarantee is not unconditional:

- ordinary project, user and plugin hooks must be reviewed and trusted and can be disabled;
- `PreToolUse` does not cover hosted tools such as Web Search and some specialized tool paths may opt out;
- Codex can be interrupted or closed by the human;
- instructions, skills and agent descriptions cannot by themselves force role execution;
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
| Subagents | Codex can spawn, wait for, continue and close subagent threads; activity is inspectable in supported clients. | Materialize role separation and collect role-specific evidence. | `OBSERVABLE`; spawning remains instruction-driven |
| Sandbox and approvals | Codex constrains filesystem, network and escalation behavior according to the active permission mode. Subagents inherit the parent session's live sandbox and permission mode. | Least privilege per session and role; read-only review where the effective mode supports it. | `ENFORCEABLE` at the technical boundary |
| Command rules | Experimental `prefix_rule` entries allow, prompt or forbid matching commands outside the sandbox; the most restrictive match wins. | Block or approve sensitive shell entry points. | `ENFORCEABLE` for matching command boundaries; not a workflow engine |
| Hooks | Codex runs deterministic commands at session, prompt, tool, compaction, subagent and stop lifecycle points. Several events can block or continue the flow. | Mandatory participation, context injection, execution attribution and evidence/completion gates. | `ENFORCEABLE_IF_TRUSTED`; `MANAGED_ENFORCEABLE` with requirements |
| MCP | Desktop, CLI and IDE clients on the same host share MCP configuration. A server may be local STDIO or HTTP, required at startup, tool-filtered and approval-configured. | Read and mutate authoritative AWCP work state through validated domain operations. | Availability is `ENFORCEABLE` with `required = true`; model invocation alone is not guaranteed |
| Plugin | An installed plugin may package skills, MCP configuration and lifecycle hooks. Plugin hooks use the normal trust review unless managed. | Distribute the Codex-specific AWCP integration as one versioned unit. | Packaging only; contained surfaces retain their own guarantees |
| App Server | JSON-RPC API can list/read stored threads, turns and items, expose thread status and lineage, and stream events for threads it controls or subscribes to. | TUI enrichment with Codex conversation metadata and optional managed-run integration. | `OBSERVABLE`; passive cross-process live streaming is not established |
| `codex exec --json` | Emits JSONL events including thread, turn and item lifecycle and supports resuming a session by ID. | Deterministic ingestion for future AWCP-originated automation. | `OBSERVABLE`; only for runs launched this way |
| Codex SDK | Starts and resumes local Codex threads programmatically. | Optional future execution mode for AWCP-originated jobs. | Strong control, but using it as the default would move AWCP toward owning execution |
| Config profiles and requirements | Profiles select reusable runtime settings; `requirements.toml` can constrain security-sensitive settings and managed hooks. | Installation modes and host policy, not semantic work state. | `ENFORCEABLE` for supported settings |
| Record & Replay | Converts a demonstrated workflow into a reusable skill. | Capture a mature role playbook after the method stabilizes. | Same as skills: `INJECTABLE`, `GUIDANCE_ONLY` |
| Native goal and plan state | App Server exposes the persisted goal also shown by `/goal`; plans appear as turn items. | Optional projection of the active objective and current execution plan. | `OBSERVABLE`; insufficient for AWCP work hierarchy, role evidence or completion |

## Hooks are the decisive surface

The earlier hypothesis treated hooks as optional checks. The official Codex contract is substantially stronger.

| Hook | Stable data relevant to AWCP | AWCP responsibility |
| --- | --- | --- |
| `SessionStart` | `session_id`, `cwd`, `model`, source (`startup`, `resume`, `clear`, `compact`) | Register or refresh the Codex session and inject the active work contract. |
| `UserPromptSubmit` | `session_id`, `turn_id`, prompt, permission mode | Resolve the active task, inject task context or block a prompt that cannot enter the governed flow. |
| `PreToolUse` | session, turn, tool name, tool-use ID and tool input | Reject supported mutations unless the task and active role permit them. |
| `PostToolUse` | the same identity plus tool output | Record best-effort execution observations and attach candidate evidence. It cannot undo side effects. |
| `PermissionRequest` | pending approval request and tool identity | Apply deterministic approval policy or defer to the normal human prompt. |
| `SubagentStart` | parent session, turn, `agent_id`, `agent_type`, permission mode | Bind a concrete Codex subagent to a required AWCP role and inject its role contract. |
| `SubagentStop` | parent session, turn, `agent_id`, `agent_type`, last message | Refuse a normal role stop and continue the subagent until required role evidence exists. |
| `Stop` | session, turn and last assistant message | Refuse a normal turn stop and continue Codex when completion gates are missing. |
| `SessionEnd` | session, cwd and current reason | Record a lifecycle observation only. Never infer work completion from it. |

Important limitations:

- subagent hooks report the parent `session_id`; `agent_id` is required to distinguish executors;
- `Stop` and `SubagentStop` do not reject a completed turn as a transaction would; a block asks Codex to continue with a new focused prompt;
- `SessionEnd` may occur on normal close or after 30 minutes with no subscribers and is always advisory;
- transcript paths are convenient but the transcript format is explicitly unstable and must not become the integration contract;
- tool hooks cover shell/unified exec, `apply_patch`, MCP tools and most local function tools, but not every possible tool path.

## Identity and provenance model

AWCP should record native identifiers, not infer them from text or filesystem paths.

| AWCP concept | Codex identifier | Notes |
| --- | --- | --- |
| Coding client | integration source + observed App Server `sourceKind` when available | Examples include `cli`, `vscode`, `exec`, `appServer` and subagent source kinds. |
| Session tree | hook `session_id` or App Server `thread.sessionId` | Root threads use their own thread ID; forks retain the root session ID. Read it, do not derive it. |
| Thread | App Server `thread.id` | Distinguishes a root, fork or spawned descendant. |
| Turn | hook `turn_id` or App Server turn ID | Unit of user-to-agent work. |
| Executor | root-thread marker or hook `agent_id` | Subagents require `agent_id`; the parent session ID is shared. |
| Executor profile | hook `agent_type` | Candidate mapping to an AWCP semantic role, subject to policy validation. |
| Tool execution | hook tool-use ID / App Server item ID | Useful correlation, not itself semantic evidence. |
| Work execution | AWCP-owned execution-attempt ID | Authoritative link among task, role, Codex identities and timestamps. |

The TUI may use App Server `thread/list`, `thread/read` and experimental turn/item pagination to enrich history without parsing rollout JSONL directly. Documentation confirms that stored interactive `cli` and `vscode` threads can be listed and filtered, including spawned descendants. Whether a second App Server process can provide sufficiently fresh, contention-free observation of an actively open desktop task remains an empirical question.

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

1. `SubagentStart` binds `agent_id` and `agent_type` to one open role assignment.
2. The hook injects only that role's contract, inputs, constraints and evidence schema.
3. The role runs with the least effective permission level available from Codex.
4. The subagent records findings and evidence through the AWCP MCP server.
5. `SubagentStop` checks the authoritative role state and continues the subagent if its contract is incomplete.

Codex deciding to spawn a subagent is still guidance-driven. The hard gate is that `Stop` cannot accept completion while a required role remains unsatisfied. A human may explicitly waive a role only through an authorized AWCP transition that records the reason and degradation.

Both `SubagentStop` and `Stop` expose `stop_hook_active`. AWCP must use it to prevent blind continuation loops: after one automated continuation, the next failed gate should request a concrete repair or human decision and leave the work blocked if neither is possible.

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
- subagent start/stop can be attributed to agent ID and type;
- Codex cannot end a normal role or main turn cleanly while the corresponding AWCP gate says to continue.

### Not guaranteed by Codex native surfaces

- prevention of all possible activity after the user disables the integration;
- coverage of hosted tools or every specialized local tool path;
- automatic selection of the correct work item from arbitrary prose without confirmation;
- deterministic subagent spawning from instructions alone;
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

## Empirical validation plan

Documentation establishes the candidate contract. The next step is a non-production dry run with disposable tasks and a minimal fake AWCP endpoint or fixture, not the product implementation.

### Test A - hook enforcement

- verify `UserPromptSubmit` can inject and block;
- verify `PreToolUse` blocks shell, unified exec, `apply_patch` and MCP calls before side effects;
- verify expected behavior for tool paths not covered by hooks;
- verify hook trust, changed-hook review and disabled-hook behavior;
- verify Windows command invocation and timeout behavior.

### Test B - role lifecycle

- configure `developer`, `tester` and `code-reviewer` custom agents;
- verify actual `SubagentStart` and `SubagentStop` payloads;
- verify parent session ID, agent ID, type and turn correlation;
- verify a blocked `SubagentStop` produces one focused continuation and does not loop indefinitely;
- verify effective sandbox inheritance for each role.

### Test C - completion gate

- run an implementation task requiring Developer + Tester + Code Reviewer;
- attempt to stop before test evidence and before review evidence;
- verify `Stop` continuation behavior and human interruption behavior;
- verify that only the authoritative service can produce completion.

### Test D - TUI observation substrate

- start Codex work in the desktop app and CLI;
- query a separate App Server with `thread/list` and `thread/read`;
- measure freshness, locking, source kind, lineage and active status;
- determine whether polling supported APIs is sufficient or hooks must publish all live identity into AWCP;
- do not parse raw rollout JSONL.

### Test E - degraded operation

- stop the AWCP service;
- fail required MCP initialization;
- disable or modify an untrusted hook;
- interrupt Codex during an active role;
- verify that the task remains blocked, degraded, interrupted or stale, never complete.

## Exit criteria

SPIKE-001 can close only when the dry run records:

- exact supported hook payloads on the installed Windows Codex version;
- actual block/continue behavior for each selected gate;
- reliable session, turn and agent correlation;
- effective role permission behavior;
- failure and recovery behavior when AWCP or MCP is unavailable;
- App Server viability for secondary TUI inspection;
- an updated guarantee matrix based on observed results.

The installed Windows application observed during this documentation pass is `OpenAI.Codex 26.803.10989.0`. Direct CLI execution from the current automation environment was denied by Windows Apps permissions, so runtime claims remain pending until the dedicated dry run.

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
