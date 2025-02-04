import '/imports.dart';

class CannedResponsesApi {
  final ApiService service;
  CannedResponsesApi({required this.service});

  /// List all Canned Responses in an Account
  Future<Result<List<CannedResponseInfo>>> list({
    Function(List<CannedResponseInfo> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/canned_responses';

    final result = await service.get<List<dynamic>>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = data.map(CannedResponseInfo.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    List<dynamic> data = result.getOrThrow().data!;
    return data.map(CannedResponseInfo.fromJson).toList().toSuccess();
  }

  /// Add a new Canned Response to Account
  Future<Result<CannedResponseInfo>> create({
    required String content,
    required String short_code,
  }) async {
    final path = '/accounts/{account_id}/canned_responses';

    final result = await service.post(
      path,
      data: {
        'content': content,
        'short_code': short_code,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return CannedResponseInfo.fromJson(data).toSuccess();
  }
}
