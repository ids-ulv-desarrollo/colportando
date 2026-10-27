import "package:colportando/core/error/result.dart";
import "package:http/http.dart" as http;

// Manejador global para las excepciones que ocurren durante las peticiones HTTP.
Result<T> exceptionError<T>(Object error) {
  final errorString = error.toString();

  if (error is http.ClientException ||
      errorString.contains("SocketException") ||
      errorString.contains("Connection timed out") ||
      errorString.contains("Network is unreachable") ||
      errorString.contains("TimeoutException") ||
      errorString.contains("Failed host lookup")) {
    return Result.failure(
      "Error de conexión al servidor. Verifique si tiene conexión a internet.",
    );
  }

  return Result.failure("Error: $errorString");
}
