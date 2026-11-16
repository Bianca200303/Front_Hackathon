import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/services/speech/backend_speech_client.dart';
import 'package:siembra_segura/core/services/speech/flutter_tts_speech_service.dart';
import 'package:siembra_segura/core/services/speech/speech_text.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/alerts/data/mock_alerts_repository.dart';
import 'package:siembra_segura/features/climate/data/mock_climate_repository.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_crop_planning_repository.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/farm/data/mock_farm_repository.dart';
import 'package:siembra_segura/shared/data/mock_campaign_catalog_repository.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';

import '../../helpers/planning_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('idioma según el celular', () {
    AppLanguage resolve(List<Locale> locales) => AppLanguage.resolve(locales);

    test('usa el primer idioma del celular que la app tiene', () {
      expect(resolve(const [Locale('es', 'PE')]), AppLanguage.spanish);
      expect(resolve(const [Locale('en', 'US')]), AppLanguage.english);
      expect(
        resolve(const [Locale('de'), Locale('en', 'GB'), Locale('es')]),
        AppLanguage.english,
      );
    });

    test('reconoce las variedades de quechua', () {
      for (final code in ['qu', 'quz', 'quy', 'qub', 'qvi']) {
        expect(
          resolve([Locale(code, 'PE')]),
          AppLanguage.quechua,
          reason: code,
        );
      }
    });

    test('si no tiene el idioma, decide por la región', () {
      // Un celular en francés comprado en Perú: español.
      expect(resolve(const [Locale('fr', 'PE')]), AppLanguage.spanish);
      // En francés y en Francia: inglés.
      expect(resolve(const [Locale('fr', 'FR')]), AppLanguage.english);
      expect(resolve(const []), AppLanguage.english);
    });
  });

  group('datos de ejemplo', () {
    test('todos sus textos están traducidos al inglés', () async {
      await initTestLocale();
      MockText.missing.clear();
      const en = AppLanguage.english;
      // Con una rotación propia, para revisar también sus textos.
      await MockCropPlanningRepository(language: en).getPlanningData(
        CropPlanningQuery(
          location: referenceQuery.location,
          areaHectares: referenceQuery.areaHectares,
          plantingDate: referenceQuery.plantingDate,
          consecutiveCampaigns: referenceQuery.consecutiveCampaigns,
          customRotation: const ['rice', 'maize'],
        ),
      );
      await const MockFarmRepository(language: en).getFarm();
      await const MockCampaignCatalogRepository(language: en).getCatalog();
      final alerts = MockAlertsRepository(clock: () => testNow, language: en);
      await alerts.getAlerts();
      await alerts.getMessage('enfen-pronostico');
      await MockClimateRepository(
        clock: () => testNow,
        language: en,
      ).getOverview();

      expect(MockText.missing, isEmpty);
    });

    test('en quechua lo que falta se queda en español', () async {
      final farm = await const MockFarmRepository(
        language: AppLanguage.quechua,
      ).getFarm();
      final names = farm.lastCropOptions.map((crop) => crop.name);
      expect(names, containsAll(['Sara', 'Arroz']));
    });
  });

  group('fechas', () {
    setUpAll(initTestLocale);
    tearDown(() => AppFormatters.useLanguage(AppLanguage.spanish));

    test('siguen el idioma; el quechua usa los nombres en español', () {
      final date = DateTime(2026, 12, 15);
      expect(AppFormatters.dayAndMonth(date), '15 de diciembre');
      AppFormatters.useLanguage(AppLanguage.english);
      expect(AppFormatters.dayAndMonth(date), 'December 15');
      expect(AppFormatters.weekday(date), 'Tuesday');
      AppFormatters.useLanguage(AppLanguage.quechua);
      expect(AppFormatters.weekday(date), 'martes');
    });
  });

  group('voz de Semi', () {
    test('busca una voz del idioma; para quechua, la de español de Perú', () {
      expect(
        FlutterTtsSpeechService.preferredLanguagesFor(
          AppLanguage.english,
        ).first,
        'en-US',
      );
      expect(
        FlutterTtsSpeechService.preferredLanguagesFor(
          AppLanguage.quechua,
        ).first,
        'es-PE',
      );
    });

    test('lee las unidades en el idioma', () {
      expect(
        SpeechText.normalize('Up to S/ 5,000 and 40 mm', AppLanguage.english),
        'Up to 5,000 soles and 40 millimeters',
      );
    });

    test('pide al backend el audio en el idioma', () {
      final base = Uri.parse('https://api.example.com');
      expect(
        BackendSpeechClient(base, appLanguage: AppLanguage.english).language,
        'en-US',
      );
      expect(
        BackendSpeechClient(base, appLanguage: AppLanguage.quechua).language,
        'qu-PE',
      );
    });
  });
}
