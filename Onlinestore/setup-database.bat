@echo off
echo Setting up Coffee Haven Database...
echo.

REM Check if MySQL is running
echo Checking MySQL connection...
mysql -h localhost -P 3310 -u root -p2000 -e "SELECT 'MySQL connection successful!' as Status;" 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to MySQL. Please ensure:
    echo 1. MySQL is running on localhost:3310
    echo 2. Username: root, Password: 2000
    echo 3. Or update the connection details in the script
    pause
    exit /b 1
)

echo MySQL connection successful!
echo.

REM Create the database and tables
echo Creating database and tables...
mysql -h localhost -P 3310 -u root -p2000 < database-setup.sql
if %errorlevel% neq 0 (
    echo ERROR: Failed to create database tables
    pause
    exit /b 1
)

echo.
echo Database setup completed successfully!
echo.
echo You can now run the application with: dotnet run
echo.
pause