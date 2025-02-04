import '/imports.dart';

class AgentsApi {
  final ApiService service;
  AgentsApi({required this.service});

  /// List Agents in Account
  Future<Result<List<UserInfo>>> list() async {
    final path = '/accounts/{account_id}/agents';

    final result = await service.get(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    List<dynamic> items = data;
    return items.map(UserInfo.fromJson).toList().toSuccess();
  }

  Future<Result<List<UserInfo>>> listAssignable({
    required List<int> inbox_ids,
    CancelToken? cancelToken,
  }) async {
    final path = '/accounts/{account_id}/assignable_agents';

    final result = await service.get(
      path,
      queryParameters: {
        // TODO: make list
        'inbox_ids[]': inbox_ids.first,
      },
      cancelToken: cancelToken,
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    List<dynamic> items = data['payload'];
    return items.map(UserInfo.fromJson).toList().toSuccess();
  }
}
