import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Combina dos [AsyncValue] en uno, de forma síncrona.
///
/// - Si alguno falló, el resultado es ese error.
/// - Si ambos tienen valor, se aplica [combine] (aunque se estén recargando,
///   para no parpadear al cambiar filtros).
/// - En otro caso, está cargando.
AsyncValue<R> combineAsync<A, B, R>(
  AsyncValue<A> first,
  AsyncValue<B> second,
  R Function(A first, B second) combine,
) {
  if (first case AsyncError(:final error, :final stackTrace)) {
    return AsyncError<R>(error, stackTrace);
  }
  if (second case AsyncError(:final error, :final stackTrace)) {
    return AsyncError<R>(error, stackTrace);
  }
  if (first.hasValue && second.hasValue) {
    try {
      return AsyncData(combine(first.requireValue, second.requireValue));
    } on Object catch (error, stackTrace) {
      return AsyncError<R>(error, stackTrace);
    }
  }
  return const AsyncLoading();
}
