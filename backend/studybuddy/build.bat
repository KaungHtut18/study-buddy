@echo off
echo Building Study Buddy Docker image...
docker build -t study-buddy:latest .
if %ERRORLEVEL% EQU 0 (
    echo Build complete!
) else (
    echo Build failed!
)
pause
