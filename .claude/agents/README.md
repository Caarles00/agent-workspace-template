# Agentes específicos del proyecto

Esta carpeta empieza vacía a propósito: los subagentes personalizados dependen del stack
de cada proyecto (backend-feature en FastAPI no sirve igual en Rails), así que se recrean
cada vez en vez de copiarse.

## Cuándo crear uno

Solo cuando un tipo de tarea se repite lo bastante como para justificar un system prompt
dedicado — típicamente: implementar features de backend, crear/editar vistas de frontend,
y escribir tests. Si el proyecto es pequeño o el patrón no se repite, no hace falta ninguno.

## Molde

Cada agente es un fichero `.claude/agents/<nombre>.md` con frontmatter:

```markdown
---
name: nombre-corto
description: Una frase — cuándo se lanza este agente y qué produce.
tools: [Read, Write, Edit, Bash, Grep, Glob]   # ajusta al mínimo necesario
model: sonnet   # tier estándar; mapeo de tiers en CLAUDE.md, criterio en AGENTS.md
---

Instrucciones del agente: convenciones del proyecto, patrones a seguir,
qué comprobar antes de terminar (tests, lint, etc.)
```

## Ejemplos a recrear según el stack

- **Backend**: implementar endpoints/rutas y modelos de datos siguiendo las convenciones
  del ORM/framework del proyecto.
- **Frontend**: crear o modificar vistas/componentes siguiendo el patrón de UI del proyecto
  (SSR+HTMX, SPA, etc.).
- **Testing**: escribir tests para el código nuevo, con el framework de test del proyecto.

Actualiza la tabla de `AGENTS.md` en cuanto crees el primero.
