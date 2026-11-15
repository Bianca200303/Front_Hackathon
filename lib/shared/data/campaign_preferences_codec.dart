import 'dart:convert';

import 'package:siembra_segura/shared/data/soil_texture_ids.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

/// Convierte las preferencias de campaña a JSON y de vuelta.
///
/// Formato versionado para poder migrarlo si cambia:
/// `{"v":4,"lastCropId":"rice","priorityId":"save-water",
/// "restrictionIds":[],"areaHectares":2.0,"plantingDate":"2026-12-15",
/// "consecutiveCampaigns":3,"farmLatitude":-5.19,"farmLongitude":-80.63,
/// "customRotation":["rice","bean"],"soilTexture":"sandy"}`
abstract final class CampaignPreferencesCodec {
  static const _version = 4;

  /// Serializa solo las preferencias guardables de [context].
  static String encode(CampaignContext context) => jsonEncode({
    'v': _version,
    'lastCropId': context.lastCropId,
    'priorityId': context.priorityId,
    'restrictionIds': context.restrictionIds.toList(),
    'areaHectares': context.areaHectares,
    'plantingDate': context.plantingDate?.toIso8601String(),
    'consecutiveCampaigns': context.consecutiveCampaigns,
    'farmLatitude': context.farmLatitude,
    'farmLongitude': context.farmLongitude,
    'customRotation': context.customRotation,
    'soilTexture': switch (context.soilTexture) {
      final texture? => SoilTextureIds.of(texture),
      null => null,
    },
  });

  /// Lee lo que produjo [encode]. Devuelve `null` si el contenido está
  /// dañado o es de una versión desconocida: es preferible empezar de cero
  /// que fallar al abrir la app.
  static CampaignContext? decode(String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, Object?> || json['v'] != _version) return null;
      final restrictions = json['restrictionIds'];
      final plantingDate = json['plantingDate'];
      final customRotation = json['customRotation'];
      return CampaignContext(
        lastCropId: json['lastCropId'] as String?,
        priorityId: json['priorityId'] as String?,
        restrictionIds: restrictions is List
            ? Set.unmodifiable(restrictions.whereType<String>())
            : const {},
        areaHectares: (json['areaHectares'] as num?)?.toDouble(),
        plantingDate: plantingDate is String
            ? DateTime.parse(plantingDate)
            : null,
        consecutiveCampaigns: (json['consecutiveCampaigns'] as num?)?.toInt(),
        farmLatitude: (json['farmLatitude'] as num?)?.toDouble(),
        farmLongitude: (json['farmLongitude'] as num?)?.toDouble(),
        customRotation: customRotation is List
            ? List.unmodifiable(customRotation.whereType<String>())
            : const [],
        soilTexture: SoilTextureIds.byId[json['soilTexture']],
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
