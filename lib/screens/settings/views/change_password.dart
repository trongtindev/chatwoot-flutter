import '../controllers/change_password.dart';
import '/imports.dart';

// TODO: make better UI
class SettingsChangePasswordView
    extends GetView<SettingsChangePasswordController> {
  const SettingsChangePasswordView({super.key});

  @override
  Widget build(context) {
    return GetBuilder(
      init: SettingsChangePasswordController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(t.change_password),
            centerTitle: true,
          ),
          body: buildBody(context),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              children: [
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.current_password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          label: Text(t.change_password_current),
                          hintText: t.change_password_current_hint,
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                        validator: (value) {
                          if (value == null || !isPassword(value)) {
                            return t.password_invalid;
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.new_password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          label: Text(t.change_password_new),
                          hintText: t.change_password_new_hint,
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                        validator: (value) {
                          if (value == null || !isPassword(value)) {
                            return t.password_invalid;
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      TextFormField(
                        enabled: !isLoading,
                        controller: controller.confirm_password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          label: Text(t.change_password_confirm),
                          hintText: t.change_password_confirm_hint,
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                        validator: (value) {
                          if (value == null || !isPassword(value)) {
                            return t.password_invalid;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: primaryButton(
                block: true,
                label: t.save_changes,
                loading: isLoading,
                onPressed: controller.submit,
              ),
            ),
          ),
        ],
      );
    });
  }
}
