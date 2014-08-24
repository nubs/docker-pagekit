#!/bin/bash
chown -R www-data:www-data /pagekit/storage /pagekit/app/cache

exec /usr/bin/supervisord