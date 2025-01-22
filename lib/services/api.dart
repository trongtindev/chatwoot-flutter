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
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.w(error, stackTrace: error.stackTrace);
          return handler.next(error);
        },
      ),
    );

    return this;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logger.t('[${options.method}] ${options.uri}');

    // inject user-agent
    options.headers['user-agent'] =
        '${_packageInfo.appName}/${_packageInfo.version}';

    // inject authorization
    final profile = _getAuth.profile.value;
    if (options.uri.toString().contains('/api/') && profile != null) {
      options.headers['api_access_token'] = profile.access_token;
    }

    return handler.next(options);
  }

  Future<Result<ApiInfo>> getInfo({String? baseUrl}) async {
    try {
      final result = await _http.get('${baseUrl ?? env.API_URL}/api');
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
    String? sso_auth_token,
  }) async {
    try {
      final result = await _http.post('${baseUrl.value}/auth/sign_in', data: {
        'email': email,
        'password': password,
        'sso_auth_token': sso_auth_token,
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
      final result = await _http.get('${baseUrl.value}/profile');
      return ProfileInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// Creating a conversation in chatwoot requires a source id.
  /// Learn more about source_id: https://github.com/chatwoot/chatwoot/wiki/Building-on-Top-of-Chatwoot:-Importing-Existing-Contacts-and-Creating-Conversations
  Future<Result<ConversationInfo>> createConversation({
    int? account_id,
    required int inbox_id,
    required int contact_id,
    required String source_id,
    int? assignee_id,
    int? team_id,
    ConversationStatus? status,
    required String content,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/conversations';
      final result = await _http.post(
        path,
        data: {
          'inbox_id': inbox_id,
          'contact_id': contact_id,
          'source_id': source_id,
          'assignee_id': assignee_id,
          'team_id': team_id,
          'status': status?.name,
          'message': {
            'content': content,
          },
        },
      );

      return ConversationInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// Toggles the priority of conversation
  Future<Result<bool>> updateConversationPriority({
    int? account_id,
    required int conversation_id,
    required ConversationPriority priority,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path =
          '/accounts/$account_id/conversations/$conversation_id/toggle_priority';
      await _http.post(
        path,
        data: {
          'priority': priority.name,
        },
      );

      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// Get all details regarding a conversation with all messages in the conversation
  Future<Result<ConversationInfo>> getConversation({
    int? account_id,
    required int conversation_id,
    Function(ConversationInfo data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/conversations/$conversation_id';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ConversationInfo.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return ConversationInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<UserInfo>>> getConversationParticipants({
    int? account_id,
    required int conversation_id,
    Function(List<UserInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path =
          '/accounts/$account_id/conversations/$conversation_id/participants';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data);
          final transformedData = items.map(UserInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);
      List<dynamic> items = result.data;

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return items.map(UserInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> updateConversationLabels({
    int? account_id,
    required int conversation_id,
    required List<String> labels,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path =
          '/accounts/$account_id/conversations/$conversation_id/labels';

      await _http.post(path, data: {'labels': labels});

      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListConversationResult>> listConversations({
    int? account_id,
    String? q,
    ConversationStatus? status,
    int? inbox_id,
    int? team_id,
    List<String>? labels,
    int? assignee_type_id,
    required ConversationSortType sort_order,
    AssigneeType? assignee_type,
    int? page,
    Function(ListConversationResult data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/conversations';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          final json = jsonDecode(cached.data);
          final transformedData = ListConversationResult.fromJson(json['data']);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(
        path,
        queryParameters: {
          'status': status?.name,
          'inbox_id': inbox_id,
          'team_id': team_id,
          'labels': labels,
          'assignee_type_id': assignee_type_id ?? 0,
          'assignee_type': assignee_type?.name,
          'sort_order': sort_order.name, // TODO: maybe not working
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

  Future<Result<String>> changeConversationStatus({
    int? account_id,
    required int conversation_id,
    required ConversationStatus status,
    DateTime? snoozed_until,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final result = await _http.post(
        '/accounts/$account_id/conversations/$conversation_id/toggle_status',
        data: {
          'status': status.name,
          'snoozed_until': snoozed_until?.toString(),
        },
      );
      return '${result.data['message']}'.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<UserInfo>>> listAssignableAgents({
    int? account_id,
    required int conversation_id,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path =
          '/accounts/$account_id/conversations/$conversation_id/assignable_agents';

      final result = await _http.get(path);
      List<dynamic> items = result.data['payload'];

      return items.map(UserInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ListNotificationResult>> listNotifications({
    int? account_id,
    List<NotificationStatus>? includes,
    int? page,
    Function(ListNotificationResult data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/notifications';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListNotificationResult.fromJson(json['data']);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(
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

  Future<Result<bool>> markNotificationsRead({
    int? account_id,
    required int primary_actor_id,
    required NotificationActorType primary_actor_type,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/notifications/read_all';

      await _http.post(
        path,
        queryParameters: {
          'primary_actor_id': primary_actor_id,
          'primary_actor_type': primary_actor_type.name,
        },
      );

      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// Listing all the resolved contacts with pagination (Page size = 15).
  /// Resolved contacts are the ones with a value for identifier, email or phone number.
  Future<Result<ListContactResult>> listContacts({
    int? account_id,
    int? page,
    required ContactSortBy sortBy,
    required OrderBy orderBy,
    Function(ListContactResult data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/contacts';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListContactResult.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(
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
    int? before,
    Function(ListMessageResult data)? onCacheHit,
  }) async {
    try {
      final path =
          '/accounts/$account_id/conversations/$conversation_id/messages';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ListMessageResult.fromJson(json);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(
        path,
        queryParameters: {
          'after': after,
          'before': before,
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
      final result = await _http.post(
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
    int? account_id,
    required int contact_id,
    Function(ContactInfo data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/contacts/$contact_id';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          var transformedData = ContactInfo.fromJson(json['payload']);
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);

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
    int? account_id,
    AttributeModel? attribute_model,
    Function(List<CustomAttribute> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/custom_attribute_definitions';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data);
          var transformedData = items.map(CustomAttribute.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(
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

  Future<Result<MessageInfo>> sendMessage({
    int? account_id,
    required int conversation_id,
    String? content,
    MessageType? message_type,
    bool? private,
    List<FileInfo>? attachments,
    Function(double progress)? onProgress,
    String? echo_id,
    int? in_reply_to,
  }) async {
    try {
      attachments ??= [];
      account_id ??= _getAuth.profile.value!.account_id;
      message_type ??= MessageType.outgoing;
      private ??= false;

      final data = FormData.fromMap({
        'content': content,
        'message_type': message_type.name,
        'private': private,
        'echo_id': echo_id,
      });

      if (attachments.isNotEmpty) {
        for (var file in attachments) {
          _logger.d('file name:${file.name} size:${file.size}');

          if (file.size > env.ATTACHMENT_SIZE_LIMIT) {
            // TODO: maybe make SafeException
            throw Exception(t.attachment_exceeds_limit);
          }

          var multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: file.name,
            contentType: DioMediaType.parse(file.contentType!),
          );
          data.files.add(MapEntry('attachments[]', multipartFile));
        }
      }

      final result = await _http.post(
        '/accounts/$account_id/conversations/$conversation_id/messages',
        data: data,
        onSendProgress: (count, total) {
          if (attachments!.isEmpty) return;
          _logger.t('count:$count total:$total');
          if (onProgress != null) onProgress(count / total);
        },
      );

      return MessageInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> markMessageRead({
    int? account_id,
    required int conversation_id,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      await _http.post(
        '/accounts/$account_id/conversations/$conversation_id/update_last_seen',
      );

      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<MacroInfo>>> listMacros({
    int? account_id,
    Function(List<MacroInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/macros';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          List<dynamic> items = json['payload'];
          var transformedData = items.map(MacroInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      List<dynamic> items = result.data['payload'];
      return items.map(MacroInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> executeMacro({
    int? account_id,
    required List<int> conversation_ids,
    required int macro_id,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      await _http.post(
        '/accounts/$account_id/macros/$macro_id/execute',
        data: {
          'conversation_ids': conversation_ids,
        },
      );
      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> deleteMacro({
    int? account_id,
    required int macro_id,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      await _http.delete(
        '/accounts/$account_id/macros/$macro_id',
      );
      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<InboxInfo>>> listInboxes({
    int? account_id,
    Function(List<InboxInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/inboxes';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          List<dynamic> items = json['payload'];
          var transformedData = items.map(InboxInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      List<dynamic> items = result.data['payload'];
      return items.map(InboxInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<LabelInfo>>> listLabels({
    int? account_id,
    Function(List<LabelInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;

      final path = '/accounts/$account_id/labels';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          var json = jsonDecode(cached.data);
          List<dynamic> items = json['payload'];
          var transformedData = items.map(LabelInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      var result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      List<dynamic> items = result.data['payload'];
      return items.map(LabelInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// List all Canned Responses in an Account
  Future<Result<List<CannedResponseInfo>>> listCannedResponses({
    int? account_id,
    AttributeModel? attribute_model,
    Function(List<CannedResponseInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/canned_responses';

      // if onCacheHit defined
      if (onCacheHit != null) {
        var cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data);
          var transformedData = items.map(CannedResponseInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      List<dynamic> items = result.data;
      return items.map(CannedResponseInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// Add a new Canned Response to Account
  Future<Result<CannedResponseInfo>> createCannedResponse({
    int? account_id,
    required String content,
    required String short_code,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/canned_responses';

      final result = await _http.post(
        path,
        data: {
          'content': content,
          'short_code': short_code,
        },
      );

      return CannedResponseInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> updatePassword({
    required String current_password,
    required String password,
    required String password_confirmation,
  }) async {
    try {
      final result = await _http.put(
        '/profile',
        data: {
          'profile': {
            'current_password': current_password,
            'password': password,
            'password_confirmation': password_confirmation,
          }
        },
      );
      return ProfileInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<ProfileInfo>> updateProfile({
    String? name,
    String? email,
    String? display_name,
    String? signature,
  }) async {
    try {
      final profile = <String, String>{};
      if (name != null) profile['name'] = name;
      if (email != null) profile['email'] = email;
      if (display_name != null) profile['display_name'] = display_name;
      if (signature != null) profile['signature'] = '**$signature**';

      final result = await _http.put('/profile', data: {'profile': profile});
      return ProfileInfo.fromJson(result.data).toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<String>> resetPassword({
    required String email,
  }) async {
    try {
      final result = await _http.post(
        '${baseUrl.value}/auth/password',
        data: {'email': email},
      );
      return '${result.data['message']}'.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  /// List Agents in Account
  Future<Result<List<UserInfo>>> listAgents({
    int? account_id,
    required int conversation_id,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/agents';

      final result = await _http.get(path);
      List<dynamic> items = result.data;

      return items.map(UserInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<String>>> getContactLabels({
    int? account_id,
    required int contact_id,
    Function(List<String> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/contacts/$contact_id/labels';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data)['payload'];
          final transformedData = items.map((e) => e.toString()).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);
      List<dynamic> items = result.data['payload'];

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return items.map((e) => e.toString()).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<bool>> updateContactLabels({
    int? account_id,
    required int contact_id,
    required List<String> labels,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/contacts/$contact_id/labels';

      await _http.post(path, data: {'labels': labels});

      return true.toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<ConversationInfo>>> getContactConversations({
    int? account_id,
    required int contact_id,
    Function(List<ConversationInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/contacts/$contact_id/conversations';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data)['payload'];
          final transformedData = items.map(ConversationInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);
      List<dynamic> items = result.data['payload'];

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return items.map(ConversationInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }

  Future<Result<List<TeamInfo>>> getTeams({
    int? account_id,
    Function(List<TeamInfo> data)? onCacheHit,
  }) async {
    try {
      account_id ??= _getAuth.profile.value!.account_id;
      final path = '/accounts/$account_id/teams';

      // if onCacheHit defined
      if (onCacheHit != null) {
        final cached = await getCache(url: path);
        if (cached != null) {
          List<dynamic> items = jsonDecode(cached.data);
          final transformedData = items.map(TeamInfo.fromJson).toList();
          onCacheHit(transformedData);
        }
      }

      final result = await _http.get(path);
      List<dynamic> items = result.data;

      // if onCacheHit defined
      if (onCacheHit != null) saveCache(url: path, data: result.data);

      return items.map(TeamInfo.fromJson).toList().toSuccess();
    } on DioException catch (error) {
      return ApiError.fromException(error).toFailure();
    } on Exception catch (error) {
      return error.toFailure();
    }
  }
}
