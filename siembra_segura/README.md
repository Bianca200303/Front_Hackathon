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
| `VOICE_SOURCE` | `device` · `backend` | Voz de Semi. `backend` requiere `API_BASE_URL` (ver abajo) |

### Voz de Semi

Por defecto Semi habla con la voz del celular (`VOICE_SOURCE=device`), ajustada
para sonar cercana. Con `VOICE_SOURCE=backend` la app pide el audio a
`POST {API_BASE_URL}/v1/speech` (contrato en `docs/contracts/voz.md`), lo
guarda en el celular y, si no hay señal o el backend falla, vuelve a la voz del
celular. La voz del backend se puede probar aunque los datos sigan en `mock`.
La app no guarda claves de servicios de voz: las tiene el backend.

### Idiomas

Español, inglés y quechua (borrador). La app elige según el idioma y la región
del celular, y se puede cambiar en Ajustes. Para agregar o corregir textos,
edita `lib/core/l10n/app_<idioma>.arb` y ejecuta `flutter gen-l10n`; lo que
falta traducir al quechua queda en `docs/l10n_qu_pendientes.json`. Detalles en
`docs/ARCHITECTURE.md`, §5c.

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
