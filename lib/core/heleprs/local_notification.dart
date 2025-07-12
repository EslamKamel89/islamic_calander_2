import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/heleprs/format_date.dart';
import 'package:islamic_calander_2/core/heleprs/get_local_timezone.dart';
import 'package:islamic_calander_2/core/heleprs/lock_screen_widget.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';
import 'package:islamic_calander_2/features/main_homepage/models/wisdom_model.dart';
import 'package:islamic_calander_2/features/tasks/cubits/tasks/tasks_cubit.dart';
import 'package:islamic_calander_2/features/tasks/models/task_model.dart';
import 'package:timezone/timezone.dart' as tz;

final NotificationService notificationService = NotificationService();

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final PrayersController prayersController = serviceLocator<PrayersController>();
  List<PrayersTimeModel> prayers = [];
  List<WisdomModel> wisdoms = [];

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
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> _requestIOSPermissions() async {
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  PrayerTimeParams? prayerParams;
  Future<void> addNotifications({PrayerTimeParams? params}) async {
    if (params != null) prayerParams = params;
    params ??= prayerParams;
    await _cancelAllNotificatons();
    final locationName = await getLocalTimezone();
    final location = tz.getLocation(locationName);
    // prayers
    await _fetchPrayers(params!);
    for (var day in prayers) {
      await _scheduleSingleDayNotifications(day, location);
    }
    // trigger lock screen widget update
    LockScreenService.sendPrayerJson({'prayers': prayers.map((prayer) => prayer.toJson()).toList()});
    // wisdoms
    await _fetchWisdoms();
    for (var i = 0; i < wisdoms.length; i++) {
      var wisdom = wisdoms[i];
      await _scheduleWisdomNotification(wisdom, DateTime.now().add(Duration(days: i)), location);
    }
    await _addTasksNotifications(location);
  }

  Future _addTasksNotifications(tz.Location location) async {
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;
    List<TaskModel> tasks = context.read<TasksCubit>().state.tasks ?? [];
    pr(tasks, '$t - tasks');
    tasks.sort((a, b) => b.date!.compareTo(a.date!));
    if (tasks.length > 5) {
      tasks = tasks.sublist(0, 4);
    }
    for (var i = 0; i < tasks.length; i++) {
      await _scheduleTaskNotification(tasks[i], location);
    }
  }

  Future _fetchPrayers(PrayerTimeParams params) async {
    for (var i = 0; i < 5; i++) {
      var res = await prayersController.prayerTime(params.copyWith(date: params.date?.add(Duration(days: i))));
      if (res.data != null) {
        // pr(res.data, 'data recieved from the from api');
        prayers.add(res.data!);
      }
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

  Future<void> _schedulePrayerNotification(String prayerName, String timeStr, String dateStr, tz.Location loc) async {
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
      'It\'s time for $prayerName. today: $dateStr, time: $timeStr',
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
    pr(DateTime.now(), '$t - DateTime.now');
    for (var i = 0; i < pendingNotifications.length; i++) {
      var notif = pendingNotifications[i];
      pr('number: ${i + 1}, id: ${notif.id}, title: ${notif.title} , body: ${notif.body}, payload: ${notif.payload}',
          '$t - prayers');
    }
  }

  Future<void> _scheduleTaskNotification(TaskModel task, tz.Location loc) async {
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(task.date ?? DateTime.now(), loc);
    if (scheduledTime.millisecondsSinceEpoch < tz.TZDateTime.now(loc).millisecondsSinceEpoch) {
      return;
    }

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
    final int notificationId = "task_${task.date?.millisecondsSinceEpoch}".hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      task.title,
      task.content,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exact,
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _scheduleWisdomNotification(WisdomModel wisdom, DateTime date, tz.Location loc) async {
    date = date.copyWith(hour: 7, minute: 0);
    tz.TZDateTime scheduledTime = tz.TZDateTime.from(date, loc);
    if (scheduledTime.millisecondsSinceEpoch < tz.TZDateTime.now(loc).millisecondsSinceEpoch) {
      return;
    }

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
    final int notificationId = "wisdom_${date.millisecondsSinceEpoch}".hashCode;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'حكمة اليوم',
      wisdom.wisdomAr,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exact,
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future _fetchWisdoms() async {
    for (var i = 0; i < 5; i++) {
      final res = await _fetchWisdom(DateTime.now().add(Duration(days: i)));
      if (res.data != null) {
        wisdoms.add(res.data!);
      }
    }
  }

  Future<ApiResponseModel<WisdomModel>> _fetchWisdom(DateTime date) async {
    final ApiConsumer api = serviceLocator<ApiConsumer>();
    date = date;
    try {
      final response = await api.get(EndPoint.wisdomEndPoint, queryParameter: {
        'date': formatDateForApi(date),
      });
      return pr(
          ApiResponseModel(
            response: ResponseEnum.success,
            data: WisdomModel.fromJson((jsonDecode(response) as List)[0]),
          ),
          t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      }
      pr(errorMessage, '$t - Error Message');
      return ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failure);
    }
  }
}

const t = 'Prayer notification';
