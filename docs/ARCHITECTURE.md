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
├── main.dart              # Bootstrap: lee AppConfig, abre el almacenamiento local y crea el ProviderScope
├── app/                   # Raíz de composición (único lugar que conoce todos los features)
│   ├── app.dart           # MaterialApp.router: tema, l10n, router
│   └── router/            # GoRouter + shell de pestañas
├── core/                  # Infraestructura transversal, SIN dependencias de features
│   ├── config/            # AppConfig (entorno, origen de datos), latencia de mocks
│   ├── error/             # AppException (sealed) + mensajes para el usuario
│   ├── l10n/              # app_es.arb → AppLocalizations (generado)
│   ├── network/           # ApiClient + HttpApiClient (package:http), ApiEndpoints, JsonObject, reintentos
│   ├── router/            # AppRoutes: paths de la app (constantes)
│   ├── services/speech/   # SpeechService (abstracto) + implementación TTS
│   ├── theme/             # Tokens: colores, tipografía, espaciado, breakpoints, ThemeData
│   └── utils/             # Formateadores, reloj inyectable, combinación de AsyncValue
├── shared/                # Compartido por varios features
│   ├── domain/            # Vocabulario, CampaignCatalog, CampaignContext, CampaignPreferencesStore, SeasonalOutlook, FarmLocation
│   ├── data/              # MockCatalog (única fuente de datos de ejemplo del catálogo), mocks, zona piloto,
│   │                      # almacén de preferencias (SharedPreferences / memoria) y su codec JSON
│   ├── state/             # campaignContextProvider, campaignCatalogProvider, seasonalOutlookProvider, farmLocationProvider
│   ├── presentation/      # Textos y colores del vocabulario
│   └── widgets/           # Design system (ver §5)
└── features/
    ├── farm/              # Pantalla 0: Mi parcela
    ├── climate/           # Pantalla 1: Clima
    ├── crop_planning/     # Pantallas 2, 2b, 3: Qué sembrar, Cuándo siembro, Rotación
    └── alerts/            # Pantallas 4, 4b: Avisos y mensaje
        ├── domain/        # Entidades, interfaz del repositorio, políticas y casos de uso
        ├── data/          # Mock<X>Repository (hoy) / Remote<X>Repository (con backend)
        └── presentation/  # providers/, screens/, widgets/, textos derivados
```

Se verificó con `grep` que ningún feature importa a otro, que `core` no
importa `shared` ni `features`, que ningún `domain/` importa Flutter, que
`MockCatalog` solo se usa desde capas `data/` y que fuera de `core/theme` no
hay tamaños de letra ni colores escritos a mano.

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
                 ├─ Mock<X>Repository    (DATA_SOURCE=mock)    datos de mvp.html
                 └─ Remote<X>Repository  (DATA_SOURCE=remote)  ──▶ ApiClient ──▶ backend
```

Hoy cada repositorio mock implementa directamente la interfaz: separar
"repositorio" y "data source" sin fuente remota solo añadiría indirección.
Cuando haya caché offline (B10), `Remote<X>Repository` combinará una fuente
remota y una local dentro de `data/`, sin tocar dominio ni presentación.

### Modo `remote` híbrido

Con `DATA_SOURCE=remote`, cada repositorio usa el backend
(`spaceapps-2026-core`) si ya tiene contrato, y los datos de ejemplo si no.
Así la app se puede probar completa contra el backend mientras se integra
pantalla por pantalla.

| Repositorio | Con `remote` | Endpoint / pendiente |
|---|---|---|
| `ClimateRepository` | **Backend** | `GET /api/v1/app/climate-overview` (Open-Meteo + NASA POWER) |
| `SeasonalOutlookRepository` | Ejemplo | Probabilidades del ENFEN; el backend aún no las publica |
| `FarmRepository` | Ejemplo | B4 |
| `CampaignCatalogRepository` | Ejemplo | B12 |
| `CropPlanningRepository`, `RotationRankingPolicy` | Ejemplo | B3, B6 |
| `AlertsRepository` | Ejemplo | B7 |

