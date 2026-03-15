# ValidarAuto — Plataforma de Verificación Vehicular

Sistema de verificación vehicular mexicana. Permite consultar datos del **Registro Público Vehicular (REPUVE)**, estado de robo y **adeudos** (tenencia, multas, fotocívicas) de cualquier vehículo mediante su placa o NIV.

---

## Repositorios del proyecto

Cada módulo tiene su propio repositorio. Deben clonarse e instalarse en este orden:

| # | Módulo | Repositorio | Puerto |
|---|--------|-------------|--------|
| 1 | Platform (este repo) | [validarauto-platform](https://github.com/AfelioDev/validarauto-platform) | — |
| 2 | Common (DTOs compartidos) | [validarauto-common](https://github.com/AfelioDev/validarauto-common) | — |
| 3 | Gateway | [validarauto-gateway](https://github.com/AfelioDev/validarauto-gateway) | 8080 |
| 4 | Auth | [validarauto-auth](https://github.com/AfelioDev/validarauto-auth) | 8081 |
| 5 | Reporte | [validarauto-reporte](https://github.com/AfelioDev/validarauto-reporte) | 8082 |
| 6 | Repuve | [validarauto-repuve](https://github.com/AfelioDev/validarauto-repuve) | 8083 |
| 7 | Adeudos | [validarauto-adeudos](https://github.com/AfelioDev/validarauto-adeudos) | 8084 |

---

## Setup desde repos separados (primera vez)

```bash
# 1. Platform — instala el parent POM en ~/.m2
git clone https://github.com/AfelioDev/validarauto-platform.git
cd validarauto-platform
chmod +x bootstrap.sh && ./bootstrap.sh
cd ..

# 2. Common — instala el JAR compartido en ~/.m2
git clone https://github.com/AfelioDev/validarauto-common.git
cd validarauto-common
mvn install -q
cd ..

# 3. Compilar cada servicio de forma independiente
git clone https://github.com/AfelioDev/validarauto-auth.git
git clone https://github.com/AfelioDev/validarauto-gateway.git
git clone https://github.com/AfelioDev/validarauto-reporte.git
git clone https://github.com/AfelioDev/validarauto-repuve.git
git clone https://github.com/AfelioDev/validarauto-adeudos.git

for svc in validarauto-auth validarauto-gateway validarauto-reporte validarauto-repuve validarauto-adeudos; do
  cd $svc && mvn package -DskipTests -q && cd ..
done
```

## Levantar la infraestructura con Docker

```bash
# Desde validarauto-platform:
cp .env.example .env          # editar variables (ver sección Variables de entorno)
docker compose up -d
docker compose ps             # todos deben mostrar (healthy)
```

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
               /api/auth/**     │          │ /api/reports/**  /api/repuve/**
                                │          │          │       /api/adeudos/**
         ┌──────────────────────▼──┐  ┌───▼──────────▼──────────────┐
         │   auth-service (:8081)   │  │   reporte-service (:8082)    │
         │  Spring MVC · JWT · PG  │  │  Spring WebFlux · R2DBC · PG │
         └──────────────────────────┘  │  Redis Cache · Kafka Events  │
                                        └──────┬───────────┬──────────┘
                                               │           │
                                 ┌─────────────▼──┐  ┌────▼───────────────┐
                                 │ repuve-service   │  │  adeudos-service    │
                                 │    (:8083)       │  │     (:8084)         │
                                 └────────┬─────────┘  └────────────────────┘
                                          │
                                 ┌────────▼──────────────────────────────────┐
                                 │         placas.info API v2                  │
                                 │  REPUVE · PGJ · OCRA · RAPI · CarFax       │
                                 └────────────────────────────────────────────┘

   Infraestructura compartida:
   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
   │  PostgreSQL  │  │    Redis    │  │    Kafka    │
   │    :5432    │  │    :6379    │  │    :9092    │
   └─────────────┘  └─────────────┘  └─────────────┘
```

---

## Endpoints API

| Método | Ruta (vía gateway :8080)               | Auth | Descripción                         |
|--------|----------------------------------------|------|-------------------------------------|
| POST   | `/api/auth/register`                   | No   | Registrar usuario                   |
| POST   | `/api/auth/login`                      | No   | Login — obtener tokens JWT          |
| POST   | `/api/auth/refresh`                    | No   | Renovar access token                |
| GET    | `/api/auth/me`                         | JWT  | Perfil del usuario autenticado      |
| POST   | `/api/reports/generate`                | JWT  | Generar reporte vehicular           |
| GET    | `/api/reports/{id}`                    | JWT  | Obtener reporte por UUID            |
| GET    | `/api/reports/my-reports`             | JWT  | Listar reportes del usuario         |
| GET    | `/api/repuve/consultar/{licensePlate}` | No   | Consultar REPUVE + robo (placas.info) |
| GET    | `/api/adeudos/consultar/{licensePlate}`| No   | Consultar adeudos vehiculares       |

### Ejemplo rápido end-to-end

```bash
# Registrar usuario
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.mx","password":"Test1234!","firstName":"Juan","lastName":"García"}'

# Login y guardar token
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.mx","password":"Test1234!"}' \
  | jq -r '.data.accessToken')

# Consultar vehículo por placa (real, sin JWT requerido)
curl http://localhost:8080/api/repuve/consultar/G45BCB

# Generar reporte vehicular completo
curl -X POST http://localhost:8080/api/reports/generate \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"licensePlate":"G45BCB","reportPlan":"BASICO"}'
```

---

## Variables de entorno

Copia `.env.example` a `.env` y configura:

| Variable         | Descripción                                      | Default              |
|------------------|--------------------------------------------------|----------------------|
| `JWT_SECRET`     | Secreto HMAC-HS512 para firmar JWT (mín. 64 chars) | valor de ejemplo   |
| `PLACAS_TOKEN`   | Token de API de placas.info (REPUVE + robo)      | token de ejemplo     |
| `ADEUDOS_API_KEY`| API key para consulta de adeudos                 | *(vacío = demo)*     |
| `DB_PASSWORD`    | Contraseña PostgreSQL                            | `validarauto123`     |

> **Nota:** Si `PLACAS_TOKEN` está vacío, `repuve-service` arranca en **modo demo** con datos simulados.
> Si `ADEUDOS_API_KEY` está vacío, `adeudos-service` arranca en **modo demo**.

---

## Stack técnico

- **Java 21** · Spring Boot 4.0.3 · Spring Cloud 2025.1.1
- **PostgreSQL 16** · Redis 7 · Apache Kafka 3.7
- **Resilience4j 2.2.0** — circuit breakers en clientes externos
- **JJWT 0.12.6** — tokens HS512 (access 24h + refresh 7d)
- **OAS 3.0** como fuente de verdad para todos los DTOs (`openapi-generator-maven-plugin 7.6.0`)
- **Swagger UI** en cada servicio: `:808{1-4}/swagger-ui.html`
- **placas.info API v2** — datos reales REPUVE, PGJ, OCRA, RAPI, CarFax
