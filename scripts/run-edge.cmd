@echo off
setlocal
cd /d "%~dp0.."
set "DEADLINE_FLUTTER=%~dp0..\..\tools\flutter\bin\flutter.bat"
if not exist "%DEADLINE_FLUTTER%" set "DEADLINE_FLUTTER=flutter"
call "%DEADLINE_FLUTTER%" run -d edge --release --web-hostname localhost --web-port 8085 --dart-define-from-file=config/cloudinary.json
pause
