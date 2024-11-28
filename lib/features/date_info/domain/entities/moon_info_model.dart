class MoonInfoModel {
  String? id;
  String? datetime;
  String? phase;
  String? friendlydate;
  String? hjridate;
  String? ecllipse;

  MoonInfoModel({
    this.id,
    this.datetime,
    this.phase,
    this.friendlydate,
    this.hjridate,
    this.ecllipse,
  });

  @override
  String toString() {
    return 'MoonInfoModel(id: $id, datetime: $datetime, phase: $phase, friendlydate: $friendlydate, hjridate: $hjridate, ecllipse: $ecllipse)';
  }

  factory MoonInfoModel.fromJson(Map<String, dynamic> json) => MoonInfoModel(
        id: json['id'] as String?,
        datetime: json['datetime'] as String?,
        phase: json['phase'] as String?,
        friendlydate: json['friendlydate'] as String?,
        hjridate: json['hjridate'] as String?,
        ecllipse: json['ecllipse'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'datetime': datetime,
        'phase': phase,
        'friendlydate': friendlydate,
        'hjridate': hjridate,
        'ecllipse': ecllipse,
      };
}
