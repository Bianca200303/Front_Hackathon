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
│   ├── network/           # Contrato ApiClient, ApiEndpoints, política de reintentos
│   ├── router/            # AppRoutes: paths de la app (constantes)
│   ├── services/speech/   # SpeechService (abstracto) + TTS del dispositivo + voz de Semi (backend)
│   ├── theme/             # Tokens: colores, tipografía, espaciado, breakpoints, ThemeData
│   └── utils/             # Formateadores, reloj inyectable, combinación de AsyncValue
├── shared/                # Compartido por varios features
│   ├── domain/            # Vocabulario, CampaignCatalog, CampaignContext, CampaignPreferencesStore, SeasonalOutlook
│   ├── data/              # MockCatalog (única fuente de datos de ejemplo del catálogo), mocks,
│   │                      # almacén de preferencias (SharedPreferences / memoria) y su codec JSON
│   ├── state/             # campaignContextProvider, campaignCatalogProvider, seasonalOutlookProvider
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

Con `DATA_SOURCE=remote`, los providers lanzan un error explícito
(`remoteDataSourcePending`) hasta que existan los contratos (B2).

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
| `AppSettingsButton` | — (acceso a Mi parcela desde las pestañas) |
| `SemiAvatar`, `SemiGuide`, `AppSettingsButton` / `showAppSettings` | — (Semi y los modos de uso; ver §5b) |
| `ResponsiveColumns` | — (dos columnas en tablets) |

`SourceNote` añade "Cifras de ejemplo." solo cuando `DATA_SOURCE=mock`.

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
| 5 | Sin DTOs ni serialización todavía | No hay contratos de backend (B2) | Inventar JSON |
| 6 | Config con `--dart-define-from-file` | Nativo, sin dependencias; valida al arrancar | flutter_dotenv |
| 7 | Figtree incluida en assets | Funciona offline | google_fonts (descarga en runtime) |
| 8 | `flutter_tts` detrás de `SpeechService` | "Escuchar" es central; permite cambiar a audio del servidor (B8) | TTS directo en widgets |
| 9 | Colores en una `ThemeExtension` (`AppPalette`, claro y oscuro), leídos con `context.colors`; estilos de texto con color con `context.text` | `semi_app.html` trae modo oscuro; el cambio conserva el estado de cada pantalla. En oscuro, verde y azul pasan a tonos claros con texto oscuro (Material 3) para cumplir contraste AA | Constantes `AppColors` (versión anterior, sin modo oscuro) |
| 10 | Strings en ARB (gen-l10n) | Sin texto fijo en widgets; formatos centralizados | Strings sueltos |
| 11 | Agrupación de miles con coma (`14,500 m³`) | Convención peruana y de la referencia; `intl` usa punto para `es_PE` | `NumberFormat.decimalPattern('es_PE')` |
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
| 25 | Dos modos de uso (Asistencia / Llenado manual) sobre las mismas pantallas y providers | Niños y quien necesita guía, y agricultores que quieren ir rápido, sin duplicar lógica | Dos apps o dos juegos de pantallas |
| 26 | Semi dibujado con `CustomPainter` | Animar ojos, brazo y brote; cero dependencias; colores por tokens | `flutter_svg` (imagen estática), Rive/Lottie (requiere animador) |
| 27 | Voz de Semi generada en el **backend** (`POST v1/speech`) detrás de `SpeechService`, con caché local y respaldo `flutter_tts`; **`audioplayers`** para reproducir | El clima y los datos cambian por día y por valle: no alcanzan audios grabados. La app se usa con red; el backend guarda la clave del motor de voz y cachea por texto | ElevenLabs llamado desde la app (la clave viajaría en el APK), voz neural dentro de la app (sherpa-onnx, +20–80 MB), solo audios grabados |
| 28 | `http://` permitido solo en el manifiesto de **debug** de Android | Probar el backend local desde el emulador (`10.0.2.2`); release exige `https://` | Permitirlo en todas las builds |
| 29 | Idioma automático por idioma y región del celular, con selector manual; quechua como borrador con respaldo en español | Funciona en cualquier país sin pedir permisos; el quechua llega aunque falte traducir | Elegir por GPS/IP (permisos, red); esperar la traducción completa |
| 30 | Los datos de ejemplo se traducen con una tabla (`MockText`) con el español como clave | Los textos de contenido los mandará el backend ya traducidos (B15); el mock solo imita eso | Duplicar los datos por idioma |
| 31 | Los estilos de texto de los botones nombran la fuente (`Figtree`) | Flutter no hereda la fuente del tema en los botones: salían con la del sistema | Confiar en `ThemeData.fontFamily` |
| 32 | **Sin dinero:** las opciones se comparan por cosecha esperada (% de una buena campaña, también en un mal año), agua (m³) y estado de la tierra, todo con datos NASA; la prioridad "Ganar más" pasó a "Que el clima no malogre mi cosecha" | Decisión del equipo: el proyecto se centra en datos de la NASA, no en costos ni precios (igual que `semi_app.html`) | Ganancia y pérdida en soles (versión anterior) |
| 33 | Llenado manual en una sola pantalla con chips (`#v-manual`): chacra (miniatura del mapa), último cultivo con etiqueta "Satélite", prioridad y restricciones | Rápido para quien ya conoce la app; mismas preguntas y mismos datos que la conversación | Tarjetas separadas (versión anterior) |

