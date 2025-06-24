import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

final NotificationService notificationService = NotificationService();

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        // AndroidInitializationSettings('app_icon');
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // final List<DarwinNotificationCategory> darwinNotificationCategories =
    //     <DarwinNotificationCategory>[
    //   DarwinNotificationCategory(
    //     darwinNotificationCategoryText,
    //     actions: <DarwinNotificationAction>[
    //       DarwinNotificationAction.text(
    //         'text_1',
    //         'Action 1',
    //         buttonTitle: 'Send',
    //         placeholder: 'Placeholder',
    //       ),
    //     ],
    //   ),
    //   DarwinNotificationCategory(
    //     darwinNotificationCategoryPlain,
    //     actions: <DarwinNotificationAction>[
    //       DarwinNotificationAction.plain('id_1', 'Action 1'),
    //       DarwinNotificationAction.plain(
    //         'id_2',
    //         'Action 2 (destructive)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.destructive,
    //         },
    //       ),
    //       DarwinNotificationAction.plain(
    //         navigationActionId,
    //         'Action 3 (foreground)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.foreground,
    //         },
    //       ),
    //       DarwinNotificationAction.plain(
    //         'id_4',
    //         'Action 4 (auth required)',
    //         options: <DarwinNotificationActionOption>{
    //           DarwinNotificationActionOption.authenticationRequired,
    //         },
    //       ),
    //     ],
    //     options: <DarwinNotificationCategoryOption>{
    //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    //     },
    //   )
    // ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // notificationCategories: darwinNotificationCategories,
    );

    // final LinuxInitializationSettings initializationSettingsLinux =
    //     LinuxInitializationSettings(
    //   defaultActionName: 'Open notification',
    //   defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    // );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      // macOS: initializationSettingsDarwin,
      // linux: initializationSettingsLinux,
      // windows: windows.initSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse: selectNotificationStream.add,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
    //         Platform.isLinux
    //     ? null
    //     : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // String initialRoute = HomePage.routeName;
    // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    //   selectedNotificationPayload =
    //       notificationAppLaunchDetails!.notificationResponse?.payload;
    //   initialRoute = SecondPage.routeName;
    // }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      pr('Tapped notification with payload: ${response.payload}');
      // You can navigate to a specific page or do something
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    } else if (Platform.isIOS) {
      await _requestIOSPermissions();
    }
  }

  Future<void> _requestAndroidPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  /// Basic permission request for iOS
  Future<void> _requestIOSPermissions() async {
    final IOSFlutterLocalNotificationsPlugin? iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showBasicNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'This is a basic notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID of the notification
      'Hello!', // Title
      'This is a basic notification', // Body
      details,
      payload: 'basic_notification', // Optional data
    );
  }
}
