#!/bin/bash

echo "Check if project exists"

if [[ ! -d "/srv/backend/app" ]]; then
    echo "Project does not exist, proceeding to create it"

    composer create-project --prefer-dist laravel/laravel /srv/backend/example_app
    
    mv /srv/backend/example_app/{*,.*} /srv/backend

    rm -rf /srv/backend/example_app

    echo "Project created"
else
    echo "Project exists"
fi

echo "Check if .env file exists"

if [[ ! -f "/srv/backend/.env" ]]; then
    echo "File does not exist, proceeding to create it"

    cp /srv/backend/.env.example /srv/backend/.env

    echo "File created"

    echo "Prepare database configuration"

    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/' /srv/backend/.env
    sed -i 's/# DB_HOST=127.0.0.1/DB_HOST=backend_database/' /srv/backend/.env
    sed -i 's/# DB_PORT=3306/DB_PORT=5432/' /srv/backend/.env
    sed -i 's/# DB_DATABASE=laravel/DB_DATABASE=easy_crm/' /srv/backend/.env
    sed -i 's/# DB_USERNAME=root/DB_USERNAME=postgres/' /srv/backend/.env
    sed -i 's/# DB_PASSWORD=/DB_PASSWORD=postgres/' /srv/backend/.env

    echo "Database configuration prepared"

    echo "Generate app key"

    php /srv/backend/artisan key:generate

    echo "App key generated"

    echo "Loading migrations"

    php /srv/backend/artisan migrate
else
    echo "File exists"
fi

echo "Setting permissions"

chown -R www:www /srv/backend/storage
chown -R www:www /srv/backend/bootstrap/cache

echo "Permissions set"

echo "Start the php-fpm server"

exec "$@"
