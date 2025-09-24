#!/bin/bash

echo "Setting up Coffee Haven Database..."
echo

# Check if MySQL is running
echo "Checking MySQL connection..."
if mysql -h localhost -P 3310 -u root -p2000 -e "SELECT 'MySQL connection successful!' as Status;" 2>/dev/null; then
    echo "MySQL connection successful!"
else
    echo "ERROR: Cannot connect to MySQL. Please ensure:"
    echo "1. MySQL is running on localhost:3310"
    echo "2. Username: root, Password: 2000"
    echo "3. Or update the connection details in this script"
    exit 1
fi

echo

# Create the database and tables
echo "Creating database and tables..."
if mysql -h localhost -P 3310 -u root -p2000 < database-setup.sql; then
    echo
    echo "Database setup completed successfully!"
    echo
    echo "You can now run the application with: dotnet run"
    echo
else
    echo "ERROR: Failed to create database tables"
    exit 1
fi