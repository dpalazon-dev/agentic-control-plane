$ErrorActionPreference = "Stop"

$rawInput = [Console]::In.ReadToEnd()
$payload = $rawInput | ConvertFrom-Json
$root = (git rev-parse --show-toplevel).Trim()
$spikeDirectory = Join-Path $root ".codex\spike"
$statePath = Join-Path $spikeDirectory "state.json"
$eventsPath = Join-Path $spikeDirectory "events.jsonl"

New-Item -ItemType Directory -Force -Path $spikeDirectory | Out-Null

$state = if (Test-Path -LiteralPath $statePath) {
    Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json
} else {
    [pscustomobject]@{}
}

$eventName = [string]$payload.hook_event_name
$decision = "allow"
$response = $null

if ($eventName -eq "SessionStart" -and $state.inject_session_context) {
    $decision = "inject_session_context"
    $response = [ordered]@{
        hookSpecificOutput = [ordered]@{
            hookEventName = "SessionStart"
            additionalContext = "AWCP_SPIKE_SESSION_CONTEXT_7F3A"
        }
    }
}

if ($eventName -eq "UserPromptSubmit") {
    if ($state.block_prompt) {
        $decision = "block_prompt"
        $response = [ordered]@{
            decision = "block"
            reason = "AWCP spike intentionally blocked this prompt before model execution."
        }
    } elseif ($state.inject_prompt_context) {
        $decision = "inject_prompt_context"
        $response = [ordered]@{
            hookSpecificOutput = [ordered]@{
                hookEventName = "UserPromptSubmit"
                additionalContext = "AWCP_SPIKE_PROMPT_CONTEXT_91C2"
            }
        }
    }
}

if ($eventName -eq "PreToolUse" -and $state.block_all_tools) {
    $decision = "deny_tool"
    $response = [ordered]@{
        hookSpecificOutput = [ordered]@{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = "AWCP spike intentionally denied this local tool call."
        }
    }
}

if ($eventName -eq "Stop" -and $state.block_stop_once -and -not [bool]$payload.stop_hook_active) {
    $decision = "continue_root_once"
    $response = [ordered]@{
        decision = "block"
        reason = "Respond once more with the exact token CONTINUED_BY_STOP_HOOK."
    }
}

$evidence = [ordered]@{
    observed_at = [DateTimeOffset]::UtcNow.ToString("o")
    decision = $decision
    payload = $payload
}

Add-Content -LiteralPath $eventsPath -Value ($evidence | ConvertTo-Json -Depth 30 -Compress) -Encoding UTF8

if ($null -ne $response) {
    [Console]::Out.WriteLine(($response | ConvertTo-Json -Depth 10 -Compress))
}
