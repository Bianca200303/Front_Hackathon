import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';

void main() {
  final l10n = AppLocalizationsEs();
  const maize = Crop(id: 'maize', name: 'Maíz amarillo duro');
  const bean = Crop(id: 'bean', name: 'Frijol caupí');
  const sweetPotato = Crop(id: 'sweet-potato', name: 'Camote');
  const rice = Crop(id: 'rice', name: 'Arroz');

  test('nombra todos los cultivos de la secuencia', () {
    expect(
      cropSequenceName(const [maize, bean, sweetPotato], l10n),
      'Maíz amarillo duro y después frijol caupí y después camote',
    );
    expect(
      cropSequenceName(const [maize, bean], l10n),
      'Maíz amarillo duro y después frijol caupí',
    );
    expect(cropSequenceName(const [rice, rice], l10n), 'Arroz y arroz');
  });
}
