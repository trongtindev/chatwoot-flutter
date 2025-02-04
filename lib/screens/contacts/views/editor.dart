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
                  avatar(context, size: 96),
                ],
              ),
              // first_name
              TextFormField(
                enabled: !loading,
                controller: controller.first_name,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text(t.first_name),
                  hintText: t.first_name_hint,
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value != null) {
                    return t.first_name_invalid;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              // last_name
              TextFormField(
                enabled: !loading,
                controller: controller.last_name,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text(t.last_name),
                  hintText: t.last_name_hint,
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value != null) {
                    return t.last_name_invalid;
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
              // description
              TextFormField(
                enabled: !loading,
                controller: controller.description,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  label: Text(t.bio),
                  hintText: t.bio_hint,
                  prefixIcon: Icon(Icons.edit),
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
              // company
              TextFormField(
                enabled: !loading,
                controller: controller.company_name,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  label: Text(t.company),
                  hintText: t.company_hint,
                  prefixIcon: Icon(Icons.edit),
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
