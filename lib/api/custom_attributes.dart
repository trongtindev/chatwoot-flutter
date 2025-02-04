import '/imports.dart';

class CustomAttributesApi {
  final ApiService service;
  CustomAttributesApi({required this.service});

  Future<Result<List<CustomAttribute>>> list({
    AttributeModel? attribute_model,
    Function(List<CustomAttribute> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/custom_attribute_definitions';

    final result = await service.get<List<dynamic>>(
      path,
      queryParameters: {
        'attribute_model': attribute_model?.name,
      },
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        List<dynamic> items = data;
        final transformedData = items.map(CustomAttribute.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data!;
    return data.map(CustomAttribute.fromJson).toList().toSuccess();
  }
}
