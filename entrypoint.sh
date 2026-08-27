#!/usr/bin/env bash
set -e

echo "Waiting for postgres to connect ..."

cd /app/src

# Wait for the database to be up and ready, if not ready, then sleep for 5 seconds
while ! nc -z db 5432; do
  echo "Running database check..."
  sleep 5
done

echo "PostgreSQL is active"

python manage.py collectstatic --noinput

python manage.py migrate
echo "Postgresql migrations finished"

if [ -n "${DJANGO_SUPERUSER_USERNAME}" ] && [ -n "${DJANGO_SUPERUSER_EMAIL}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD}" ]; then
    echo "Creating superuser ${DJANGO_SUPERUSER_USERNAME}..."
    python manage.py createsuperuser --noinput --username "$DJANGO_SUPERUSER_USERNAME" --email "$DJANGO_SUPERUSER_EMAIL" || true
fi

exec gunicorn tsa_app.wsgi:application --bind 0.0.0.0:8000 --workers 4
