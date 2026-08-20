# dev-skeleton

Plantilla base para arrancar un proyecto nuevo con Claude Code ya configurado: skills
genéricas, convenciones de agentes/subagentes, y documentos de referencia de buenas
prácticas (seguridad, testing), todo agnóstico de lenguaje y framework.

## Uso

```bash
git clone https://github.com/<tu-usuario>/dev-skeleton.git nombre-del-proyecto
cd nombre-del-proyecto
rm -rf .git && git init   # deshaz el historial de la plantilla
```

Luego, en orden:

1. Rellena [CLAUDE.md](CLAUDE.md) con el stack real (backend, frontend, gestor de paquetes, convenciones de código, quirks de librerías).
2. Ajusta [SECURITY.md](SECURITY.md) y [TESTING.md](TESTING.md) si el stack tiene checklist propio (p. ej. herramientas de audit de dependencias, framework de test concreto).
3. Cuando el proyecto tenga patrones de tarea que se repiten (features de backend, vistas de frontend, tests), crea agentes en `.claude/agents/` siguiendo [.claude/agents/README.md](.claude/agents/README.md) y añádelos a la tabla de [AGENTS.md](AGENTS.md).
4. Añade skills específicas del stack si aplica (framework de backend, librería de UI/animación, proveedor de datos como Supabase, etc.) — no vienen incluidas porque dependen del proyecto.

## Qué incluye `.claude/skills/`

Todas agnósticas de lenguaje/framework:

| Skill | Para qué |
|---|---|
| `ponytail` | Fuerza la solución más simple — anti-overengineering |
| `grilling` / `grill-me` | Interroga el plan antes de construir, detecta casos borde sin resolver |
| `tdd` | Guía el bucle rojo→verde: qué es un buen test, dónde van los tests (seams), anti-patrones (tests acoplados a implementación, tautológicos, "horizontal slicing") |
| `requesting-code-review` | Checklist de revisión al cerrar una feature |
| `security-review` | Revisión de seguridad tipo OWASP Top 10 |
| `codebase-design` / `improve-codebase-architecture` | Vocabulario de "deep modules", detecta oportunidades de simplificar el diseño |
| `domain-modeling` | Fijar terminología de dominio (ubiquitous language) |
| `api-design-principles` | Principios de diseño REST/GraphQL |
| `web-design-guidelines` | Revisión de accesibilidad/UX del frontend |
| `obsidian-markdown` | Sintaxis de Obsidian para la documentación en `docs.local/` |

`tdd` se instaló con [`npx skills add`](https://skills.sh) en vez de copiarse a mano — por eso
vive en `.agents/skills/tdd/` (fuente canónica, compartida entre editores) con un symlink en
`.claude/skills/tdd/`. `skills-lock.json` registra su origen y hash para poder actualizarla más
adelante con el mismo comando. Es el método recomendado para sumar skills nuevas de repos
externos; las demás se copiaron a mano porque ya vivían en otro proyecto propio.

## Qué NO incluye (a propósito)

Agentes concretos (`backend-feature`, `frontend-template`, `testing`...) y skills atadas
a un stack (framework de backend, librería de animación, proveedor cloud) — se recrean o
se añaden por proyecto, porque copiarlas sin adaptar el stack real no aporta nada.
