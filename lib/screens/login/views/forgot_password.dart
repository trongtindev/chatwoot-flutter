import '../controllers/forgot_password.dart';
import '../widgets/layout.dart';
import '/imports.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  final api = Get.find<ApiService>();
  final ForgotPasswordController c;

  ForgotPasswordView({super.key}) : c = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final width = double.infinity; // TODO: responsive
    final baseUrl = Uri.parse(api.baseUrl.value).host;

    return Scaffold(
      appBar: AppBar(),
      body: buildBody(
        width: width,
        header: buildHeader(
          title: t.forgot_password_title,
          description: t.forgot_password_description(baseUrl),
        ),
        child: buildForm(),
      ),
    );
  }

  Widget buildForm() {
    return Obx(() {
      var isLoading = controller.isLoading.value;

      return Form(
        key: controller.formKey,
        child: Column(
          children: [
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
            Padding(padding: EdgeInsets.only(top: 8)),
            SizedBox(
              width: double.infinity,
              child: primaryButton(
                loading: isLoading,
                onPressed: controller.submit,
                label: t.forgot_password_submit,
              ),
            ),
          ],
        ),
      );
    });
  }
}
