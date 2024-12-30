import 'package:http/http.dart';

class ApiException {
  final String message;
  final Response response;
  ApiException(this.message, this.response);
}