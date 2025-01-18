import '/imports.dart';

Widget avatar({
  String? url,
  bool? isOnline,
  double? width,
  double? height,
  String? fallback,
}) {
  width ??= 40;
  height ??= 40;
  isOnline ??= false;
  fallback ??= '?';

  var fallbackWidget = Center(
    child: Text(
      fallback,
      style: TextStyle(
        fontSize: 16,
      ),
    ),
  );

  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainerHigh,
            border: Border.all(),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Builder(builder: (_) {
            if (url == null || url.isEmpty) {
              return fallbackWidget;
            }

            return ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(height! / 2),
              child: CachedNetworkImage(
                imageUrl: url,
                errorWidget: (_, a, b) {
                  return fallbackWidget;
                },
              ),
            );
          }),
        ),
        if (isOnline)
          Positioned(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          )
      ],
    ),
  );
}
