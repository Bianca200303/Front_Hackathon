# Arquitectura — Siembra Segura

Documento vivo. Actualizarlo con cada decisión técnica relevante.

## 1. Contexto

App móvil (Android + iOS) para pequeños agricultores del Medio Piura. Ayuda a
decidir qué sembrar combinando datos de la NASA (lluvia y temperatura de
POWER, verdor MODIS, humedad SMAP, lluvia medida GPM IMERG), el suelo del
punto (SoilGrids más la textura que reconoce el agricultor), la ficha de cada
cultivo (agua que pide, duración, si fija nitrógeno) y las prioridades del
agricultor. El agricultor **explora**: marca su chacra en el mapa, dice a cuál
de tres tierras se parece la suya, elige el escenario climático (lluvias
fuertes / normal / seco; por defecto normal) y puede armar su propia secuencia
de cultivos. Referencia visual y funcional: `../mvp.html`.

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
│   ├── services/speech/   # SpeechService (abstracto) + TTS del dispositivo + voz de Semi (backend)
│   ├── theme/             # Tokens: colores, tipografía, espaciado, breakpoints, ThemeData
│   └── utils/             # Formateadores, reloj inyectable, combinación de AsyncValue
├── shared/                # Compartido por varios features
│   ├── domain/            # Vocabulario, CampaignCatalog, CampaignContext, CampaignPreferencesStore, FarmLocation
│   ├── data/              # MockCatalog (única fuente de datos de ejemplo del catálogo), mocks, zona piloto,
│   │                      # almacén de preferencias (SharedPreferences / memoria) y su codec JSON
│   ├── state/             # campaignContextProvider, campaignCatalogProvider, farmLocationProvider
│   ├── presentation/      # Textos y colores del vocabulario
│   └── widgets/           # Design system (ver §5); semi/: el personaje Semi
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
| `CampaignCatalogRepository` | **Backend** | `GET /api/v1/app/catalog` (prioridades, restricciones, texturas de suelo, ficha de cada cultivo y cuántos cultivos se pueden encadenar) |
| `CropPlanningRepository` | **Backend** | `POST /api/v1/app/recommendation` (NASA POWER + SoilGrids + la textura que reportó el agricultor + verdor MODIS + humedad SMAP + lluvia GPM IMERG + parámetros agronómicos) |
| `RotationRankingPolicy` | **Backend** | El orden viene en la respuesta; la política local devuelve `null` (decisión 13) |
| `FarmRepository` | Ejemplo | B4 |
| `AlertsRepository` | Ejemplo | B7 |

`submitPlantingFeedback` todavía no tiene endpoint (B6): con `remote` la
respuesta se guarda en memoria.

- La parcela se ubica con `farmLocationProvider`: las coordenadas que el
  agricultor marcó en el mapa de Mi parcela o, si no marcó ninguna, el centro
  de la zona piloto (`shared/data/pilot_farm_location.dart`, la misma que
  `DEFAULT_LAT/LON` del backend). El recuadro en el que se puede marcar es
  `pilotValleyBounds`; el nombre del valle sigue siendo el de la zona piloto
  (la app no sabe resolverlo desde las coordenadas, B4).
- `SourceNote(…, backedByRemote: true)` marca las notas cuyos datos ya vienen
  del backend: "Cifras de ejemplo." solo se oculta en esas y solo con
  `remote`.
- Si el backend no puede calcular la comparación con un año normal, devuelve
  `anomalies: []` y la pantalla Clima oculta esa tarjeta.

### Ejemplo: la recomendación

```
cropPlanningQueryProvider ─▶ planningDataProvider ─┐   (hectáreas, fecha de
  (parcela, hectáreas, fecha de siembra,           │    siembra, campañas
   campañas seguidas, último cultivo,              │    seguidas, parcela,
   rotación propia)                                │    rotación propia)
campaignContextProvider ───────────────────────────┼─▶ recommendationProvider
  (ids de prioridad y restricciones, escenario)    │      │
campaignCatalogProvider ───────────────────────────┘      ▼
  (prioridades y restricciones disponibles)      Qué sembrar / Cuándo siembro / Rotación

recommendationProvider usa GetRecommendation → RotationRanker (dominio)
                                                 └─ RotationRankingPolicy «interface»
                                                      ├─ ServerRotationRankingPolicy (remote)
                                                      └─ MockRotationRankingPolicy (ejemplo)
```

