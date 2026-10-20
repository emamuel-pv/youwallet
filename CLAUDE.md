# YouWallet — contexto para Claude

App personal de finanzas de Emanuel (Cali, Colombia), en pesos colombianos (COP). Se usa en su iPhone como app instalada desde Safari (Agregar a inicio). Publicada con GitHub Pages en https://emamuel-pv.github.io/youwallet/ (repo público `emamuel-pv/youwallet`, rama `main`, carpeta raíz).

Responde siempre en español de Colombia, claro y directo.

## Cómo está hecha

- Todo en un solo archivo: `index.html` (HTML + CSS + JS sin frameworks ni build). No agregar dependencias ni pasos de compilación.
- Datos **en el teléfono primero**: IndexedDB (base `youwallet`, store `kv`), con localStorage como respaldo. La app funciona igual sin internet y sin cuenta. Nunca subir datos personales al repo (es público).
- **Nube opcional con Supabase** (proyecto `nhaxqqujbtxqurftyoex`): al iniciar sesión (correo y contraseña) se sincroniza con la tabla `registros` (`user_id`, `coll`, `id`, `data` jsonb, `deleted`, `updated_at` puesto por el servidor), protegida con RLS. Se habla con Supabase por `fetch` directo a `/auth/v1` y `/rest/v1`, sin librería. En el código solo va la clave pública (`sb_publishable_…`); **nunca** poner la `service_role`/`secret`.
  - Cada `put`/`putMany`/`del`/`putSettings`/`setSettings` marca el registro como pendiente (`track`), y `runSync()` sube pendientes y luego baja lo cambiado desde `lastPull`. Si un registro tiene cambio local sin subir, gana el local. Borrar sube `deleted: true`.
  - Los ajustes van como `coll = "settings"`, `id = "main"`, **sin el PIN** (cada teléfono tiene el suyo).
  - Sesión y pendientes se guardan en la clave `sync` del mismo store. Si se agrega una colección nueva, basta con incluirla en `COLLS`.
  - Los enlaces de los correos de Supabase (confirmar cuenta y "Olvidé mi contraseña") vuelven a la app con la sesión en el `#hash`; `authFromLink()` los procesa al abrir. Site URL y Redirect URLs de Supabase: `https://emamuel-pv.github.io/youwallet/`.
  - Cambios de la base: nueva migración en `supabase/migrations/` (la integración de GitHub de Supabase la aplica al subir a `main`).
- `sw.js`: service worker para modo sin conexión (red primero, caché si no hay internet). **Cada vez que cambies algo, sube el número de `CACHE`** (ahora `youwallet-v10`) para que el iPhone baje la versión nueva.
- `manifest.webmanifest` + íconos `icon-192.png`, `icon-512.png`, `apple-touch-icon.png` en la raíz.
- Colecciones en el estado `S`: `accounts`, `txns`, `cats`, `budgets`, `goals`, `debts`, `bills`, `videos`, `proyectos` y `settings`. Funciones de guardado: `put(coll, obj)`, `putMany`, `del(coll, id)`, `putSettings(patch)`, `setSettings(obj)`.
- Render: `render()` arma la vista según `UI.tab` (`inicio`, `movs`, `plan`, `agenda`, `clientes`) o `UI.settings`. Los clics se manejan con un solo listener por `data-act`. Los formularios abren en hojas inferiores con `openSheet()`.
- Copia de seguridad: JSON con `app: "youwallet"`; Restaurar agrega o reemplaza por `id`, no borra lo demás.

## Funciones actuales

- Inicio: saldo disponible, lo que queda después de obligaciones, deudas, KPIs con mini barras de 6 meses, "Resumen del mes" (compara gastos con el mes pasado a la misma fecha, sin IA), medidor de "Salud financiera" 0–100, cuentas, resumen de clientes, próximos pagos, gráfica de 6 meses y categorías.
- Movimientos: ingresos, gastos y transferencias con búsqueda y filtros.
- Planear: presupuestos (mensual/semanal, alertas 80% y 100%, sugeridos), metas y fondo de emergencia (cada meta dice dónde se ahorra: `saveAcc` o `saveWhere`; cada aporte/retiro guarda `acc` y `accBalance` lo resta/suma a esa cuenta, así lo apartado sale del saldo disponible; movimientos viejos sin `acc` no afectan cuentas y se pueden editar desde el historial), deudas (tasa E.A., cuota, simulador, abonos extra, calendario).
- Agenda: pagos e ingresos recurrentes (semanal, quincenal 15 y fin de mes, mensual, anual), cortes y pagos de tarjetas, flujo de caja a 60 días y alerta de faltantes.
- Clientes: control de videos de edición (DMT Mentoring, El Clan): estado Pendiente/En edición/Entregado, precio (vacío = PENDIENTE), pagado, mensaje de cobro para WhatsApp, proyectos con pendientes. Al marcar pagado ofrece registrar el ingreso.
- Ajustes: cuentas, categorías y subcategorías, Nube (iniciar/cerrar sesión, estado de sincronización), PIN (hash PBKDF2), copia/restauración, exportar CSV, borrar todo, instrucciones para iPhone.
- Sin zoom (viewport + bloqueo de pellizco y doble toque; inputs a 16px).
- El asistente de IA se quitó a propósito.

## Estilo

Tema oscuro único "carbón + cobre" (inspirado en una referencia de Behance): fondo `#0B0B0C`, tarjetas con degradado oscuro, acento cobre `#DB5B14`, coral `#E84A45` para gastos, verde para positivo. Tipografía Inter (Google Fonts, eje opsz). Botones tipo píldora: primario cobre, secundario blanco. Mantener este estilo en todo lo nuevo.

## Antes de subir cambios

1. Revisa la sintaxis del script (extrae el `<script>` y corre `node --check`).
2. Sube el número de `CACHE` en `sw.js`.
3. Commit y push a `main`. GitHub Pages publica en uno o dos minutos.
4. Dile a Emanuel que cierre y abra la app (a veces dos veces) para ver la versión nueva. Si un cambio exige quitar y volver a agregar el ícono, recuérdale **guardar una copia antes**, porque al quitarlo se borran los datos.
