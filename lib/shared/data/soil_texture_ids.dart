import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Identificadores de [SoilTexture] en el contrato del backend, que son los
/// mismos con los que se guarda la preferencia en el dispositivo.
///
/// Solo la capa de datos los usa: el dominio y la presentación trabajan con
/// el enum.
abstract final class SoilTextureIds {
  /// Textura por identificador.
  static const byId = {
    'sandy': SoilTexture.sandy,
    'loamy': SoilTexture.loamy,
    'clayey': SoilTexture.clayey,
  };

  /// Identificador de [texture].
  static String of(SoilTexture texture) => texture.name;
}
