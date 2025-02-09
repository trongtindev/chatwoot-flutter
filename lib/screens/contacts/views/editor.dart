import '../controllers/editor.dart';
import '/imports.dart';

class ContactEditorView extends StatelessWidget {
  final ContactEditorController controller;

  final int? contact_id;
  ContactEditorView({super.key, this.contact_id})
      : controller = Get.put(ContactEditorController(contact_id: contact_id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.contacts_editor_title),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: Obx(() {
          final loading = controller.loading.value;

          return ListView(
            padding: EdgeInsets.all(8),
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Obx(() {
                    final thumbnail = controller.thumbnail.value;
                    return avatar(context, size: 96, url: thumbnail);
                  }),
                ],
              ),
              // name
              TextFormField(
                enabled: !loading,
                controller: controller.name,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text(t.full_name),
                  hintText: t.full_name_hint,
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value != null) {
                    return t.full_name_invalid;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // email
              TextFormField(
                enabled: !loading,
                controller: controller.email,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text(t.email),
                  hintText: t.email_hint,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value != null && !isEmail(value)) {
                    return t.email_invalid;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // email
              TextFormField(
                enabled: !loading,
                controller: controller.phone_number,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: Text(t.email),
                  hintText: t.email_hint,
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // email
              TextFormField(
                enabled: !loading,
                controller: controller.city,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  label: Text(t.city),
                  hintText: t.city_hint,
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value != null && !isEmail(value)) {
                    return t.email_invalid;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // country
              TextFormField(
                enabled: !loading,
                readOnly: true,
                controller: controller.country,
                decoration: InputDecoration(
                  label: Text(t.country),
                  prefixIcon: Icon(Icons.work_outline),
                  suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                ),
                onTap: controller.showCountryPicker,
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // company
              TextFormField(
                enabled: !loading,
                controller: controller.company_name,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  label: Text(t.company),
                  hintText: t.company_hint,
                  prefixIcon: Icon(Icons.work_outline),
                ),
                validator: (value) {
                  if (value != null) {
                    return t.company_invalid;
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 5,
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // description
              TextFormField(
                enabled: !loading,
                controller: controller.description,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  label: Text(t.bio),
                  hintText: t.bio_hint,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value != null) {
                    return t.bio_invalid;
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 5,
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final loading = controller.loading.value;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: primaryButton(
            loading: loading,
            label: t.save_changes,
            onPressed: controller.submit,
          ),
        );
      }),
    );
  }
}
