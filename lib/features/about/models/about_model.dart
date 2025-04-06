import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

class AboutModel {
  String? ar;
  String? en;

  AboutModel({this.ar, this.en});

  @override
  String toString() => 'AboutModel(ar: $ar, en: $en)';

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    pr(json, 'json inside AboutModel');
    return AboutModel(
      ar: (json['ar'] as String?),
      // ?.replaceAll('line-height: 50px;', ''),
      en: json['en'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ar': ar,
        'en': en,
      };

  AboutModel copyWith({
    String? ar,
    String? en,
  }) {
    return AboutModel(
      ar: ar ?? this.ar,
      en: en ?? this.en,
    );
  }
}
