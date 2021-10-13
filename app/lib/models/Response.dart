class Response {
  final bool success;
  final String message;
  final dynamic data;
  final Error? error;

  Response({this.success = true, required this.message, this.data, this.error});
}
