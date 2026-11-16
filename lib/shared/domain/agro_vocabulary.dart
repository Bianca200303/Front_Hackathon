/// Vocabulario de negocio compartido por varios features.
///
/// Hay dos tipos de conceptos:
///
/// - **Catálogos abiertos** ([Crop], [CampaignPriority],
///   [CampaignRestriction]): son datos. El backend decide cuáles existen y
///   cómo se llaman; la app no conoce una lista fija y nunca compara contra
///   identificadores concretos. Agregar un cultivo nuevo no requiere tocar
///   la app.
/// - **Escalas cerradas** ([ClimateScenario], [SoilCondition],
///   [ClimateRisk], [CropWaterNeed], [SoilTexture]): tienen un orden y un
///   significado visual fijo (color, medidor, ilustración, titulares). El
///   backend se mapea a estas escalas.
library;

import 'package:equatable/equatable.dart';

/// Un cultivo, tal como lo entrega la fuente de datos.
class Crop extends Equatable {
  /// Crea un cultivo con su identificador estable y su nombre visible.
  ///
  /// La ficha ([cycleMonths], [waterNeed], [fixesNitrogen]) es opcional: una
  /// fuente que no la tenga deja los campos nulos y la app no los muestra.
  const Crop({
    required this.id,
    required this.name,
    this.cycleMonths,
    this.waterNeed,
    this.fixesNitrogen = false,
  });

  /// Identificador estable del backend. Solo se usa para comparar y
  /// persistir; nunca para decidir comportamiento.
  final String id;

  /// Nombre para mostrar, ya localizado (p. ej., "Maíz").
  final String name;

  /// Cuántos meses ocupa el campo; nulo si la fuente no lo dice.
  final int? cycleMonths;

  /// Cuánta agua pide comparado con los demás cultivos; nulo si la fuente
  /// no lo dice.
  final CropWaterNeed? waterNeed;

  /// `true` si le deja nitrógeno al cultivo siguiente.
  ///
  /// Es informativo: la mejora de la tierra ya está contada en
  /// `RotationOption.soilImpact`.
  final bool fixesNitrogen;

  @override
  List<Object?> get props => [id, name, cycleMonths, waterNeed, fixesNitrogen];
}

/// Agua que pide un cultivo comparado con los demás, de menos a más.
enum CropWaterNeed {
  /// Poca.
  low,

  /// Media.
  medium,

  /// Mucha.
  high,
}

/// Textura de la tierra: lo que cambia cuánta lluvia aprovecha el cultivo.
///
/// La reconoce el agricultor en su chacra y, si no contesta, la estima
/// SoilGrids. La app dibuja una ilustración por valor, así que es una escala
/// cerrada.
enum SoilTexture {
  /// Arenosa: se desarma en la mano y el agua se va rápido.
  sandy,

  /// Franca: guarda bien el agua.
  loamy,

  /// Arcillosa: retiene el agua y se encharca.
  clayey,
}

/// Una de las texturas entre las que elige el agricultor, con los textos
/// que entrega la fuente de datos.
class SoilTextureAnswer extends Equatable {
  /// Crea la opción.
  const SoilTextureAnswer({
    required this.texture,
    required this.name,
    required this.description,
  });

  /// Textura que representa.
  final SoilTexture texture;

  /// Nombre para mostrar (p. ej., "Arenosa").
  final String name;

  /// Cómo la reconoce el agricultor en la mano.
  final String description;

  @override
  List<Object?> get props => [texture, name, description];
}

/// Lo que más le importa al agricultor esta campaña (p. ej., "Cuidar mi agua").
class CampaignPriority extends Equatable {
  /// Crea una prioridad del catálogo.
  const CampaignPriority({
    required this.id,
    required this.name,
    required this.phrase,
  });

  /// Identificador estable del backend.
  final String id;

  /// Texto de la opción (p. ej., "Cuidar mi agua").
  final String name;

  /// Forma corta para insertar en frases (p. ej., "Pensando en: cuidar tu
  /// agua").
  final String phrase;

  @override
  List<Object?> get props => [id, name, phrase];
}

/// Limitación opcional que declara el agricultor (p. ej., "Tendré poca
/// agua"). Las opciones de rotación indican qué restricciones las
/// descartan, por identificador.
class CampaignRestriction extends Equatable {
  /// Crea una restricción del catálogo.
  const CampaignRestriction({required this.id, required this.name});

  /// Identificador estable del backend.
  final String id;

  /// Texto para mostrar.
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Escenario climático de la campaña (hasta el fin del horizonte del
/// pronóstico).
enum ClimateScenario {
  /// Lluvias fuertes, asociadas a El Niño costero.
  heavyRains,

  /// Año normal.
  normal,

  /// Año seco.
  dry,
}

/// Riesgo de que el clima del escenario afecte a la campaña, de menor a
/// mayor. Lo calcula la fuente de datos a partir de los meses de lluvia
/// fuerte que toca el calendario del cultivo.
enum ClimateRisk {
  /// Bajo.
  low,

  /// Medio.
  medium,

  /// Alto.
  high,
}

/// Estado estimado de la tierra, de peor a mejor.
enum SoilCondition {
  /// Muy cansada.
  veryTired,

  /// Cansada.
  tired,

  /// Regular.
  regular,

  /// Buena.
  good,
}
