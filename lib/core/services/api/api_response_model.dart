import 'package:embeyi/core/utils/constants/app_string.dart';

class ApiResponseModel {
  final int? _statusCode;
  final Map? _data;

  ApiResponseModel(this._statusCode, this._data);

  bool get isSuccess => _statusCode == 200;

  int get statusCode => _statusCode ?? 500;

  String get message {
    if (_statusCode == 502) {
      return AppString.startServer;
    }
    if (_data != null) {
      final msg = _data!['message']?.toString();
      if (msg != null && msg.trim().isNotEmpty) {
        return msg.trim();
      }
      final error = _data!['error']?.toString();
      if (error != null && error.trim().isNotEmpty) {
        return error.trim();
      }
      if (_data!['errorMessages'] is List && (_data!['errorMessages'] as List).isNotEmpty) {
        final firstError = (_data!['errorMessages'] as List).first;
        if (firstError is Map && firstError['message'] != null) {
          return firstError['message'].toString().trim();
        }
      }
    }
    return AppString.someThingWrong;
  }

  Map get data => _data ?? {};
}