### Dependencias pospuestas

| Paquete | Cuándo |
|---|---|
| `dio` | Al definir contratos y autenticación (B1, B2) |
| Caché local de datos | Al decidir el modo offline (B10) |
| `firebase_messaging` | Si los avisos usan push (B7) |

## 7. Decisiones pendientes del backend

| # | Tema | Pregunta abierta | Dónde impacta |
|---|---|---|---|
| B1 | Autenticación | ¿Cómo se identifica el agricultor? ¿Sesión o tokens? | `core/network`, nuevo feature `auth` |
| B2 | Contratos | Endpoints, formatos, IDs, formato de error | `data/` de cada feature, `ApiClient` |
| B3 | Recomendación | ¿Ranking en el servidor o en el cliente? Si es en el cliente, ¿quién define el criterio de cada prioridad? | `RotationRankingPolicy` |
| B4 | Parcela | Geometría, imagen satelital, inferencia del último cultivo | `farm` |
| B5 | Preferencias | Hoy en el dispositivo. ¿También en el perfil del servidor (cambio de teléfono)? | `CampaignPreferencesStore` |
| B6 | Feedback | Endpoint "qué sembré" y nivel de detalle | `crop_planning` |
| B7 | Avisos | ¿Polling, push o SMS? ¿Estado de leído (badge)? | `alerts`, `AppShell` |
| B8 | Audio | Propuesta del front: `POST v1/speech` (texto → MP3) en `docs/contracts/voz.md`. ¿Lo confirma el backend y con qué motor (Azure `es-PE`, Google, Piper)? | `BackendSpeechClient` |
| B9 | Chat | ¿Existe asistente conversacional? (hoy: deshabilitado, "Próximamente") | `alerts` |
| B10 | Offline | ¿Caché y antigüedad de datos aceptable? | `data/` de cada feature |
| B11 | Contenido | ¿Textos explicativos (fichas, razones) del servidor? | entidades de dominio |
| B12 | Catálogo | Endpoint de prioridades y restricciones (¿por valle? ¿por campaña?); cuál es la prioridad sugerida (hoy: la primera) | `CampaignCatalogRepository` |
| B13 | Color de cultivo | ¿Producto quiere un color fijo por cultivo? Si es así, el backend lo envía | `CropTone` |
| B14 | Varias parcelas | Ver propuesta en §8b (pendiente de aprobación) | `farm`, estado de campaña, todos los repositorios |
| B15 | Idioma del contenido | Propuesta: el front mandará `Accept-Language` (`es-PE`, `en-US` o `qu-PE`). ¿El backend devuelve los textos de contenido (razones, avisos, fichas, nombres de cultivos) en ese idioma, con español como respaldo? | todos los repositorios remotos, `MockText` |
| B16 | Cosecha esperada | Por opción y escenario, el front espera `expectedHarvest` y `worstHarvest` (fracción de una buena campaña: 0.85 = 85 %) y, para lo que siembra hoy, `expectedHarvest` por escenario. ¿Cómo la calcula el modelo (verdor MODIS/Landsat, lluvia GPM, humedad SMAP)? No se envían precios | `ScenarioOutcome`, `CurrentPractice` |
| B17 | Simulador | `PlanSimulator`: cultivos elegibles (con restricciones que los descartan y si se cosechan) y `simulate(plan, último cultivo, tierra de hoy, clima de la primera campaña)` → cosecha por campaña, agua y tierra al final. ¿Lo calcula el modelo del backend? | `MockPlanSimulator` |

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
