@echo off
setlocal

set "REPO_URL=https://github.com/Turnstone7512/Sudoku-Solver.git"
set "BRANCH=main"
set "COMMIT_MESSAGE=Update Sudoku Solver"

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Git is not installed or not found in PATH.
  echo Please install Git for Windows first: https://git-scm.com/download/win
  pause
  exit /b 1
)

if not exist ".git" (
  echo [INFO] Initializing Git repository...
  git init
  if errorlevel 1 goto :error
)

git branch -M %BRANCH%
if errorlevel 1 goto :error

git remote get-url origin >nul 2>nul
if errorlevel 1 (
  echo [INFO] Adding GitHub remote...
  git remote add origin "%REPO_URL%"
  if errorlevel 1 goto :error
) else (
  echo [INFO] Updating GitHub remote...
  git remote set-url origin "%REPO_URL%"
  if errorlevel 1 goto :error
)

echo [INFO] Staging files...
git add index.html push-to-github.cmd
if errorlevel 1 goto :error

git diff --cached --quiet
if not errorlevel 1 (
  echo [INFO] No new changes to commit.
) else (
  echo [INFO] Creating commit...
  git commit -m "%COMMIT_MESSAGE%"
  if errorlevel 1 goto :error
)

echo [INFO] Pushing to GitHub...
git push -u origin %BRANCH%
if errorlevel 1 goto :push_error

echo.
echo [DONE] Push completed successfully.
echo GitHub repo: https://github.com/Turnstone7512/Sudoku-Solver
pause
exit /b 0

:push_error
echo.
echo [ERROR] Push failed.
echo If this is your first push, make sure:
echo 1. The GitHub repo exists.
echo 2. You are signed in through Git Credential Manager or GitHub CLI.
echo 3. Your GitHub account has permission to push to Turnstone7512/Sudoku-Solver.
pause
exit /b 1

:error
echo.
echo [ERROR] Command failed. Please check the message above.
pause
exit /b 1
