#!/bin/bash
# 🧠 Notebook Brain — instalador
# Conecta Google NotebookLM con Claude Code mediante MCP.
# Seguro de ejecutar varias veces: si algo ya está instalado, lo salta.
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
NLM_BIN="$HOME/.local/bin"

echo ""
echo "🧠 Notebook Brain — instalador"
echo "=============================="
echo ""

# 1. uv (gestor de paquetes de Python)
if command -v uv >/dev/null 2>&1; then
  echo "✓ uv ya está instalado"
else
  echo "→ Instalando uv (gestor de paquetes de Python)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$NLM_BIN:$PATH"

# 2. notebooklm-mcp-cli (el puente con NotebookLM)
if [ -x "$NLM_BIN/nlm" ]; then
  echo "✓ notebooklm-mcp-cli ya estaba instalado — buscando actualizaciones..."
  uv tool upgrade notebooklm-mcp-cli >/dev/null 2>&1 || true
else
  echo "→ Instalando notebooklm-mcp-cli..."
  uv tool install notebooklm-mcp-cli
fi

# Dejar la carpeta de programas en el PATH de las terminales nuevas,
# para poder escribir "nlm login" directamente
uv tool update-shell >/dev/null 2>&1 || true

# 3. Registrar el servidor MCP en Claude Code
if command -v claude >/dev/null 2>&1; then
  echo "→ Conectando NotebookLM con Claude Code..."
  # Ruta absoluta al servidor: funciona aunque ~/.local/bin no esté en el PATH
  claude mcp remove notebooklm-mcp -s user >/dev/null 2>&1 || true
  claude mcp add -s user notebooklm-mcp -- "$NLM_BIN/notebooklm-mcp"
else
  echo ""
  echo "⚠️  No encuentro Claude Code. Instálalo con:"
  echo ""
  echo "    curl -fsSL https://claude.ai/install.sh | bash"
  echo ""
  echo "y vuelve a ejecutar: bash setup.sh"
  exit 1
fi

# 4. Iniciar sesión en Google (solo si hace falta y la terminal es interactiva)
LOGIN_PENDIENTE=1
if [ -f "$HOME/.notebooklm-mcp-cli/profiles/default/cookies.json" ]; then
  echo "✓ Sesión de Google ya guardada (si caduca, ejecuta: nlm login)"
  LOGIN_PENDIENTE=0
elif [ -t 0 ]; then
  echo ""
  echo "Último paso: iniciar sesión en tu cuenta de Google."
  echo "Se abrirá tu navegador — entra con normalidad. Tu contraseña NO se guarda,"
  echo "solo las cookies de sesión (duran 2-4 semanas)."
  echo ""
  printf "¿Iniciar sesión ahora? (s/n) "
  read -r respuesta
  if [ "$respuesta" = "s" ] || [ "$respuesta" = "S" ]; then
    "$NLM_BIN/nlm" login
    LOGIN_PENDIENTE=0
  fi
fi

# 5. Crear la carpeta del primer cerebro con la plantilla (sin pisar nada)
CEREBRO="$REPO_DIR/cerebros/mi-cerebro"
if [ -f "$CEREBRO/CLAUDE.md" ]; then
  echo "✓ $CEREBRO/CLAUDE.md ya existe — no lo toco"
else
  mkdir -p "$CEREBRO"
  cp "$REPO_DIR/plantillas/CLAUDE.md" "$CEREBRO/CLAUDE.md"
  echo "✓ Creado $CEREBRO/CLAUDE.md a partir de la plantilla"
fi

echo ""
echo "✅ ¡Instalación completa!"
echo ""
echo "Siguientes pasos:"
if [ "$LOGIN_PENDIENTE" = "1" ]; then
  echo "  0. Inicia sesión en Google:  nlm login"
fi
echo "  1. Crea tu cuaderno en https://notebooklm.google.com y añade los vídeos"
echo "     del experto como fuentes (enlaces de YouTube)"
echo "  2. Edita $CEREBRO/CLAUDE.md:"
echo "     nombre del experto, nombre del cuaderno y su estilo"
echo "     (tienes un ejemplo en plantillas/CLAUDE-ejemplo-hormozi.md)"
echo "  3. Abre tu cerebro:  cd $CEREBRO && claude"
echo ""
echo "Consejos:"
echo "  · Si 'nlm' no se encuentra, abre una terminal nueva."
echo "  · Si Claude Code estaba abierto, reinícialo para activar NotebookLM."
echo ""
