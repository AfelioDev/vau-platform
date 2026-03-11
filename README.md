# ValidarAuto — Plataforma de Verificación Vehicular

Sistema de verificación vehicular mexicana. Permite consultar datos del **Registro Público Vehicular (REPUVE)** y **adeudos** (tenencia, multas, fotocívicas) de cualquier vehículo mediante su placa.

---

## Arquitectura

```
                         ┌─────────────────────────────────────────────┐
                         │              INTERNET / CLIENTES             │
                         └────────────────────┬────────────────────────┘
                                              │ HTTP :8080
                         ┌────────────────────▼────────────────────────┐
                         │           gateway-service (:8080)            │
                         │  Spring Cloud Gateway · Rate Limit · JWT Val │
                         └──────┬──────────┬──────────┬────────────────┘
                                │          │          │
               /api/auth/**     │          │          │  /api/repuve/**
                                │          │          │  /api/adeudos/**
         ┌──────────────────────▼──┐  ┌───▼──────────▼──────────────┐
         │   auth-service (:8081)   │  │   reporte-service (:8082)    │
         │  Spring MVC · JWT · PG  │  │  Spring WebFlux · R2DBC · PG │
         └──────────────────────────┘  │  Redis Cache · Kafka Events  │
                                        └──────┬───────────┬──────────┘
                                               │           │
                                 ┌─────────────▼──┐  ┌────▼───────────────┐
                                 │ repuve-service   │  │  adeudos-service    │
                                 │    (:8083)       │  │     (:8084)         │
                                 │ Spring MVC ·     │  │  Spring MVC ·       │
                                 │ Caffeine · CB    │  │  Caffeine · CB      │
                                 └──────────────────┘  └────────────────────┘
                                         │                      │
                                 ┌───────▼──────────────────────▼────────────┐
                                 │         APIs Externas (Modo Producción)     │
                                 │    REPUVE API          Adeudos API          │
                                 └────────────────────────────────────────────┘

   Infraestructura compartida:
   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
   │  PostgreSQL  │  │    Redis    │  │    Kafka    │
   │    :5432    │  │    :6379    │  │    :9092    │
   └─────────────┘  └─────────────┘  └─────────────┘
```

---

## Puertos de servicios

| Servicio           | Puerto | Tecnología principal              | Swagger UI                              |
|--------------------|--------|-----------------------------------|-----------------------------------------|
| `gateway-service`  | 8080   | Spring Cloud Gateway (WebFlux)    | N/A                                     |
| `auth-service`     | 8081   | Spring MVC + Security + JPA       | http://localhost:8081/swagger-ui.html   |
| `reporte-service`  | 8082   | Spring WebFlux + R2DBC            | http://localhost:8082/swagger-ui.html   |
| `repuve-service`   | 8083   | Spring MVC                        | http://localhost:8083/swagger-ui.html   |
| `adeudos-service`  | 8084   | Spring MVC                        | http://localhost:8084/swagger-ui.html   |

---

## Quick Start

### Levantar toda la plataforma con Docker Compose

```bash
# Desde la raíz del proyecto
docker compose up -d

# Verificar estado de los servicios
docker compose ps

# Ver logs de todos los servicios
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f auth-service
```

La plataforma estará lista cuando todos los servicios reporten `healthy` en `docker compose ps`.

### Flujo de uso básico

```bash
# 1. Registrar usuario
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ejemplo.mx","password":"Password123","nombre":"Test","apellido":"User"}'

# 2. Guardar el accessToken de la respuesta
TOKEN="eyJhbGciOiJIUzI1NiJ9..."

# 3. Generar un reporte vehicular
curl -X POST http://localhost:8080/api/reportes/consultar \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"placa":"ABC-123-D","planReporte":"BASICO"}'
```

---

## Resumen de endpoints API

| Método | Ruta (vía gateway :8080)             | Auth   | Descripción                         |
|--------|--------------------------------------|--------|-------------------------------------|
| POST   | `/api/auth/register`                 | No     | Registrar nuevo usuario             |
| POST   | `/api/auth/login`                    | No     | Login — obtener tokens JWT          |
| POST   | `/api/auth/refresh`                  | No     | Renovar access token                |
| GET    | `/api/auth/me`                       | JWT    | Perfil del usuario autenticado      |
| POST   | `/api/reportes/consultar`            | JWT    | Generar reporte vehicular completo  |
| GET    | `/api/reportes/{id}`                 | JWT    | Obtener reporte por UUID            |
| GET    | `/api/reportes/mis-reportes`         | JWT    | Listar reportes del usuario         |
| GET    | `/api/repuve/consultar/{placa}`      | No     | Consultar vehículo en REPUVE        |
| GET    | `/api/adeudos/consultar/{placa}`     | No     | Consultar adeudos del vehículo      |

---

## Variables de entorno

