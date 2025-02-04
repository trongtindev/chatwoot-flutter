import '/imports.dart';

class NotificationsApi {
  final device = Get.find<DeviceService>();
  final ApiService service;
  NotificationsApi({required this.service});

  Future<Result<ListNotificationResult>> list({
    List<NotificationStatus>? includes,
    int? page,
    Function(ListNotificationResult data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/notifications';

    final result = await service.get(
      path,
      queryParameters: {
        'includes': includes?.map((e) => e.name),
        'page': page,
      },
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListNotificationResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListNotificationResult.fromJson(data).toSuccess();
  }

  Future<Result<bool>> readAll({
    required int primary_actor_id,
    required NotificationActorType primary_actor_type,
  }) async {
    final path = '/accounts/{account_id}/notifications/read_all';

    final result = await service.post(
      path,
      queryParameters: {
        'primary_actor_id': primary_actor_id,
        'primary_actor_type': primary_actor_type.name,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<bool>> saveDeviceDetails({
    required String push_token,
  }) async {
    final path = '/notification_subscriptions';

    final result = await service.post(
      path,
      data: {
        'subscription_type': 'fcm',
        'subscription_attributes': {
          'deviceName': device.name,
          'devicePlatform': device.platform,
          'apiLevel': device.apiLevel,
          'brandName': device.brandName,
          'buildNumber': packageInfo.buildNumber,
          'push_token': push_token,
          'device_id': device.deviceId,
        },
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<bool>> deleteSubscription({
    required String push_token,
  }) async {
    final path = '/notification_subscriptions';

    final result = await service.delete(
      path,
      data: {'push_token': push_token},
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }
}
