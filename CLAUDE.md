@AGENTS.md

# TEN EN CUENTA ESTAS COSAS SIEMPRE

> Plantilla base. Rellena cada sección al arrancar un proyecto nuevo y borra este aviso.

## General
- Revisa si hay skills disponibles antes de implementar algo
- Revisa el código generado buscando posibles errores antes de darlo por hecho
- La documentación debe estar en español, guardada en `docs.local/` y actualizada siguiendo los estándares de Obsidian y Markdown

## Stack del proyecto
- **Backend**: _(framework, lenguaje, ORM/DB, cola/cache si aplica)_
- **Frontend**: _(framework o SSR+HTMX/vanilla, con o sin build step)_
- **Servicios locales**: _(cómo se levantan DB/Redis/etc. en local — Docker Compose, servicios nativos...)_
- **Gestor de paquetes**: _(uv, npm/pnpm, cargo... — indica el comando canónico para añadir dependencias)_

## Convenciones de código
- _(estilo del ORM/lenguaje: p. ej. SQLAlchemy 2.x con `Mapped`+`mapped_column`, no el estilo antiguo)_
- _(cómo se resuelven imports circulares o dependencias de tipos)_
- Nunca escribir comentarios que expliquen QUÉ hace el código; solo escribir comentarios cuando el POR QUÉ no sea obvio

## Quirks conocidos de las librerías instaladas
- _(anota aquí los falsos positivos de linter/type-checker o comportamientos no obvios de las dependencias del proyecto, a medida que los descubras)_

## Frontend
- Todo frontend debe ser responsive
- _(preferencia de interactividad: HTMX, framework SPA, vanilla JS... y cuándo usar cada uno)_
- Preservar siempre la sintaxis de templates y la lógica existente al modificarlos

## Específico de Claude Code

La doctrina general (cuándo lanzar subagentes, cuándo invocar cada skill, tiers de modelo) vive en
[AGENTS.md](AGENTS.md) y se importa arriba con `@AGENTS.md`. Aquí solo va lo que no aplica a otros harnesses:

- **Mapeo de tiers a modelos**: rápido → `haiku`, estándar → `sonnet` (por defecto), razonamiento alto → `opus`.
- Las skills se invocan también como slash command (`/ponytail lite|full|ultra`, `/grilling`, `/tdd`...).
- Los subagentes propios del proyecto van en `.claude/agents/` (ver [.claude/agents/README.md](.claude/agents/README.md)).
