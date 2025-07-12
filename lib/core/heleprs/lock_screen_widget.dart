import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

class LockScreenService {
  static const _channel = MethodChannel('lockscreen_channel');

  static Future<void> sendPrayerJson(Map<String, dynamic> jsonData) async {
    final jsonString = json.encode(jsonData);
    try {
      await _channel.invokeMethod('updatePrayerData', {'json': jsonString});
    } on PlatformException catch (e) {
      pr('Error sending JSON to iOS: ${e.message}', 'LookScreenService - sendPrayerJson');
    }
  }
}
