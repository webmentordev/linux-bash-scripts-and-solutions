#!/bin/bash

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "PHP is not installed on this system."
    exit 1
fi

# Extract and clean up the version number
PHP_VERSION=$(php -r 'echo PHP_VERSION;')
PHP=$(echo $PHP_VERSION | sed 's/\([0-9]*\.[0-9]*\).*/\1/')

echo $PHP