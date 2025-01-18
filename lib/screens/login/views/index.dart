import '../controllers/index.dart';
import '../widgets/layout.dart';
import '/imports.dart';
import 'change_url.dart';
import 'forgot_password.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Get.find<ApiService>();
    var width = double.infinity; // TODO: responsive

    return GetBuilder(
      init: LoginController(),
      builder: (_) {
        return Scaffold(
          body: buildBody(
            width: width,
            header: Obx(() {
              var baseUrl = api.baseUrl.value;
              return buildHeader(
                title: 'login.title'.tr,
                description: 'login.description'.trParams({
                  'baseUrl': Uri.parse(baseUrl).host,
                }),
              );
            }),
            child: buildForm(width),
          ),
        );
      },
    );
  }

  Widget buildForm(double width) {
    return SizedBox(
      width: width,
      child: Obx(() {
        var visiblePassword = controller.visiblePassword.value;
        var isSigning = controller.isSigning.value;

        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !isSigning,
                controller: controller.email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text('login.email'.tr),
                  hintText: 'login.email_hint'.tr,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || !isEmail(value)) {
                    return 'login.email_invalid'.tr;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              TextFormField(
                enabled: !isSigning,
                controller: controller.password,
                obscureText: !visiblePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text('login.password'.tr),
                  hintText: 'login.password_hint'.tr,
                  prefixIcon: Icon(Icons.password_outlined),
                  suffixIcon: InkWell(
                    onTap: controller.toggleVisiblePassword,
                    child: Icon(visiblePassword
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye),
                  ),
                ),
                validator: (value) {
                  if (value == null || !isPassword(value)) {
                    return 'login.password_invalid'.tr;
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () => Get.to(() => ForgotPasswordView()),
                    child: Text('login.forgot_password'.tr),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: primaryButton(
                  loading: isSigning,
                  onPressed: controller.submit,
                  label: 'login.submit'.tr,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.to(() => ChangeUrlView()),
                  child: Text('login.change_url'.tr),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text('login.change_language'.tr),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
