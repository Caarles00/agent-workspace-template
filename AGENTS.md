# Agentes del proyecto

## Agentes especializados

_Vacía hasta que el proyecto tenga agentes propios — ver [.claude/agents/README.md](.claude/agents/README.md)
para el molde. Rellena esta tabla en cuanto crees el primero._

| Agente | Cuándo | Modelo | Archivo |
|--------|--------|--------|---------|
| — | — | — | — |

---

## Cuándo lanzar un subagente

- Lanza un subagente solo si aporta **paralelismo real**, **búsqueda amplia** (quieres la conclusión, no el volcado de archivos) o **aislamiento de contexto**. Para leer un dato ya conocido o un edit trivial, hazlo directo.
- **Fan-out masivo (workflows / decenas de agentes) solo con petición explícita.** No dispararlo por iniciativa propia.
- Mantén el patrón establecido: al cerrar una feature, revisión de código + seguridad en paralelo (2 agentes acotados; ver "Skills de uso puntual" más abajo).
- Poda los custom agents que no uses: cada ficha ocupa contexto aunque no se lance.

---

## Skills de uso puntual

### `ponytail` — fuerza la solución más simple que funciona

Invócala cuando notes alguna de estas señales:

**Sí invocar:**
- Estás a punto de crear un archivo nuevo para algo que podría ir en uno existente
- Te preguntas "¿necesito un `service` para esto?" antes de tener dos casos de uso que lo compartan
- Vas a añadir una dependencia nueva — ¿la stdlib o algo ya instalado lo cubre?
- Estás creando una clase o helper para algo que ocurre una sola vez
- Alguien pide "añadir caché" sin benchmark que lo justifique
- Estás refactorizando sin que nadie lo haya pedido

**No invocar:**
- Lógica de seguridad, auth o pagos — ponytail no simplifica esto
- Cuando necesitas entender la causa raíz de un bug primero

Niveles: `lite` (sugiere alternativa), `full` (por defecto), `ultra` (extremista YAGNI). Cada harness expone la skill a su manera (slash command, mención por nombre...); el nivel se indica al invocarla.

### `grilling` — interroga al usuario antes de construir

Invócala cuando notes alguna de estas señales:

**Sí invocar:**
- Vas a empezar una feature nueva, un endpoint nuevo, o cualquier cambio significativo de lógica de negocio
- El plan tiene casos borde sin resolver, o el diseño da por hecho algo que no se ha confirmado
- El usuario usa alguna frase disparadora de "grill" o pide que le cuestiones el planteamiento

**No invocar:**
- Bugfixes triviales de una línea, cambios de CSS/estilos, actualizaciones de documentación o tests unitarios sin lógica nueva

### `requesting-code-review` + `security-review` — al completar una feature

Al terminar de implementar una feature nueva, un endpoint nuevo, o cualquier cambio significativo de lógica de negocio, lanza **en paralelo** estos dos agentes antes de dar la tarea por terminada:

1. **Revisión de código** — usa la skill `requesting-code-review` para verificar que el trabajo cumple los requisitos y las convenciones del proyecto.
2. **Revisión de seguridad** — usa la skill `security-review` para detectar vulnerabilidades (OWASP Top 10, inyección, auth, XSS, etc.).

**No invocar** (ninguna de las dos) para: bugfixes triviales de una línea, cambios de CSS/estilos, actualizaciones de documentación o tests unitarios sin lógica nueva.

---

# Subagentes — Selección de modelo

Cuando lances subagentes, elige el tier según la tarea. Los tiers son genéricos; el mapeo a modelos
concretos de cada proveedor va en el fichero de configuración del harness (p. ej. CLAUDE.md para Claude Code).

## Tier rápido — tareas rápidas y de bajo coste

- Buscar archivos, leer código, grep, exploración del repo
- Responder preguntas factuales sobre el código
- Tareas de un solo paso sin decisiones complejas
- Agentes de exploración por defecto

## Tier estándar — trabajo habitual

Es el tier por defecto, no hace falta indicarlo.

- Escribir y editar código nuevo
- Implementar features, corregir bugs
- Generar traducciones, plantillas, CSS
- Agentes de propósito general por defecto

## Tier de razonamiento alto — decisiones críticas

- Revisar arquitectura o diseño de sistema
- Refactors complejos con muchas dependencias
- Decisiones de seguridad o rendimiento críticas
- Segunda opinión independiente antes de merge
- Agentes de planificación o revisión de PR

## Regla de oro

> Explora con el tier rápido, construye con el estándar, revisa lo que importa con el de razonamiento alto.
