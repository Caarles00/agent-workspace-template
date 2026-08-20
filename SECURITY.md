# Seguridad

> Checklist de referencia, agnóstica de stack. La skill `security-review` (`.claude/skills/security-review/`)
> la aplica automáticamente al revisar código; esto es la versión legible para humanos.

## Al añadir cualquier endpoint o punto de entrada

- **Validación de entrada**: nunca confíes en datos del cliente (body, query, headers, cookies). Valida tipo, longitud y rango antes de usarlos.
- **Autenticación y autorización**: confirma no solo *quién* es el usuario sino *si puede* hacer esa acción sobre ese recurso concreto (evita IDOR — comprobar ownership, no solo login).
- **Inyección**: usa siempre queries parametrizadas/ORM; nunca concatenes input del usuario en SQL, comandos de shell, o templates sin escapar.
- **XSS**: escapa toda salida que se renderiza en HTML; si el framework de templates ya auto-escapa, no lo desactives sin motivo explícito y documentado.
- **CSRF**: cualquier endpoint que muta estado desde un formulario/sesión de navegador necesita protección CSRF salvo que sea una API con auth por token.

## Secretos y configuración

- Ningún secreto (API key, credencial, token) en el repo, ni en tests, ni en commits antiguos si se detecta a tiempo.
- Variables de entorno para todo lo sensible; `.env.example` sin valores reales versionado, `.env` en `.gitignore`.
- Rota cualquier secreto que haya llegado a estar en un commit, aunque se elimine después.

## Dependencias

- Antes de añadir una dependencia nueva, comprueba que sigue mantenida y no tiene CVEs abiertos conocidos.
- Revisa periódicamente el listado de vulnerabilidades del gestor de paquetes (`npm audit`, `pip-audit`, `cargo audit`, etc.).

## Al cerrar una feature con lógica de negocio significativa

Lanza la skill `security-review` (ver [AGENTS.md](AGENTS.md)) antes de dar la tarea por terminada. Presta atención extra si la feature toca:

- Autenticación, sesiones o gestión de permisos
- Pagos o cualquier dato financiero
- Subida o procesamiento de ficheros de usuario
- Llamadas a servicios externos con datos del usuario (posible SSRF)

## Referencia

- [OWASP Top 10](https://owasp.org/www-project-top-ten/) — checklist de referencia general
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) — guías concretas por tipo de vulnerabilidad
