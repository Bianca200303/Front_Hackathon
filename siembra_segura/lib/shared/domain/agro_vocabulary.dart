/// Vocabulario de negocio compartido por varios features.
///
/// Son conceptos de dominio puros: los textos visibles se resuelven en la
/// capa de presentación (l10n) y los identificadores del backend se mapean
/// en la capa de datos cuando existan contratos (decisión B2).
library;

/// Cultivos que aparecen en la referencia.
enum Crop { rice, maize, cotton, bean, pulse, other }

/// Escenario climático de la campaña (hasta marzo).
enum ClimateScenario { heavyRains, normal, dry }

/// Lo que más le importa al agricultor esta campaña.
enum CampaignPriority { maximizeProfit, saveWater, restoreSoil }

/// Limitaciones opcionales que declara el agricultor.
enum CampaignRestriction { noCottonBuyer, lowWater }

/// Estado estimado de la tierra, de peor a mejor.
enum SoilCondition { veryTired, tired, regular, good }
