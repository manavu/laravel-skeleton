#!/bin/bash
set -e

# Fix permissions for storage and cache (no longer needed with user mapping)
# chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache 2>/dev/null || true

# Execute the main command
exec "$@"
