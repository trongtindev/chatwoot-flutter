import '/imports.dart';
import '../controllers/profile.dart';

class SettingsProfileView extends GetView<SettingsProfileController> {
  const SettingsProfileView({super.key});

  @override
  Widget build(context) {
    return GetBuilder(
      init: SettingsProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('settings.profile'.tr),
            centerTitle: true,
          ),
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    final auth = Get.find<AuthService>();
    return Obx(() {
      var profile = auth.profile.value!;
      var isLoading = controller.isLoading.value;

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: avatar(
              url: profile.avatar_url,
              width: 128,
              height: 128,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              defaultButton(
                label: 'upload'.tr,
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
                    label: Text('profile.full_name'.tr),
                    hintText: 'profile.full_name_hint'.tr,
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || !isFullName(value)) {
                      return 'profile.full_name_invalid'.tr;
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
                    label: Text('profile.display_name'.tr),
                    hintText: 'profile.display_name_hint'.tr,
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'profile.display_name_invalid'.tr;
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
                    label: Text('profile.email'.tr),
                    hintText: 'profile.email_hint'.tr,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || !isEmail(value)) {
                      return 'profile.email_invalid'.tr;
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
                Padding(padding: EdgeInsets.only(top: 8)),
                primaryButton(
                  block: true,
                  label: 'common.save_changes'.tr,
                  loading: isLoading,
                  onPressed: controller.submit,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