- La parcela se ubica con `farmLocationProvider` (hoy, la zona piloto de
  `shared/data/pilot_farm_location.dart`, la misma que `DEFAULT_LAT/LON` del
  backend).
- `SourceNote(…, backedByRemote: true)` marca las notas cuyos datos ya vienen
  del backend: "Cifras de ejemplo." solo se oculta en esas y solo con
  `remote`.
- Si el backend no puede calcular la comparación con un año normal, devuelve
  `anomalies: []` y la pantalla Clima oculta esa tarjeta.

### Ejemplo: la recomendación

```
campaignContextProvider ─┐ (ids de prioridad y restricciones, escenario)
campaignCatalogProvider ─┤ (prioridades y restricciones disponibles)
planningDataProvider ────┼─▶ recommendationProvider ──▶ Qué sembrar / Cuándo siembro / Rotación
seasonalOutlookProvider ─┘      usa GetRecommendation → RotationRanker (dominio)
                                                         └─ RotationRankingPolicy «interface»
                                                              └─ MockRotationRankingPolicy (data)
```

`recommendationProvider` es síncrono: al cambiar la prioridad o el escenario
se recalcula al instante, sin volver a pedir datos ni mostrar "cargando".

- **DI:** providers de Riverpod. El provider del data source elige la
  implementación según `AppConfig.dataSource`. Los tests sobrescriben providers.
- **Errores:** el data layer traduce todo a `AppException`. La UI muestra los
  errores con `AsyncValueView` / `ErrorView` y `userMessageFor`.
- **Catálogos abiertos vs. escalas cerradas:** cultivos, prioridades y
  restricciones son **datos** (`id` + nombre visible) que entrega la fuente
  de datos; la app no conoce una lista fija ni compara contra ids concretos.
  Escenarios climáticos y estado del suelo siguen siendo `enum`: son escalas
  ordenadas con significado visual fijo (color, medidor, titulares) y el
  backend deberá mapearse a ellas (B2).
- **Estado de campaña:** `campaignContextProvider` guarda **identificadores**
  (`lastCropId`, `priorityId`, `restrictionIds`) y el escenario explorado.
  `null` significa "usar el valor sugerido por los datos" (inferencia
  satelital, primera prioridad del catálogo, escenario más probable). Un id
  que ya no existe en los datos se trata como `null`.
- **Persistencia:** cada cambio de preferencia se guarda al instante en el
  dispositivo mediante `CampaignPreferencesStore` (JSON versionado bajo una
  sola clave). El escenario explorado no se guarda. Si el almacenamiento falla,
  la app sigue funcionando en memoria.

## 5. Navegación

| Ruta | Pantalla | Pestañas |
|---|---|---|
| `/parcela` | Mi parcela | No (inicial la primera vez; después se abre con `push` encima de cualquier pestaña) |
| `/clima` | Clima | Sí |
| `/que-sembrar` | Qué sembrar | Sí |
| `/que-sembrar/cuando-sembrar` | ¿Cuándo siembro? | No (encima del shell) |
| `/rotacion` | Rotación | Sí |
| `/avisos` | Avisos | Sí |
| `/avisos/:alertId` | Mensaje de aviso | No (encima del shell) |

`StatefulShellRoute.indexedStack` conserva el estado de cada pestaña. Al
cambiar de ruta se detiene la lectura en voz alta (como en la referencia).
Abrir la recomendación desde el mensaje del ENFEN fija el escenario del aviso
(`AlertMessage.relatedScenario`), como el `data-forzar` del HTML.

**Volver a la configuración ("Mi parcela"):**

- Primera vez (nada guardado): la app abre en Mi parcela y "Empezar" lleva a
  Clima.
- Con configuración guardada: la app abre directamente en Clima.
- Desde cualquier pestaña: el botón de ajustes de la cabecera
  (`FarmSettingsButton`) abre Mi parcela con `push`; muestra "Volver" y el
  botón "Listo" regresa a la misma pestaña. "Cambiar" en Qué sembrar hace lo
  mismo.
- "Volver a los valores sugeridos" borra lo guardado y ofrece "Deshacer".

