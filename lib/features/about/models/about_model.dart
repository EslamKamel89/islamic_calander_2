class AboutModel {
  String? content;

  AboutModel({this.content});

  @override
  String toString() => 'AboutModel(content: $content)';

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
        content: json['content'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'content': content,
      };

  AboutModel copyWith({
    String? content,
  }) {
    return AboutModel(
      content: content ?? this.content,
    );
  }
}
