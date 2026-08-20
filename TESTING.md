# Testing

> Convenciones de referencia, agnósticas de framework. Ajusta a la herramienta de test
> concreta del proyecto (pytest, vitest, jest, cargo test...) al arrancar.

## Qué testear

- Lógica de negocio no trivial y endpoints/rutas nuevos — siempre.
- Utilidades reutilizables (helpers, parsers, validadores) — siempre.
- Bugfixes: añade el test que reproduce el bug antes de corregirlo, para que quede como regresión.
- No testees getters/setters triviales ni código generado (migraciones, tipos autogenerados).

## Cómo

- **Aísla**: cada test debe poder correr solo y en cualquier orden. Nada de estado compartido entre tests salvo fixtures explícitas.
- **No sobre-mockees**: mockea límites externos reales (red, filesystem, servicios de terceros), no las capas internas del propio proyecto — si mockeas demasiado, el test deja de probar nada.
- **Nombra por comportamiento**, no por implementación: `test_rechaza_email_duplicado`, no `test_funcion_2`.
- **Arrange-Act-Assert**: estructura cada test en preparar, ejecutar, verificar; evita lógica condicional dentro del test.
- **Un assert conceptual por test** — varios `assert` está bien si verifican la misma afirmación desde distintos ángulos; si prueban cosas no relacionadas, sepáralos.

## Antes de dar una feature por terminada

- Corre la suite completa, no solo los tests nuevos — un cambio puede romper algo que no tocaste directamente.
- Si el proyecto mide cobertura, no persigas el 100% — persigue que la lógica con ramas/casos borde esté cubierta.

## Qué NO consolidar

Antes de fusionar tests que parecen similares, confirma que cubren de verdad el mismo caso.
Dos tests con estructura parecida pero que ejercitan dominios o casos borde distintos deben
quedarse separados aunque el código se vea repetido — la duplicación en tests es más barata
que un falso positivo de cobertura.
