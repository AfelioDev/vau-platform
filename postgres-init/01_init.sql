-- ValidarAuto Platform - Full Database Schema Init
-- Runs automatically on first postgres startup

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── Users (auth-service) ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    role        VARCHAR(20)  NOT NULL DEFAULT 'USER',
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    active      BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(active);

-- ─── Reports (reporte-service) ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS reports (
    id                UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    license_plate     VARCHAR(20)  NOT NULL,
    vin               VARCHAR(17),
    user_id           VARCHAR(255) NOT NULL,
    report_plan       VARCHAR(20)  NOT NULL,
    report_status     VARCHAR(20)  NOT NULL DEFAULT 'COMPLETED',
    json_data         TEXT         NOT NULL,
    created_at        TIMESTAMP    NOT NULL DEFAULT NOW(),
    response_time_ms  BIGINT       NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_reports_license_plate ON reports(license_plate);
CREATE INDEX IF NOT EXISTS idx_reports_user_id ON reports(user_id);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_reports_plan ON reports(report_plan);

CREATE TABLE IF NOT EXISTS query_logs (
    id            UUID         PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id     UUID         REFERENCES reports(id) ON DELETE SET NULL,
    user_id       VARCHAR(255) NOT NULL,
    license_plate VARCHAR(20)  NOT NULL,
    report_plan   VARCHAR(20)  NOT NULL,
    data_source   VARCHAR(50)  NOT NULL,
    success       BOOLEAN      NOT NULL DEFAULT TRUE,
    time_ms       BIGINT       NOT NULL DEFAULT 0,
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_query_logs_report_id ON query_logs(report_id);
CREATE INDEX IF NOT EXISTS idx_query_logs_user_id ON query_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_query_logs_created_at ON query_logs(created_at DESC);
