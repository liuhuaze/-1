@echo off
setlocal enabledelayedexpansion

set "ARGS="
set "MODULE_PATH="
set "FIX_NEEDED=0"

for %%A in (%*) do (
    set "ARG=%%~A"
    echo !ARG! | findstr /C:"core-for-system-modules.jar" >nul 2>&1
    if !errorlevel! equ 0 (
        set "FIX_NEEDED=1"
        set "ORIG_JAR=%%~A"
        set "TEMP_JAR=%%~dpAcore-system-modules-fixed.jar"
        if not exist "!TEMP_JAR!" (
            copy "%%~A" "!TEMP_JAR!" >nul 2>&1
            "C:\Users\Administrator\AppData\Roaming\Badlion Client\Data\jdk-21.0.2\bin\jar.exe" xf "!TEMP_JAR!" META-INF/MANIFEST.MF 2>nul
            echo Automatic-Module-Name: core.system.modules>> META-INF\MANIFEST.MF
            "C:\Users\Administrator\AppData\Roaming\Badlion Client\Data\jdk-21.0.2\bin\jar.exe" uf "!TEMP_JAR!" META-INF/MANIFEST.MF 2>nul
            rd /s /q META-INF 2>nul
        )
        set "ARG=!TEMP_JAR!"
    )
    set "ARGS=!ARGS! !ARG!"
)

"C:\Users\Administrator\AppData\Roaming\Badlion Client\Data\jdk-21.0.2\bin\jlink.exe" !ARGS!
exit /b %errorlevel%