abstract class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class LocationException extends ServerException {
  LocationException({required super.message});
}

class ConnectionException extends ServerException {
  ConnectionException({required super.message});
}

class ScanException extends ServerException {
  ScanException({required super.message});
}
