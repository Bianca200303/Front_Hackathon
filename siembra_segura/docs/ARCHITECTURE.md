# Arquitectura — Siembra Segura

Documento vivo. Actualizarlo con cada decisión técnica relevante.

## 1. Contexto

App móvil (Android + iOS) para pequeños agricultores del Medio Piura. Ayuda a
decidir qué sembrar según el pronóstico de El Niño (ENFEN), datos satelitales
(NASA) y modelos de rotación. Referencia visual y funcional: `../mvp.html`.

Usuarios con baja alfabetización digital y conectividad rural, lo que exige:
áreas táctiles grandes, lenguaje simple, lectura en voz alta y funcionamiento
robusto con mala señal.

## 2. Principios

- **Feature-first + Clean Architecture pragmática.** Capas por feature:
  `presentation → domain ← data`.
- **Domain es Dart puro.** No importa Flutter, HTTP ni librerías de datos.
- **Sin casos de uso que solo reenvían la llamada.** Solo se crean donde hay
  lógica de negocio real (p. ej., ranking de rotaciones).
- **Sin datos ficticios en widgets.** Todo dato viene de un repositorio; los
  mocks viven en `data/datasources/mock_*`.
- **Sin dependencias "por si acaso".** Se añaden cuando hay una necesidad
  concreta (ver §6).

## 3. Estructura

```
lib/
├── main.dart              # Bootstrap: lee AppConfig y crea el ProviderScope
├── app/                   # Raíz de composición (único lugar que conoce todos los features)
│   ├── app.dart           # MaterialApp.router: tema, l10n, router
│   └── router/            # GoRouter + shell de pestañas
├── core/                  # Infraestructura transversal, SIN dependencias de features
│   ├── config/            # AppConfig (entorno, origen de datos, URL base)
│   ├── error/             # AppException (sealed) + mensajes para el usuario
│   ├── l10n/              # app_es.arb → AppLocalizations (generado)
│   ├── network/           # Contrato ApiClient + ApiEndpoints
│   ├── router/            # AppRoutes: paths de la app (constantes)
│   ├── services/speech/   # SpeechService (abstracto) + implementación TTS
│   ├── theme/             # Colores, tipografía, espaciado, ThemeData
│   └── utils/             # Formateadores (soles, m³, %)
├── shared/                # Compartido por varios features
│   ├── domain/            # Vocabulario: Crop, ClimateScenario, CampaignPriority…
│   ├── state/             # campaignContextProvider (estado de campaña)
│   └── widgets/           # Design system y estados (carga/error/vacío)
└── features/
    ├── farm/              # Pantalla 0: Mi parcela
    ├── climate/           # Pantalla 1: Clima
    ├── crop_planning/     # Pantallas 2, 2b, 3: Qué sembrar, Cuándo siembro, Rotación
    └── alerts/            # Pantallas 4, 4b: Avisos y mensaje
        ├── domain/        # Entidades, interfaces de repositorio, políticas
        ├── data/          # Implementaciones de repositorio + data sources
        └── presentation/  # providers/, screens/, widgets/
```

### Reglas de dependencia

| Desde → hacia | ¿Permitido? |
|---|---|
| `features/*` → `core`, `shared` | Sí |
| `features/a` → `features/b` | **No.** Si dos features necesitan algo, sube a `shared` |
| `shared` → `core` | Sí |
| `core` → `shared`, `features` | **No** |
| `app` → todo | Sí (raíz de composición) |
| `domain` → Flutter / `data` / `presentation` | **No** |

`AppRoutes` vive en `core/router` (solo constantes) para que los features
naveguen sin depender de `app/`.

## 4. Comunicación entre capas

```
Screen (ConsumerWidget)
  └─ ref.watch(xProvider) ──▶ AsyncValue<T>  (loading / error / data)
        │
Provider / Notifier (presentation)
  └─ usa ──▶ Repository «interface» (domain)
                 ▲ implementa
            RepositoryImpl (data)
                 ├─ MockDataSource      (DATA_SOURCE=mock)
                 └─ RemoteDataSource    (DATA_SOURCE=remote) ──▶ ApiClient ──▶ backend
```

- **DI:** providers de Riverpod. El provider del data source elige la
  implementación según `AppConfig.dataSource`. Los tests sobrescriben providers.
- **Errores:** el data layer traduce todo a `AppException`. La UI muestra los
  errores con `AsyncValueView` / `ErrorView` y `userMessageFor`.
- **Estado de campaña:** `campaignContextProvider` (prioridad, restricciones,
  último cultivo, escenario). `null` en `lastCrop` / `selectedScenario`
  significa "usar el valor sugerido por los datos" (inferencia satelital /
  escenario más probable), sin fijarlos en el código.

## 5. Navegación

| Ruta | Pantalla | Pestañas |
|---|---|---|
| `/parcela` | Mi parcela (inicial) | No |
| `/clima` | Clima | Sí |
| `/que-sembrar` | Qué sembrar | Sí |
| `/que-sembrar/cuando-sembrar` | ¿Cuándo siembro? | No (encima del shell) |
| `/rotacion` | Rotación | Sí |
| `/avisos` | Avisos | Sí |
| `/avisos/:alertId` | Mensaje de aviso | No (encima del shell) |

