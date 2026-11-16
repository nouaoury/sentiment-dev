# Installer de la roue sentiment-app 0.6.0 (PowerShell)
# Usage : .\setup_roue.ps1
$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "  Installation du Paquet Sentiment-App 0.6.0 (Wheel / Roue)" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

$Roue = Get-ChildItem -Path $ScriptDir, (Join-Path $ScriptDir "dist"), "C:\Users\assia\Downloads" -Filter "sentiment_app-0.6.0-py3-none-any.whl" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $Roue) {
    Write-Error "Fichier sentiment_app-0.6.0-py3-none-any.whl introuvable."
    exit 1
}

Write-Host "[1/4] Roue trouvée : $($Roue.FullName)" -ForegroundColor Green

$EnvDir = Join-Path $ScriptDir "env-roue"
Write-Host "[2/4] Création de l'environnement virtuel dans $EnvDir..." -ForegroundColor Yellow
if (-not (Test-Path $EnvDir)) {
    py -3.11 -m venv $EnvDir
}

$Pip = Join-Path $EnvDir "Scripts\pip.exe"
$Python = Join-Path $EnvDir "Scripts\python.exe"

Write-Host "[3/4] Installation du paquet et de ses dépendances..." -ForegroundColor Yellow
& $Pip install $Roue.FullName --upgrade

Write-Host "[4/4] Vérification de la commande..." -ForegroundColor Green
& $Python -m sentiment_app --version

$Modele = Get-ChildItem -Path $ScriptDir, (Join-Path $ScriptDir "models"), "C:\Users\assia\Downloads" -Filter "sentiment.joblib" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($Modele) {
    Write-Host "`n[TEST] Test de prédiction avec modèle : $($Modele.FullName)" -ForegroundColor Cyan
    $env:SENTIMENT_MODELE = $Modele.FullName
    & $Python -m sentiment_app predict "Livraison rapide, produit conforme, très satisfait"
    Remove-Item Env:SENTIMENT_MODELE
}

Write-Host "`nInstallation terminée avec succès !" -ForegroundColor Green
Write-Host "Usage : & '$Python' -m sentiment_app [predict|serve|ui]"
