import '/imports.dart';

class TeamsApi {
  final ApiService service;
  TeamsApi({required this.service});

  Future<Result<List<TeamInfo>>> list({
    Function(List<TeamInfo> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/teams';

    final result = await service.get<List<dynamic>>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = data.map(TeamInfo.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data!;
    return data.map(TeamInfo.fromJson).toList().toSuccess();
  }
}
