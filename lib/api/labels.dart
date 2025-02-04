import '/imports.dart';

class LabelsApi {
  final ApiService service;
  LabelsApi({required this.service});

  Future<Result<ListLabelsResult>> list({
    Function(ListLabelsResult data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/labels';

    final result = await service.get(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListLabelsResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListLabelsResult.fromJson(data).toSuccess();
  }

  Future<Result<LabelInfo>> create({
    required String title,
    required String description,
    required String color,
    required bool show_on_sidebar,
  }) async {
    final path = '/accounts/{account_id}/labels';

    final result = await service.post(path, data: {
      'title': title,
      'description': description,
      'color': color,
      'show_on_sidebar': show_on_sidebar,
    });
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return LabelInfo.fromJson(data).toSuccess();
  }

  Future<Result<bool>> delete({
    required int label_id,
  }) async {
    final path = '/accounts/{account_id}/labels/$label_id';

    final result = await service.delete(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<LabelInfo>> update({
    required int label_id,
    required String title,
    required String description,
    required String color,
    required bool show_on_sidebar,
  }) async {
    final path = '/accounts/{account_id}/labels/$label_id';

    final result = await service.post(
      path,
      data: {
        'title': title,
        'description': description,
        'color': color,
        'show_on_sidebar': show_on_sidebar,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return LabelInfo.fromJson(data).toSuccess();
  }
}
