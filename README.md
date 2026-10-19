# YouWallet

App personal de finanzas en pesos colombianos. Funciona en el navegador y se instala en el iPhone como app. Todos los datos se guardan **solo en el teléfono** (IndexedDB). No hay servidor ni base de datos.

## Qué incluye

- Ingresos, gastos y transferencias, con categorías y subcategorías.
- Cuentas: bancos, Nequi, Daviplata, efectivo y tarjetas de crédito (cupo, tasa E.A., corte y fecha de pago).
- Inicio: disponible, ingresos, gastos y ahorro del mes, lo que queda después de obligaciones y deudas pendientes.
- Presupuestos mensuales y semanales con alertas al 80% y al 100%, y sugerencias según tu historial.
- Metas de ahorro y fondo de emergencia, con simulador y fecha estimada.
- Deudas con tasa, cuota, intereses, calendario de pagos y abonos extra.
- Agenda de pagos recurrentes y flujo de caja a 60 días con alerta de faltantes.
- Clientes de edición: videos que debes, cobros pendientes, mensaje de cobro y proyectos.
- PIN, copia de seguridad y restauración (JSON), y exportación de movimientos a CSV.

## Publicar en GitHub Pages

1. Sube todos los archivos de esta carpeta a la rama `main` del repo `youwallet`.
2. En GitHub ve a **Settings → Pages**.
3. En "Build and deployment" elige **Deploy from a branch**, rama `main`, carpeta `/ (root)`, y guarda.
4. Espera uno o dos minutos. La app queda en `https://emamuel-pv.github.io/youwallet/`.

## Instalar en el iPhone

1. Abre la dirección en **Safari**.
2. Toca Compartir → **Agregar a inicio**.
3. Usa siempre ese ícono. Los datos de Safari y los de la app instalada son espacios separados.

## Importante sobre tus datos

- Viven solo en ese iPhone. Si borras los datos de Safari, quitas el ícono o cambias de teléfono, se pierden.
- Guarda una copia de seguridad cada cierto tiempo: **Ajustes → Seguridad y datos → Guardar copia**. Puedes guardarla en Archivos o en iCloud Drive.
- Para pasarte a otro teléfono: guarda una copia, instala la app en el nuevo y usa **Restaurar copia**.

## Actualizar la app

Sube los cambios a `main`. La app descarga la versión nueva la próxima vez que la abras con internet. Si cambias `sw.js`, sube también el número en `CACHE` (por ejemplo `youwallet-v2`).
