import '/imports.dart';

class ProfileApi {
  final ApiService service;
  ProfileApi({required this.service});

  Future<Result<ProfileInfo>> get() async {
    final result = await service.get('${service.baseUrl.value}/profile');
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ProfileInfo.fromJson(data).toSuccess();
  }

  Future<Result<ProfileInfo>> update({
    String? name,
    String? email,
    String? display_name,
    String? signature,
  }) async {
    final profile = <String, String>{};
    if (name != null) profile['name'] = name;
    if (email != null) profile['email'] = email;
    if (display_name != null) profile['display_name'] = display_name;
    if (signature != null) profile['signature'] = '**$signature**';

    final result = await service.put('/profile', data: {'profile': profile});
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ProfileInfo.fromJson(data).toSuccess();
  }

  Future<Result<bool>> updateAutoOffline({
    required bool auto_offline,
  }) async {
    final path =
        '${service.baseUrl.value}/api/${service.version.value}/profile/auto_offline';

    final result = await service.post(
      path,
      data: {
        'profile': {
          'account_id': service.account_id,
          'auto_offline': auto_offline,
        }
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<bool>> updateAvailability({
    required AvailabilityStatus availability,
  }) async {
    final path =
        '${service.baseUrl.value}/api/${service.version.value}/profile/availability';

    final result = await service.post(
      path,
      data: {
        'profile': {
          'account_id': service.account_id,
          'availability': availability.name,
        }
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<ProfileInfo>> updatePassword({
    required String current_password,
    required String password,
    required String password_confirmation,
  }) async {
    final result = await service.put(
      '/profile',
      data: {
        'profile': {
          'current_password': current_password,
          'password': password,
          'password_confirmation': password_confirmation,
        }
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ProfileInfo.fromJson(data).toSuccess();
  }
}
