// Permite el manejo de errores de manera controlada.
class Result<T> {
  final T? data;
  final String? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  // Transforma el dato si fue exitoso (ej. DTO a entidad); si falló, conserva el error.
  Result<R> map<R>(R Function(T data) transform) =>
      isSuccess ? Result.success(transform(data as T)) : Result.failure(error);
}
