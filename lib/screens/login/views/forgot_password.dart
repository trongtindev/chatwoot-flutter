import '../controllers/index.dart';
import '../widgets/layout.dart';
import '/imports.dart';

class ForgotPasswordView extends GetView<LoginController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = double.infinity; // TODO: responsive

    return GetBuilder(
      init: LoginController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(),
          body: buildBody(
            width: width,
            header: buildHeader(
              title: t.forgot_password_title,
              description: t.forgot_password_description,
            ),
            child: Text('ok'),
          ),
        );
      },
    );
  }
}