| Variable                  | Servicios que la usan                    | Valor por defecto                                        | Descripción                         |
|---------------------------|------------------------------------------|----------------------------------------------------------|-------------------------------------|
| `DB_HOST`                 | auth-service, reporte-service            | `postgres`                                               | Host de PostgreSQL                  |
| `DB_PORT`                 | auth-service, reporte-service            | `5432`                                                   | Puerto de PostgreSQL                |
| `DB_NAME`                 | auth-service, reporte-service            | `validarauto`                                            | Nombre de la base de datos          |
| `DB_USER`                 | auth-service, reporte-service            | `validarauto`                                            | Usuario de PostgreSQL               |
| `DB_PASSWORD`             | auth-service, reporte-service            | `validarauto123`                                         | Contraseña de PostgreSQL            |
| `JWT_SECRET`              | auth-service, reporte-service            | `validarauto-super-secret-key-...` (>= 256 bits)         | Clave HMAC-SHA256 para firmar JWT   |
| `JWT_ISSUER_URI`          | gateway-service                          | `http://auth-service:8081`                               | Emisor JWT para validación          |
| `JWT_JWK_SET_URI`         | gateway-service                          | `http://auth-service:8081/api/auth/.well-known/jwks.json`| JWK Set URI                        |
| `REDIS_HOST`              | gateway-service, reporte-service         | `redis`                                                  | Host de Redis                       |
| `REDIS_PORT`              | gateway-service, reporte-service         | `6379`                                                   | Puerto de Redis                     |
| `REDIS_PASSWORD`          | gateway-service, reporte-service         | *(vacío)*                                                | Contraseña de Redis                 |
| `KAFKA_BOOTSTRAP_SERVERS` | reporte-service                          | `kafka:9092`                                             | Kafka bootstrap servers             |
| `REPUVE_API_URL`          | repuve-service                           | *(vacío — activa modo demo)*                             | URL base del API externo REPUVE     |
| `REPUVE_API_KEY`          | repuve-service                           | *(vacío — activa modo demo)*                             | API key del proveedor REPUVE        |
| `REPUVE_SERVICE_URL`      | reporte-service                          | `http://repuve-service:8083`                             | URL interna del repuve-service      |
| `ADEUDOS_API_URL`         | adeudos-service                          | *(vacío — activa modo demo)*                             | URL base del API externo de adeudos |
| `ADEUDOS_API_KEY`         | adeudos-service                          | *(vacío — activa modo demo)*                             | API key del proveedor de adeudos    |
| `ADEUDOS_SERVICE_URL`     | reporte-service                          | `http://adeudos-service:8084`                            | URL interna del adeudos-service     |

---

## Modo Demo vs. Producción

Por defecto, los servicios de datos (repuve-service y adeudos-service) arrancan en **modo demo** cuando no tienen API keys configuradas. Esto permite desarrollar y probar sin necesidad de contratar acceso a las APIs externas.

### Activar modo producción para REPUVE:
```bash
export REPUVE_API_URL=https://api.proveedor-repuve.mx/v1
export REPUVE_API_KEY=tu-api-key-real
docker compose up -d repuve-service
```

### Activar modo producción para Adeudos:
```bash
export ADEUDOS_API_URL=https://api.proveedor-adeudos.mx/v1
export ADEUDOS_API_KEY=tu-api-key-real
docker compose up -d adeudos-service
```

---

## Estructura del proyecto

```
validarauto/
├── pom.xml                    # Parent POM (groupId: mx.validarauto, v1.0.0-SNAPSHOT)
├── docker-compose.yml         # Orquestación completa de la plataforma
├── common/                    # Módulo compartido: DTOs, excepciones, configs
├── gateway-service/           # Puerto 8080 — Spring Cloud Gateway
├── auth-service/              # Puerto 8081 — Autenticación JWT
├── reporte-service/           # Puerto 8082 — Orquestador reactivo (WebFlux)
├── repuve-service/            # Puerto 8083 — Consulta REPUVE
└── adeudos-service/           # Puerto 8084 — Consulta adeudos
```

---

## Tecnologías utilizadas

| Categoría         | Tecnología                                              |
|-------------------|---------------------------------------------------------|
| Framework base    | Spring Boot 3.3.4, Java 21                              |
| Servicios reactivos| Spring WebFlux, R2DBC, Reactor                        |
| Seguridad         | Spring Security, JJWT 0.12.6, OAuth2 Resource Server   |
| Persistencia      | Spring Data JPA (MVC), Spring Data R2DBC (WebFlux)      |
| Base de datos     | PostgreSQL                                              |
| Caché L1          | Caffeine (in-memory, repuve y adeudos)                  |
| Caché L2          | Redis (reporte-service, 24h TTL)                        |
| Mensajería        | Apache Kafka (eventos reporte.generado)                 |
| Circuit Breaker   | Resilience4j 2.2.0                                      |
| Migraciones DB    | Flyway (auth-service)                                   |
| Documentación API | SpringDoc OpenAPI 2.6.0                                 |
| Build             | Maven (multi-módulo)                                    |
| Contenedores      | Docker + Docker Compose                                 |
| Gateway           | Spring Cloud Gateway 2023.0.3                           |

---

## Swagger UI de cada servicio

Acceder directamente a cada servicio (no pasan por el gateway):

- Auth Service: http://localhost:8081/swagger-ui.html
- Reporte Service: http://localhost:8082/swagger-ui.html
- REPUVE Service: http://localhost:8083/swagger-ui.html
- Adeudos Service: http://localhost:8084/swagger-ui.html
