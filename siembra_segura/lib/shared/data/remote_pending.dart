/// Error explícito para las fuentes remotas que aún no existen.
///
/// Se lanza al resolver un repositorio con `DATA_SOURCE=remote` antes de que
/// el backend defina sus contratos (decisión B2 en docs/ARCHITECTURE.md).
Never remoteDataSourcePending(String repository) {
  throw UnsupportedError(
    '$repository: la fuente remota está pendiente de los contratos del '
    'backend (B2). Usa DATA_SOURCE=mock.',
  );
}
