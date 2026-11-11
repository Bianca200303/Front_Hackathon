import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fuente de la hora actual. Inyectable para que fechas relativas
/// ("Hoy", "Ayer") y datos de ejemplo sean deterministas en los tests.
typedef Clock = DateTime Function();

/// Hora actual. Los tests la reemplazan por una fecha fija.
final clockProvider = Provider<Clock>((ref) => DateTime.now);
