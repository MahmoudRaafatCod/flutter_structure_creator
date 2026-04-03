@echo off
echo ================================
echo   Flutter Structure Creator
echo ================================
echo.
echo What would you like to do?
echo   1. Create a new Flutter project
echo   2. Add a new feature folder
echo.
set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" (
    dart flutter_structure_creator.dart
) else if "%choice%"=="2" (
    dart create_feature.dart
) else (
    echo.
    echo Invalid choice. Please enter 1 or 2.
)

pause
