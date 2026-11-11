import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Tipo de aviso; define su icono y color.
enum AlertType {
  /// Lluvia fuerte cercana.
  rain,

  /// Estado de la tierra.
  soil,

  /// Cambio en el pronóstico estacional (ENFEN).
  forecastChange,
}

/// A dónde lleva tocar un aviso.
enum AlertDestination {
  /// Pantalla de clima.
  climate,

  /// Mensaje completo del aviso.
  message,
}

/// Un aviso de la lista "Avisos".
class Alert extends Equatable {
  /// Crea el aviso.
  const Alert({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.source,
    required this.destination,
    this.isRead = false,
  });

  /// Identificador estable del aviso.
  final String id;

  /// Tipo, que define icono y color.
  final AlertType type;

  /// Título corto.
  final String title;

  /// Resumen.
  final String body;

  /// Cuándo llegó.
  final DateTime receivedAt;

  /// Origen del dato (p. ej., "Comunicado ENFEN").
  final String source;

  /// A qué pantalla lleva al tocarlo.
  final AlertDestination destination;

  /// Cómo se marca como leído depende del backend (decisión B7).
  final bool isRead;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    receivedAt,
    source,
    destination,
    isRead,
  ];
}

/// Mensaje completo de un aviso, como llega al celular.
class AlertMessage extends Equatable {
  /// Crea el mensaje.
  const AlertMessage({
    required this.alertId,
    required this.sentAt,
    required this.headline,
    required this.paragraphs,
    required this.audioDuration,
    this.relatedScenario,
  });

  /// Aviso al que pertenece.
  final String alertId;

  /// Cuándo se envió.
  final DateTime sentAt;

  /// Frase inicial destacada.
  final String headline;

  /// Párrafos con énfasis marcado como `**texto**`. El formato real del
  /// contenido depende del backend (decisión B11).
  final List<String> paragraphs;

  /// Duración de la versión en audio.
  final Duration audioDuration;

  /// Escenario que hay que mostrar al abrir la recomendación desde aquí.
  final ClimateScenario? relatedScenario;

  @override
  List<Object?> get props => [
    alertId,
    sentAt,
    headline,
    paragraphs,
    audioDuration,
    relatedScenario,
  ];
}

/// Fuente de los avisos.
abstract interface class AlertsRepository {
  /// Avisos, del más reciente al más antiguo.
  Future<List<Alert>> getAlerts();

  /// Lanza `NotFoundException` si el aviso no tiene mensaje.
  Future<AlertMessage> getMessage(String alertId);
}
