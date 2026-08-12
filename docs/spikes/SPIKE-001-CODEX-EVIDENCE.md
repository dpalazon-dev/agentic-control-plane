# SPIKE-001 - Codex Empirical Evidence

## Purpose

This record preserves the first empirical validation of the Codex integration contract. It contains supported identifiers and externally observable outcomes, not raw Codex transcripts. Transcript files are intentionally excluded because their format is not a stable integration API.

## Environment

- Date: `2026-08-12`
- OS: Windows
- Desktop package: `OpenAI.Codex 26.803.10989.0`
- CLI: `codex-cli 0.147.0-alpha.6.6`
- Stable features: `hooks = true`, `multi_agent = true`
- Optional comparison: `multi_agent_v2 = true`
- Fixture: [`fixtures/spike-001-codex`](fixtures/spike-001-codex/README.md)

Each test ran in a disposable Git repository. The fixture appended hook payloads to an ignored JSONL file, while the test asserted model output, filesystem side effects, process exit status or supported App Server responses. No AWCP service, database, MCP implementation or execution runtime was created.

## Results

| Case | Native thread ID | Observation | Result |
| --- | --- | --- | --- |
| Session and prompt injection | `019ff5eb-9057-7782-9347-7e3705db2a91` | The model returned both deterministic context markers. Session and prompt events shared the session ID; prompt and stop shared a turn ID. | `PASS` |
| Prompt block | `019ff5ec-71d6-74e2-b7bd-f461eb16986b` | A turn started and completed with zero usage and no assistant message. | `PASS` |
| Shell denial | `019ff5ed-4481-78e3-a746-175b3a5d8b4e` | `PreToolUse` used canonical tool name `Bash`; the target file was not created and no `PostToolUse` followed. | `PASS` |
| Patch denial | `019ff5ee-536b-7112-8f03-702603699605` | `PreToolUse` used `apply_patch`; the target file was not created. | `PASS` |
| Allowed shell observation | `019ff5ef-7b34-72d2-915c-be0f17f7e37f` | Pre/post events shared session, turn and tool-use IDs; the expected file was written. | `PASS` |
| Root stop continuation | `019ff5f0-c874-7231-b8b5-82f1794ec8e2` | The first `Stop` continued the agent in the same turn; the second had `stop_hook_active = true` and was allowed. | `PASS` |
| Custom `tester` spawn, v1 | `019ff5f1-ee22-7c42-a49e-830697d92634` | `spawn_agent` pre/post events exposed `agent_type = tester` and child `019ff5f2-66f3-7f92-95a6-c6bfcd876730`. No subagent lifecycle hook fired. | `PARTIAL` |
| Custom `tester` spawn, v2 | `019ff5f3-8542-7d50-9ca5-88653ec82d6a` | Spawn succeeded with `multi_agent_v2`; no subagent lifecycle hook fired. | `PARTIAL` |
| Custom `tester` spawn, interactive CLI | `019ff5f5-65df-7930-9d50-6547091feb56` | Child `019ff5f5-d003-7432-8785-ea6cc9e78aa0` completed; no subagent lifecycle hook fired. | `PARTIAL` |
| Child permission inheritance | `019ff5f9-99ca-7502-afaa-bb07f623f8e7` | A child profile requesting `workspace-write` could not write under a read-only parent. | `PASS` |
| Untrusted project hooks | `019ff5fb-52be-7f20-8692-e3fc87072975` | Codex continued normally without adding a fixture event. | `PASS` for degraded-mode hypothesis |
| Session end | `019ff5fd-7bb8-75b3-bc09-3ca9a98ae886` | `SessionEnd` appeared with reason `other` after raising the Windows command timeout to three seconds. | `PASS` with caveat |
| Cross-process live App Server read | `019ff5fe-775d-7203-a508-b68fd8478a58` | During an active shell call, a separate App Server returned thread `notLoaded` and turn `interrupted`; after completion the turn became `completed`. | `FAIL` as a live source |
| MCP tool denial | `019ff601-f632-7231-9d06-3a125890b954` | `PreToolUse` denied `mcp__graphify__graph_stats` before invocation; no post event followed. | `PASS` |

Required-MCP startup used a deliberately missing executable with `required = true`. Codex exited with code `1` before creating a thread, which validates required service availability as a hard precondition.

## App Server identity findings

A separate App Server process successfully listed and read completed `cli`, `exec` and `subAgent` threads. For the interactive child it returned:

- `thread.id = 019ff5f5-d003-7432-8785-ea6cc9e78aa0`;
- `parentThreadId = 019ff5f5-65df-7930-9d50-6547091feb56`;
- `agentRole = tester`;
- `sourceKind = subAgent`.

The child `sessionId` equalled the child thread ID, not the root ID. AWCP must therefore use `parentThreadId` for ancestry and use the `spawn_agent` result plus App Server reconciliation for executor binding.

## Unsupported or untested claims

- Registered `SubagentStart` and `SubagentStop` hooks did not fire in any tested mode.
- Passive cross-process App Server reads were not reliable for active state.
- `PermissionRequest`, administratively managed hooks, Desktop-specific source behavior and unified exec as a distinct path were not tested.
- No real AWCP service existed, so authoritative state transitions, evidence validation and recovery after service loss remain product acceptance tests.

## Revalidation rule

Rerun this fixture for every supported Codex release. A documented surface becomes part of AWCP's guarantee only after it is observed in the supported runtime. Missing required events or changed payload identity must mark the integration degraded until the contract is updated.
