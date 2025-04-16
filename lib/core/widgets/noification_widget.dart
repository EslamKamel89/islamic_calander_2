import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar<dynamic> customNotification({
  required String title,
  required String content,
  required void Function()? onTap,
}) {
  return Flushbar(
    titleColor: Colors.white,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.red,
    boxShadows: [
      BoxShadow(
          color: Colors.blue[800]!,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0)
    ],
    backgroundGradient:
        const LinearGradient(colors: [Colors.blueGrey, Colors.black]),
    isDismissible: false,
    duration: const Duration(seconds: 4),
    icon: const Icon(
      Icons.check,
      color: Colors.white,
    ),
    mainButton: ElevatedButton(
      onPressed: onTap,
      child: const Text(
        "Go",
        style: TextStyle(color: Colors.amber),
      ),
    ),
    showProgressIndicator: true,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    titleText: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.yellow[600],
          fontFamily: "ShadowsIntoLightTwo"),
    ),
    messageText: Text(
      content,
      style: const TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
  );
}
