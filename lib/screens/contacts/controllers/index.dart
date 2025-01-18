import '/imports.dart';

class ContactsController extends GetxController {
  final _logger = Logger();
  final _api = Get.find<ApiService>();
  final _auth = Get.find<AuthService>();

  final items = RxList<ContactInfo>();
  final loading = true.obs;
  final error = ''.obs;

  @override
  void onReady() {
    super.onReady();
    getContacts();
  }

  Future<void> getContacts() async {
    try {
      loading.value = true;
      var result = await _api.listContacts(
        account_id: _auth.profile.value!.account_id,
      );
      var data = result.getOrThrow();
      items.value = data.payload;
    } on ApiError catch (reason) {
      _logger.w(reason);
      error.value = reason.errors.join(';');
    } catch (reason) {
      _logger.e(reason);
      error.value = reason.toString();
    } finally {
      loading.value = false;
    }
  }
}