`recommendationProvider` es síncrono: al cambiar la **prioridad**, las
**restricciones** o el **escenario** se recalcula al instante, sin volver a
pedir datos ni mostrar "cargando". Por eso la petición **no** envía la
prioridad ni las restricciones: el backend devuelve el orden de todas las
prioridades para los tres escenarios y marca las opciones descartadas
(`excludedBy`), y la app elige. Lo que sí vuelve a pedir datos es cambiar la
ubicación de la chacra, las hectáreas, la fecha de siembra, las campañas
seguidas, el último cultivo o la rotación propia: cambian el cálculo del
servidor. `AsyncValueView` usa `skipLoadingOnReload`, así que al recalcular se
mantiene en pantalla lo anterior en vez de parpadear "Cargando".

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
- **Estado de campaña:** `campaignContextProvider` guarda **identificadores y
  valores simples** (`lastCropId`, `priorityId`, `restrictionIds`,
  `areaHectares`, `plantingDate`, `consecutiveCampaigns`, `soilTexture`) y el
  escenario explorado. `null` significa "usar el valor sugerido" (inferencia satelital,
  primera prioridad del catálogo, escenario normal, 1 ha, hoy, 1 campaña);
  los providers `selectedAreaHectaresProvider`,
  `selectedPlantingDateProvider` y `selectedConsecutiveCampaignsProvider`
  resuelven ese valor. Un id que ya no existe en los datos se trata como
  `null`.
- **Tierra del agricultor:** `CampaignContext.soilTexture` guarda a cuál de
  las texturas del catálogo (`sandy` / `loamy` / `clayey`) dijo que se parece
  su chacra. Se envía como `reported_soil_texture` y **manda sobre SoilGrids**
  en el cálculo del servidor: cambia cuánta lluvia aprovecha el cultivo, así
  que al contestar se vuelven a pedir los datos. `null` = "no estoy seguro",
  y entonces decide el satélite.
- **Lluvia ya medida:** `CropPlanningData.measuredRainNote` es la frase con la
  que el backend cuenta cuánto llovió sobre la chacra (GPM IMERG) y a qué
  escenario se parece el año. Se muestra en "Explorar otros escenarios" y es
  `null` mientras el backend no la tenga (ver §4, modo híbrido).
- **Rotación propia:** `CampaignContext.customRotation` guarda los ids que
  encadenó el agricultor (vacío = solo las rotaciones que propone la fuente).
  Se envía en la petición y vuelve como una opción más con el id
  `CropPlanningData.customRotationId` (`custom`), que compite en el ranking y
  trae su propio calendario, agua, riesgo y plan a dos años.
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
  (`AppSettingsButton`) abre Mi parcela con `push`; muestra "Volver" y el
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
  icono, valor y botones `−`/`+` apilados, semana desplazable).

### Design system (`shared/widgets`)

| Widget | Equivale en mvp.html |
|---|---|
| `ScreenLayout`, `ScreenContent`, `ScreenHeader` | `.pantalla`, `.contenido`, `.barra`, `.pie` |
| `ListenButton` | `.escuchar` (solo icono si el texto es muy grande) |
| `AppCard` (standard / highlighted / compact / flush) | `.tarjeta`, `.destacada`, `.compacta`, `.sin` |
| `AppButton` (primary / secondary / outline) | `.btn`, `.btn2`, `.btn3` |
| `SelectableChip`, `RadioOptionTile`, `SegmentedSelector` | `.chip`, `.prio`, `.seg` |
| `AppButton(icon: …)` | — (abre el selector de fechas en Mi parcela) |
| `ParcelMapCard` (mapa tocable), `SoilTextureCard`, `CustomRotationCard` | — (marcar la chacra, reconocer la tierra y armar la rotación) |
| `StatusPill`, `ColoredBlock` | `.estado`, `.tierra`, `.etiqueta`, `.bloque` |
| `ExplainerTile` | `<details class="significa">` |
| `NoticeTile` | `.aviso-item` |
| `AdviceBox`, `GuideDisclaimer`, `SourceNote`, `BulletList` | `.consejo`, `.guia`, `.nota`, `.razones` |
| `AsyncValueView` (carga / error / vacío) | — (no existía en la referencia) |
| `AppSettingsButton` | — (acceso a Mi parcela desde las pestañas) |
| `SemiAvatar`, `SemiGuide`, `AppSettingsButton` / `showAppSettings` | — (Semi y los modos de uso; ver §5b) |
| `ResponsiveColumns` | — (dos columnas en tablets) |

