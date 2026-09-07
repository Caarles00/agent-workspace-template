# agent-workspace-template

Plantilla base para arrancar un proyecto nuevo con agentes de código ya configurados: skills
genéricas, convenciones de agentes/subagentes, y documentos de referencia de buenas
prácticas (seguridad, testing), todo agnóstico de lenguaje, framework y harness (Claude Code,
Codex, Cursor, OpenCode...).

## Uso

La forma más simple es el botón **Use this template** de GitHub (o su equivalente en CLI), que
crea un repo nuevo sin arrastrar el historial de la plantilla:

```bash
gh repo create nombre-del-proyecto --template Caarles00/agent-workspace-template --private --clone
```

Si prefieres clonar a mano:

```bash
git clone https://github.com/Caarles00/agent-workspace-template.git nombre-del-proyecto
cd nombre-del-proyecto
rm -rf .git && git init   # deshaz el historial de la plantilla
```

En Windows, ejecuta después `scripts/install.sh --copy` (ver [Cómo están organizadas las skills](#cómo-están-organizadas-las-skills)).

Luego, en orden:

1. Rellena [CLAUDE.md](CLAUDE.md) con el stack real (backend, frontend, gestor de paquetes, convenciones de código, quirks de librerías). La doctrina compartida entre harnesses (subagentes, skills, tiers de modelo) está en [AGENTS.md](AGENTS.md); CLAUDE.md la importa con `@AGENTS.md`.
2. Ajusta [SECURITY.md](SECURITY.md) y [TESTING.md](TESTING.md) si el stack tiene checklist propio (p. ej. herramientas de audit de dependencias, framework de test concreto).
3. Cuando el proyecto tenga patrones de tarea que se repiten (features de backend, vistas de frontend, tests), crea agentes en `.claude/agents/` siguiendo [.claude/agents/README.md](.claude/agents/README.md) y añádelos a la tabla de [AGENTS.md](AGENTS.md).
4. Añade skills específicas del stack si aplica (framework de backend, librería de UI/animación, proveedor de datos como Supabase, etc.) — no vienen incluidas porque dependen del proyecto.

## Qué incluye `.agents/skills/`

Todas agnósticas de lenguaje/framework:

| Skill | Para qué |
|---|---|
| `ponytail` | Fuerza la solución más simple — anti-overengineering |
| `grilling` | Interroga el plan antes de construir, detecta casos borde sin resolver |
| `tdd` | Guía el bucle rojo→verde: qué es un buen test, dónde van los tests (seams), anti-patrones (tests acoplados a implementación, tautológicos, "horizontal slicing") |
| `requesting-code-review` | Checklist de revisión al cerrar una feature |
| `security-review` | Revisión de seguridad tipo OWASP Top 10 |
| `codebase-design` / `improve-codebase-architecture` | Vocabulario de "deep modules", detecta oportunidades de simplificar el diseño |
| `domain-modeling` | Fijar terminología de dominio (ubiquitous language) |
| `api-design-principles` | Principios de diseño REST/GraphQL |
| `web-design-guidelines` | Revisión de accesibilidad/UX del frontend |
| `obsidian-markdown` | Sintaxis de Obsidian para la documentación en `docs.local/` |

## Cómo están organizadas las skills

- **Fuente canónica**: `.agents/skills/<skill>/`. Es la carpeta que comparten Codex, Cursor, OpenCode
  y el resto de harnesses que siguen la convención de [skills.sh](https://skills.sh). Se edita solo aquí.
- **Por harness**: `.claude/skills/<skill>` es un symlink relativo al canon (Claude Code sigue symlinks
  y deduplica). Para otro harness que use carpeta propia, se añade otro juego de symlinks igual.
- **Script**: `scripts/install.sh` recrea los symlinks que falten. En Windows sin Developer Mode git
  materializa los symlinks como ficheros de texto; ahí usa `scripts/install.sh --copy`, que copia en
  vez de enlazar (y asume que actualizarás las copias a mano).
- **Añadir y actualizar skills externas**: `npx skills add <owner>/<repo> --skill <nombre>` instala en el
  canon, crea los symlinks y registra origen y hash en `skills-lock.json`. Todas las skills incluidas
  entraron por esa vía, así que `npx skills update` las pone al día y avisa si se han editado en local.
- **Metadatos por harness dentro de una skill**: `agents/openai.yaml` lo lee Codex; el campo
  `disable-model-invocation` del frontmatter lo lee Claude Code (fuerza invocación manual). Los demás
  harnesses ignoran lo que no conocen, así que conviven sin problema.

## Qué NO incluye (a propósito)

Agentes concretos (`backend-feature`, `frontend-template`, `testing`...) y skills atadas
a un stack (framework de backend, librería de animación, proveedor cloud) — se recrean o
se añaden por proyecto, porque copiarlas sin adaptar el stack real no aporta nada.

## Licencia y contenido de terceros

El repo es [MIT](LICENSE). Las skills proceden de estos repos (origen exacto y hash en `skills-lock.json`),
cada uno con su propia licencia:

| Origen | Skills |
|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | `tdd`, `grilling`, `codebase-design`, `improve-codebase-architecture`, `domain-modeling` |
| [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) | `ponytail` |
| [obra/superpowers](https://github.com/obra/superpowers) | `requesting-code-review` |
| [getsentry/skills](https://github.com/getsentry/skills) | `security-review` (incluye material de la [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/), CC BY-SA 4.0, ver su `LICENSE`) |
| [wshobson/agents](https://github.com/wshobson/agents) | `api-design-principles` |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `web-design-guidelines` |
| [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | `obsidian-markdown` |
