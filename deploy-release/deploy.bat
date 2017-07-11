@echo off
set EXECUTABLE="%~dp0\build\exe.win-amd64-3.6\deploy.exe"
IF EXIST %EXECUTABLE% (
    "%~dp0\build\exe.win-amd64-3.6\deploy.exe"
) ELSE (
    @echo The file '\build\exe.win-amd64-3.6\deploy.exe' was not found.
)