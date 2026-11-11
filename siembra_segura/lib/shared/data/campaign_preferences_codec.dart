import 'dart:convert';

import 'package:siembra_segura/shared/domain/campaign_context.dart';

/// Convierte las preferencias de campaña a JSON y de vuelta.
///
/// Formato versionado para poder migrarlo si cambia:
/// `{"v":1,"lastCropId":"rice","priorityId":"save-water","restrictionIds":[]}`
abstract final class CampaignPreferencesCodec {
  static const _version = 1;

  /// Serializa solo las preferencias guardables de [context].
  static String encode(CampaignContext context) => jsonEncode({
    'v': _version,
    'lastCropId': context.lastCropId,
    'priorityId': context.priorityId,
    'restrictionIds': context.restrictionIds.toList(),
  });

  /// Lee lo que produjo [encode]. Devuelve `null` si el contenido está
  /// dañado o es de una versión desconocida: es preferible empezar de cero
  /// que fallar al abrir la app.
  static CampaignContext? decode(String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, Object?> || json['v'] != _version) return null;
      final restrictions = json['restrictionIds'];
      return CampaignContext(
        lastCropId: json['lastCropId'] as String?,
        priorityId: json['priorityId'] as String?,
        restrictionIds: restrictions is List
            ? Set.unmodifiable(restrictions.whereType<String>())
            : const {},
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
