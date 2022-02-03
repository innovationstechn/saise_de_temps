class CustomException implements Exception {
  final String _message;
  final String _prefix;

  CustomException(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class RequestFailureException extends CustomException {
  RequestFailureException(String message) : super(message, "");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(message) : super(message, "");
}