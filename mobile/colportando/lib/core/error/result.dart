// Permite el manejo de errores de manera controlada.
class Result<T> {
  final T? data;
  final String? error;
  // Código HTTP de una respuesta fallida; es nulo si no llegó respuesta del servidor.
  final int? statusCode;

  const Result.success(this.data) : error = null, statusCode = null;
  const Result.failure(this.error, {this.statusCode}) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  // Indica una falla sin respuesta definitiva: sin respuesta, error 5xx o éxito que no pudo leerse.
  bool get isOutcomeUnknown {
    final code = statusCode;
    return isFailure && (code == null || code >= 500 || code < 300);
  }

  // Transforma el dato si fue exitoso (ej. DTO a entidad); si falló, conserva el error.
  Result<R> map<R>(R Function(T data) transform) => isSuccess
      ? Result.success(transform(data as T))
      : Result.failure(error, statusCode: statusCode);
}
