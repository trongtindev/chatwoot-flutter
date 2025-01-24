import '/imports.dart';
import '../controllers/appearance.dart';

class SettingsAppearanceView extends StatelessWidget {
  final theme = Get.find<ThemeService>();
  final controller = Get.put(SettingsAppearanceController());

  SettingsAppearanceView({super.key});

  @override
  Widget build(context) {
    // if (GetPlatform.isDesktop) {
    //   return buildBody(context);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(t.appearance),
        centerTitle: true,
      ),
      body: buildMobile(context),
    );
  }

  Widget buildMobile(
    BuildContext context,
  ) {
    return Scaffold(
      body: ListView(
        children: [
          Obx(() {
            return ListTile(
              title: Text(t.appearance_mode),
              subtitle: Text(theme.mode.value.label),
              onTap: controller.changeMode,
            );
          }),
          // Obx(() {
          //   return SwitchListTile(
          //     value: theme.colours.value,
          //     title: Text(t.appearance_colours),
          //     subtitle: Text(t.appearance_colours_subtitle),
          //     onChanged: (next) => theme.colours.value = next,
          //   );
          // }),
          Obx(() {
            var activeColor = theme.color.value;
            return Column(
              children: [
                ListTile(
                  title: Text(t.appearance_color),
                  subtitle: Text(activeColor.toHexTriplet()),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(right: 16),
                    itemCount: colors.length,
                    itemBuilder: (ctx, i) {
                      var color = colors[i];
                      var active = activeColor.compareTo(color);
                      return Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: buildColorItem(
                          context,
                          color: color,
                          active: active,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildColorItem(
    BuildContext context, {
    required Color color,
    required bool active,
  }) {
    var colorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: context.theme.brightness,
      contrastLevel: theme.contrast.value,
    );

    return AspectRatio(
      aspectRatio: GetPlatform.isDesktop ? 4 / 3 : 4 / 5,
      child: InkWell(
        onTap: () => theme.color.value = color,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            border: Border.all(
              width: 2,
              color: active ? color : context.theme.colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              active
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check_circle,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
