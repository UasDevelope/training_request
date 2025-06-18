class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super("Unauthorized");
}

class NotFoundException extends ApiException {
  NotFoundException() : super("Resource not found");
}

class BadExceptionRequest extends ApiException {
  BadExceptionRequest(String msg) : super(msg);
}

class InternalServerException extends ApiException {
  InternalServerException() : super("Internal Server Error");
}
