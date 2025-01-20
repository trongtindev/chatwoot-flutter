import '../controllers/change_url.dart';
import '../widgets/layout.dart';
import '/imports.dart';

class ChangeUrlView extends GetView<ChangeUrlController> {
  const ChangeUrlView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = double.infinity; // TODO: responsive

    return GetBuilder(
      init: ChangeUrlController(),
      builder: (_) {
        var url = Uri.parse(env.API_URL).host;
        return Scaffold(
          appBar: AppBar(),
          body: buildBody(
            width: width,
            header: buildHeader(
              title: t.change_url_title,
              description: t.change_url_description(url),
            ),
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
        var isValidating = controller.isValidating.value;

        return Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !isValidating,
                controller: controller.baseUrl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  label: Text(t.change_url_url),
                  hintText: t.change_url_url_hint,
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || !isUrlWithoutHttp(value)) {
                    return t.change_url_url_invalid;
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              SizedBox(
                width: double.infinity,
                child: primaryButton(
                  loading: isValidating,
                  onPressed: controller.submit,
                  label: t.change_url_submit,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
