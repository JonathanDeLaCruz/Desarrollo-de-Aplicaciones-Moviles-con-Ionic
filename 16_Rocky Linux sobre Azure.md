# Instalación de Docker + PHP 8.2 + Yii2 + Nginx Reverse Proxy en Rocky Linux sobre Azure

## Objetivo

Configurar una máquina virtual limpia con Rocky Linux en Azure para ejecutar un proyecto Yii2 usando Docker, PHP 8.2 FPM y Nginx como reverse proxy.

La arquitectura será:

```text
Internet / IP pública de Azure
        ↓ puerto 80
Nginx Reverse Proxy Docker
        ↓ red interna Docker
Nginx del proyecto Yii2
        ↓ FastCGI
PHP 8.2 FPM
        ↓
Código Yii2
```

---

# 1. Actualizar Rocky Linux e instalar paquetes base

```bash
sudo dnf update -y
sudo dnf install -y dnf-utils git nano curl unzip
```

---

# 2. Agregar repositorio oficial de Docker

```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

---

# 3. Instalar Docker y Docker Compose

```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

# 4. Habilitar e iniciar Docker

```bash
sudo systemctl enable --now docker
```

---

# 5. Agregar el usuario actual al grupo docker

```bash
sudo usermod -aG docker $USER
```

Después de ejecutar este comando, cerrar sesión SSH y volver a entrar.

Verificar Docker:

```bash
docker --version
docker compose version
docker ps
```

---

# 6. Abrir puertos HTTP y HTTPS en Rocky Linux

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

---

# 7. Abrir puertos en Azure

En el **Network Security Group** de la máquina virtual, abrir:

```text
Puerto 80  TCP
Puerto 443 TCP
```

Por ahora se usará solamente el puerto 80 porque todavía no se usará dominio.

---

# 8. Crear estructura de carpetas

```bash
sudo mkdir -p /srv/dockers/proxy/conf.d
sudo mkdir -p /srv/dockers/yii2-app
sudo mkdir -p /srv/public_html/yii2-app

sudo chown -R $USER:$USER /srv/dockers
sudo chown -R $USER:$USER /srv/public_html
```

La estructura quedará así:

```text
/srv/
├── dockers/
│   ├── proxy/
│   │   ├── docker-compose.yml
│   │   └── conf.d/
│   │       └── yii2-app.conf
│   └── yii2-app/
│       ├── docker-compose.yml
│       ├── Dockerfile
│       ├── nginx/
│       │   └── default.conf
│       └── php/
│           └── custom.ini
└── public_html/
    └── yii2-app/
        └── aquí va el proyecto Yii2
```

---

# 9. Crear red externa para el reverse proxy

```bash
docker network create proxy-net
```

Esta red servirá para conectar varios proyectos al mismo Nginx reverse proxy.

---

# 10. Crear configuración del Nginx Reverse Proxy

Crear el archivo:

```bash
nano /srv/dockers/proxy/docker-compose.yml
```

Agregar el siguiente contenido:

```yaml
services:
  reverse-proxy:
    image: nginx:1.27-alpine
    container_name: reverse-proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /srv/dockers/proxy/conf.d:/etc/nginx/conf.d:ro
    networks:
      - proxy-net

networks:
  proxy-net:
    external: true
```

---

# 11. Crear configuración temporal para acceder por IP pública

Crear el archivo:

```bash
nano /srv/dockers/proxy/conf.d/yii2-app.conf
```

Agregar el siguiente contenido:

```nginx
server {
    listen 80;
    server_name _;

    client_max_body_size 50M;

    location / {
        proxy_pass http://yii2-nginx:80;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

# 12. Levantar el reverse proxy

```bash
cd /srv/dockers/proxy
docker compose up -d
```

Verificar:

```bash
docker ps
docker logs reverse-proxy
```

---

# 13. Crear carpetas para la configuración del proyecto Yii2

```bash
mkdir -p /srv/dockers/yii2-app/nginx
mkdir -p /srv/dockers/yii2-app/php
```

---

# 14. Crear Dockerfile para PHP 8.2 FPM

Crear el archivo:

```bash
nano /srv/dockers/yii2-app/Dockerfile
```

Agregar el siguiente contenido:

```dockerfile
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    libpq-dev \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mysqli \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        intl \
        zip \
        opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY php/custom.ini /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html
```

---

# 15. Crear configuración personalizada de PHP

Crear el archivo:

```bash
nano /srv/dockers/yii2-app/php/custom.ini
```

Agregar el siguiente contenido:

```ini
upload_max_filesize=50M
post_max_size=50M
memory_limit=512M
max_execution_time=300
date.timezone=America/Mexico_City

opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=10000
opcache.validate_timestamps=1
```

---

# 16. Crear configuración de Nginx interno para Yii2

Crear el archivo:

```bash
nano /srv/dockers/yii2-app/nginx/default.conf
```

Agregar el siguiente contenido:

```nginx
server {
    listen 80;
    server_name _;

    root /var/www/html/web;
    index index.php index.html;

    client_max_body_size 50M;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri =404;

        fastcgi_pass yii2-php:9000;
        fastcgi_index index.php;

        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $document_root;
    }

    location ~ /\.(ht|svn|git) {
        deny all;
    }
}
```

---

# 17. Crear docker-compose del proyecto Yii2

Crear el archivo:

```bash
nano /srv/dockers/yii2-app/docker-compose.yml
```

Agregar el siguiente contenido:

```yaml
services:
  yii2-php:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: yii2-php
    restart: unless-stopped
    volumes:
      - /srv/public_html/yii2-app:/var/www/html
    networks:
      - yii2-net

  yii2-nginx:
    image: nginx:1.27-alpine
    container_name: yii2-nginx
    restart: unless-stopped
    depends_on:
      - yii2-php
    volumes:
      - /srv/public_html/yii2-app:/var/www/html:ro
      - /srv/dockers/yii2-app/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    networks:
      - yii2-net
      - proxy-net

networks:
  yii2-net:
    driver: bridge

  proxy-net:
    external: true
```

---