### Diseño adaptable

| Ancho de ventana | Navegación | Contenido |
|---|---|---|
| < 600 dp (teléfono en vertical) | Barra inferior | 1 columna |
| 600–839 dp (teléfono en horizontal, tablet pequeña) | Riel lateral | 1 columna centrada |
| ≥ 840 dp (tablet) | Riel lateral con logo | Hasta 2 columnas |

- `AppBreakpoints` define los cortes (clases de tamaño de Material 3).
- `ResponsiveColumns` pone tarjetas lado a lado cuando el **contenido** mide
  ≥ 720 dp. Se usa en Mi parcela, Clima y Rotación (`ScreenLayout.wide`, hasta
  1040 dp). Las pantallas de lectura lineal se limitan a 600 dp para no
  alargar las líneas.
- Además, cada componente se adapta al texto grande (botón "Escuchar" solo
  icono, barras de probabilidad apiladas, semana desplazable).

### Design system (`shared/widgets`)

| Widget | Equivale en mvp.html |
|---|---|
| `ScreenLayout`, `ScreenContent`, `ScreenHeader` | `.pantalla`, `.contenido`, `.barra`, `.pie` |
| `ListenButton` | `.escuchar` (solo icono si el texto es muy grande) |
| `AppCard` (standard / highlighted / compact / flush) | `.tarjeta`, `.destacada`, `.compacta`, `.sin` |
| `AppButton` (primary / secondary / outline) | `.btn`, `.btn2`, `.btn3` |
| `SelectableChip`, `RadioOptionTile`, `SegmentedSelector` | `.chip`, `.prio`, `.seg` |
| `StatusPill`, `ColoredBlock` | `.estado`, `.tierra`, `.etiqueta`, `.bloque` |
| `ExplainerTile` | `<details class="significa">` |
| `NoticeTile` | `.aviso-item` |
| `AdviceBox`, `GuideDisclaimer`, `SourceNote`, `BulletList` | `.consejo`, `.guia`, `.nota`, `.razones` |
| `AsyncValueView` (carga / error / vacío) | — (no existía en la referencia) |
| `FarmSettingsButton` | — (acceso a Mi parcela desde las pestañas) |
| `ResponsiveColumns` | — (dos columnas en tablets) |

`SourceNote` añade "Cifras de ejemplo." salvo en las notas con
`backedByRemote: true` cuando `DATA_SOURCE=remote` (ver §4).

**Tokens:** los widgets no escriben tamaños de letra ni colores. Usan el
`TextTheme` o los estilos con nombre de `AppTypography` (`muted`, `caption`,
`cardTitle`, `metricValue`, `pill`…), los colores de `AppColors` y las
medidas de `AppSpacing` / `AppRadii` / `AppSizes`. Para variar solo el color
se usa `copyWith(color: …)`.

## 6. Decisiones técnicas (ADR resumido)

