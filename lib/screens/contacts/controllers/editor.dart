import '/imports.dart';

class ContactEditorController extends GetxController {
  final _api = Get.find<ApiService>();

  final int? contact_id;

  ContactEditorController({this.contact_id});

  final loading = false.obs;
  final formKey = GlobalKey<FormState>();
  final thumbnail = ''.obs;
  final name = TextEditingController();
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final phone_number = TextEditingController();
  final country = TextEditingController();
  final country_code = ''.obs;
  final description = TextEditingController();
  final company_name = TextEditingController();

  Future<void> submit() async {}
}
