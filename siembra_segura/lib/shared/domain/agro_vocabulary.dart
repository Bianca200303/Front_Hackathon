/// Vocabulario de negocio compartido por varios features.
///
/// Hay dos tipos de conceptos:
///
/// - **Catálogos abiertos** ([Crop], [CampaignPriority],
///   [CampaignRestriction]): son datos. El backend decide cuáles existen y
///   cómo se llaman; la app no conoce una lista fija y nunca compara contra
///   identificadores concretos. Agregar un cultivo nuevo no requiere tocar
///   la app.
/// - **Escalas cerradas** ([ClimateScenario], [SoilCondition]): tienen un
///   orden y un significado visual fijo (color, medidor, titulares). El
///   backend deberá mapear sus valores a estas escalas (decisión B2).
library;

import 'package:equatable/equatable.dart';

/// Un cultivo, tal como lo entrega la fuente de datos.
class Crop extends Equatable {
  /// Crea un cultivo con su identificador estable y su nombre visible.
  const Crop({required this.id, required this.name});

  /// Identificador estable del backend. Solo se usa para comparar y
  /// persistir; nunca para decidir comportamiento.
  final String id;

  /// Nombre para mostrar, ya localizado (p. ej., "Maíz").
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Lo que más le importa al agricultor esta campaña (p. ej., "Ganar más").
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
