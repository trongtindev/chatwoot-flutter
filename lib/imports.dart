import 'package:shared_preferences/shared_preferences.dart';
export 'package:refreshed/refreshed.dart'
    show
        Get,
        GetxController,
        GetxService,
        GetPlatform,
        Obx,
        GetBuilder,
        GetView,
        ObxWidget,
        GetWidget,
        Binding,
        Bind;
export 'package:refreshed/get_state_manager/src/rx_flutter/rx_ticker_provider_mixin.dart';
export 'package:refreshed/get_instance/get_instance.dart';
export 'package:refreshed/route_manager.dart' hide Translations;
export 'package:refreshed/get_utils/get_utils.dart';
export 'package:refreshed/get_rx/get_rx.dart';
export 'package:flutter/material.dart' hide Page, Table, TableRow, ThemeMode;
export 'package:flutter/services.dart' show rootBundle;
export 'package:events_emitter/events_emitter.dart';
export 'package:result_dart/result_dart.dart';
export 'package:flutter/foundation.dart';
export 'package:window_manager/window_manager.dart';
export 'package:url_launcher/url_launcher_string.dart';
export 'package:extended_image/extended_image.dart'
    show ExtendedImage, LoadState, ExtendedImageMode;
export 'package:dio/dio.dart';
export 'package:dio_http2_adapter/dio_http2_adapter.dart';
export 'package:logger/logger.dart' show Level;
export 'package:path_provider/path_provider.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:permission_handler/permission_handler.dart' show Permission;
export 'package:file_picker/file_picker.dart' show PlatformFile;
export 'package:flutter_inappwebview/flutter_inappwebview.dart'
    show CookieManager, WebUri, HTTPCookieSameSitePolicy;
export 'package:url_launcher/url_launcher.dart';

export 'dart:io' show File, Platform;
export 'dart:async';
export 'dart:convert';
export 'dart:math';

export 'config/dotenv.dart';
export 'config/constants.dart';
export 'config/theme.dart';

export 'extensions/color.dart';

export 'layouts/default/default.dart';

export 'models/account.dart';
export 'models/api.dart';
export 'models/assistant.dart';
export 'models/attribute.dart';
export 'models/cache.dart';
export 'models/canned_response.dart';
export 'models/contact.dart';
export 'models/conversation.dart';
export 'models/file.dart';
export 'models/inbox.dart';
export 'models/label.dart';
export 'models/macro.dart';
export 'models/message.dart';
export 'models/notification.dart';
export 'models/profile.dart';
export 'models/realtime.dart';
export 'models/team.dart';
export 'models/user.dart';

export 'services/analytics.dart';
export 'services/api.dart';
export 'services/assistant.dart';
export 'services/auth.dart';
export 'services/db.dart';
export 'services/deeplink.dart';
export 'services/notification.dart';
export 'services/realtime.dart';
export 'services/settings.dart';
export 'services/theme.dart';
export 'services/updater.dart';

export 'utils/bytes.dart';
export 'utils/common.dart';
export 'utils/duration.dart';
export 'utils/file.dart';
export 'utils/internationalization.dart';
export 'utils/logger.dart';
export 'utils/navigation.dart';
export 'utils/permision.dart';
export 'utils/persistent_rx.dart';
export 'utils/random.dart';
export 'utils/regex.dart';
export 'utils/theme.dart';
export 'utils/time.dart';

export 'widgets/audio.dart';
export 'widgets/avatar.dart';
export 'widgets/bottom_sheet.dart';
export 'widgets/button.dart';
export 'widgets/common.dart';
export 'widgets/image.dart';
export 'widgets/video.dart';

export 'screens/custom_attributes/controllers/index.dart';
export 'screens/labels/controllers/index.dart';
export 'screens/inboxes/controllers/index.dart';
export 'screens/macros/controllers/index.dart';
export 'screens/canned_responses/controllers/index.dart';
export 'screens/teams/controllers/index.dart';
export 'screens/agents/controllers/index.dart';

late SharedPreferences prefs;
