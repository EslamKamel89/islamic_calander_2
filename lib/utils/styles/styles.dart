import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum St {
  reg14,
  semi14,
  bold14,
  reg16,
  semi16,
  bold16,
  reg18,
  semi18,
  bold18,
  reg20,
  semi20,
  bold20,
  reg25,
  semi25,
  bold25,
  reg30,
  semi30,
  bold30,
}

/// e =>  enum         => St
///
/// s =>  fontSize     => double?
///
/// w =>  fontWeight   => FontWeight?
///
/// f =>  fontFamily   => String?
///
/// c =>  color        => Color?
///
///googleFontCallback => TextSylte Function()?
///
/// maxLines => int?
///
/// Default fontSize = 16.sp
///
/// Default fontWeight = FontWeight.normal
Text txt(
  String text, {
  St? e,
  double? s,
  FontWeight? w,
  String? f,
  Color? c,
  int? maxLines,
  TextStyle Function()? googleFontCallback,
  TextAlign? textAlign,
}) {
  s = s ?? 16.sp;
  w = FontWeight.normal;
  if (e != null) {
    switch (e) {
      case St.semi14:
        s = 14.sp;
        w = FontWeight.w600;
        break;
      case St.reg14:
        s = 14.sp;
        w = FontWeight.normal;
        break;
      case St.bold14:
        s = 14.sp;
        w = FontWeight.w900;
        break;
      case St.semi16:
        s = 16.sp;
        w = FontWeight.w600;
        break;
      case St.reg16:
        s = 16.sp;
        w = FontWeight.normal;
        break;
      case St.bold16:
        s = 16.sp;
        w = FontWeight.bold;
        break;
      case St.semi18:
        s = 18.sp;
        w = FontWeight.w600;
        break;
      case St.reg18:
        s = 18.sp;
        w = FontWeight.normal;
        break;
      case St.bold18:
        s = 18.sp;
        w = FontWeight.bold;
        break;
      case St.semi20:
        s = 20.sp;
        w = FontWeight.w600;
        break;
      case St.reg20:
        s = 20.sp;
        w = FontWeight.normal;
        break;
      case St.bold20:
        s = 20.sp;
        w = FontWeight.bold;
        break;
      case St.semi25:
        s = 25.sp;
        w = FontWeight.w600;
        break;
      case St.reg25:
        s = 25.sp;
        w = FontWeight.normal;
        break;
      case St.bold25:
        s = 25.sp;
        w = FontWeight.bold;
        break;
      case St.semi30:
        s = 30.sp;
        w = FontWeight.w600;
        break;
      case St.reg30:
        s = 30.sp;
        w = FontWeight.normal;
        break;
      case St.bold30:
        s = 30.sp;
        w = FontWeight.bold;
        break;
    }
  }
  if (googleFontCallback != null) {
    return Text(
      text,
      style: googleFontCallback()
          .copyWith(fontSize: s.sp, fontWeight: w, color: c),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
  return Text(
    text,
    style: TextStyle(fontSize: s.sp, fontWeight: w, fontFamily: f, color: c),
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: textAlign,
  );
}