| # | Decisión | Motivo | Alternativas descartadas |
|---|---|---|---|
| 1 | **Riverpod 3** (sin codegen) para estado y DI | Estado derivado y compartido entre pantallas; `AsyncValue`; overrides para mocks y tests | BLoC (más boilerplate para estado cruzado), get_it (redundante) |
| 2 | **go_router** | Shell con pestañas que conservan estado; deep links futuros desde notificaciones | Navigator 2.0 manual |
| 3 | **equatable** para igualdad de valor | Evita reconstrucciones innecesarias y facilita tests, sin build_runner | freezed (se reevaluará al tener DTOs) |
| 4 | Excepciones tipadas + `AsyncValue` | Idiomático en Riverpod, sin dependencias extra | Either / fpdart |
| 5 | Sin clases DTO: el JSON se lee con `JsonObject` (lectura tipada que lanza `FormatException`) y se mapea directo al dominio en `data/` | Un solo contrato y pocos campos; los errores de formato se traducen a `UnexpectedException` en un único lugar | freezed / json_serializable (requieren build_runner) |
| 6 | Config con `--dart-define-from-file` | Nativo, sin dependencias; valida al arrancar | flutter_dotenv |
| 7 | Figtree incluida en assets | Funciona offline | google_fonts (descarga en runtime) |
| 8 | `flutter_tts` detrás de `SpeechService` | "Escuchar" es central; permite cambiar a audio del servidor (B8) | TTS directo en widgets |
| 9 | Colores como constantes (`AppColors`) | La referencia no tiene modo oscuro: KISS | ThemeExtension (se migra si llega el modo oscuro) |
| 10 | Strings en ARB (gen-l10n) | Sin texto fijo en widgets; formatos centralizados | Strings sueltos |
| 11 | Agrupación de miles con coma (`S/ 2,400`) | Convención peruana y de la referencia; `intl` usa punto para `es_PE` | `NumberFormat.decimalPattern('es_PE')` |
| 12 | Material Symbols para iconos | Incluidos en el SDK, cero dependencias | lucide / flutter_svg |
| 13 | `RotationRanker` (dominio) solo filtra por restricciones y ordena de forma estable; el **criterio** de cada prioridad es una `RotationRankingPolicy` intercambiable. La de ejemplo (`MockRotationRankingPolicy`, reglas del HTML) vive en `data/` | Las prioridades son datos: el cliente no puede saber qué significa cada una. Si el backend ordena (B3), la política devuelve `null` y se respeta su orden | Reglas fijas por prioridad en el dominio (versión anterior) |
| 14 | Las restricciones que descartan una opción vienen en los datos (`RotationOption.excludedBy`) | En el HTML la regla "algodón fuera" estaba fija en el código; así la decide el backend | Reglas fijas en el cliente |
| 15 | Reintentos automáticos solo para errores de red/tiempo (3, espera 1-2-4 s) | Conectividad rural; reintentar un 404 o un 401 no sirve | Reintentar todo (por defecto en Riverpod 3) |
| 16 | Reloj inyectable (`clockProvider`) | Fechas relativas ("Hoy", "Ayer") deterministas en tests | `DateTime.now()` directo |
| 17 | La hora se normaliza con espacio no separable U+00A0 | `intl` y `flutter_localizations` usan separadores distintos en "a. m." | Depender del que cargue primero |
| 18 | Énfasis en mensajes como `**texto**` | Formato mínimo para el mock; el real depende de B11 | Markdown completo |
| 19 | Cultivos, prioridades y restricciones como datos (`id` + nombre), no `enum` | Agregar un cultivo o una restricción no debe requerir publicar otra versión de la app | `enum` + textos en ARB (versión anterior) |
| 20 | Color de cultivo derivado del id (hash FNV-1a estable sobre una paleta de 5 tonos) | El cliente no conoce la lista de cultivos; el mismo cultivo tiene siempre el mismo color. Los de ejemplo conservan su color del HTML | `switch` por cultivo; color enviado por el backend (B13) |
| 21 | **`shared_preferences`** (`SharedPreferencesWithCache`) detrás de `CampaignPreferencesStore` | Sin señal en el campo, el agricultor no debe reconfigurar cada vez. Lectura síncrona para decidir la pantalla inicial. Se podrá sumar el perfil del servidor (B5) sin tocar pantallas | Sin persistencia; Hive/Isar/SQLite (excesivos para 3 valores) |
| 22 | Navegación adaptable: barra inferior < 600 dp, riel lateral ≥ 600 dp; dos columnas solo donde aportan | Tablets y teléfonos en horizontal; el riel libera alto | Solo centrar el contenido (versión anterior); `flutter_adaptive_scaffold` (dependencia extra) |
| 23 | Tipografía solo por tokens (`TextTheme` + `AppTypography`) | 38 estilos sueltos duplicaban tamaños; ahora un cambio de escala se hace en un lugar | Estilos inline |
| 24 | Lint `public_member_api_docs` activo | Todo miembro público lleva documentación; el analizador impide olvidarla | Documentar "cuando haya tiempo" |
| 25 | **`http`** detrás de `ApiClient` (`HttpApiClient`) | Solo hace falta GET/POST JSON sin autenticación; `MockClient` permite probar sin red. El cuerpo se decodifica como UTF-8 porque FastAPI no declara charset | `dio` (interceptores que todavía no se usan) |
| 26 | Modo `remote` híbrido: backend donde hay contrato, ejemplo en el resto | Permite integrar pantalla por pantalla sin romper la app | Todo o nada (versión anterior: `remote` fallaba en todas las pantallas) |
| 27 | Clima usa un endpoint hecho para la pantalla (`/app/climate-overview`) en lugar de combinar series en el cliente | El cálculo de anomalías y el consejo viven en el servidor (B11); la app hace una sola petición, mejor con mala señal | Pedir `/climate/forecast` y `/climate/history` y calcular en la app |

