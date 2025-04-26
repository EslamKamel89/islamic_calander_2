// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaskModel {
  final String? id;
  final String? title;
  final String? subject;
  final String? content;
  final DateTime? date;

  TaskModel({
    this.id,
    this.title,
    this.subject,
    this.content,
    this.date,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? content,
    DateTime? date,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, subject: $subject, content: $content, date: $date)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subject': subject,
      'content': content,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] != null ? json['id'] as String : null,
      title: json['title'] != null ? json['title'] as String : null,
      subject: json['subject'] != null ? json['subject'] as String : null,
      content: json['content'] != null ? json['content'] as String : null,
      date: json['date'] != null ? DateTime.fromMillisecondsSinceEpoch(json['date'] as int) : null,
    );
  }
}
