import '/imports.dart';
import '../controllers/profile.dart';

// TODO: make better UI
class SettingsProfileView extends GetView<SettingsProfileController> {
  const SettingsProfileView({super.key});

  @override
  Widget build(context) {
    return GetBuilder(
      init: SettingsProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(t.profile),
            centerTitle: true,
          ),
          body: buildBody(context),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    final auth = Get.find<AuthService>();
    return Obx(() {
      final profile = auth.profile.value!;
      final isLoading = controller.isLoading.value;

      return Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: avatar(
                    context,
                    url: profile.avatar_url,
                    size: 128,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultButton(
                      label: t.upload,
                      onPressed: () {},
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.full_name,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          label: Text(t.full_name),
                          hintText: t.full_name_hint,
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                        validator: (value) {
                          if (value == null || !isFullName(value)) {
                            return t.full_name_invalid;
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.display_name,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          label: Text(t.display_name),
                          hintText: t.display_name_hint,
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return t.display_name_invalid;
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: Text(t.email),
                          hintText: t.email_hint,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || !isEmail(value)) {
                            return t.email_invalid;
                          }
                          return null;
                        },
                      ),
                      // Padding(padding: EdgeInsets.only(top: 8)),
                      // TextFormField(
                      //   enabled: !isLoading,
                      //   controller: controller.message_signature,
                      //   keyboardType: TextInputType.multiline,
                      //   decoration: InputDecoration(
                      //     label: Text('profile.message_signature'.tr),
                      //     hintText: 'profile.message_signature_hint'.tr,
                      //   ),
                      //   validator: (value) {
                      //     if (value == null) {
                      //       return 'profile.message_signature_invalid'.tr;
                      //     }
                      //     return null;
                      //   },
                      //   minLines: 2,
                      //   maxLines: 10,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                return primaryButton(
                  block: true,
                  label: t.save_changes,
                  loading: isLoading,
                  onPressed: controller.submit,
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}
