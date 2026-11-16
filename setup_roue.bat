@echo off
setlocal enabledelayedexpansion

echo =========================================================
echo   Installation du Paquet Sentiment-App 0.6.0 (Roue / Wheel)
echo =========================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "ROUE_FILE="

REM Chercher le fichier .whl dans le repertoire courant ou dans dist
if exist "%SCRIPT_DIR%sentiment_app-0.6.0-py3-none-any.whl" (
    set "ROUE_FILE=%SCRIPT_DIR%sentiment_app-0.6.0-py3-none-any.whl"
) else if exist "%SCRIPT_DIR%dist\sentiment_app-0.6.0-py3-none-any.whl" (
    set "ROUE_FILE=%SCRIPT_DIR%dist\sentiment_app-0.6.0-py3-none-any.whl"
) else if exist "%SCRIPT_DIR%..\dist\sentiment_app-0.6.0-py3-none-any.whl" (
    set "ROUE_FILE=%SCRIPT_DIR%..\dist\sentiment_app-0.6.0-py3-none-any.whl"
)

if "%ROUE_FILE%"=="" (
    echo [ERREUR] Fichier de roue sentiment_app-0.6.0-py3-none-any.whl introuvable.
    pause
    exit /b 1
)

echo [1/4] Roue trouvee : %ROUE_FILE%

REM Creation de l'environnement virtuel
echo [2/4] Creation de l'environnement virtuel 'env-roue'...
if not exist "%SCRIPT_DIR%env-roue" (
    py -3.11 -m venv "%SCRIPT_DIR%env-roue"
    if errorlevel 1 python -m venv "%SCRIPT_DIR%env-roue"
)

set "PYTHON_EXE=%SCRIPT_DIR%env-roue\Scripts\python.exe"
set "PIP_EXE=%SCRIPT_DIR%env-roue\Scripts\pip.exe"

echo [3/4] Installation de la roue et de ses dependances avec pip...
"%PIP_EXE%" install "%ROUE_FILE%" --upgrade

echo.
echo [4/4] Verification de l'installation de la commande 'sentiment'...
"%PYTHON_EXE%" -m sentiment_app --version
if errorlevel 1 (
    echo [ERREUR] Echec lors de la verification.
    pause
    exit /b 1
)

REM Configuration du modele si present
set "MODELE_PATH="
if exist "%SCRIPT_DIR%sentiment.joblib" (
    set "MODELE_PATH=%SCRIPT_DIR%sentiment.joblib"
) else if exist "%SCRIPT_DIR%models\sentiment.joblib" (
    set "MODELE_PATH=%SCRIPT_DIR%models\sentiment.joblib"
) else if exist "C:\Users\assia\Downloads\sentiment.joblib" (
    set "MODELE_PATH=C:\Users\assia\Downloads\sentiment.joblib"
)

if not "%MODELE_PATH%"=="" (
    echo.
    echo [TEST] Execution d'une prediction avec le modele : %MODELE_PATH%
    set "SENTIMENT_MODELE=%MODELE_PATH%"
    "%PYTHON_EXE%" -m sentiment_app predict "Livraison rapide, produit conforme, tres satisfait"
)

echo.
echo =========================================================
echo   INSTALLATION REUSSIE AVEC SUCCES !
echo =========================================================
echo Pour utiliser la commande sentiment :
echo   "%PYTHON_EXE%" -m sentiment_app [predict^|serve^|ui]
echo =========================================================
pause
