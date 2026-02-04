import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

class AboutModel {
  String? ar;
  String? en;
  String? mode;

  AboutModel({this.ar, this.en, this.mode});

  @override
  String toString() => 'AboutModel(mode: $mode, ar: $ar, en: $en)';

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    pr(json, 'json inside AboutModel');
    return AboutModel(
      ar: (json['ar'] as String?),
      // ?.replaceAll('line-height: 50px;', ''),
      en: json['en'] as String?,
      mode: json['mode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'ar': ar,
        'en': en,
        'model': mode,
      };

  AboutModel copyWith({
    String? ar,
    String? en,
    String? mode,
  }) {
    return AboutModel(
      ar: ar ?? this.ar,
      en: en ?? this.en,
      mode: mode ?? this.mode,
    );
  }
}
