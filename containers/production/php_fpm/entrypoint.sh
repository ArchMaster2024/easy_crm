#!/bin/bash

cd /srv/backend

echo "Verify if the .env file exists"

if [[ ! -f /srv/backend/.env ]]; then
    echo "The .env file doesn't exist, copying the .env.example file"

    cp /srv/backend/.env.example /srv/backend/.env

    echo "The .env file has been copied"
    echo "Prepare the .env file for production"

    sed -i "s/APP_ENV=local/APP_ENV=production/g" /srv/backend/.env
    sed -i "s/APP_DEBUG=true/APP_DEBUG=false/g" /srv/backend/.env

    echo "The .env file has been prepared"
    echo "Prepare the backend for connect with database"

    sed -i "s/DB_CONNECTION=sqlite/DB_CONNECTION=pgsql/g" /srv/backend/.env
    sed -i "s/DB_HOST=127.0.0.1/DB_HOST=backend_database/g" /srv/backend/.env
    sed -i "s/DB_PORT=3306/DB_PORT=5432/g" /srv/backend/.env
    sed -i "s/DB_DATABASE=laravel/DB_DATABASE=easy_crm/g" /srv/backend/.env
    sed -i "s/DB_USERNAME=root/DB_USERNAME=postgres/g" /srv/backend/.env
    sed -i "s/DB_PASSWORD=/DB_PASSWORD=postgres/g" /srv/backend/.env

    echo "Backend is ready for connect with database"
else
    echo "The .env file already exists"
fi

echo "Verify if key exists"

if [[ ! grep -q "APP_KEY=.+" /srv/backend/.env ]]; then
    echo "The key doesn't exist, generating the key"
    
    php artisan key:generate

    echo "The key has been generated"
else
    echo "The key already exists"
else

php artisan optimize

echo "Change the name of checkhealth route name"

sed -i "s/health: '/up'/health: '/status'/g" /srv/backend/bootstrap/app.php

echo "Name changed from /up to /status"

echo "Check php-fpm helth"

php-fpm-healthcheck

echo $?

echo "Start the php-fpm server"

exec "$@"
