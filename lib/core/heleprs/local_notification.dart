import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_calander_2/core/heleprs/get_local_timezone.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';
import 'package:timezone/timezone.dart' as tz;

final NotificationService notificationService = NotificationService();

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final PrayersController prayersController = serviceLocator<PrayersController>();
  List<PrayersTimeModel> prayers = [];

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

  Future<void> addPrayersNotifications(PrayerTimeParams params) async {
    await _cancelAllNotificatons();
    for (var i = 0; i < 5; i++) {
      var res = await prayersController
          .prayerTime(params.copyWith(date: params.date?.add(Duration(days: i))));
      if (res.data != null) {
        prayers.add(res.data!);
      }
    }
    final locationName = await getLocalTimezone();

    final location = tz.getLocation(locationName);
    for (var day in prayers) {
      await _scheduleSingleDayNotifications(day, location);
    }
  }

  tz.TZDateTime _parseToTZDateTime(String dateStr, String timeStr, tz.Location location) {
    final List<int> dateParts = dateStr.split('-').map(int.parse).toList();
    final year = dateParts[2];
    final month = dateParts[1];
    final day = dateParts[0];

    final List<int> timeParts = timeStr.split(':').map(int.parse).toList();
    final hour = timeParts[0];
    final minute = timeParts[1];

    return tz.TZDateTime(location, year, month, day, hour, minute);
  }

  Future<void> _scheduleSingleDayNotifications(PrayersTimeModel day, tz.Location location) async {
    final String baseDateStr = day.date!; // e.g., "25-06-2025"

    await _schedulePrayerNotification("Fajr", day.fajr!, baseDateStr, location);
    await _schedulePrayerNotification("Sunrise", day.sunrise!, baseDateStr, location);
    await _schedulePrayerNotification("Dhuhr", day.dhuhr!, baseDateStr, location);
    await _schedulePrayerNotification("Asr", day.asr!, baseDateStr, location);
    await _schedulePrayerNotification("Maghrib", day.maghrib!, baseDateStr, location);
    await _schedulePrayerNotification("Isha", day.isha!, baseDateStr, location);
  }

  Future<void> _schedulePrayerNotification(
      String prayerName, String timeStr, String dateStr, tz.Location loc) async {
    tz.TZDateTime scheduledTime = _parseToTZDateTime(dateStr, timeStr, loc);
    if (scheduledTime.millisecondsSinceEpoch < tz.TZDateTime.now(loc).millisecondsSinceEpoch) {
      return;
    }

    // pr(scheduledTime.toIso8601String(), '$t - tz.TZDateTime scheduledTime');
    // pr(tz.TZDateTime.now(location).toIso8601String(), '$t - DateTime.now()');

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_reminder_channel',
      'Prayer Reminder',
      channelDescription: 'Reminds you about prayer times',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use unique ID per notification to avoid conflicts
    final int notificationId = "$dateStr-$prayerName".hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '$prayerName Time',
      'It\'s time for $prayerName. date: $dateStr , time: $timeStr',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exact,
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future _cancelAllNotificatons() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future showAllPendingNotifications() async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    pr(pendingNotifications.length, '$t - pending notifications number');
    for (var notif in pendingNotifications) {
      pr('id: ${notif.id}, title: ${notif.title} , body: ${notif.body}, payload: ${notif.payload}',
          '$t - prayers');
    }
  }
}

const t = 'Prayer notification';



  // Future<void> showBasicNotification() async {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'channel_id',
  //     'channel_name',
  //     channelDescription: 'This is a basic notification channel',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

  //   const NotificationDetails details = NotificationDetails(
  //     android: androidDetails,
  //     iOS: iosDetails,
  //   );

  //   await flutterLocalNotificationsPlugin.show(
  //     0, // ID of the notification
  //     'Hello!', // Title
  //     'This is a basic notification', // Body
  //     details,
  //     payload: 'basic_notification', // Optional data
  //   );
  // }

  // Future<void> scheduleNotification() async {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   final tz.TZDateTime scheduledTime = now.add(const Duration(seconds: 10));

  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'prayer_reminder_channel',
  //     'Prayers Reminder',
  //     channelDescription: 'Reminds you about prayer times',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   const NotificationDetails details = NotificationDetails(
  //     android: androidDetails,
  //     iOS: iosDetails,
  //   );

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     1,
  //     'Scheduled Notification',
  //     'This will appear in 10 seconds',
  //     scheduledTime,
  //     details,
  //     androidScheduleMode: AndroidScheduleMode.exact,
  //     // androidAllowWhileIdle: true,
  //     // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  // Future<void> schedulePrayerNotification(String prayerName, tz.TZDateTime time) async {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'prayer_reminder_channel',
  //     'Prayer Reminder',
  //     channelDescription: 'Reminds you about prayer times',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );

  //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );

  //   const NotificationDetails details = NotificationDetails(
  //     android: androidDetails,
  //     iOS: iosDetails,
  //   );

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     1,
  //     '$prayerName Time',
  //     'It\'s time for $prayerName.',
  //     time,
  //     details,
  //     androidScheduleMode: AndroidScheduleMode.exact,
  //     // : true,
  //     // uiLocalNotificationDateInterpretation:
  //     //     UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
