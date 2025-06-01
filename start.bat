@echo off
ruby -v >nul 2>&1
if errorlevel 1 (
  echo Ruby yüklü değil. Lutfen Ruby'yi kurun.
  pause
  exit /b
)

cd /d "%~dp0"
ruby manager.rb
pause
