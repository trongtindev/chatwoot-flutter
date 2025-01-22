import '/imports.dart';

class ContactDetailController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final int contact_id;

  ContactDetailController(
    this.contact_id, {
    ContactInfo? initial,
  }) : info = Rxn<ContactInfo>(initial);

  late Rxn<ContactInfo> info;
  final after = 0.obs;
  final error = ''.obs;

  @override
  void onReady() {
    super.onReady();
    getContact();
  }

  Future<void> getContact() async {
    try {
      final result = await _api.getContact(
        account_id: _auth.profile.value!.account_id,
        contact_id: contact_id,
        onCacheHit: (data) => info.value = data,
      );
      final data = result.getOrThrow();
      info.value = data;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } on Error catch (reason) {
      _logger.e(reason, stackTrace: reason.stackTrace);
      error.value = reason.toString();
    }
  }
}
