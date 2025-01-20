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
              var base_url = Uri.parse(api.baseUrl.value).host;
              return buildHeader(
                title: t.login_title,
                description: t.login_description(base_url),
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
              TextFormField(
                enabled: !isSigning,
                controller: controller.password,
                obscureText: !visiblePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text(t.password),
                  hintText: t.password_hint,
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
                    return t.password_invalid;
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () => Get.to(() => ForgotPasswordView()),
                    child: Text(t.forgot_password),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: primaryButton(
                  loading: isSigning,
                  onPressed: controller.submit,
                  label: t.login_submit,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.to(() => ChangeUrlView()),
                  child: Text(t.change_url),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text(t.change_language),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
