import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/widgets/noification_widget.dart';

abstract class FirebaseHelper {
  static Future handleFirebaseNotification() async {
    final t = prt('handleFirebaseNotification - FirebaseHelper');
    try {
      await FirebaseHelper._requestFirebaseNotificationsPermission();
      //! Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        pr('FirebaseMessaging.onMessage.listen: Message received in foreground: ${message.notification?.title}',
            t);
        BuildContext? context = navigatorKey.currentContext;
        if (context == null) return;
        customNotification(
            title: message.notification?.title ?? 'Notification',
            content: message.notification?.body ?? '',
            onTap: () {
              pr(message.data, '$t the payload in the notificaion');
              _handleNotificationNavigatin(context, message.data);
            }).show(context);
      });

      //! background and terminated notification listener
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      BuildContext? context = navigatorKey.currentContext;
      if (context == null) return;
      if (initialMessage != null) {
        _handleNotificationNavigatin(context, initialMessage.data);
      }
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
        BuildContext? context = navigatorKey.currentContext;
        if (context == null) return;
        _handleNotificationNavigatin(context, remoteMessage.data);
      });
    } catch (e) {
      pr('Exeception occured: $e', t);
    }
  }

  static Future<void> _requestFirebaseNotificationsPermission() async {
    final t = prt('requestFirebaseNotificationsPermission - FirebaseHelper');
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      // provisional: false ,
      // announcement: false,
      // carPlay: false ,
      // criticalAlert: false ,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      pr('User granted permission', t);
    } else {
      pr('User declined or has not accepted permission', t);
      showSnackbar('Warning', "You didn't give the app notification permission", true);
    }
  }

  static void _handleNotificationNavigatin(BuildContext context, Map<String, dynamic> data) {
    final t = prt('_handleNotificationNavigatin - FirebaseHelper');
    String? routeName = data['routeName'] as String?;
    pr(routeName, '$t - routeName');
    if (routeName == null) return;
    // if (routeName == AppRoutesNames.doctorJobDetailsScreen) {
    //   final payload = JobAddNotificationPayload.fromJsonRaw(data['payload']);
    //   Navigator.of(context).pushNamed(routeName, arguments: payload.toJson());
    //   return;
    // }
  }

  static Future<String?> fcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    pr(token, 'fcmToken');
    return token;
  }
}
