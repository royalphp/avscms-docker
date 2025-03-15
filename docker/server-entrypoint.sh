#!/bin/sh
set -e

BASE_DIR="/var/www/html"

PATHS="
/include/config.local.php
/cache/frontend
/cache/backend
/images/logo
/images/notice_images
/images/notice_images/thumbs
/media/albums
/media/categories/album
/media/categories/video
/media/csv
/media/photos
/media/photos/tmb
/media/player/logo
/media/users
/media/users/orig
/media/videos/tmb
/media/videos/vid
/media/videos/h264
/templates/backend/default/analytics/analytics.tpl
/templates/emails
/templates/emails/*.tpl
/templates/frontend/**/static/*.tpl
/tmp/albums
/tmp/avatars
/tmp/downloads
/tmp/logs
/tmp/sessions
/tmp/thumbs
/tmp/uploader
/aembed.sh
"

set_permissions() {
    path="$1"

    if [ -d "$path" ]; then
        echo "Setting permissions for directory: $path"
        chmod -R 0777 "$path"
        chown -R www-data:www-data "$path"
    elif [ -f "$path" ]; then
        echo "Setting permissions for file: $path"
        chmod 0777 "$path"
        chown www-data:www-data "$path"
    else
        echo "Path not found or unsupported type: $path"
    fi
}

for path in $PATHS; do
    if echo "$path" | grep -q '\*'; then
        find "${BASE_DIR}" -path "${BASE_DIR}${path}" -type f 2>/dev/null | while read -r full_path; do
            set_permissions "$full_path"
        done
    else
        set_permissions "${BASE_DIR}${path}"
    fi
done
