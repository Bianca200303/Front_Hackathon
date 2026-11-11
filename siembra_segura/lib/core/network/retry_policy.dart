import 'package:siembra_segura/core/error/app_exception.dart';

/// Política de reintentos automáticos de los providers (Riverpod 3).
///
/// Solo reintenta errores transitorios de conectividad, frecuentes en zonas
/// rurales. Errores como "no encontrado" o "sesión vencida" no mejoran
/// reintentando, así que se muestran de inmediato con opción de reintentar.
Duration? retryTransientErrors(int retryCount, Object error) {
  const maxRetries = 3;
  final isTransient =
      error is NetworkException || error is RequestTimeoutException;
  if (!isTransient || retryCount >= maxRetries) return null;
  return Duration(seconds: 1 << retryCount);
}
