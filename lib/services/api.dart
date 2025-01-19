import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '/imports.dart';

class ApiService extends GetxService {
  final _logger = Logger();

  late Dio _http;
  late PackageInfo _packageInfo;
  late DeviceInfoPlugin _deviceInfoPlugin;
  late AndroidDeviceInfo _androidDeviceInfo;
  late IosDeviceInfo _iosDeviceInfo;

  final baseUrl = PersistentRxString(env.API_URL, key: 'api:baseUrl');
  final version = PersistentRxString(env.API_VERSION, key: 'api:version');

  @override
  void onReady() {
    super.onReady();

    baseUrl.listen((next) {
      _http.options.baseUrl = getBaseUrl;
      _logger.i('baseUrl changed => ${_http.options.baseUrl}');
    });
  }

  DbService? _db;
  DbService get _getDb {
    _db ??= Get.find<DbService>();
    if (_db == null) throw Exception('DbService not found!');
    return _db!;
  }

  AuthService? _auth;
  AuthService get _getAuth {
    _auth ??= Get.find<AuthService>();
    if (_auth == null) throw Exception('AuthService not found!');
    return _auth!;
  }

  String get getBaseUrl {
    return '${baseUrl.value}/api/${version.value}';
  }

  String get getDeviceName {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.model;
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.model;
    }
    throw UnsupportedError(
      'getDeviceName are not supported for this platform.',
    );
  }

  String get getdevicePlatform {
    if (GetPlatform.isIOS) {
      return 'iOS';
    } else if (GetPlatform.isAndroid) {
      return 'Android';
    }
    throw UnsupportedError(
      'getdevicePlatform are not supported for this platform.',
    );
  }

  String get getApiLevel {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.systemVersion;
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.version.sdkInt.toString();
    }
    throw UnsupportedError(
      'getDeviceName are not supported for this platform.',
    );
  }

  String get getBrandName {
    if (GetPlatform.isIOS) {
      return 'Apple';
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.brand;
    }
    throw UnsupportedError(
      'brandName are not supported for this platform.',
    );
  }

  String get getDeviceId {
    if (GetPlatform.isIOS) {
      return _iosDeviceInfo.identifierForVendor ?? '';
    } else if (GetPlatform.isAndroid) {
      return _androidDeviceInfo.id;
    }
    throw UnsupportedError(
      'brandName are not supported for this platform.',
    );
  }

  Future<ApiService> init() async {
    _logger.i('init() baseUrl:$getBaseUrl');

    _packageInfo = await PackageInfo.fromPlatform();
    _deviceInfoPlugin = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
    } else if (GetPlatform.isIOS) {
      _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
    }

    _http = Dio();
    _http.options.headers = {
      'content-type': 'application/json',
      'x-app-version': _packageInfo.version,
    };
    _http.options.baseUrl = getBaseUrl;
    _http.options.connectTimeout = Duration(seconds: env.API_TIMEOUT);
    _http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => _onRequest(options, handler),
        onResponse: (response, handler) {
          // if (kDebugMode) {
          //   var options = response.requestOptions;
          //   print('---${options.method} ${options.uri}:START---');
          //   print(response.data);
          //   print('---${options.method} ${options.uri}:END---');
          // }
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.w(error);
          if (kDebugMode && error.response != null) {
            print('${error.requestOptions.method} ${error.requestOptions.uri}');
            print(error.response?.data);
          }
          return handler.next(error);
        },
      ),
    );

    _logger.i('init() => successful');
    return this;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // inject user-agent
    options.headers['user-agent'] =
        '${_packageInfo.appName}/${_packageInfo.version}';

    // inject authorization
    var profile = _getAuth.profile.value;
    if (options.uri.toString().contains('/api/') && profile != null) {
      options.headers['api_access_token'] = profile.access_token;
    }

    return handler.next(options);
  }

  Future<Result<ApiInfo>> getInfo({String? baseUrl}) async {
    try {
      var result = await _http.get('${baseUrl ?? env.API_URL}/api');
      return ApiInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var result = await _http.post('${baseUrl.value}/auth/sign_in', data: {
        'email': email,
        'password': password,
      });
      return ProfileInfo.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> getProfile() async {
    try {
      var result = await _http.get('${baseUrl.value}/profile');
      return ProfileInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ConversationInfo>> getConversation({
    required int account_id,
    required int conversation_id,
    Function(ConversationInfo data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/conversations/$conversation_id';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ConversationInfo.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ConversationInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListConversationResult>> listConversations({
    required int account_id,
    ConversationStatus? status,
    int? assignee_type_id,
    SortType? sort_order,
    AssigneeType? assignee_type,
    int? page,
    Function(ListConversationResult data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/conversations';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListConversationResult.fromJson(json['data']);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(
        path,
        queryParameters: {
          'status': status?.name,
          'assignee_type_id': assignee_type_id ?? 0,
          'sort_order': sort_order?.name,
          'assignee_type': assignee_type?.name,
          'page': page,
        },
      );

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ListConversationResult.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListNotificationResult>> listNotifications({
    required int account_id,
    List<NotificationStatus>? includes,
    int? page,
    Function(ListNotificationResult data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/notifications';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListNotificationResult.fromJson(json['data']);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(
        path,
        queryParameters: {
          'includes': includes?.map((e) => e.name),
          'page': page,
        },
      );

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ListNotificationResult.fromJson(result.data['data']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListContactResult>> listContacts({
    required int account_id,
    int? page,
    required ContactSortBy sortBy,
    required OrderBy orderBy,
    Function(ListContactResult data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/contacts';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListContactResult.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(
        path,
        queryParameters: {
          'page': page ?? 1,
          'sort': '${orderBy.value}${sortBy.name}',
        },
      );

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ListContactResult.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListMessageResult>> listMessages({
    required int account_id,
    required int conversation_id,
    int? after,
    Function(ListMessageResult data)? onCacheHit,
  }) async {
    try {
      var path =
          '/accounts/$account_id/conversations/$conversation_id/messages';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListMessageResult.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(
        path,
        queryParameters: {
          'after': after,
        },
      );

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ListMessageResult.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> saveDeviceDetails({
    required String push_token,
  }) async {
    try {
      var result = await _http.post(
        '/notification_subscriptions',
        data: {
          'subscription_type': 'fcm',
          'subscription_attributes': {
            'deviceName': getDeviceName,
            'devicePlatform': getdevicePlatform,
            'apiLevel': getApiLevel,
            'brandName': getBrandName,
            'buildNumber': _packageInfo.buildNumber,
            'push_token': push_token,
            'device_id': getDeviceId,
          },
        },
      );
      if (kDebugMode) print(result.data);
      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<CachedRequest?> getCache({
    required String url,
  }) async {
    var query = await _getDb.database.query(
      'cached_requests',
      where: 'url = ?',
      whereArgs: [url],
    );
    if (query.isEmpty) return null;
    return CachedRequest.fromJson(query.first);
  }

  Future<void> saveCache({
    required String url,
    required dynamic data,
  }) async {
    await _getDb.database.insert('cached_requests', {
      'url': url,
      'data': jsonEncode(data),
      'createdAt': timestamp(),
    });
  }

  Future<Result<ContactInfo>> getContact({
    required int account_id,
    required int contact_id,
    Function(ContactInfo data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/contacts/$contact_id';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ContactInfo.fromJson(json['payload']);
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ContactInfo.fromJson(result.data['payload']).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<CustomAttribute>>> listCustomAttributes({
    required int account_id,
    AttributeModel? attribute_model,
    Function(List<CustomAttribute> data)? onCacheHit,
  }) async {
    try {
      var path = '/accounts/$account_id/custom_attribute_definitions';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data);
          var transformedData = items.map(CustomAttribute.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(
        path,
        queryParameters: {
          'attribute_model': attribute_model?.name,
        },
      );

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      List<dynamic> items = result.data;
      return items.map(CustomAttribute.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }
}
