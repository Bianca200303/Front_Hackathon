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
| `DATA_SOURCE` | `mock` · `remote` | `mock` usa datos locales de ejemplo; `remote` requiere backend |
| `API_BASE_URL` | URL | Obligatoria si `DATA_SOURCE=remote` |

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
