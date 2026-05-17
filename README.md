# Despliegue y CI/CD en Railway

## Autor

**Nombre:** Jhoseth Esneider Rozo Carrillo  
**Código:** 02230131027  
**Programa:** Ingeniería de Sistemas  
**Unidad:** Unidad 12 – Despliegue y CI/CD
**Actividad:** Post-Contenido 1
**Fecha:** 16/05/2026

---

## Descripción del Proyecto

Este proyecto implementa la contenedorización de una aplicación Spring Boot mediante Docker y su orquestación local con Docker Compose. Adicionalmente, el proyecto se despliega en producción utilizando la plataforma Railway con una base de datos PostgreSQL.

Se integran mecanismos de despliegue modernos como:

- **Dockerfile Multi-Stage** para optimizar el tamaño de la imagen.
- **Docker Compose** para orquestar la app y PostgreSQL en entorno local.
- **Railway** para el despliegue público y aprovisionamiento automático de base de datos.

El objetivo es garantizar un ambiente de producción consistente y automatizar el proceso de construcción.

---

## Objetivo

Implementar un sistema de despliegue que permita:

- Separar el entorno de construcción (JDK) del de ejecución (JRE).
- Configurar variables de entorno y perfiles para producción.
- Ejecutar la aplicación de forma local con Docker Compose junto a una base de datos PostgreSQL real.
- Desplegar la aplicación y la base de datos en Railway con endpoints públicos.

---

## Prerrequisitos

Antes de ejecutar el proyecto, asegúrate de tener:

- Docker Desktop instalado y en ejecución.
- Maven 3.8+ o utilizar el wrapper incluido (`mvnw`).
- Cuenta gratuita en Railway (railway.app) vinculada a GitHub.
- JDK 21 (opcional para pruebas locales sin Docker).

---

## Estructura del Proyecto

```text
/
├── .mvn/                   # Maven Wrapper
├── src/                    # Código fuente Spring Boot
│   ├── main/java/...       # Controladores, Entidades, Repositorios
│   └── main/resources/     # application.properties, application-prod.properties
├── Dockerfile              # Configuración Multi-Stage
├── .dockerignore           # Exclusiones de Docker
├── docker-compose.yml      # Orquestación local (App + PostgreSQL)
└── pom.xml                 # Dependencias Maven
```

## Funciones principales (Endpoints):

- `GET /api/productos` → Retorna la lista de productos
- `POST /api/productos` → Crea un nuevo producto
- `GET /actuator/health` → Verifica la salud de la aplicación y conexión a DB

---

## Componentes de Despliegue

### 1. Dockerfile Multi-Stage

- **Decisión de diseño:**
  Se usa `eclipse-temurin:21-jdk-alpine` para la compilación aprovechando la caché de Maven y `eclipse-temurin:21-jre-alpine` para producción. Esto reduce drásticamente el tamaño de la imagen final (menos de 300MB) y elimina herramientas innecesarias en el contenedor de producción. Además, se ejecuta con el usuario no root `spring` por motivos de seguridad.

### 2. Docker Compose

- **Decisión de diseño:**
  Se define la base de datos PostgreSQL 16 con un `healthcheck` para garantizar que la app no inicie hasta que la base de datos esté lista para aceptar conexiones (`condition: service_healthy`).

### 3. application-prod.properties

- **Decisión de diseño:**
  Se exteriorizan las credenciales y URL de conexión usando variables de entorno (`DATABASE_URL`, `DB_USER`, `DB_PASS`) para no exponer secretos en el código fuente.

---

## Ejecución del Proyecto (Local)

1. Clonar repositorio:
   ```bash
   git clone https://github.com/jerc31/rozo-post1-u12.git
   cd rozo-post1-u12
   ```

2. Ejecutar con Docker Compose:
   ```bash
   docker compose up -d --build
   ```

3. Verificar estado:
   ```bash
   docker compose ps
   ```

4. Probar endpoints:
   - `http://localhost:8080/actuator/health`
   - `http://localhost:8080/api/productos`

---

## Checkpoints y Verificaciones

✓ **Checkpoint 1: Verificación de Dockerfile**
- Comando: `docker build -t mi-app:local .`
- Comando: `docker images`
- *La imagen pesa menos de 300MB y compila sin errores.*

✓ **Checkpoint 2: Orquestación Local**
- Comando: `docker compose up -d --build`
- *Los contenedores están Up/Healthy y el healthcheck retorna {"status":"UP"}.*

✓ **Checkpoint 3: Despliegue en Railway**
- *La aplicación está en Railway, conectada a PostgreSQL aprovisionado desde la nube, y las variables de entorno están correctamente configuradas.*

---

## Evidencias

Las siguientes evidencias se encuentran en la carpeta `/evidencias/`:

- Captura de `docker build` (tamaño de la imagen).
- Captura de `docker compose ps` y el log del healthcheck.
- Capturas del despliegue en el panel de Railway y endpoints funcionando públicamente.
