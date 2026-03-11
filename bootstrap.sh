#!/usr/bin/env bash
# =============================================================================
# ValidarAuto — Bootstrap para desarrollo con repos separados
#
# Ejecuta este script UNA VEZ después de clonar validarauto-platform.
# Instala el parent POM en el repositorio local Maven (~/.m2) para que
# los demás módulos puedan resolver la dependencia sin tener este repo
# como directorio padre.
#
# Uso:
#   chmod +x bootstrap.sh
#   ./bootstrap.sh
# =============================================================================

set -e

echo ""
echo "=================================================="
echo "  ValidarAuto — Bootstrap de entorno de desarrollo"
echo "=================================================="
echo ""

# 1. Instalar el parent POM (sin compilar submodulos, -N = non-recursive)
echo "[1/2] Instalando parent POM en ~/.m2 ..."
mvn install -N -q
echo "      ✓ Parent POM instalado"

echo ""
echo "[2/2] Siguiente paso — instalar el módulo 'common':"
echo ""
echo "      git clone https://github.com/AfelioDev/validarauto-common.git"
echo "      cd validarauto-common"
echo "      mvn install -q"
echo ""
echo "      Después de eso, cada servicio puede compilarse de forma independiente:"
echo ""
echo "      git clone https://github.com/AfelioDev/validarauto-auth.git"
echo "      cd validarauto-auth && mvn package -DskipTests"
echo ""
echo "      git clone https://github.com/AfelioDev/validarauto-reporte.git"
echo "      cd validarauto-reporte && mvn package -DskipTests"
echo ""
echo "      # ... igual para gateway, repuve, adeudos"
echo ""
echo "=================================================="
echo "  ✓ Bootstrap completo. Revisa los pasos de arriba."
echo "=================================================="
echo ""
