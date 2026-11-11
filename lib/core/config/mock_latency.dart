import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Retardo artificial de las fuentes de datos mock, para que los estados de
/// carga se vean y prueben como con un backend real. Los tests lo anulan.
final mockLatencyProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 400),
);
