# 🚗 Plan Maestro: Plataforma de Verificación Vehicular en México
> Documento de planificación estratégica y técnica para construir un competidor directo de TotalCheck.mx

---

## Tabla de Contenidos

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Análisis Competitivo](#2-análisis-competitivo)
3. [Propuesta de Valor Diferenciada](#3-propuesta-de-valor-diferenciada)
4. [Fuentes de Datos](#4-fuentes-de-datos)
5. [Arquitectura Técnica](#5-arquitectura-técnica)
6. [Stack Tecnológico](#6-stack-tecnológico)
7. [Estructura del Reporte](#7-estructura-del-reporte)
8. [Modelo de Negocio y Precios](#8-modelo-de-negocio-y-precios)
9. [Plan de Desarrollo por Fases](#9-plan-de-desarrollo-por-fases)
10. [Estrategia de Marketing y SEO](#10-estrategia-de-marketing-y-seo)
11. [Marco Legal y Cumplimiento](#11-marco-legal-y-cumplimiento)
12. [KPIs y Métricas](#12-kpis-y-métricas)
13. [Riesgos y Mitigaciones](#13-riesgos-y-mitigaciones)

---

## 1. Resumen Ejecutivo

### Contexto del Mercado

México es el principal mercado de autos seminuevos en Latinoamérica, con **6 millones de vehículos comercializados anualmente**. Al menos 1 de cada 3 puede presentar adeudos, accidentes o antecedentes negativos. Este mercado representa una oportunidad directa para una plataforma de verificación vehicular accesible, confiable y mejor posicionada digitalmente que los actores actuales.

### Objetivo

Construir una plataforma SaaS B2C (y eventualmente B2B) de verificación vehicular en México que supere a TotalCheck en:
- Cobertura de datos (más fuentes integradas)
- Experiencia de usuario (UX/UI moderno, rápido)
- Precio competitivo o modelo freemium
- SEO y presencia digital
- Cobertura nacional de adeudos y multas (no solo CDMX)

### Nombre sugerido del proyecto

`AutoVerifica.mx` / `CheckAuto.mx` / `VeriPlaca.mx` *(pendiente de validar disponibilidad de dominio)*

---

## 2. Análisis Competitivo

| Plataforma | Precio aprox. | Fuentes | Debilidades |
|---|---|---|---|
| **TotalCheck.mx** | ~$250 MXN | Gov + aseguradoras | Baja presencia social, sin app móvil |
| **CARFAX MX** | ~$199–$399 MXN | 28B eventos, USA/CAN/MX | Precio elevado para perfil básico |
| **REPUVE (gov)** | Gratis | Solo robo y estatus | Sin adeudos, sin accidentes |
| **Autofact MX** | ~$180–$350 MXN | Gov + aseguradoras | UX mejorable, sin app |
| **VERIMAX** | Freemium | REPUVE + algunas fuentes | App solo, sin web robusta |

### Oportunidades detectadas

- Ninguno ofrece un **plan freemium** sólido con datos básicos gratis
- Muy pocos tienen **cobertura nacional de adeudos** (más allá de CDMX y Edomex)
- El SEO de TotalCheck es débil (bajo tráfico orgánico estimado)
- No existe una plataforma con **API pública** para integradores (dealers, agencias)

---

## 3. Propuesta de Valor Diferenciada

### Para el consumidor (B2C)

- ✅ Reporte básico **GRATIS** (REPUVE + marca/modelo)
- ✅ Reporte completo desde **$99 MXN** (vs $250 de TotalCheck)
- ✅ Cobertura de adeudos en **más de 20 estados**
- ✅ Historial de accidentes con severidad y piezas afectadas
- ✅ Alertas de recalls / llamados a servicio
- ✅ Pedimento de importación (autos de USA/CAN)
- ✅ Descarga de reporte en PDF
- ✅ Sin necesidad de crear cuenta para consulta básica

### Para empresas (B2B)

- ✅ API REST con precios por volumen
- ✅ Widget embebible para concesionarios
- ✅ Dashboard de consultas masivas (CSV/batch)
- ✅ Integración con CRMs automotrices

---

## 4. Fuentes de Datos

### 4.1 Fuentes Gubernamentales Gratuitas / Públicas

#### REPUVE — Registro Público Vehicular
- **URL:** `https://www2.repuve.gob.mx/ciudadania`
- **Datos:** Marca, modelo, NIV, placa, reporte de robo (PGJ, OCRA, Procuraduría), estado de inscripción, país de origen, planta de ensamblaje
- **Acceso:** Web scraping o API no oficial disponible en RapidAPI
- **API terceros:** `apitude.co/repuve-vehicle-identification-mx` — Retorna datos en tiempo real del REPUVE
- **Costo:** Scraping propio = $0; API terceros = ~$0.05–$0.20 USD/consulta

#### SAF CDMX — Secretaría de Administración y Finanzas
- **URL:** `https://data.finanzas.cdmx.gob.mx/consulta_adeudos`
- **Datos:** Tenencia, refrendo, multas de tránsito, sanciones ambientales, Fotocívicas, tarjeta de circulación
- **API disponible:** `apitude.co/adeudos-mx` — Retorna adeudos por placa CDMX
- **Costo estimado:** API terceros ~$0.05 USD/consulta

#### SEFIN Estado de México
- **URL:** `https://sfpya.edomexico.gob.mx/controlv`
- **Datos:** Tenencia vehicular, refrendo de placas Edomex
- **Acceso:** Scraping con bypass de CAPTCHA (2Captcha / Anti-Captcha)

#### Otros estados (scrapers individuales por estado)
- Jalisco: `https://finanzas.jalisco.gob.mx/vehiculos`
- Nuevo León: Portal de Finanzas NL
- Guanajuato: `https://refrendo.guanajuato.gob.mx`
- Puebla, Querétaro, Veracruz: Portales estatales (scraping)

> ⚠️ **Nota:** La cobertura estatal es fragmentada. Empezar con CDMX + Edomex cubre ~40% del mercado objetivo.

#### SEDEMA CDMX — Verificación Vehicular
- **URL:** `https://data.finanzas.cdmx.gob.mx/sma/consulta_sedema`
- **Datos:** Historial de verificaciones ecológicas (hologramas, fechas)

### 4.2 APIs Comerciales de Terceros

#### AXSI.io
- **URL:** `https://axsi.io/api/`
- **Datos:** Marca, modelo, año, NIV, placa, estado del vehículo, reportes de robo en tiempo real
- **Formato:** REST JSON
- **Costo:** Consultar en su sitio (modelo por créditos)

#### PlacaAPI.mx
- **URL:** `https://www.placaapi.mx/`
- **Datos:** Búsqueda por placa, cubre México, USA y Sudamérica
- **Costo:** $3.50 MXN / $0.20 USD por consulta (mínimo 100 créditos)
- **Tecnología:** SOAP / REST compatible

#### RapidAPI — Informacion Vehiculos MX
- **URL:** `https://rapidapi.com/edgarfur-HNbCEGamI5C/api/informacion-vehiculos-de-mexico`
- **Datos:** REPUVE, PGJ, OCRA, datos técnicos del vehículo
- **Costo:** Plan freemium disponible

#### Apitude.co (Hub de APIs MX)
- **URL:** `https://apitude.co/es/`
- **APIs disponibles:**
  - `repuve-vehicle-identification-mx` — Datos REPUVE en tiempo real
  - `adeudos-mx` — Adeudos CDMX (tenencia, multas, fotocívicas)
- **Costo:** Suscripción mensual o por consumo

### 4.3 Datos de Aseguradoras (acceso indirecto)

Los accidentes provienen principalmente de bases de datos de aseguradoras. Para acceder a este tipo de datos:

- **Opción A:** Acuerdo comercial directo con aseguradoras (GNP, AXA, Qualitas, HDI)
- **Opción B:** Compra de datos a través de agregadores como **Solera** (propietarios de TotalCheck) o **LexisNexis Risk**
- **Opción C (MVP):** Integrar CARFAX MX API si ofrecen acceso B2B
- **Opción D:** Construir base propia a partir de reportes de siniestros públicos del INEGI y SSP

> 💡 **Recomendación para MVP:** Iniciar sin datos de accidentes propios. Mostrar "Historial de siniestros no disponible — próximamente". Incorporar esta data en Fase 2.

### 4.4 Datos de Valor Agregado

| Dato | Fuente | Notas |
|---|---|---|
| Precio de mercado (Libro Azul) | Kelley Blue Book MX / Autofact | API disponible o scraping |
| Recalls / Llamados a servicio | PROFECO + NHTSA (para autos USA) | Datos públicos descargables |
| Pedimento de importación | SAT / VUCEM | Scraping o API VUCEM |
| Especificaciones técnicas | Edmunds API / NHTSA VIN Decoder | API gratuita (para NIV USA) |
| Historial de placas | REPUVE + cruce estatal | Lógica interna |

---

## 5. Arquitectura Técnica

### Decisión de arquitectura: Microservicios con Spring Boot

Se elige una **arquitectura de microservicios** basada en Java + Spring Boot. Esta decisión se justifica por:

- Cada fuente de datos (REPUVE, adeudos, scrapers estatales) puede fallar de forma independiente sin tumbar el sistema completo
- Los scrapers y las llamadas a APIs externas son naturalmente lentos → el modelo reactivo de Spring WebFlux permite paralelismo sin bloqueo
- Escalar solo el servicio de scraping sin tocar el servicio de pagos o autenticación
- Java es fuertemente tipado, ideal para mantener contratos claros entre servicios

### Diagrama de arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                  CLIENTE (Web)                           │
│           React + Next.js (SSR para SEO)                 │
└──────────────────────┬──────────────────────────────────┘
                       │ HTTPS / REST + JSON
┌──────────────────────▼──────────────────────────────────┐
│              SPRING CLOUD GATEWAY                        │
│   Rate limiting · JWT Auth · Routing · Logging (Sleuth)  │
└───┬─────────────┬──────────────┬───────────┬────────────┘
    │             │              │           │
┌───▼───┐   ┌────▼────┐   ┌─────▼───┐  ┌───▼──────┐
│AUTH   │   │REPORTE  │   │PAGO     │  │NOTIF     │
│SERVICE│   │SERVICE  │   │SERVICE  │  │SERVICE   │
│Spring │   │Spring   │   │Spring   │  │Spring    │
│Security│  │WebFlux  │   │Boot     │  │Boot      │
│+ JWT  │   │(reactivo│   │Conekta  │  │SendGrid  │
└───┬───┘   └────┬────┘   └─────────┘  └──────────┘
    │            │
    │     ┌──────▼──────────────────────────────────┐
    │     │        ORQUESTADOR DE DATOS              │
    │     │   Spring WebFlux · Reactor (Mono/Flux)   │
    │     │   Llamadas paralelas con zipWith()       │
    │     └──┬──────┬──────┬──────┬──────┬──────────┘
    │        │      │      │      │      │
┌───┘   ┌───▼─┐ ┌──▼──┐ ┌─▼───┐ ┌▼────┐ ┌▼──────┐
│       │REPU │ │ADEU │ │SCRA │ │RECA │ │PRECIO │
│       │VE   │ │DOS  │ │PER  │ │LLS  │ │SERVICE│
│       │SVC  │ │SVC  │ │SVC  │ │SVC  │ │       │
│       │     │ │     │ │     │ │     │ └───────┘
│       └──┬──┘ └──┬──┘ └──┬──┘ └──┬──┘
│          │       │       │       │
│     ┌────▼───────▼───────▼───────▼──────────────┐
│     │              DATOS                         │
│     │  PostgreSQL (principal) · Redis (caché)    │
│     │  Apache Kafka (eventos async)              │
│     └────────────────────────────────────────────┘
│
└─── Keycloak (Identity Provider / OAuth2)
```

### Microservicios definidos

| Servicio | Tecnología | Responsabilidad |
|---|---|---|
| `gateway-service` | Spring Cloud Gateway | Enrutamiento, rate limiting, JWT validation |
| `auth-service` | Spring Security + Keycloak | Login, registro, OAuth2, gestión de tokens |
| `reporte-service` | Spring WebFlux | Orquestar consultas paralelas y ensamblar reporte |
| `repuve-service` | Spring Boot + WebClient | Consultar REPUVE vía Apitude/AXSI |
| `adeudos-service` | Spring Boot + WebClient | Consultar adeudos CDMX/Edomex/estados |
| `scraper-service` | Spring Boot + Selenium | Scrapers de portales gubernamentales con CAPTCHA bypass |
| `pago-service` | Spring Boot | Integración con Conekta y Stripe |
| `notif-service` | Spring Boot + Kafka | Envío de emails con PDF (SendGrid) |
| `pdf-service` | Spring Boot + iText/JasperReports | Generación de PDFs del reporte |

### Flujo de una consulta

```
1.  Usuario ingresa placa o NIV en el frontend
2.  Spring Cloud Gateway valida JWT y enruta a reporte-service
3.  reporte-service valida formato (regex por estado mexicano)
4.  Verifica caché Redis → si existe, retorna inmediatamente
5.  Si no hay caché, lanza llamadas paralelas con Reactor:
      Mono.zip(
        repuveService.consultar(placa),
        adeudosService.consultar(placa),
        scraperService.consultarEstado(placa),
        recallsService.consultar(vin),
        precioService.estimar(marca, modelo, anio)
      )
6.  Agrega resultados en objeto ReporteDTO
7.  Persiste resultado en PostgreSQL + cachea en Redis (TTL 24h)
8.  Publica evento en Kafka → pdf-service genera PDF async
9.  notif-service envía email con enlace de descarga
10. Respuesta JSON al frontend en < 4 segundos
```

### Patrón de resiliencia

Se usa **Circuit Breaker** con Resilience4j para cada llamada a APIs externas. Si REPUVE falla, el reporte continúa con los demás datos disponibles en lugar de fallar completamente.

```java
// Ejemplo de patrón aplicado en repuve-service
@CircuitBreaker(name = "repuve", fallbackMethod = "repuveFallback")
@TimeLimiter(name = "repuve")
public Mono<RepuveDTO> consultar(String placa) {
    return webClient.get()
        .uri("/repuve/{placa}", placa)
        .retrieve()
        .bodyToMono(RepuveDTO.class);
}

public Mono<RepuveDTO> repuveFallback(String placa, Throwable t) {
    return Mono.just(RepuveDTO.sinDatos("Fuente temporalmente no disponible"));
}
```

---

## 6. Stack Tecnológico

### Frontend

| Tecnología | Uso | Justificación |
|---|---|---|
| **Next.js 14** | Framework principal | SSR nativo = mejor SEO |
| **TypeScript** | Tipado | Mantenibilidad |
| **Tailwind CSS** | Estilos | Rapidez de desarrollo |
| **shadcn/ui** | Componentes UI | Diseño moderno y accesible |
| **React Query (TanStack)** | Fetching / caché | Optimización de re-renders |
| **Framer Motion** | Animaciones | UX premium |

> El frontend permanece en Next.js. Separar frontend (JS) de backend (Java) es la práctica estándar para este tipo de plataformas y permite escalar y desplegar cada capa de forma independiente.

---

### Backend — Java + Spring (núcleo del sistema)

#### Framework principal

| Tecnología | Versión | Uso |
|---|---|---|
| **Java** | 21 (LTS) | Lenguaje base — Virtual Threads (Project Loom) para alta concurrencia |
| **Spring Boot** | 3.3.x | Framework base de todos los microservicios |
| **Spring WebFlux** | Incluido en Boot | Programación reactiva para el orquestador de datos |
| **Spring Cloud Gateway** | 4.x | API Gateway — enrutamiento, rate limiting, JWT filter |
| **Spring Security** | 6.x | Seguridad, OAuth2 Resource Server, validación JWT |
| **Spring Data JPA** | Incluido | ORM con Hibernate para acceso a PostgreSQL |
| **Spring Data Redis** | Incluido | Abstracción sobre Redis para caché |
| **Spring Cloud OpenFeign** | 4.x | Clientes HTTP declarativos entre microservicios |
| **Spring Kafka** | Incluido | Productor/Consumidor de eventos Kafka |

#### Resiliencia y observabilidad

| Tecnología | Uso |
|---|---|
| **Resilience4j** | Circuit Breaker, Retry, TimeLimiter por cada fuente externa |
| **Micrometer + Prometheus** | Métricas de cada microservicio |
| **Grafana** | Dashboards de monitoreo |
| **Spring Cloud Sleuth + Zipkin** | Trazabilidad distribuida (trace IDs entre servicios) |
| **Logback + ELK Stack** | Logs estructurados (Elasticsearch + Kibana) |

#### Persistencia y caché

| Tecnología | Uso | Justificación |
|---|---|---|
| **PostgreSQL 16** | Base de datos principal | ACID, ideal para transacciones de pago y reportes |
| **Flyway** | Migraciones de esquema | Control de versiones del schema SQL |
| **Redis 7** | Caché de consultas (TTL 24h) | Evitar re-consultar APIs externas |
| **Hibernate** | ORM | Integrado con Spring Data JPA |

#### Mensajería asíncrona

| Tecnología | Uso |
|---|---|
| **Apache Kafka** | Eventos: reporte-generado → pdf-service → notif-service |
| **Schema Registry (Confluent)** | Validación de schemas Avro de los eventos Kafka |

#### Scraping y automatización

| Tecnología | Uso | Justificación |
|---|---|---|
| **Selenium 4 + WebDriverManager** | Scrapers de portales con CAPTCHA | Control total desde Java |
| **HtmlUnit** | Scrapers de portales simples (sin JS) | Más ligero que Selenium |
| **jsoup** | Parsing de HTML | Extracción de datos de respuestas HTML |
| **Spring Batch** | Procesamiento de consultas masivas (B2B batch) | Procesamiento robusto por lotes |

#### Generación de PDFs

| Tecnología | Uso |
|---|---|
| **iText 7** | Generación programática de PDFs del reporte |
| **JasperReports** | Alternativa con plantillas visuales `.jrxml` |

> **Recomendación:** Usar **iText 7** para el MVP (más simple de integrar). JasperReports para Fase 2 si se necesitan reportes más complejos con gráficas.

#### Autenticación

| Tecnología | Uso |
|---|---|
| **Keycloak** | Identity Provider (OAuth2/OIDC) — login, registro, refresh tokens |
| **Spring Security OAuth2 Resource Server** | Validación de tokens JWT en cada microservicio |

#### Build y gestión de dependencias

| Tecnología | Uso |
|---|---|
| **Maven 3.9** | Build tool — gestión de dependencias, multi-módulo |
| **Docker + Docker Compose** | Contenerización de todos los servicios |

> **Alternativa:** Gradle para proyectos que prefieran builds más rápidos. Maven se recomienda para equipos que priorizan convención sobre configuración.

---

### Infraestructura

| Tecnología | Fase | Uso |
|---|---|---|
| **Docker Compose** | MVP | Levantar todos los servicios localmente |
| **Railway** | MVP | Hosting inicial — soporta contenedores Docker |
| **Vercel** | MVP + | Frontend Next.js |
| **AWS ECS / Fargate** | Fase 2 | Orquestación de contenedores en producción |
| **AWS RDS (PostgreSQL)** | Fase 2 | Base de datos gestionada |
| **AWS ElastiCache (Redis)** | Fase 2 | Redis gestionado |
| **AWS MSK (Kafka)** | Fase 2 | Kafka gestionado |
| **Cloudflare** | MVP + | CDN + protección DDoS |
| **AWS S3 / Cloudflare R2** | MVP + | Almacenamiento de PDFs generados |

### Pagos

| Plataforma | Ventaja |
|---|---|
| **Conekta** | Líder en México, acepta OXXO, tarjetas nacionales e internacionales |
| **Stripe** | Fallback internacional, SDK Java oficial |
| **Mercado Pago** | Alta penetración en México, SDK Java disponible |

> 💡 **Recomendación:** Conekta como primario (acepta OXXO = mayor alcance demográfico) + Stripe como secundario. Ambos tienen SDKs Java oficiales.

### CAPTCHA Bypass (para scrapers)

| Servicio | Precio | Uso |
|---|---|---|
| **2Captcha** | ~$1 USD / 1000 CAPTCHAs | Scrapers gubernamentales desde Selenium |
| **Anti-Captcha** | Similar | Alternativa |
| **CapMonster Cloud** | Mayor control | Opción self-hosted |

### Estructura del proyecto Maven (multi-módulo)

```
vehiclecheck-platform/
├── pom.xml                        ← Parent POM
├── gateway-service/
│   └── pom.xml
├── auth-service/
│   └── pom.xml
├── reporte-service/               ← Orquestador principal (WebFlux)
│   └── pom.xml
├── repuve-service/
│   └── pom.xml
├── adeudos-service/
│   └── pom.xml
├── scraper-service/               ← Selenium + jsoup
│   └── pom.xml
├── pago-service/
│   └── pom.xml
├── pdf-service/                   ← iText 7
│   └── pom.xml
├── notif-service/                 ← Kafka consumer + SendGrid
│   └── pom.xml
├── common/                        ← DTOs, excepciones, utils compartidos
│   └── pom.xml
└── docker-compose.yml
```

---

## 7. Estructura del Reporte

El reporte final debe tener tres secciones principales:

### Sección A — Identificación del Vehículo
- Marca, submarca, modelo, año
- Tipo / clase (sedán, SUV, pick-up...)
- Color
- NIV / VIN (con validación de dígito verificador)
- Placa y estado de emplacado
- País de origen y planta de ensamblaje
- Fecha de primera inscripción REPUVE

### Sección B — Alertas y Riesgos
- 🔴 Reporte de robo activo (PGJ, OCRA, Procuraduría)
- 🔴 Reporte de vehículo recuperado
- 🟡 Autos provenientes de USA o Canadá (salvage title)
- 🟡 Adeudos de tenencia (por estado disponible)
- 🟡 Multas de tránsito pendientes
- 🟡 Sanciones ambientales / verificación vencida
- 🟢 Sin antecedentes negativos detectados

### Sección C — Información Adicional
- Historial de placas (si aplica)
- Pedimento de importación (si es auto importado)
- Recalls / llamados a servicio activos
- Precio estimado de mercado (Libro Azul)
- Especificaciones técnicas (cilindros, combustible, etc.)
- Historial de accidentes *(Fase 2)*

---

## 8. Modelo de Negocio y Precios

### B2C — Planes de Consumidor

| Plan | Precio | Contenido |
|---|---|---|
| **Gratis** | $0 | Marca, modelo, año + estatus de robo REPUVE |
| **Básico** | $59 MXN | Todo lo anterior + adeudos CDMX/Edomex + multas |
| **Completo** | $99 MXN | Todo + pedimento + recalls + precio de mercado + PDF |
| **Premium** | $149 MXN | Todo + historial de accidentes (Fase 2) |

> Comparativa: TotalCheck cobra ~$250 MXN por un reporte similar al "Completo".

### B2B — API y Empresas

| Plan | Precio | Consultas |
|---|---|---|
| **Starter** | $499 MXN/mes | 100 consultas/mes |
| **Business** | $1,999 MXN/mes | 500 consultas/mes |
| **Enterprise** | Cotización | Ilimitado + SLA |

### Ingresos adicionales
- **Afiliación de seguros:** Cobrar comisión al redirigir a cotizadores de seguros (Rastreator, Coru, comparadores)
- **Afiliación de dealers:** Mostrar autos verificados en venta
- **Publicidad contextual** (si el auto tiene recalls, mostrar talleres)

---

## 9. Plan de Desarrollo por Fases

### 🟢 Fase 1 — MVP (Mes 1–2)
**Objetivo:** Producto funcional mínimo con los datos más valiosos

- [ ] Setup del proyecto (Next.js + NestJS + PostgreSQL)
- [ ] Módulo REPUVE via API Apitude o AXSI
- [ ] Módulo adeudos CDMX (API Apitude)
- [ ] Sistema de pagos (Conekta + Stripe)
- [ ] Generación de PDF básico (Puppeteer)
- [ ] Landing page con SEO básico
- [ ] Deploy en Railway + Vercel
- [ ] Tests básicos (Jest + Playwright)

**Costo estimado Fase 1:** $15,000–$30,000 MXN (desarrollo propio) o $50,000–$80,000 MXN (agencia)

### 🟡 Fase 2 — Expansión de Datos (Mes 3–4)
**Objetivo:** Ampliar cobertura y diferenciar del competidor

- [ ] Scraper Edomex (tenencia/refrendo)
- [ ] Scraper estados clave (Jalisco, NL, Guanajuato)
- [ ] Módulo pedimento SAT
- [ ] Módulo recalls PROFECO/NHTSA
- [ ] Módulo precio de mercado (Libro Azul scraper)
- [ ] Caché inteligente con Redis
- [ ] Sistema de colas BullMQ para reportes grandes

### 🔵 Fase 3 — B2B y Escala (Mes 5–6)
**Objetivo:** Monetizar canal empresarial

- [ ] API pública con documentación (Swagger/OpenAPI)
- [ ] Dashboard empresarial (bulk queries)
- [ ] Widget embebible para dealers
- [ ] Panel de administración
- [ ] Alertas por email (recordatorio de verificación vencida)
- [ ] App móvil (React Native o PWA)

### 🟣 Fase 4 — Historial de Accidentes (Mes 7+)
**Objetivo:** Paridad total con TotalCheck / CARFAX

- [ ] Negociar acceso a datos de aseguradoras
- [ ] Integrar base de siniestros
- [ ] Modelo de ML para score de riesgo del vehículo

---

## 10. Estrategia de Marketing y SEO

### SEO (mayor oportunidad vs TotalCheck)

TotalCheck tiene presencia social mínima y su SEO es débil. Las palabras clave de alto volumen sin competidor dominante son:

**Keywords objetivo:**
- `verificar placas mexico` — Alto volumen
- `consulta vehicular gratis` — Alto intención
- `checar si un auto es robado` — Transaccional
- `adeudos vehiculares [estado]` — Long-tail por estado
- `historial de autos mexico` — Buyer intent
- `reporte vehicular mexico` — Buyer intent
- `consulta REPUVE gratis` — Alto volumen

**Estrategia de contenido:**
- Blog con guías de trámites vehiculares por estado
- Páginas de aterrizaje por estado: `/verificar/jalisco`, `/verificar/cdmx`, etc.
- Herramientas gratuitas que capturen leads: "Decodificador de NIV gratis"

### Canales de adquisición

| Canal | Estrategia | Prioridad |
|---|---|---|
| **SEO orgánico** | Contenido + backlinks | ⭐⭐⭐⭐⭐ |
| **Google Ads** | Keywords transaccionales | ⭐⭐⭐⭐ |
| **TikTok/Instagram** | Contenido viral (estafas de autos usados) | ⭐⭐⭐⭐ |
| **YouTube** | Tutoriales y casos reales | ⭐⭐⭐ |
| **Afiliados** | Comisión a canales de autos usados | ⭐⭐⭐ |
| **Facebook Ads** | Targeting compradores de autos | ⭐⭐⭐ |

### Posicionamiento de marca

- Slogan sugerido: *"Conoce la historia de tu próximo auto antes de comprarlo"*
- Propuesta: Más transparente, más accesible, más mexicano que CARFAX

---

## 11. Marco Legal y Cumplimiento

### Consideraciones clave

**Uso de datos públicos (scraping)**
El scraping de sitios gubernamentales (REPUVE, SAF, etc.) que ofrecen información de libre consulta ciudadana es generalmente permitido siempre que:
- No se vulneren sistemas de seguridad informática
- Se respete el `robots.txt`
- No se revelen datos personales sensibles del propietario
- Los datos se usen con fines informativos, no de vigilancia

**Aviso de privacidad (LFPDPPP)**
- El sitio debe tener un Aviso de Privacidad conforme a la Ley Federal de Protección de Datos Personales en Posesión de los Particulares
- No almacenar datos personales del propietario del vehículo
- Solo procesar placa/NIV del usuario para consulta

**Constitución de empresa**
- Constituir una SAPI de CV o S de RL de CV en México
- Registro ante el SAT como empresa de servicios de información
- Contrato de términos y condiciones claro: "Datos con fines informativos, sin validez legal"

**Disclaimer obligatorio (como TotalCheck y CARFAX)**
```
"La información presentada proviene de fuentes públicas y de terceros. 
No tiene validez legal ni oficial. Se recomienda confirmar 
con las autoridades competentes antes de cualquier transacción."
```

---

## 12. KPIs y Métricas

### Producto
| Métrica | Meta Mes 3 | Meta Mes 6 |
|---|---|---|
| Consultas totales | 500/mes | 5,000/mes |
| Tasa de conversión (free→pago) | 5% | 10% |
| Tiempo de respuesta del reporte | < 5 seg | < 3 seg |
| Uptime | 99% | 99.9% |

### Negocio
| Métrica | Meta Mes 3 | Meta Mes 6 |
|---|---|---|
| MRR | $5,000 MXN | $50,000 MXN |
| CAC (costo de adquisición) | < $80 MXN | < $50 MXN |
| LTV (valor del cliente) | $99 MXN | $200 MXN (B2B) |
| NPS | > 50 | > 65 |

### SEO
| Métrica | Meta Mes 3 | Meta Mes 6 |
|---|---|---|
| Posiciones top 10 Google | 5 keywords | 30 keywords |
| Tráfico orgánico | 1,000 visitas/mes | 15,000 visitas/mes |
| Backlinks de calidad | 10 | 50 |

---

## 13. Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| APIs externas (REPUVE) se caen o cambian | Alta | Alto | Múltiples proveedores + scraper propio de respaldo |
| CAPTCHA en portales gubernamentales se vuelve más difícil | Media | Medio | Contratar servicio CAPTCHA + caché agresivo |
| TotalCheck baja precios | Media | Medio | Diferenciarse en UX y cobertura, no solo precio |
| Datos incorrectos generan problemas legales | Baja | Alto | Disclaimer legal robusto + no garantizar exactitud |
| Regulación que restrinja el uso de datos vehiculares | Baja | Alto | Monitorear DOF, asesoría legal periódica |
| Baja conversión del plan gratis a pago | Alta | Alto | A/B test de precios, mejora continua del funnel |

---

## Apéndice A — Recursos y URLs Clave

### APIs y datos
- REPUVE consulta ciudadana: `https://www2.repuve.gob.mx/ciudadania`
- Apitude REPUVE API: `https://apitude.co/es/docs/services/repuve-vehicle-identification-mx/`
- Apitude Adeudos CDMX: `https://apitude.co/es/docs/services/adeudos-mx/`
- AXSI API: `https://axsi.io/api/`
- PlacaAPI.mx: `https://www.placaapi.mx/`
- RapidAPI Vehículos MX: `https://rapidapi.com/edgarfur-HNbCEGamI5C/api/informacion-vehiculos-de-mexico`
- SAF CDMX adeudos: `https://data.finanzas.cdmx.gob.mx/consulta_adeudos`
- SEDEMA verificación: `https://data.finanzas.cdmx.gob.mx/sma/consulta_sedema`
- NHTSA VIN Decoder (USA): `https://vpic.nhtsa.dot.gov/api/`
- PROFECO recalls: `https://www.profeco.gob.mx/automotriz/`

### Pagos MX
- Conekta: `https://conekta.com`
- OpenPay: `https://www.openpay.mx`
- Mercado Pago API: `https://www.mercadopago.com.mx/developers`

### CAPTCHA
- 2Captcha: `https://2captcha.com`
- Anti-Captcha: `https://anti-captcha.com`

### Competidores a monitorear
- TotalCheck: `https://landing.totalcheck.mx`
- CARFAX MX: `https://carfax.mx`
- Autofact: `https://www.autofact.com.mx`
- VERIMAX: App en Google Play / App Store

---

## Apéndice B — Estimación de Costos Operativos Mensuales (MVP)

| Concepto | Costo estimado MXN/mes |
|---|---|
| API Apitude (REPUVE + Adeudos) — 1,000 consultas | ~$800 |
| CAPTCHA service (2Captcha) | ~$200 |
| Hosting Railway + Vercel | ~$400 |
| Dominio + SSL | ~$150 (anual / 12) |
| Conekta (fee por transacción ~3%) | Variable |
| Total fijo MVP | **~$1,550 MXN/mes** |

> A partir de 200 reportes pagados a $99 MXN = $19,800 MXN de ingresos con costos de ~$2,500 MXN → margen bruto estimado >85%.

---

*Documento generado: Marzo 2026 — Versión 1.0*
*Revisar y actualizar trimestralmente conforme avance el proyecto.*
