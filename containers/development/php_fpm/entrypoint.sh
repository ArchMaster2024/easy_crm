#!/bin/bash

cd /srv/backend

echo "Check if project exists"

if [[ ! -d "app" ]]; then
    echo "Project does not exist, proceeding to create it"

    composer create-project --prefer-dist laravel/laravel example-app

    rm example-app/README.md
    
    mv example-app/{*,.*} ./

    rm -rf example-app

    echo "Project created"
else
    echo "Project exists"
fi

echo "Check if .env file exists"

if [[ ! -f ".env" ]]; then
    echo "File does not exist, proceeding to create it"

    cp .env.example .env

    echo "File created"

    echo "Prepare database configuration"

    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/' .env
    sed -i 's/# DB_HOST=127.0.0.1/DB_HOST=backend_database/' .env
    sed -i 's/# DB_PORT=3306/DB_PORT=5432/' .env
    sed -i 's/# DB_DATABASE=laravel/DB_DATABASE=easy_crm/' .env
    sed -i 's/# DB_USERNAME=root/DB_USERNAME=postgres/' .env
    sed -i 's/# DB_PASSWORD=/DB_PASSWORD=postgres/' .env

    echo "Database configuration prepared"

    echo "Generate app key"

    php artisan key:generate

    echo "App key generated"

    echo "Loading migrations"

    php artisan migrate
else
    echo "File exists"
fi

echo "Setting permissions"

chown -R storage
chown -R bootstrap/cache

echo "Permissions set"

echo "Check if php-fpm is running"

php-fpm-healthcheck

echo $?

echo "Start the php-fpm server"

exec "$@"
