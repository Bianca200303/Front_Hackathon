# Siembra Segura

App Flutter que guía a los agricultores del valle sobre qué y cuándo sembrar,
usando pronóstico climático y datos satelitales.

- Arquitectura y decisiones: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- Referencia de diseño: [`../mvp.html`](../mvp.html)

## Requisitos

- Flutter 3.35+ (Dart 3.9+)

## Ejecutar

```bash
flutter pub get
flutter run --dart-define-from-file=config/dev.json
```

### Entornos

La configuración se inyecta en tiempo de compilación desde `config/<entorno>.json`:

| Clave | Valores | Descripción |
|---|---|---|
| `APP_ENV` | `dev` · `staging` · `prod` | Entorno |
| `DATA_SOURCE` | `mock` · `remote` | `mock` usa datos locales de ejemplo; `remote` usa el backend en las pantallas ya integradas (Clima, Qué sembrar, ¿Cuándo siembro?, Rotación) y datos de ejemplo en el resto. Con `remote`, la recomendación combina NASA POWER, SoilGrids, la tierra que reconoció el agricultor, el verdor MODIS, la humedad SMAP y la lluvia GPM IMERG del punto que marcó en el mapa |
| `API_BASE_URL` | URL | Obligatoria si `DATA_SOURCE=remote` |

### Con el backend local

1. Levanta `spaceapps-2026-core` (`make dev`, puerto 8000).
2. Ejecuta la app con `config/local.json`:

   ```bash
   flutter run --dart-define-from-file=config/local.json
   ```

   `local.json` apunta a `http://10.0.2.2:8000/`, que es el equipo visto
   desde el emulador de Android. En el simulador de iOS usa
   `http://localhost:8000/`; en un iPhone físico, `config/device.json`, que
   usa el nombre Bonjour del Mac (`scutil --get LocalHostName` + `.local`). El HTTP sin TLS solo está permitido en las compilaciones de
   depuración de Android y para la red local en iOS.

### En el navegador (sin celular)

Con el backend levantado (`make dev` en `spaceapps-2026-core`):

```bash
flutter run -d web-server --web-port 5050 --dart-define-from-file=config/web.json
```

Abre <http://localhost:5050> en cualquier navegador. En la terminal, `r`
recarga los cambios y `R` reinicia la app.

Si prefieres que Flutter abra el navegador solo, usa `-d chrome`. Sin Chrome
instalado, apunta Flutter a otro navegador Chromium, por ejemplo Brave:

```bash
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
```

`web.json` apunta a `http://localhost:8000/`. El backend permite cualquier
origen por defecto (`CORS_ORIGINS=*`); si lo restringes, agrega
`http://localhost:5050`. Para ver la app con tamaño de celular, abre las
DevTools del navegador y activa el modo dispositivo (`Cmd+Shift+M`).

Para probar solo la interfaz con datos de ejemplo, sin backend, usa
`config/dev.json`.

Sin `--dart-define-from-file`, la app arranca en `dev` + `mock`. Usa
`config/prod.json.example` como plantilla. No guardes secretos en estos
archivos: todo lo que se embebe en una app móvil puede extraerse.

## Calidad

```bash
dart format lib test
flutter analyze
flutter test
```

## Localización

Los textos están en `lib/core/l10n/app_es.arb`. Después de editarlos:

```bash
flutter gen-l10n
```