### Dependencias pospuestas

| Paquete | Cuándo |
|---|---|
| `dio` | Solo si la autenticación (B1) necesita interceptores |
| Caché local de datos | Al decidir el modo offline (B10) |
| `firebase_messaging` | Si los avisos usan push (B7) |

## 7. Decisiones pendientes del backend

| # | Tema | Pregunta abierta | Dónde impacta |
|---|---|---|---|
| B1 | Autenticación | ¿Cómo se identifica el agricultor? ¿Sesión o tokens? | `core/network`, nuevo feature `auth` |
| B2 | Contratos | **Parcial:** Clima ya tiene contrato (§4). Falta el resto de endpoints y usar el cuerpo de error `{"error": {"code", "message"}}` del backend | `data/` de cada feature, `ApiClient` |
| B3 | Recomendación | ¿Ranking en el servidor o en el cliente? Si es en el cliente, ¿quién define el criterio de cada prioridad? | `RotationRankingPolicy` |
| B4 | Parcela | Geometría, imagen satelital, inferencia del último cultivo | `farm` |
| B5 | Preferencias | Hoy en el dispositivo. ¿También en el perfil del servidor (cambio de teléfono)? | `CampaignPreferencesStore` |
| B6 | Feedback | Endpoint "qué sembré" y nivel de detalle | `crop_planning` |
| B7 | Avisos | ¿Polling, push o SMS? ¿Estado de leído (badge)? | `alerts`, `AppShell` |
| B8 | Audio | ¿TTS en el dispositivo o audio del servidor? ¿Narraciones del backend? | `SpeechService` |
| B9 | Chat | ¿Existe asistente conversacional? (hoy: deshabilitado, "Próximamente") | `alerts` |
| B10 | Offline | ¿Caché y antigüedad de datos aceptable? | `data/` de cada feature |
| B11 | Contenido | ¿Textos explicativos (fichas, razones) del servidor? | entidades de dominio |
| B12 | Catálogo | Endpoint de prioridades y restricciones (¿por valle? ¿por campaña?); cuál es la prioridad sugerida (hoy: la primera) | `CampaignCatalogRepository` |
| B13 | Color de cultivo | ¿Producto quiere un color fijo por cultivo? Si es así, el backend lo envía | `CropTone` |
| B14 | Varias parcelas | Ver propuesta en §8b (pendiente de aprobación) | `farm`, estado de campaña, todos los repositorios |

## 8. Huecos de la referencia (no se inventan soluciones)

| Hueco | Cómo quedó en la app |
|---|---|
| El "último cultivo" no afecta ningún resultado en el HTML | Se guarda en `CampaignContext.lastCropId` y se usa en la narración, pero `getPlanningData()` no lo recibe: lo que se compara ("Arroz y arroz") viene de los datos. Pendiente B3 |
| "Otro" cultivo y "Sembré otra cosa" no dicen cuál | Se registra solo `followedRecommendation: false` (B6) |
| Input y micrófono del chat sin comportamiento | Deshabilitados, con aviso "Podrás hacer preguntas próximamente" (B9) |
| Badge de avisos siempre visible | Se muestra si algún aviso tiene `isRead: false`; cómo se marca como leído depende de B7 |
| No hay login ni alta de parcela | Sin implementar; la parcela viene del repositorio (B1, B4) |
| Sin estados de carga, error ni vacío | Implementados en todas las pantallas con `AsyncValueView` |
| "Si al final no llueve tanto" se muestra en todos los escenarios | Se mantiene igual que la referencia; conviene revisarlo con producto |
| No había forma de volver a la configuración | Botón de ajustes en cada pestaña, "Listo" para volver, "Volver a los valores sugeridos" con "Deshacer" (ver §5) |

