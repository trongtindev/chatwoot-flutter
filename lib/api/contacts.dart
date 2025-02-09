import '/imports.dart';

class ContactsApi {
  final ApiService service;
  ContactsApi({required this.service});

  /// Listing all the resolved contacts with pagination (Page size = 15).
  /// Resolved contacts are the ones with a value for identifier, email or phone number.
  Future<Result<ListContactResult>> list({
    int? page,
    required ContactSortBy sortBy,
    required OrderBy orderBy,
    Function(ListContactResult data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/contacts';

    final result = await service.get(
      path,
      queryParameters: {
        'page': page ?? 1,
        'sort': '${orderBy.value}${sortBy.name}',
      },
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ListContactResult.fromJson(data);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    return ListContactResult.fromJson(data).toSuccess();
  }

  Future<Result<ContactInfo>> get({
    required int contact_id,
    Function(ContactInfo data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id';
    final result = await service.get<dynamic>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = ContactInfo.fromJson(data['payload']);
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data!;
    return ContactInfo.fromJson(data['payload']).toSuccess();
  }

  Future<Result<bool>> createNote({
    required int contact_id,
    required String content,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/notes';

    final result = await service.post(
      path,
      data: {
        'content': content,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<List<ContactNoteInfo>>> listNotes({
    required int contact_id,
    Function(List<ContactNoteInfo> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/notes';

    final result = await service.get<List<dynamic>>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        final transformedData = data.map(ContactNoteInfo.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data!;
    return data.map(ContactNoteInfo.fromJson).toList().toSuccess();
  }

  Future<Result<bool>> deleteNote({
    required int contact_id,
    required int note_id,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/notes/$note_id';

    final result = await service.delete(path);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    return true.toSuccess();
  }

  Future<Result<List<String>>> getLabels({
    required int contact_id,
    Function(List<String> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/labels';

    final result = await service.get<dynamic>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        List<dynamic> items = data['payload'];
        final transformedData = items.map((e) => e.toString()).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    List<dynamic> items = data['payload'];
    return items.map((e) => e.toString()).toList().toSuccess();
  }

  Future<Result<bool>> updateLabels({
    required int contact_id,
    required List<String> labels,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/labels';
    final result = await service.post(
      path,
      data: {
        'labels': labels,
      },
    );

    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }
    return true.toSuccess();
  }

  Future<Result<List<ConversationInfo>>> getConversations({
    required int contact_id,
    Function(List<ConversationInfo> data)? onCacheHit,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id/conversations';

    final result = await service.get<dynamic>(
      path,
      onCacheHit: (data) {
        if (onCacheHit == null) return;
        List<dynamic> items = data['payload'];
        final transformedData = items.map(ConversationInfo.fromJson).toList();
        onCacheHit(transformedData);
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data;
    List<dynamic> items = data['payload'];
    return items.map(ConversationInfo.fromJson).toList().toSuccess();
  }

  Future<Result<ContactInfo>> create({
    String? city,
    String? company_name,
    String? country,
    String? country_code,
    String? description,
    AvailabilityStatus? availability_status,
    String? email,
    String? identifier,
    required String name,
    String? phone_number,
    String? thumbnail,
  }) async {
    final path = '/accounts/{account_id}/contacts';
    final result = await service.post(
      path,
      queryParameters: {
        'include_contact_inboxes': false,
      },
      data: {
        'additional_attributes': {
          'city': city,
          'company_name': company_name,
          'country': country,
          'country_code': country_code,
          'description': description,
        },
        'availability_status': availability_status?.name,
        'email': email,
        'identifier': identifier,
        'name': name,
        'phone_number': phone_number,
        'thumbnail': thumbnail,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data['payload'];
    return ContactInfo.fromJson(data).toSuccess();
  }

  Future<Result<ContactInfo>> update({
    required int contact_id,
    String? city,
    String? company_name,
    String? country,
    String? country_code,
    String? description,
    AvailabilityStatus? availability_status,
    String? email,
    String? identifier,
    required String name,
    String? phone_number,
    String? thumbnail,
  }) async {
    final path = '/accounts/{account_id}/contacts/$contact_id';
    final result = await service.patch(
      path,
      queryParameters: {
        'include_contact_inboxes': false,
      },
      data: {
        'additional_attributes': {
          'city': city,
          'company_name': company_name,
          'country': country,
          'country_code': country_code,
          'description': description,
        },
        'availability_status': availability_status?.name,
        'email': email,
        'identifier': identifier,
        'name': name,
        'phone_number': phone_number,
        'thumbnail': thumbnail,
      },
    );
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }

    final data = result.getOrThrow().data['payload'];
    return ContactInfo.fromJson(data).toSuccess();
  }
}