`SourceNote` añade "Cifras de ejemplo." salvo en las notas con
`backedByRemote: true` cuando `DATA_SOURCE=remote` (ver §4).

**Tokens:** los widgets no escriben tamaños de letra ni colores. Usan el
`TextTheme`, los estilos con color de `context.text` (`muted`, `caption`,
`cardTitle`, `metricValue`…) o los sin color de `AppTypography` (`pill`,
`chip`…), los colores de `context.colors` (`AppPalette`) y las medidas de `AppSpacing` / `AppRadii` / `AppSizes`. Para variar solo el color
se usa `copyWith(color: …)`.

## 5b. Semi y los modos de uso

La app tiene dos modos con **las mismas funciones y los mismos datos**; solo
cambia la presentación (`AppMode`, guardado en el dispositivo con
`AppModeStore`):

| Modo | Qué ve la persona |
|---|---|
| **Asistencia** (por defecto) | Semi presenta cada pantalla con un mensaje y su voz (`SemiGuide`) |
| **Llenado manual** | Las pantallas directas, sin guía |

- **Primera vez:** pantalla de bienvenida (§5d), hay que elegir para seguir.
- **Cambiar después:** selector **[Asistencia | Llenado manual]** arriba de
  todas las pantallas, en los dos modos. Es la única forma de cambiar, a
  propósito: una carita sin texto en la cabecera resultó difícil de encontrar.
- `SemiGuide` (selector + tarjeta de Semi) va en `ScreenLayout.guide` y se
  desplaza con el contenido
  (`NestedScrollView`): con letra grande o en horizontal no tapa la pantalla.
  Con poco alto o letra > 1.3× se muestra compacto (cabeza y dos líneas; al
  tocarlo, el mensaje completo).
- Semi se dibuja con `CustomPainter` (`SemiPainter`), copiando las formas del
  SVG de su ficha (`Personaje bot – App de agricultura.html`). Así se animan
  piezas sueltas (parpadeo, saludo, saltito) sin dependencias. Las
  animaciones son cortas y no se repiten en bucle (no bloquean
  `pumpAndSettle`) y se apagan si el sistema pide reducir movimiento.
- Expresiones: feliz, pensando, alerta, celebra. Sus colores están en
  `SemiColors`.
- **Voz:** con `VOICE_SOURCE=backend`, `ClipSpeechService` pide cada frase a
  `POST v1/speech` (`BackendSpeechClient`, contrato en `docs/contracts/voz.md`),
  la guarda en caché (archivo temporal por hash de URL + texto) y la reproduce
  con `audioplayers`. Sin red o con error, cae a `flutter_tts`, ajustado para
  sonar cercano (tono 1.12, ritmo 0.42, mejor voz en español sin internet).
  Antes de hablar, `SpeechText` cambia símbolos por palabras (`mm` → milímetros,
  `°C` → grados). Todos los botones "Escuchar" usan esta misma voz.

## 5c. Idiomas

- **Idiomas:** español (base), inglés y quechua. El quechua es un
  **borrador** (quechua sureño): solo están traducidas las pantallas
  principales, los botones y las frases de Semi; lo demás se muestra en
  español (gen-l10n usa el texto base). La lista de lo que falta está en
  `docs/l10n_qu_pendientes.json` y se regenera con `flutter gen-l10n`.
  **Debe revisarlo un hablante antes de publicar.**
- **Cómo se elige** (`AppLanguage.resolve`): el primer idioma del celular que
  la app tenga (acepta `qu`, `quz`, `quy`…); si no tiene ninguno, la región
  del celular (país hispanohablante → español); si no, inglés. Sin GPS.
