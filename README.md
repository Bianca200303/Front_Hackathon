# Siembra Segura

App Flutter (Android, iOS y web) que guía a los pequeños agricultores del
valle del Chira (Piura, Perú) sobre **qué, cuándo y cómo rotar lo que
siembran**, con datos de la NASA, el suelo de su chacra y lo que el propio
agricultor sabe de su tierra.

Proyecto para el reto _"Field Shift: Adapting Farms with NASA Data"_ del
**NASA Space Apps Challenge 2026**.

| | |
|---|---|
| **Backend** | [neilnathanhidalgo/spaceapps-2026-core](https://github.com/neilnathanhidalgo/spaceapps-2026-core) |
| **API en vivo** | <https://spaceapps-2026-core-production.up.railway.app> ([Swagger](https://spaceapps-2026-core-production.up.railway.app/docs)) |
| **Contrato de la API** | [docs/API_ESP.md del backend](https://github.com/neilnathanhidalgo/spaceapps-2026-core/blob/main/docs/API_ESP.md) |
| **Arquitectura y decisiones** | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) |
| **Ficha de Semi (el personaje guía)** | [`Personaje bot – App de agricultura.html`](<Personaje bot – App de agricultura.html>) |

## Qué hace

El agricultor marca su chacra en el mapa, dice a cuál de tres tierras se
parece la suya (arenosa, franca o arcillosa), qué sembró la última vez y qué
le importa más: **tener menos riesgo de clima, cuidar su agua o recuperar su
tierra**. La app le responde para un año de lluvias fuertes, uno normal y uno
seco.

| Pantalla | Qué responde | Datos (`DATA_SOURCE=remote`) |
|---|---|---|
| **Mi parcela** / conversación con Semi | Dónde está la chacra y qué busca el agricultor | Catálogo de cultivos, prioridades y restricciones del backend. Mapa satelital Sentinel-2 cloudless (EOX) |
| **Clima** | ¿Cómo viene el tiempo y cómo está frente a lo normal? | Backend: pronóstico Open-Meteo y anomalías NASA POWER |
| **Qué sembrar** | ¿Qué rotación me conviene según mi prioridad? | Backend: recomendación (ver abajo) |
| **¿Cuándo siembro?** | Calendario de siembra de la rotación elegida | Backend: recomendación |
| **Rotación** | Agua, riesgo y estado de la tierra en 2 años; "Prueba tu propio plan" | Backend: recomendación. El simulador de plan propio usa reglas de ejemplo |
| **Avisos** | Mensajes de alerta (tipo ENFEN) | Datos de ejemplo |

### Datos de la NASA detrás de la recomendación

| Fuente | Para qué se usa |
|---|---|
| **NASA POWER** | Clima de cada escenario, agua de riego por hectárea y los dos semáforos de agua |
| **MODIS NDVI** (ORNL DAAC) | Si el verdor de la chacra sube o baja en los últimos años |
| **SMAP** (AppEEARS) | Qué tan húmeda ha estado la capa superficial del suelo |
| **GPM IMERG** | Lluvia medida en la campaña actual |
| SoilGrids + la tierra que reconoce el agricultor | Suelo de la chacra; lo que dice el agricultor tiene prioridad |

MODIS, SMAP e IMERG tardan minutos en responder, así que el backend los pide
en segundo plano: **la primera consulta de una chacra nueva llega sin ellos y
las siguientes los incluyen**. Las dos chacras demo (Marcavelica y Amotape)
se dejan precalentadas con `scripts/warm_demo_farms.py` del backend.

### Semáforos de agua

"Qué sembrar" muestra dos indicadores que calcula el backend con NASA POWER:

- **Lluvia y tierra de tu zona:** lluvia y humedad de la tierra en la zona de
  las raíces de los últimos 6 meses, frente a los mismos meses de los 10 años
  anteriores.
- **Agua que llega por riego:** lluvia de la última temporada (diciembre a
  abril) en cuatro puntos de la cuenca alta del Chira-Catamayo (Ayabaca,
  Pacaipampa, Cariamanga y Catamayo), frente a las 10 temporadas anteriores.
  **Es una aproximación con lluvia, no el nivel real del reservorio de
  Poechos**; la app lo dice junto al semáforo.

El orden de las rotaciones usa el más desfavorable de los dos. Con datos de
ejemplo no hay semáforos. La validación con la sequía 2024-2025 está en el
backend: `scripts/validate_drought_2024.py`.

### Pensada para el agricultor

- **Semi**, un personaje guía, presenta cada pantalla con un mensaje y su voz
  (modo **Asistencia**), o se puede usar sin guía (**Llenado manual**).
- Todos los textos se pueden **escuchar**; botones y letras grandes; se adapta
  al texto agrandado del celular, a tablets y al modo oscuro.
- **Español, inglés y quechua** (borrador, debe revisarlo un hablante).
- Si el backend tarda, sirve la última respuesta real de esa chacra.

## Requisitos

- Flutter 3.35+ (Dart 3.9+)

## Ejecutar

### Con la API en vivo (recomendado para revisar)

```bash
flutter pub get
flutter run --dart-define-from-file=config/prod.json
```

Para instalarla en cualquier celular Android:

```bash
flutter build apk --release --dart-define-from-file=config/prod.json
```

El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.

En el navegador:

```bash
flutter run -d web-server --web-port 5050 --dart-define-from-file=config/prod.json
```

Abre <http://localhost:5050>. En la terminal, `r` recarga los cambios y `R`
reinicia la app. Para verla con tamaño de celular, abre las DevTools del
navegador y activa el modo dispositivo (`Ctrl+Shift+M`, o `Cmd+Shift+M` en
Mac).

### Solo la interfaz, sin backend

```bash
flutter run --dart-define-from-file=config/dev.json
```

Usa datos locales de ejemplo. Sin `--dart-define-from-file`, la app arranca
igual en `dev` + `mock`.

### Con el backend local

1. Levanta `spaceapps-2026-core` (`make dev`, puerto 8000).
2. Ejecuta la app con el archivo de tu dispositivo:

| Dispositivo | Archivo | Apunta a |
|---|---|---|
| Emulador de Android | `config/local.json` | `http://10.0.2.2:8000/` (el equipo visto desde el emulador) |
| Navegador | `config/web.json` | `http://localhost:8000/` |
| iPhone físico | `config/device.json` | El nombre Bonjour del Mac (`scutil --get LocalHostName` + `.local`); ajústalo al tuyo |

```bash
flutter run --dart-define-from-file=config/local.json
```

En el simulador de iOS usa `http://localhost:8000/`. El HTTP sin TLS solo
está permitido en las compilaciones de depuración de Android y para la red
local en iOS.

Para `-d chrome` sin Chrome instalado, apunta Flutter a otro navegador
Chromium con la variable `CHROME_EXECUTABLE` (por ejemplo, la ruta de Brave).

### Entornos

La configuración se inyecta en tiempo de compilación desde `config/<entorno>.json`:

| Clave | Valores | Descripción |
|---|---|---|
| `APP_ENV` | `dev` · `staging` · `prod` | Entorno |
| `DATA_SOURCE` | `mock` · `remote` | `mock` usa datos locales de ejemplo; `remote` usa el backend en las pantallas integradas (ver [Qué hace](#qué-hace)) y datos de ejemplo en el resto |
| `API_BASE_URL` | URL | Obligatoria si `DATA_SOURCE=remote` |
| `VOICE_SOURCE` | `device` · `backend` | Voz de Semi (ver abajo) |

`config/prod.json` apunta a la API en vivo; `config/prod.json.example` es la
plantilla para otro despliegue. No guardes secretos en estos archivos: todo
lo que se embebe en una app móvil puede extraerse.

El backend permite cualquier origen por defecto (`CORS_ORIGINS=*`); si lo
restringes, agrega el origen de la versión web (por ejemplo,
`http://localhost:5050`).

### Voz de Semi

Semi habla con la voz del celular (`VOICE_SOURCE=device`), ajustada para
sonar cercana y sin necesitar internet.

`VOICE_SOURCE=backend` está preparado en la app: pide el audio a
`POST {API_BASE_URL}/v1/speech` según [`docs/contracts/voz.md`](docs/contracts/voz.md),
lo guarda en el celular y, si falla, vuelve a la voz del celular. **El
backend todavía no implementa ese endpoint**, así que por ahora se usa
`device`.

## Idiomas

Español (base), inglés y quechua (borrador). La app elige según el idioma y
la región del celular, y se puede cambiar en Ajustes. Para agregar o corregir
textos, edita `lib/core/l10n/app_<idioma>.arb` y ejecuta:

```bash
flutter gen-l10n
```

Lo que falta traducir al quechua queda en `docs/l10n_qu_pendientes.json`.
Detalles en [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), §5c.

## Calidad

```bash
dart format lib test
flutter analyze
flutter test
```

Las pruebas recorren todas las pantallas en los 3 idiomas, con texto al
doble, en horizontal, en tablet y en modo oscuro.
