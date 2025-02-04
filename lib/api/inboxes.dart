import '/imports.dart';

class InboxesApi {
  final ApiService service;
  InboxesApi({required this.service});

  Future<Result<ListInboxesResult>> list({
    Function(ListInboxesResult data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/inboxes';

    final result = await service.get(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListInboxesResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListInboxesResult.fromJson(data).toSuccess();
  }
}
