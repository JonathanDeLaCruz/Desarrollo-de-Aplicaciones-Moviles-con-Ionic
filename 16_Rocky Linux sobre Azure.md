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

# 18. Subir el proyecto Yii2

El proyecto Yii2 debe quedar en:

```bash
/srv/public_html/yii2-app
```

Ejemplo si se clona desde Git:

```bash
cd /srv/public_html
git clone URL_DEL_REPOSITORIO yii2-app
```

La estructura esperada del proyecto debe ser similar a:

```text
/srv/public_html/yii2-app/
├── assets/
├── commands/
├── config/
├── controllers/
├── models/
├── runtime/
├── vendor/
├── views/
├── web/
│   └── index.php
├── composer.json
└── yii
```

---

# 19. Instalar dependencias con Composer

Si el proyecto no trae la carpeta `vendor`, ejecutar:

```bash
cd /srv/public_html/yii2-app
docker run --rm -v "$PWD":/app composer:2 install --no-dev --optimize-autoloader
```

---

# 20. Configurar permisos para Yii2

Yii2 necesita permisos de escritura en `runtime` y `web/assets`.

```bash
sudo chown -R $USER:$USER /srv/public_html/yii2-app
sudo chmod -R 775 /srv/public_html/yii2-app/runtime
sudo chmod -R 775 /srv/public_html/yii2-app/web/assets
```

Como el contenedor PHP usa normalmente el usuario `www-data`, reforzar permisos con:

```bash
sudo chown -R 33:33 /srv/public_html/yii2-app/runtime
sudo chown -R 33:33 /srv/public_html/yii2-app/web/assets
```

---

# 21. Levantar el proyecto Yii2

```bash
cd /srv/dockers/yii2-app
docker compose up -d --build
```

---

# 22. Verificar contenedores activos

```bash
docker ps
```

Debe aparecer algo similar a:

```text
reverse-proxy
yii2-nginx
yii2-php
```

---

# 23. Revisar logs

Logs del reverse proxy:

```bash
docker logs -f reverse-proxy
```

Logs del Nginx interno de Yii2:

```bash
docker logs -f yii2-nginx
```

Logs de PHP:

```bash
docker logs -f yii2-php
```

---

# 24. Probar desde el servidor

```bash
curl -I http://127.0.0.1
```

También puedes probar:

```bash
curl -I http://localhost
```

---

# 25. Probar desde navegador

Abrir en el navegador:

```text
http://IP_PUBLICA_DE_AZURE
```

Ejemplo:

```text
http://20.100.50.25
```

Debe cargar el proyecto Yii2 desde la carpeta:

```text
/srv/public_html/yii2-app/web
```

---

# Agregar MariaDB al proyecto Yii2 con Docker

## 1. Crear carpeta para persistencia de MariaDB

```bash
mkdir -p /srv/dockers/yii2-app/mariadb
```

---

## 2. Editar el docker-compose del proyecto Yii2

Abrir el archivo:

```bash
nano /srv/dockers/yii2-app/docker-compose.yml
```

Reemplazar el contenido por este:

```yaml
services:
  yii2-db:
    image: mariadb:11.4
    container_name: yii2-db
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: RootPasswordSeguro123
      MARIADB_DATABASE: yii2_db
      MARIADB_USER: yii2_user
      MARIADB_PASSWORD: Yii2PasswordSeguro123
    volumes:
      - /srv/dockers/yii2-app/mariadb:/var/lib/mysql
    networks:
      - yii2-net
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5

  yii2-php:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: yii2-php
    restart: unless-stopped
    depends_on:
      yii2-db:
        condition: service_healthy
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

## 3. Cambiar contraseñas

Antes de levantar el contenedor, cambia estos valores:

```yaml
MARIADB_ROOT_PASSWORD: RootPasswordSeguro123
MARIADB_DATABASE: yii2_db
MARIADB_USER: yii2_user
MARIADB_PASSWORD: Yii2PasswordSeguro123
```

Ejemplo recomendado:

```yaml
MARIADB_ROOT_PASSWORD: Cambia_Esta_Root_2026
MARIADB_DATABASE: sistema_db
MARIADB_USER: sistema_user
MARIADB_PASSWORD: Cambia_Esta_User_2026
```

---

## 4. Levantar MariaDB junto con Yii2

```bash
cd /srv/dockers/yii2-app
docker compose up -d --build
```

---

## 5. Verificar que MariaDB esté activo

```bash
docker ps
```

Debe aparecer:

```text
yii2-db
yii2-php
yii2-nginx
reverse-proxy
```

Revisar logs de MariaDB:

```bash
docker logs -f yii2-db
```

---

## 6. Entrar a MariaDB desde el contenedor

```bash
docker exec -it yii2-db mariadb -u root -p
```

Te pedirá la contraseña definida en:

```yaml
MARIADB_ROOT_PASSWORD
```

Dentro de MariaDB puedes probar:

```sql
SHOW DATABASES;
SELECT User, Host FROM mysql.user;
```

Para salir:

```sql
exit;
```

---

# Nota importante

No uses `localhost` en la configuración de Yii2.

Dentro de Docker, Yii2 debe conectarse usando el nombre del servicio:

```text
yii2-db
```

Correcto:

```php
'dsn' => 'mysql:host=yii2-db;dbname=yii2_db;charset=utf8mb4',
```

Incorrecto:

```php
'dsn' => 'mysql:host=localhost;dbname=yii2_db;charset=utf8mb4',
```

Porque `localhost` dentro del contenedor `yii2-php` apunta al propio contenedor PHP, no al contenedor de MariaDB.
