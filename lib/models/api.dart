import '/imports.dart';

class ApiError implements Exception {
  final bool success;
  final List<String> errors;

  const ApiError({
    required this.success,
    required this.errors,
  });

  factory ApiError.fromException(DioException dioException) {
    List<dynamic> errors = dioException.response?.data['errors'] ?? [];
    return ApiError(
      success: dioException.response?.data['success'] ?? true,
      errors: errors.map((e) => e.toString()).toList(),
    );
  }
}

class ApiInfo implements Exception {
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

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
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

  factory ApiListResult.fromJson(Map<String, dynamic> json) {
    throw Exception('Method not implemented!');
  }
}

class ApiListMeta {
  final int count;
  // final int current_page;

  const ApiListMeta({
    required this.count,
    // required this.current_page,
  });

  factory ApiListMeta.fromJson(Map<String, dynamic> json) {
    // var current_page = int.parse('${json['current_page']}');
    return ApiListMeta(
      count: json['count'],
      // current_page: current_page,
    );
  }
}

class ListConversationResult
    extends ApiListResult<ListConversationMeta, ConversationInfo> {
  const ListConversationResult({
    required super.meta,
    required super.payload,
  });

  factory ListConversationResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListConversationResult(
      meta: ListConversationMeta.fromJson(json['meta']),
      payload: payload.map(ConversationInfo.fromJson).toList(),
    );
  }
}

class ListNotificationResult
    extends ApiListResult<ListNotificationMeta, NotificationInfo> {
  const ListNotificationResult({
    required super.meta,
    required super.payload,
  });

  factory ListNotificationResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListNotificationResult(
      meta: ListNotificationMeta.fromJson(json['meta']),
      payload: payload.map(NotificationInfo.fromJson).toList(),
    );
  }
}

class ListContactResult extends ApiListResult<ListContactMeta, ContactInfo> {
  const ListContactResult({
    required super.meta,
    required super.payload,
  });

  factory ListContactResult.fromJson(dynamic json) {
    List<dynamic> payload = json['payload'];
    return ListContactResult(
      meta: ListContactMeta.fromJson(json['meta']),
      payload: payload.map(ContactInfo.fromJson).toList(),
    );
  }
}
