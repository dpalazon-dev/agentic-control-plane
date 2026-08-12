param(
    [Parameter(Mandatory = $true)]
    [string]$CodexPath,

    [Parameter(Mandatory = $true)]
    [string]$WorkingDirectory,

    [Parameter(Mandatory = $true)]
    [string]$ThreadId
)

$ErrorActionPreference = "Stop"

$startInfo = [System.Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = $CodexPath
$startInfo.Arguments = "app-server --stdio"
$startInfo.WorkingDirectory = $WorkingDirectory
$startInfo.UseShellExecute = $false
$startInfo.CreateNoWindow = $true
$startInfo.RedirectStandardInput = $true
$startInfo.RedirectStandardOutput = $true
$startInfo.RedirectStandardError = $true

$process = [System.Diagnostics.Process]::new()
$process.StartInfo = $startInfo
$null = $process.Start()

function Send-Message {
    param([hashtable]$Message)

    $process.StandardInput.WriteLine(($Message | ConvertTo-Json -Depth 30 -Compress))
    $process.StandardInput.Flush()
}

function Read-Response {
    param([int]$Id)

    while ($true) {
        $line = $process.StandardOutput.ReadLine()
        if ($null -eq $line) {
            throw "App Server closed before response $Id. $($process.StandardError.ReadToEnd())"
        }

        $message = $line | ConvertFrom-Json
        if ($message.id -eq $Id) {
            return $message
        }
    }
}

try {
    Send-Message -Message @{
        method = "initialize"
        id = 1
        params = @{
            clientInfo = @{
                name = "awcp-spike-probe"
                version = "0.1"
            }
            capabilities = @{
                experimentalApi = $true
            }
        }
    }
    $initialize = Read-Response -Id 1

    Send-Message -Message @{ method = "initialized" }

    $allSourceKinds = @(
        "cli",
        "vscode",
        "exec",
        "appServer",
        "subAgent",
        "subAgentReview",
        "subAgentCompact",
        "subAgentThreadSpawn",
        "subAgentOther",
        "unknown"
    )

    Send-Message -Message @{
        method = "thread/list"
        id = 2
        params = @{
            cwd = $WorkingDirectory
            limit = 100
            sourceKinds = $allSourceKinds
            sortKey = "created_at"
            sortDirection = "desc"
        }
    }
    $threadList = Read-Response -Id 2

    Send-Message -Message @{
        method = "thread/read"
        id = 3
        params = @{
            threadId = $ThreadId
            includeTurns = $true
        }
    }
    $threadRead = Read-Response -Id 3

    Send-Message -Message @{
        method = "thread/list"
        id = 4
        params = @{
            ancestorThreadId = $ThreadId
            limit = 100
            sourceKinds = $allSourceKinds
        }
    }
    $descendants = Read-Response -Id 4

    [ordered]@{
        initialize = $initialize.result
        listed_threads = $threadList.result.data
        read_thread = $threadRead.result.thread
        descendants = $descendants.result.data
    } | ConvertTo-Json -Depth 50
} finally {
    if (-not $process.HasExited) {
        $process.Kill()
        $process.WaitForExit()
    }

    $process.Dispose()
}