## 8b. Propuesta: varias parcelas por agricultor (pendiente de aprobación, sin implementar)

Hoy la app asume una sola parcela. Propuesta para soportar de 1 a N:

- **Dominio:** `Farm` gana un `id`. `FarmRepository` pasa a
  `getFarms()` (resumen: id, nombre, valle, hectáreas) y `getFarm(id)`.
- **Estado:** un `selectedFarmIdProvider` (guardado en el dispositivo, "la
  última que usó"). Los datos que dependen de la parcela (clima, planificación,
  avisos, contexto de campaña) se piden con el id de la parcela activa y se
  cachean por id, así cambiar de parcela y volver es instantáneo.
- **Preferencias por parcela:** el último cultivo es necesariamente por
  parcela; prioridad y restricciones también (el agua disponible cambia según
  la parcela). El almacén se indexa por id: `load(farmId)`.
- **UI:** con 1 parcela, la app queda idéntica a hoy (no se muestra ningún
  selector). Con 2 o más:
  - En la cabecera de cada pestaña, el nombre de la parcela activa con un
    selector (hoja inferior con la lista).
  - "Mi parcela" pasa a "Mis parcelas": lista y luego el detalle actual.
  - En Avisos, cada aviso muestra a qué parcela corresponde.
- **Preguntas para producto y backend:** ¿cuántas parcelas como máximo?
  ¿la recomendación considera las parcelas por separado o en conjunto (p.
  ej., el agua total del agricultor)? ¿los avisos son por parcela o por
  agricultor? ¿el agricultor puede dar de alta parcelas desde la app o vienen
  del registro (B4)?

## 9. Calidad y pruebas

- `flutter analyze`: lints de `flutter_lints` + modo estricto (`strict-casts`,
  `strict-inference`, `strict-raw-types`) y reglas adicionales, incluida
  `public_member_api_docs` (todo miembro público documentado).
- `test/` replica la estructura de `lib/` (99 tests):
  - **Unit:** config, errores, formateadores, reintentos, combinación de
    estados, ranking genérico, política de ejemplo, caso de uso, textos
    derivados, contexto de campaña (persistencia, restablecer, deshacer).
  - **Widget:** cada pantalla con datos, error y vacío; navegación; envío de
    respuesta; mensaje del ENFEN; Mi parcela abierta desde una pestaña;
    arranque con configuración guardada.
  - **Accesibilidad:** las guías de Flutter (área táctil, etiquetas,
    contraste) en todas las pantallas, y ausencia de desbordes en un teléfono
    de 360 dp con el texto al doble.
  - **Responsive:** barra inferior o riel según el ancho; una o dos columnas;
    sin desbordes en teléfono horizontal (texto 1× y 1.5×) y tablet
    (vertical, y horizontal con texto 2×).
- Los tests usan reloj fijo (domingo 8/11/2026, como la referencia), sin
  latencia y sin reintentos (`test/helpers/pump_app.dart`).
- `integration_test/`: flujo completo en dispositivo (Fase 5).

## 10. Historial

| Fecha | Cambio |
|---|---|
| 2026-11-10 | Fase 3: proyecto base, tema, router, DI, configuración de entornos, servicio de voz y tests de infraestructura |
| 2026-11-10 | Fase 4: design system, los 4 features con datos mock, recomendación con ranking en dominio, estados de carga/error/vacío, accesibilidad y texto grande |
| 2026-11-10 | Revisión de la Fase 4: catálogos como datos, criterio de orden como política intercambiable, preferencias guardadas en el dispositivo, volver a Mi parcela y restablecer, diseño adaptable (riel y dos columnas), tipografía por tokens, documentación obligatoria de código |
| 2026-11-13 | Integración con el backend: `HttpApiClient`, modo `remote` híbrido y Clima con datos reales (Open-Meteo + NASA POWER) |
