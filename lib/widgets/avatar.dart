import '/imports.dart';

Widget avatar(
  BuildContext context, {
  String? url,
  bool? isOnline,
  bool? isTyping,
  double? size,
  String? fallback,
}) {
  size ??= 40;
  isOnline ??= false;
  isTyping ??= false;
  fallback ??= '?';

  var fallbackWidget = Center(
    child: Text(
      fallback,
      style: TextStyle(
        fontSize: size * 0.5,
      ),
    ),
  );

  final dotSize = size * 0.15;
  final typingSize = size * 0.4;

  return SizedBox(
    width: size,
    height: size,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Builder(builder: (_) {
            if (url == null || url.isEmpty) {
              return fallbackWidget;
            }

            return ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(size! / 2),
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
        if (isTyping)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: context.theme.colorScheme.surfaceContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                child: Image.asset(
                  'assets/images/typing.gif',
                  width: typingSize,
                ),
              ),
            ),
          )
        else if (isOnline)
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
