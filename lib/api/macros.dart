import '/imports.dart';

class MacrosApi {
  final ApiService service;
  MacrosApi({required this.service});

  Future<Result<ListMacrosResult>> list({
    Function(ListMacrosResult data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/macros';

    final result = await service.get(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListMacrosResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListMacrosResult.fromJson(data).toSuccess();
  }

  Future<Result<bool>> execute({
    required List<int> conversation_ids,
    required int macro_id,
    CancelToken? cancelToken,
  }) async {
    final path = '/accounts/{account_id}/macros/$macro_id/execute';

    final result = await service.post(
      path,
      data: {
        'conversation_ids': conversation_ids,
      },
      cancelToken: cancelToken,
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<bool>> delete({
    required int macro_id,
  }) async {
    final path = '/accounts/{account_id}/macros/$macro_id';

    final result = await service.delete(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }
}