- **A mano:** Ajustes → Idioma, y el botón "Idioma" de la bienvenida (los
  celulares casi nunca ofrecen quechua como idioma del sistema). Se guarda en
  el dispositivo; "Automático" vuelve a seguir al celular.
- **Lo que sigue al idioma** (`appLanguageProvider`): textos (ARB), fechas
  (`AppFormatters.useLanguage`; en quechua, nombres de días y meses en
  español porque `intl` no los tiene), textos de Flutter (en quechua, los de
  español: `FallbackLocalizations`), datos de ejemplo (`MockText`, tabla
  `mock_text_translations.dart`) y la voz de Semi (voz en inglés; en quechua,
  la de español de Perú, porque los celulares no traen voz quechua).
- **Responsive:** `test/app/languages_test.dart` recorre todas las pantallas
  en los 3 idiomas en teléfono pequeño (320×568), con texto al doble, en
  horizontal y en tablet; un desborde hace fallar la prueba.

## 5d. Bienvenida y apariencia

- **Bienvenida** (`AppRoutes.welcome`, feature `onboarding`): la primera vez
  (sin modo guardado) la app abre ahí, como `#v-inicio` de `semi_app.html`:
  Semi se presenta, aviso "personaje creado con IA", "Escuchar" y dos
  opciones grandes: "Que Semi me pregunte" (asistido) y "Llenar yo mismo"
  (manual). Arriba, idioma y claro/oscuro. Por ahora ambas opciones llevan a
  la conversación con Semi (asistido) o a "Mi parcela" (manual).
- **Conversación con Semi** (`AppRoutes.farmChat`, `FarmChatScreen` en el
  feature `farm`, como `#v-chat`): las mismas preguntas que "Mi parcela", una
  por una, con el porqué de cada una, barra de progreso, "Escuchar" y la
  respuesta del agricultor a la vista. Pasos: confirmar la chacra (mapa del
  satélite), último cultivo (lo del satélite primero), prioridad y
  restricción (una sola; el formulario permite varias). Guarda lo mismo que
  el formulario (`campaignContextProvider`). Semi "piensa" 0,75 s antes de
  hablar (nada si el celular pide reducir movimiento). En tablet u
  horizontal, Semi va a la izquierda. Ajustes → "Cambiar los datos" abre la
  conversación o el formulario según el modo. El valle, el nombre de la
  chacra y las varias chacras del prototipo esperan a B14.
- **Apariencia:** Automático (sigue al celular), Claro u Oscuro, en Ajustes y
  en la bienvenida. Se guarda en el dispositivo (`themeModeProvider`).
- **Contraste:** `test/app/dark_mode_test.dart` recorre todas las pantallas
  en oscuro con la guía de contraste de Flutter.

## 5e. Ayuda de Semi

- Botón **"Ayuda"** con la cara de Semi en las 4 pestañas (`SemiHelpButton`
  en `AppShell`, como `.semi-fab`). Las listas dejan espacio al final
  (`AppSizes.helpButtonClearance`) para que no tape el último contenido.
- **Sin IA:** preguntas y respuestas fijas en los ARB (funcionan sin internet
  y en los 3 idiomas). Grupos: "Qué significa" (según la pestaña), "Cambiar
  algo" (pantalla clara/oscura, modo, datos de la chacra, idioma: Semi lo
  hace) y "Cómo se usa".
- **Escribir una duda:** se busca por palabras clave (`help*K` en los ARB,
  separadas por comas) en todas las preguntas, sin tildes ni mayúsculas
  (`normalizeForSearch`); gana la que más letras coinciden. Si nada
  coincide, Semi lo dice y ofrece las preguntas.
- Para agregar una pregunta: claves `helpXQ`, `helpXA`, `helpXK` en los ARB y
  una entrada en `_topics` de `semi_help.dart`.

## 5f. Prueba tu propio plan

- En Rotación (`PlanSimulatorCard`, como `#r-campanas`): las 4 campañas del
  plan recomendado; se toca una y se elige el cultivo de una lista (más
  simple que "cultivo y después campaña" del prototipo). Los cultivos que una
  restricción descarta aparecen bloqueados con el motivo.
