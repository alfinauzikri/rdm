# Rapor Digital Madrasah (RDM) Docker

Docker image untuk menjalankan **Rapor Digital Madrasah (RDM)** menggunakan:

- Apache 2
- PHP 7.2
- ionCube Loader PHP 7.2
- MySQL 5.7
- Auto Bootstrap
- Persistent Volume

Aplikasi RDM **tidak dibundel ke dalam image**.

Saat container pertama kali dijalankan, image akan mengunduh paket instalasi dari URL yang ditentukan melalui environment variable `APP_SOURCE`, kemudian mengekstraknya ke volume aplikasi.

---

## Features

- ✅ PHP 7.2 + Apache
- ✅ ionCube Loader PHP 7.2
- ✅ GD, ZIP, SOAP, mbstring, mysqli, PDO MySQL, sockets, exif
- ✅ OPcache enabled
- ✅ Automatic application bootstrap
- ✅ Persistent application storage
- ✅ Production-ready configuration
- ✅ Lightweight deployment

---

## Requirements

- Docker Engine 20+
- Docker Compose v2

---

# Quick Start

Clone repository:

```bash
git clone https://github.com/alfinauzikri/rdm.git
cd rdm
```

Start container:

```bash
docker compose up -d
```

Open browser:

```
http://localhost:8888
```

---

# Docker Compose

```yaml
services:
  rdm-app:
    image: alfinauzikri/rdm:latest
    ports:
      - "1024:80"
    environment:
      TZ: Asia/Jakarta
      APP_SOURCE: https://hdmadrasah.id/download/minihosting
    depends_on:
      - rdm-db
    volumes:
      - rdm_app:/var/www/html

  rdm-db:
    image: mysql:5.7
    restart: unless-stopped
    command: >
      --default-authentication-plugin=mysql_native_password
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --max_allowed_packet=512M
      --innodb-log-file-size=256M
      --innodb-buffer-pool-size=512M
    environment:
      MYSQL_ROOT_PASSWORD: rdm
      MYSQL_DATABASE: rdm
      MYSQL_USER: rdm
      MYSQL_PASSWORD: rdm
    volumes:
      - rdm_db:/var/lib/mysql

volumes:
  rdm_app:
  rdm_db:
```

---

# Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TZ` | `Asia/Jakarta` | Container timezone |
| `APP_SOURCE` | - | URL aplikasi RDM (.zip) |

---

# Default Database

| Variable | Value |
|----------|-------|
| Host | `rdm-db` |
| Port | `3306` |
| Database | `rdm` |
| Username | `rdm` |
| Password | `rdm` |

---

# How It Works

Saat container dijalankan:

```
Container Start
        │
        ▼
Check /var/www/html/index.php
        │
        ├──────────────► Exists
        │                  │
        │                  ▼
        │           Start Apache
        │
        ▼
Download APP_SOURCE
        │
        ▼
Extract ZIP
        │
        ▼
Copy to Volume
        │
        ▼
Start Apache
```

Bootstrap hanya dilakukan **sekali**.

Selanjutnya aplikasi akan dijalankan langsung dari Docker Volume.

---

# Persistent Storage

| Volume | Description |
|---------|-------------|
| `rdm_app` | Application files |
| `rdm_db` | MySQL database |

Menghapus container **tidak akan menghapus data** selama volume masih ada.

---

# Rebuild

```bash
docker compose build --no-cache
docker compose up -d
```

---

# Remove

Stop container:

```bash
docker compose down
```

Remove everything including volumes:

```bash
docker compose down -v
```

---

# Docker Hub

```bash
docker pull alfinauzikri/rdm:latest
```

---

# Image Architecture

```
                Docker Image
        ┌────────────────────────┐
        │ Apache + PHP 7.2       │
        │ ionCube Loader         │
        │ PHP Extensions         │
        │ Bootstrap Script       │
        └──────────┬─────────────┘
                   │
         Download APP_SOURCE
                   │
                   ▼
         Persistent Docker Volume
                   │
                   ▼
           RDM Application
```

---

# License

This repository only provides the runtime environment.

Rapor Digital Madrasah (RDM) remains the property of its respective authors and copyright holders.

This project does **not** redistribute or modify the original RDM application.
