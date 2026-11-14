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
| `DATA_SOURCE` | `mock` · `remote` | `mock` usa datos locales de ejemplo; `remote` usa el backend en las pantallas ya integradas (hoy, Clima) y datos de ejemplo en el resto |
| `API_BASE_URL` | URL | Obligatoria si `DATA_SOURCE=remote` |

### Con el backend local

1. Levanta `spaceapps-2026-core` (`make dev`, puerto 8000).
2. Ejecuta la app con `config/local.json`:

   ```bash
   flutter run --dart-define-from-file=config/local.json
   ```

   `local.json` apunta a `http://10.0.2.2:8000/`, que es el equipo visto
   desde el emulador de Android. En el simulador de iOS usa
   `http://localhost:8000/`; en un teléfono físico, la IP del equipo en la
   red local. El HTTP sin TLS solo está permitido en las compilaciones de
   depuración de Android y para la red local en iOS.

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