- "Ver cómo te iría" muestra campaña por campaña la cosecha (o "Abona la
  tierra" para el abono verde) y al final cosecha promedio, agua en 2 años y
  tierra, comparado con el plan recomendado calculado con las mismas reglas.
  La revelación usa una animación corta (nada si se pide reducir movimiento).
- El cálculo está detrás de `PlanSimulator` (dominio). `MockPlanSimulator`
  (datos) usa las reglas de `semi_app.html`: repetir familia cansa la tierra
  y baja la cosecha, las leguminosas y el abono verde abonan, con menos agua
  rinde menos y cada cultivo aguanta distinto las lluvias fuertes. Primera
  campaña con el escenario elegido; las siguientes, año normal. Sin precios.

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
| 9 | Colores en una `ThemeExtension` (`AppPalette`, claro y oscuro), leídos con `context.colors`; estilos de texto con color con `context.text` | `semi_app.html` trae modo oscuro; el cambio conserva el estado de cada pantalla. En oscuro, verde y azul pasan a tonos claros con texto oscuro (Material 3) para cumplir contraste AA | Constantes `AppColors` (versión anterior, sin modo oscuro) |
| 10 | Strings en ARB (gen-l10n) | Sin texto fijo en widgets; formatos centralizados | Strings sueltos |
| 11 | Agrupación de miles con coma (`15,600 m³`) | Convención peruana y de la referencia; `intl` usa punto para `es_PE` | `NumberFormat.decimalPattern('es_PE')` |
| 12 | Material Symbols para iconos | Incluidos en el SDK, cero dependencias | lucide / flutter_svg |
| 13 | `RotationRanker` (dominio) filtra por restricciones y aplica, en este orden: el orden que manda la fuente (`CropPlanningData.ranking`, por prioridad y escenario), el criterio de la `RotationRankingPolicy` o el orden de llegada. Con `remote`, `ServerRotationRankingPolicy` devuelve `null`; con datos de ejemplo, `MockRotationRankingPolicy` replica los criterios del servidor | Las prioridades son datos: el cliente no puede saber qué significa cada una. Resuelto B3: ordena el servidor | Reglas fijas por prioridad en el dominio (versión anterior) |
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
| 28 | Sin ganancia esperada, pérdida máxima ni probabilidades por escenario. Se comparan **agua de riego (m³)**, **riesgo de clima** (`low`/`medium`/`high`) y estado de la tierra; el agricultor elige el escenario | No hay datos de precios ni costos que respalden cifras en soles, y las probabilidades del ENFEN no las publica el backend. Prometer plata que no se puede sustentar es el peor error posible frente al agricultor | Mantener cifras de ejemplo en soles (versión anterior) |
| 29 | Las hectáreas, la fecha de siembra y las campañas seguidas son entradas del agricultor en Mi parcela, guardadas como el resto de las preferencias | Son los datos que el servidor necesita para calcular el riego y el estado del suelo, y nadie más los sabe. `Farm` ya no trae las hectáreas: las decide el agricultor | Inferirlas del registro de la parcela (no existe, B4) |
| 30 | La fecha de siembra se elige con `showDatePicker` de Flutter | Localizado, accesible y sin dependencias; `GlobalMaterialLocalizations` ya está registrado | Campo de texto con formato (errores de tipeo) |
| 31 | Las hectáreas y las campañas se ajustan con botones `−`/`+` (pasos de 0.5 ha y de 1 campaña) | Dos áreas táctiles grandes son más fáciles que un teclado numérico para alguien con baja alfabetización digital | `TextField` numérico; `Slider` (impreciso) |
| 32 | La chacra se marca tocando una **ilustración** del valle acotada por `pilotValleyBounds`, no un mapa con teselas | Cumple el enunciado ("el agricultor toca su chacra") sin dependencias nuevas y funciona sin señal, que es la norma en el campo. Las coordenadas se muestran con 4 decimales y se guardan | `flutter_map` / `google_maps_flutter` (dependencia nueva, pendiente de aprobación); imagen satelital del backend (B4) |
| 33 | El agricultor puede armar su propia secuencia (`custom_rotation`) y el servidor la devuelve como una opción más | El reto pide explorar, no dictar: cambiar un cultivo y ver cómo cambian agua y tierra. Calcularla en el servidor evita duplicar la lógica agronómica en la app | Editar solo en el cliente con cifras estimadas |
| 34 | El suelo del punto (SoilGrids) y el verdor (MODIS NDVI) llegan como texto en `soilHealth.findings`, además de los campos estructurados | La pantalla ya pinta esos hallazgos como lista; así el backend puede sumar fuentes sin tocar la app | Modelar cada fuente en el dominio de la app |
| 35 | La textura de la tierra es una **escala cerrada** (`SoilTexture`, tres valores) y sus textos son **datos** (`soil_textures` del catálogo) | La app dibuja una ilustración por valor, así que necesita conocerlos; los nombres y el "cómo la reconoces" los escribe el equipo agronómico sin publicar otra versión. Lista vacía en el catálogo = la pregunta no se muestra | Catálogo abierto (no habría ilustración); enum con textos en ARB |
| 36 | Las tres tierras se dibujan con `CustomPainter` (granos, migas, terrones agrietados), no con fotos | Cumple "¿tu tierra se parece a esta?" sin sumar megas de imágenes a una app que se usa sin señal, y escala con el texto grande. Si producto consigue fotos reales del valle, se cambia el `leading` de la opción | Fotos en `assets/` (peso, y una foto equivocada confunde más que una ilustración) |
| 37 | SMAP llega como un hallazgo más de `soilHealth.findings` y la app no lo modela | Es una observación que el backend decidió **no** meter en el cálculo del riego (los primeros 5 cm no son el agua de las raíces); como texto no obliga a tocar la app (decisión 34) | Campos estructurados de humedad en el dominio |
| 38 | La lluvia medida (GPM IMERG) se muestra en "Explorar otros escenarios", no en Clima | Es la respuesta medida a "¿a qué escenario se parece este año?", justo donde el agricultor elige el escenario | Una tarjeta aparte en Clima (duplicaría el tema del agua) |
| 39 | Dos modos de uso (Asistencia / Llenado manual) sobre las mismas pantallas y providers | Niños y quien necesita guía, y agricultores que quieren ir rápido, sin duplicar lógica | Dos apps o dos juegos de pantallas |
| 40 | Semi dibujado con `CustomPainter` | Animar ojos, brazo y brote; cero dependencias; colores por tokens | `flutter_svg` (imagen estática), Rive/Lottie (requiere animador) |
| 41 | Voz de Semi generada en el **backend** (`POST v1/speech`) detrás de `SpeechService`, con caché local y respaldo `flutter_tts`; **`audioplayers`** para reproducir | El clima y los datos cambian por día y por valle: no alcanzan audios grabados. La app se usa con red; el backend guarda la clave del motor de voz y cachea por texto | ElevenLabs llamado desde la app (la clave viajaría en el APK), voz neural dentro de la app (sherpa-onnx, +20–80 MB), solo audios grabados |
| 42 | `http://` permitido solo en el manifiesto de **debug** de Android | Probar el backend local desde el emulador (`10.0.2.2`); release exige `https://` | Permitirlo en todas las builds |
| 43 | Idioma automático por idioma y región del celular, con selector manual; quechua como borrador con respaldo en español | Funciona en cualquier país sin pedir permisos; el quechua llega aunque falte traducir | Elegir por GPS/IP (permisos, red); esperar la traducción completa |
| 44 | Los datos de ejemplo se traducen con una tabla (`MockText`) con el español como clave | Los textos de contenido los mandará el backend ya traducidos (B18); el mock solo imita eso | Duplicar los datos por idioma |
| 45 | Los estilos de texto de los botones nombran la fuente (`Figtree`) | Flutter no hereda la fuente del tema en los botones: salían con la del sistema | Confiar en `ThemeData.fontFamily` |
| 46 | **Sin dinero ni cosecha estimada** (al unir `semi-rediseno` con `main`): las opciones se comparan por agua de riego (m³), riesgo de clima y estado de la tierra (decisión 28); la prioridad es "Menos riesgo de clima" | Es lo que calcula el backend (`POST /app/recommendation`); la "cosecha esperada" de `semi_app.html` no tiene fuente en el servidor | Cosecha esperada en % de una buena campaña (solo existía en los datos de ejemplo) |
| 47 | Llenado manual en una sola pantalla con chips (`#v-manual`): chacra (miniatura del mapa), último cultivo con etiqueta "Satélite", prioridad y restricciones | Rápido para quien ya conoce la app; mismas preguntas y mismos datos que la conversación | Tarjetas separadas (versión anterior) |
| 48 | "Prueba tu propio plan" usa `CustomRotationCard` (secuencia propia calculada por el servidor, decisión 33) dentro del bloque desplegable del rediseño | El backend acepta `custom_rotation` y devuelve agua, riesgo y tierra por campaña; no existe un endpoint de simulador | Simulador de `semi_app.html` con cosecha por campaña (solo datos de ejemplo) |
| 49 | Sin probabilidades por escenario en Clima ni en "Qué sembrar"; el agricultor elige el escenario con `ScenarioExplorer` | El backend no publica las probabilidades del ENFEN (decisión 28) | Pronóstico estacional con porcentajes de ejemplo |
| 50 | **`geolocator`** para "Estoy en mi chacra" en la conversación, detrás de `DeviceLocationService`; el mapa sigue disponible y "Es aquí" confirma el punto | Un toque es lo más accesible, pero el agricultor puede no estar en su chacra o negar el permiso: el GPS solo propone el punto, nunca avanza solo, y fuera del valle del Chira pide tocar el mapa | Solo el mapa (más pasos); solo el GPS (punto equivocado si está en casa) |
| 51 | Con poca agua (el más desfavorable de los dos semáforos), las opciones con cultivos de mucha agua traen un aviso armado con la cifra real y su riesgo no baja de medio; solo "Cuidar mi agua" las manda al final. "Menos riesgo de clima" compara en el peor año, luego las reglas agronómicas que rompe la secuencia y luego la tierra | Mover esas opciones al final en todas las prioridades dejaba las tres en el mismo orden: elegir prioridad no cambiaba nada | Reordenar en todas las prioridades (versión anterior) |

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
| B2 | Contratos | **Parcial:** Clima, catálogo y recomendación ya tienen contrato (§4). Faltan parcela y avisos, y usar el cuerpo de error `{"error": {"code", "message"}}` del backend | `data/` de cada feature, `ApiClient` |
| B15 | Observaciones del satélite | La humedad (SMAP) y la lluvia (GPM IMERG) del punto necesitan credenciales de Earthdata en el backend y tardan minutos: la primera consulta de una parcela nueva llega sin ellas y la siguiente ya las trae. ¿Se avisa en la app de que todavía se están midiendo? | `crop_planning`, `SourceNote` |
| B3 | ~~Recomendación~~ | **Resuelto:** ordena el servidor (`POST /app/recommendation` devuelve `ranking` por prioridad y escenario); la política local devuelve `null` | `RotationRankingPolicy` |
| B4 | Parcela | Geometría e imagen satelital reales (hoy: ilustración del valle con marcador), e inferencia del último cultivo. Los cultivos de `GET /app/catalog` todavía no se usan para `lastCropOptions`, que sale de `FarmRepository`; los de la recomendación sí alimentan "Arma tu rotación" | `farm` |
| B5 | Preferencias | Hoy en el dispositivo. ¿También en el perfil del servidor (cambio de teléfono)? | `CampaignPreferencesStore` |
| B6 | Feedback | Endpoint "qué sembré" y nivel de detalle | `crop_planning` |
| B7 | Avisos | ¿Polling, push o SMS? ¿Estado de leído (badge)? | `alerts`, `AppShell` |
| B8 | Audio | Propuesta del front: `POST v1/speech` (texto → MP3) en `docs/contracts/voz.md`. ¿Lo confirma el backend y con qué motor (Azure `es-PE`, Google, Piper)? | `BackendSpeechClient` |
| B9 | Chat | ¿Existe asistente conversacional? (hoy: deshabilitado, "Próximamente") | `alerts` |
| B10 | Offline | ¿Caché y antigüedad de datos aceptable? | `data/` de cada feature |
| B11 | Contenido | ¿Textos explicativos (fichas, razones) del servidor? | entidades de dominio |
| B12 | Catálogo | **Resuelto en parte:** `GET /app/catalog` entrega prioridades, restricciones y cultivos; la prioridad sugerida es la primera. Pendiente: ¿varía por valle o por campaña? | `CampaignCatalogRepository` |
| B13 | Color de cultivo | ¿Producto quiere un color fijo por cultivo? Si es así, el backend lo envía | `CropTone` |
| B14 | Varias parcelas | Ver propuesta en §8b (pendiente de aprobación) | `farm`, estado de campaña, todos los repositorios |
| B18 | Idioma del contenido | Propuesta: el front mandará `Accept-Language` (`es-PE`, `en-US` o `qu-PE`). ¿El backend devuelve los textos de contenido (razones, avisos, fichas, nombres de cultivos) en ese idioma, con español como respaldo? | todos los repositorios remotos, `MockText` |
| B16 | ~~Cosecha esperada~~ | **Descartado** al unir `semi-rediseno` con `main`: se comparan agua de riego, riesgo de clima y tierra (decisión 46) | — |
| B17 | ~~Simulador~~ | **Descartado:** "Prueba tu propio plan" usa `custom_rotation` de `POST /app/recommendation` (decisión 48) | — |

## 8. Huecos de la referencia (no se inventan soluciones)

| Hueco | Cómo quedó en la app |
|---|---|
| El "último cultivo" no afecta ningún resultado en el HTML | Se envía en `CropPlanningQuery` y el servidor calcula con él la práctica actual y el estado de la tierra |
| "Otro" cultivo y "Sembré otra cosa" no dicen cuál | Se registra solo `followedRecommendation: false` (B6) |
| Input y micrófono del chat sin comportamiento | Deshabilitados, con aviso "Podrás hacer preguntas próximamente" (B9) |
| Badge de avisos siempre visible | Se muestra si algún aviso tiene `isRead: false`; cómo se marca como leído depende de B7 |
| No hay login ni alta de parcela | Sin implementar; la parcela viene del repositorio (B1, B4) |
| Sin estados de carga, error ni vacío | Implementados en todas las pantallas con `AsyncValueView` |
| "Si al final no llueve tanto" (cifra en soles) | Eliminado con el resto de las cifras económicas (decisión 28) |
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
- `test/` replica la estructura de `lib/`:
  - **Unit:** config, errores, formateadores, reintentos, combinación de
    estados, ranking genérico (incluido el orden que manda el servidor),
    política de ejemplo, caso de uso, textos derivados, contexto de campaña
    (persistencia, restablecer, deshacer), codec de preferencias y los
    repositorios remotos (clima, catálogo y recomendación).
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
| 2026-11-14 | Motor de recomendación en el servidor (B3): agua de riego y riesgo de clima en lugar de ganancias y probabilidades, escenario elegido por el agricultor, hectáreas/fecha de siembra/campañas seguidas como entradas, y `CropPlanningRepository` + `CampaignCatalogRepository` contra el backend |
| 2026-11-14 | Los cuatro insumos del reto: chacra marcada en el mapa, suelo del punto (SoilGrids) y verdor (MODIS NDVI) en el estado de la tierra, y "Arma tu rotación" para explorar secuencias propias |
| 2026-11-15 | "¿A cuál de estas se parece tu tierra?" con tres ilustraciones (manda sobre SoilGrids), ficha de cada cultivo al armar la rotación (agua, duración, si abona la tierra) y la lluvia ya medida por GPM IMERG al explorar escenarios |
| 2026-11-15 | Unión de `semi-rediseno` (Semi, modos de uso, idiomas, modo oscuro, diseño de `semi_app.html`) con la integración del backend: agua y riesgo en lugar de cosecha, sin probabilidades por escenario, `CustomRotationCard` en lugar del simulador y las tarjetas de Mi parcela con el diseño nuevo (decisiones 46 a 49) |
