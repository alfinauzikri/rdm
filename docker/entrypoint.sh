#!/bin/sh

set -e

APP_DIR="/var/www/html"
TMP_DIR="/tmp/rdm"

if [ ! -f "${APP_DIR}/index.php" ]; then
    echo "[RDM] No application detected."
    
    if [ -z "${APP_SOURCE}" ]; then
        echo "[ERROR] APP_SOURCE is not defined."
        exit 1
    fi
    
    echo "[RDM] Downloading application..."
    
    mkdir -p "${TMP_DIR}"
    
    curl -fsSL "${APP_SOURCE}" -o /tmp/rdm.zip
    
    echo "[RDM] Extracting..."
    
    unzip -q /tmp/rdm.zip -d "${TMP_DIR}"
    
    if [ ! -f "${TMP_DIR}/index.php" ]; then
        echo "[ERROR] Invalid application package."
        exit 1
    fi
    
    echo "[RDM] Installing..."
    
    cp -a "${TMP_DIR}/." "${APP_DIR}/"
    
    chown -R www-data:www-data "${APP_DIR}"
    
    rm -rf "${TMP_DIR}" /tmp/rdm.zip
    
    echo "[RDM] Bootstrap completed."
else
    echo "[RDM] Existing installation detected."
fi

exec apache2-foreground