#!/bin/bash
# 🧠 Notebook Brain — instalador
# Conecta Google NotebookLM con Claude Code mediante MCP.
# Seguro de ejecutar varias veces: si algo ya está instalado, lo salta.
set -e

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
export PATH="$HOME/.local/bin:$PATH"

# 2. notebooklm-mcp-cli (el puente con NotebookLM)
NLM_BIN="$HOME/.local/bin"
if [ -x "$NLM_BIN/nlm" ]; then
  echo "✓ notebooklm-mcp-cli ya estaba instalado — buscando actualizaciones..."
  uv tool upgrade notebooklm-mcp-cli >/dev/null 2>&1 || true
else
  echo "→ Instalando notebooklm-mcp-cli..."
  uv tool install notebooklm-mcp-cli
fi
export PATH="$NLM_BIN:$PATH"

# Asegurar que la carpeta de programas esté en el PATH de la terminal
# (para poder escribir "nlm login" directamente en terminales nuevas)
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

# 4. Iniciar sesión en Google
echo ""
echo "Último paso: iniciar sesión en tu cuenta de Google."
echo "Se abrirá tu navegador — entra con normalidad. Tu contraseña NO se guarda,"
echo "solo las cookies de sesión (duran 2-4 semanas)."
echo ""
printf "¿Iniciar sesión ahora? (s/n) "
read -r respuesta
if [ "$respuesta" = "s" ] || [ "$respuesta" = "S" ]; then
  nlm login
else
  echo "Vale — cuando quieras, ejecuta: nlm login"
fi

echo ""
echo "✅ ¡Instalación completa!"
echo ""
echo "Siguientes pasos:"
echo "  1. Crea tu notebook en https://notebooklm.google.com (ver README, Paso 1)"
echo "  2. mkdir -p ~/mi-cerebro && cp plantillas/CLAUDE.md ~/mi-cerebro/CLAUDE.md"
echo "  3. Edita ~/mi-cerebro/CLAUDE.md con tu experto y tu notebook"
echo "  4. cd ~/mi-cerebro && claude"
echo ""
