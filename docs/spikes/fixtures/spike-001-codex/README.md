# SPIKE-001 Codex fixture

This fixture validates native Codex lifecycle contracts. It is not an AWCP service, runtime or product implementation.

Copy the fixture into a disposable Git repository, record the effective Codex configuration, isolate unrelated hooks where possible, and explicitly trust the exact project hooks for the invocation.

The hook reads `.codex/spike/state.json` and appends observed payloads to `.codex/spike/events.jsonl`. Each state switch enables one narrow experiment:

- `inject_session_context`: add deterministic developer context at session start;
- `inject_prompt_context`: add deterministic developer context before a prompt;
- `block_prompt`: reject a prompt before model execution;
- `block_all_tools`: deny every supported local tool before execution;
- `block_stop_once`: continue the root agent once through `Stop`.

The committed state is permissive. Test runs mutate only the disposable copy.

The fixture deliberately registers `SubagentStart` and `SubagentStop` even though the tested Codex build did not emit either event. Their absence is one of the recorded results, not a reason to remove the probes.

`app-server-probe.ps1` exercises the supported JSON-RPC API for historical thread, turn and descendant inspection. It must not be treated as a live event subscriber for threads owned by a different Codex process.
