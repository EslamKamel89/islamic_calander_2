import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';

class TimeRemainingWidget extends StatefulWidget {
  final DateTime target;

  const TimeRemainingWidget({super.key, required this.target});

  @override
  State<TimeRemainingWidget> createState() => _TimeRemainingWidgetState();
}

class _TimeRemainingWidgetState extends State<TimeRemainingWidget> {
  late Timer _timer;
  late DateTime _target;
  Duration _remaining = Duration.zero;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _target = widget.target;
    bool triggerTimer = _updateRemaining();
    // Update every minute
    if (triggerTimer) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateRemaining());
    }
  }

  bool _updateRemaining() {
    final now = DateTime.now();
    final diff = _target.difference(now);

    if (diff <= Duration.zero) {
      _remaining = Duration.zero;
      _color = Colors.redAccent;
      return false;
      // if (_timer.isActive) {
      // _timer.cancel(); // Stop updates
      // }
    } else {
      _remaining = diff;
      _setColorBasedOnRemainingTime(diff);
    }

    if (mounted) setState(() {});
    return true;
  }

  void _setColorBasedOnRemainingTime(Duration duration) {
    if (duration.inHours < 1) {
      _color = Colors.redAccent; // Less than an hour
    } else if (duration.inHours < 6) {
      _color = Colors.orangeAccent; // Less than 6 hours
    } else if (duration.inDays < 1) {
      _color = Colors.amber; // Less than a day
    } else {
      _color = Colors.green; // More than a day
    }
  }

  String _getLocalizedDuration(Duration duration) {
    final locale = context.locale.languageCode;

    if (duration.inSeconds <= 0) {
      return 'time_remaining.passed'.tr();
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    String result = '';
    if (locale == 'ar') {
      if (days > 0) {
        result = '$days ${days > 1 ? "ايامً" : "يوم"}';
      } else if (hours > 0) {
        result = '$hours ${hours > 1 ? "ًساعات" : "ساعة"}';
      } else if (minutes > 0) {
        result = '$minutes ${minutes > 1 ? "ًدقائق" : "دقيقة"}';
      } else {
        result = 'أقل من دقيقة';
      }
      result = '$result متبقية';
    } else {
      // English
      if (days > 0) {
        result = '$days ${days == 1 ? 'day' : 'days'}';
      } else if (hours > 0) {
        result = '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else if (minutes > 0) {
        result = '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
      } else {
        result = 'less than a minute';
      }
      result = '$result remaining ';
    }
    return result;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _remaining.inMilliseconds <= 0
        ? DateFormat('MMM dd, yyyy', isEnglish() ? 'en' : 'ar').format(widget.target)
        : _getLocalizedDuration(_remaining);

    return Text(
      text,
      style: TextStyle(
        color: _color,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
