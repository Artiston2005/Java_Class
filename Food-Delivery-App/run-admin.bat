@echo off
echo Building Foodies Admin App...
cd /d "%~dp0"
call mvn compile -q
if errorlevel 1 (
    echo Build failed! Check Maven output.
    pause
    exit /b 1
)
echo Build successful. Resolving classpath...
call mvn dependency:build-classpath -Dmdep.outputFile=cp.txt -q
set /p CP=<cp.txt
echo Launching Admin Panel...
java -cp "target\classes;%CP%" com.foodapp.admin.AdminApp
