param(
    [string]$MysqlUser = "root",
    [string]$MysqlPassword = "",
    [string]$SqlFile = ".\\database\\init_mspblog.sql"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command mysql -ErrorAction SilentlyContinue)) {
    Write-Error "MySQL CLI ('mysql') not found in PATH. Install MySQL client or add it to PATH."
}

if (-not (Test-Path $SqlFile)) {
    Write-Error "SQL file not found: $SqlFile"
}

Write-Host "Running SQL setup using file: $SqlFile"

$resolvedSqlFile = (Resolve-Path $SqlFile).Path -replace "\\", "/"
$command = "source $resolvedSqlFile"
mysql -u $MysqlUser --password=$MysqlPassword -e $command
if ($LASTEXITCODE -ne 0) {
    Write-Error "Database setup failed. Check MySQL username/password and localhost access for the user."
}

Write-Host "Database setup complete."
