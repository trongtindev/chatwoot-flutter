import '/imports.dart';

class ContactEditorController extends GetxController {
  final _api = Get.find<ApiService>();

  final int? contact_id;
  final info = Rxn<ContactInfo>();
  final loading = false.obs;
  final formKey = GlobalKey<FormState>();
  final thumbnail = ''.obs;
  final name = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final phone_number = TextEditingController();
  final country = TextEditingController();
  final country_code = ''.obs;
  final description = TextEditingController();
  final company_name = TextEditingController();

  ContactEditorController({this.contact_id});

  @override
  void onInit() {
    super.onInit();

    info.listen((next) {
      if (next == null) return;
      name.text = next.name;
      thumbnail.value = next.thumbnail;
      email.text = next.email ?? '';
      city.text = next.additional_attributes.city ?? '';
      phone_number.text = next.phone_number ?? '';
      country.text = next.additional_attributes.country ?? '';
      country_code.value = next.additional_attributes.country_code ?? '';
      description.text = next.additional_attributes.description ?? '';
      company_name.text = next.additional_attributes.company_name ?? '';
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (contact_id != null) fetch();
  }

  Future<void> fetch() async {
    final result = await _api.contacts.get(
      contact_id: contact_id!,
      onCacheHit: (data) {
        info.value = data;
      },
    );
    if (result.isError()) {
      showSnackBar(result.exceptionOrNull()!.toString());
      return;
    }
    info.value = result.getOrThrow();
  }

  Future<void> submit() async {
    try {
      loading.value = true;

      if (contact_id == null) {
        final result = await _api.contacts.create(
          name: name.text,
          email: email.text,
          city: city.text,
          phone_number: phone_number.text,
          country: country.text,
          country_code: country_code.value,
          description: description.text,
          company_name: company_name.text,
        );
        if (result.isError()) {
          showSnackBar(result.exceptionOrNull()!.toString());
          return;
        }
        Get.back();
        showSnackBar(t.successful);
        return;
      }

      final result = await _api.contacts.update(
        contact_id: contact_id!,
        name: name.text,
        email: email.text,
        city: city.text,
        phone_number: phone_number.text,
        country: country.text,
        country_code: country_code.value,
        description: description.text,
        company_name: company_name.text,
      );
      if (result.isError()) {
        showSnackBar(result.exceptionOrNull()!.toString());
        return;
      }
      showSnackBar(t.successful);
    } on Error catch (error) {
      logger.f(error, stackTrace: error.stackTrace);
    } finally {
      loading.value = false;
    }
  }
}
