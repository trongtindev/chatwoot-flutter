import '/imports.dart';

Widget avatar(
  BuildContext context, {
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

  var dotSize = width * 0.15;

  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Builder(builder: (_) {
            if (url == null || url.isEmpty) {
              return fallbackWidget;
            }

            return ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(height! / 2),
              child: url.startsWith('http')
                  ? ExtendedImage.network(
                      url,
                      loadStateChanged: (state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.failed:
                            return fallbackWidget;
                          default:
                            return null;
                        }
                      },
                    )
                  : Image.asset(url),
            );
          }),
        ),
        if (isOnline)
          Positioned(
            right: dotSize * 0.3,
            bottom: dotSize * 0.3,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(dotSize / 2),
                  ),
                ),
              ),
            ),
          )
      ],
    ),
  );
}
