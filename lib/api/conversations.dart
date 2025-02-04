import '/imports.dart';

class ConversationsApi {
  final ApiService service;
  ConversationsApi({required this.service});

  /// Get all details regarding a conversation with all messages in the conversation
  Future<Result<ConversationInfo>> get({
    required int conversation_id,
    Function(ConversationInfo data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/conversations/$conversation_id';

    final result = await service.get(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ConversationInfo.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ConversationInfo.fromJson(data).toSuccess();
  }

  Future<Result<ListConversationResult>> list({
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
    final path = '/accounts/{account_id}/conversations';

    final result = await service.get(
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
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListConversationResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListConversationResult.fromJson(data).toSuccess();
  }

  Future<Result<MessageInfo>> sendMessage({
    required int conversation_id,
    String? content,
    MessageType? message_type,
    bool? private,
    List<FileInfo>? attachments,
    Function(double progress)? onProgress,
    String? echo_id,
    int? in_reply_to,
  }) async {
    attachments ??= [];
    message_type ??= MessageType.outgoing;
    private ??= false;

    final formData = FormData.fromMap({
      'content': content,
      'message_type': message_type.name,
      'private': private,
      'echo_id': echo_id,
    });

    if (attachments.isNotEmpty) {
      for (var file in attachments) {
        if (file.size > env.ATTACHMENT_SIZE_LIMIT) {
          // TODO: maybe make SafeException
          throw Exception(t.attachment_exceeds_limit);
        }

        var multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
          contentType: DioMediaType.parse(file.contentType!),
        );
        formData.files.add(MapEntry('attachments[]', multipartFile));
      }
    }

    final result = await service.post(
      '/accounts/{account_id}/conversations/$conversation_id/messages',
      data: formData,
      onSendProgress: (count, total) {
        if (attachments!.isEmpty) return;
        if (onProgress != null) onProgress(count / total);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return MessageInfo.fromJson(data).toSuccess();
  }

  Future<Result<bool>> markMessageRead({
    required int conversation_id,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/update_last_seen';

    final result = await service.post(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<ListMessageResult>> listMessages({
    required int conversation_id,
    int? after,
    int? before,
    Function(ListMessageResult data)? onCacheHit,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/messages';

    final result = await service.get(
      path,
      queryParameters: {
        'after': after,
        'before': before,
      },
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListMessageResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListMessageResult.fromJson(data).toSuccess();
  }

  Future<Result<MessageInfo>> deleteConversationMessage({
    required int conversation_id,
    required int message_id,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/messages/$message_id';

    final result = await service.delete(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return MessageInfo.fromJson(data).toSuccess();
  }

  Future<Result<bool>> changeStatus({
    required int conversation_id,
    required ConversationStatus status,
    DateTime? snoozed_until,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/toggle_status';

    final result = await service.post(
      path,
      data: {
        'status': status.name,
        'snoozed_until': snoozed_until?.toString(),
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  /// Creating a conversation in chatwoot requires a source id.
  /// Learn more about source_id: https://github.com/chatwoot/chatwoot/wiki/Building-on-Top-of-Chatwoot:-Importing-Existing-Contacts-and-Creating-Conversations
  Future<Result<ConversationInfo>> create({
    required int inbox_id,
    required int contact_id,
    required String source_id,
    int? assignee_id,
    int? team_id,
    ConversationStatus? status,
    required String content,
  }) async {
    final path = '/accounts/{account_id}/conversations';

    final result = await service.post(
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
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ConversationInfo.fromJson(data).toSuccess();
  }

  /// Toggles the priority of conversation
  Future<Result<bool>> updatePriority({
    required int conversation_id,
    required ConversationPriority priority,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/toggle_priority';

    final result = await service.post(
      path,
      data: {
        'priority': priority.name,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<List<UserInfo>>> listParticipants({
    required int id,
    Function(List<UserInfo> data)? onCacheHit,
    CancelToken? cancelToken,
  }) async {
    final path = '/accounts/{account_id}/conversations/$id/participants';

    final result = await service.get<List<dynamic>>(
      path,
      cancelToken: cancelToken,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = data.map(UserInfo.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    List<dynamic> items = result.getOrThrow().data!;
    return items.map(UserInfo.fromJson).toList().toSuccess();
  }

  Future<Result<bool>> updateLabels({
    required int conversation_id,
    required List<String> labels,
  }) async {
    final path = '/accounts/{account_id}/conversations/$conversation_id/labels';

    final result = await service.post(path, data: {'labels': labels});
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<bool>> updateAssignments({
    required int conversation_id,
    required int assignee_id,
  }) async {
    final path =
        '/accounts/{account_id}/conversations/$conversation_id/assignments';

    final result = await service.post(
      path,
      data: {
        'assignee_id': assignee_id,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }
}
