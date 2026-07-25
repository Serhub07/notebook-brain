# 🧠 Notebook Brain

**Clona el cerebro de cualquier experto y consúltalo desde Claude Code.**

¿Y si pudieras preguntarle a tu experto favorito lo que quisieras, y te respondiera
basándose en el contenido real de sus vídeos? Ese es el truco: metes sus mejores
vídeos de YouTube en NotebookLM (que los transcribe gratis) y conectas ese notebook
a Claude Code mediante MCP. El resultado es un asesor que responde **con citas de
las fuentes reales**, no inventando.

> Funciona con cualquier experto o tema: negocios, fitness, cocina, programación…
> Tú eliges las fuentes, tú creas el cerebro.

---

## Qué necesitas

- Un Mac o Linux (en Windows, usa WSL).
- Una cuenta de Google (NotebookLM es gratis, ~50 consultas al día).
- [Claude Code](https://claude.com/claude-code) instalado. Si no lo tienes:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

---

## Paso 1 — Crea el cerebro en NotebookLM

1. Entra en [notebooklm.google.com](https://notebooklm.google.com) y crea un notebook nuevo.
2. Ponle un nombre corto y reconocible, por ejemplo `Cerebro Hormozi`.
3. Añade como **fuentes** los vídeos del experto. NotebookLM transcribe el audio
   por ti. Tienes tres formas de hacerlo:
   - **A mano**: botón *Añadir fuente → YouTube* y pegas cada enlace. Gratis,
     pero lento para 50 vídeos.
   - **Extensión de Chrome** (la del truco original): [YouTube to NotebookLM](https://chromewebstore.google.com/detail/youtube-to-notebooklm/kobncfkmjelbefaoohoblamnbackjggk)
     añade un botón en YouTube para mandar el vídeo, la playlist o el canal
     entero al notebook con un clic. Gratis con límite diario; la importación
     masiva de playlists es de pago.
   - **Con este kit** (gratis y en lote): cuando termines el Paso 2, pídeselo a
     Claude — *"añade estos enlaces al cuaderno Cerebro Hormozi"* — o usa la
     terminal: `nlm add url <cuaderno> <enlace-youtube>`.
4. El plan gratuito admite hasta **50 fuentes por notebook** — suficiente para
   los 50 vídeos más populares de cualquiera.

---

## Paso 2 — Conecta NotebookLM con Claude Code

Clona este repo y ejecuta el instalador:

```bash
git clone https://github.com/Serhub07/notebook-brain.git
cd notebook-brain
bash setup.sh
```

El script hace todo esto (y te va contando cada paso):

1. Instala `uv` si no lo tienes (un gestor de paquetes de Python).
2. Instala [`notebooklm-mcp-cli`](https://github.com/jacob-bd/notebooklm-mcp-cli),
   el puente entre NotebookLM y Claude.
3. Registra el servidor MCP en Claude Code automáticamente.
4. Te crea la carpeta `~/mi-cerebro` con la plantilla lista para editar.

Al final te pedirá iniciar sesión en Google: se abre tu navegador y entras con
normalidad. **Tu contraseña nunca se guarda** — solo las cookies de sesión, que
duran unas 2–4 semanas (cuando caduquen, repite `nlm login` y listo).

Puedes ejecutarlo las veces que quieras: no rompe ni duplica nada.

---

## Paso 3 — Dale personalidad

El instalador ya te creó `~/mi-cerebro/CLAUDE.md`. Ábrelo y rellena los huecos:
nombre del experto, nombre exacto del notebook y su estilo de comunicación. En
[`plantillas/`](plantillas/) tienes un ejemplo ya relleno al estilo Alex Hormozi.

Ese archivo `CLAUDE.md` se carga automáticamente cada vez que abras Claude Code
en esa carpeta — es lo que convierte a Claude en "el experto".

---

## Paso 4 — Úsalo

```bash
cd ~/mi-cerebro && claude
```

Y pregunta lo que quieras:

- *"Analiza mi oferta: un curso de 97 € sobre repostería. ¿Qué mejorarías?"*
- *"¿Qué dice el experto sobre conseguir los primeros 10 clientes?"*
- *"Hazme un plan de 30 días aplicando su método a mi negocio."*

Claude consultará el notebook por ti y te responderá con el estilo del experto
y citas de los vídeos originales.

---

## Actualizar

Cuando haya novedades en el proyecto o el puente deje de funcionar por un cambio
de Google:

```bash
cd notebook-brain && git pull && bash setup.sh
```

---

## Preguntas frecuentes

**¿Es oficial de Google?** No. Google aún no tiene API pública de NotebookLM, así
que esto usa un puente creado por la comunidad. Si Google cambia su web, puede
fallar temporalmente hasta que actualicen el puente (ver [Actualizar](#actualizar)).

**¿Cuánto cuesta?** NotebookLM es gratis (~50 consultas/día; ojo, una pregunta a
Claude puede gastar 2–3 consultas). Claude Code requiere suscripción o API de
Anthropic — es el único coste obligatorio.

**La terminal dice `command not found: nlm`.** Abre una terminal nueva: el
instalador configura el PATH, pero solo las terminales nuevas lo ven.

**Claude no usa el notebook.** Tres comprobaciones: (1) reinicia Claude Code si
estaba abierto durante la instalación, (2) abre `claude` dentro de la carpeta que
tiene tu `CLAUDE.md`, (3) verifica la conexión con `claude mcp list` — debe salir
`notebooklm-mcp ✔ Connected`.

**Me dice que no encuentra el notebook.** Ejecuta `nlm login` para renovar la
sesión, o comprueba que el nombre en tu `CLAUDE.md` coincide exactamente con el
de NotebookLM.

**¿Puedo tener varios cerebros?** Sí: un notebook + una carpeta con su `CLAUDE.md`
por cada experto.

---

## Créditos

- Puente MCP: [notebooklm-mcp-cli](https://github.com/jacob-bd/notebooklm-mcp-cli)
  de Jacob Ben-David (licencia MIT).
- Técnica popularizada por la comunidad de IA en español.

Licencia [MIT](LICENSE).
