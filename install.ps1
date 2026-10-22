# Pickup one-line installer for Windows
$ErrorActionPreference = "Stop"

Write-Host "Installing Pickup..." -ForegroundColor White

# Check for Python
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python 3.9+ is required but not found in PATH."
}

# Check or install Bun
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Bun..." -ForegroundColor Yellow
    irm bun.sh/install.ps1 | iex
    $env:PATH = "$env:USERPROFILE\.bun\bin;$env:PATH"
}

# Target directory
$targetDir = "$env:USERPROFILE\.samethread-repo"
if (Test-Path $targetDir) {
    Write-Host "Updating repository in $targetDir..." -ForegroundColor DarkGray
    git -C $targetDir pull --quiet
} else {
    Write-Host "Cloning repository to $targetDir..." -ForegroundColor DarkGray
    git clone --quiet https://github.com/KennyUMN/Pickup.git $targetDir
}

# Install dependencies and link
Push-Location $targetDir
try {
    Write-Host "Setting up OpenTUI and agent hooks..." -ForegroundColor DarkGray
    & bun install --silent
    & npm link --silent 2>$null
    & python -m pip install -e . --quiet
    # Python's Scripts\ folder is often not on PATH, so call the module directly
    & python -m samethread install
} finally {
    Pop-Location
}

# Put resume and hop on PATH: Bun's bin folder is on PATH once Bun is installed; npm's only with Node
$binDirs = @("$env:USERPROFILE\.bun\bin", "$env:APPDATA\npm") | Where-Object { Test-Path $_ }
foreach ($dir in $binDirs) {
    Copy-Item -Force "$targetDir\bin\resume.cmd" "$dir\resume.cmd"
    Set-Content -Path "$dir\hop.cmd" -Value "@python -m samethread %*" -Encoding ASCII
}

Write-Host "`nPickup installed successfully!" -ForegroundColor Green
Write-Host "Type 'resume' anywhere in your terminal to start."
