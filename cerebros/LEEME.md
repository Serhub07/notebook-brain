# 🧠 Tus cerebros viven aquí

Cada carpeta dentro de `cerebros/` es un cerebro: un archivo `CLAUDE.md` que
define la personalidad y apunta a un notebook de NotebookLM.

- El instalador crea el primero (`cerebros/mi-cerebro`) automáticamente.
- Para crear otro: copia la plantilla y edítala —
  `cp ../plantillas/CLAUDE.md nuevo-cerebro/CLAUDE.md`
- Para activarlo: `cd cerebros/nuevo-cerebro && claude`

**Esta carpeta es privada**: git la ignora (salvo este archivo), así que tus
cerebros nunca se suben a GitHub y `git pull` jamás los toca.