`StatefulShellRoute.indexedStack` conserva el estado de cada pestaña. Al
cambiar de ruta se detiene la lectura en voz alta (como en la referencia).

## 6. Decisiones técnicas (ADR resumido)

| # | Decisión | Motivo | Alternativas descartadas |
|---|---|---|---|
| 1 | **Riverpod 3** (sin codegen) para estado y DI | Estado derivado y compartido entre pantallas; `AsyncValue`; overrides para mocks y tests | BLoC (más boilerplate para estado cruzado), get_it (redundante) |
| 2 | **go_router** | Shell con pestañas que conservan estado; deep links futuros desde notificaciones | Navigator 2.0 manual |
| 3 | **equatable** para igualdad de valor | Evita reconstrucciones innecesarias y facilita tests, sin build_runner | freezed (se reevaluará al tener DTOs) |
| 4 | Excepciones tipadas + `AsyncValue` | Idiomático en Riverpod, sin dependencias extra | Either / fpdart |
| 5 | Sin DTOs ni serialización todavía | No hay contratos de backend (B2) | Inventar JSON |
| 6 | Config con `--dart-define-from-file` | Nativo, sin dependencias; valida al arrancar | flutter_dotenv |
| 7 | Figtree incluida en assets | Funciona offline | google_fonts (descarga en runtime) |
| 8 | `flutter_tts` detrás de `SpeechService` | "Escuchar" es central; permite cambiar a audio del servidor (B8) | TTS directo en widgets |
| 9 | Colores como constantes (`AppColors`) | La referencia no tiene modo oscuro: KISS | ThemeExtension (se migra si llega el modo oscuro) |
| 10 | Strings en ARB (gen-l10n) | Sin texto fijo en widgets; formatos centralizados | Strings sueltos |
| 11 | Agrupación de miles con coma (`S/ 2,400`) | Convención peruana y de la referencia; `intl` usa punto para `es_PE` | `NumberFormat.decimalPattern('es_PE')` |
| 12 | Material Symbols para iconos | Incluidos en el SDK, cero dependencias | lucide / flutter_svg |

### Dependencias pospuestas

| Paquete | Cuándo |
|---|---|
| `dio` | Al definir contratos y autenticación (B1, B2) |
| `shared_preferences` / caché local | Al decidir la persistencia y el modo offline (B5, B10) |
| `firebase_messaging` | Si los avisos usan push (B7) |

## 7. Decisiones pendientes del backend

| # | Tema | Pregunta abierta | Dónde impacta |
|---|---|---|---|
| B1 | Autenticación | ¿Cómo se identifica el agricultor? ¿Sesión o tokens? | `core/network`, nuevo feature `auth` |
| B2 | Contratos | Endpoints, formatos, IDs, formato de error | `data/` de cada feature, `ApiClient` |
| B3 | Recomendación | ¿Ranking en el servidor o en el cliente? | `crop_planning/domain` |
| B4 | Parcela | Geometría, imagen satelital, inferencia del último cultivo | `farm` |
| B5 | Preferencias | ¿Perfil en el servidor o en el dispositivo? | `campaignContextProvider` |
| B6 | Feedback | Endpoint "qué sembré" y nivel de detalle | `crop_planning` |
| B7 | Avisos | ¿Polling, push o SMS? ¿Estado de leído (badge)? | `alerts`, `AppShell` |
| B8 | Audio | ¿TTS en el dispositivo o audio del servidor? ¿Narraciones del backend? | `SpeechService` |
| B9 | Chat | ¿Existe asistente conversacional? (hoy: deshabilitado, "Próximamente") | `alerts` |
| B10 | Offline | ¿Caché y antigüedad de datos aceptable? | `data/` de cada feature |
| B11 | Contenido | ¿Textos explicativos (fichas, razones) del servidor? | entidades de dominio |

## 8. Huecos de la referencia (no se inventan soluciones)

- El "último cultivo" seleccionado no afecta a ningún resultado en el HTML; los
  textos "arroz" están fijos en el código.
- "Otro" cultivo y "Sembré otra cosa" no permiten especificar cuál.
- Input y micrófono del chat sin comportamiento.
- No hay login, alta de parcela ni estados de carga o error.

## 9. Calidad y pruebas

- `flutter analyze`: lints de `flutter_lints` + modo estricto (`strict-casts`,
  `strict-inference`, `strict-raw-types`) y reglas adicionales.
- `test/` replica la estructura de `lib/`:
  - **Unit:** config, errores, formateadores, estado de campaña, políticas de
    dominio y repositorios.
  - **Widget:** navegación, pantallas en cada estado y design system.
- `integration_test/`: flujo completo (Fase 5).
- Accesibilidad: mínimo táctil de 48 dp, `Semantics`, soporte de texto grande.

## 10. Historial

| Fecha | Cambio |
|---|---|
| 2026-11-10 | Fase 3: proyecto base, tema, router, DI, configuración de entornos, servicio de voz y tests de infraestructura |
