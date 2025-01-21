import '/imports.dart';

class ApiError implements Exception {
  final bool success;
  final List<String> errors;

  const ApiError({
    required this.success,
    required this.errors,
  });

  factory ApiError.fromException(DioException dioException) {
    logger.w(dioException, stackTrace: dioException.stackTrace);

    if (dioException.response?.statusCode == 404) {
      return ApiError(
        success: false,
        errors: [t.error_not_found],
      );
    }

    dynamic data = dioException.response?.data;
    List<dynamic> contentTypes =
        dioException.response?.headers['content-type'] ?? [];

    if (!contentTypes.contains('application/json') ||
        data is String ||
        data == null) {
      return ApiError(
        success: false,
        errors: [t.error_response],
      );
    }

    List<dynamic> errors = data['errors'] ?? [data['error']];
    return ApiError(
      success: dioException.response?.data['success'] ?? true,
      errors: errors.map((e) => e.toString()).toList(),
    );
  }
}

class ApiInfo {
  final String version;
  final String timestamp;
  final String queue_services;
  final String data_services;

  const ApiInfo({
    required this.version,
    required this.timestamp,
    required this.queue_services,
    required this.data_services,
  });

  factory ApiInfo.fromJson(dynamic json) {
    return ApiInfo(
      version: json['version'],
      timestamp: json['timestamp'],
      queue_services: json['queue_services'],
      data_services: json['data_services'],
    );
  }
}

class ApiListResult<T, T2> {
  final T meta;
  final List<T2> payload;

  const ApiListResult({
    required this.meta,
    required this.payload,
  });
}

class ApiListMeta {
  final int count;
  final int current_page;

  const ApiListMeta({
    required this.count,
    required this.current_page,
  });

  factory ApiListMeta.fromJson(dynamic json) {
    var current_page = int.parse('${json['current_page']}');
    return ApiListMeta(
      count: json['count'],
      current_page: current_page,
    );
  }
}
