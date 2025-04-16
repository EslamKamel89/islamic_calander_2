class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  @override
  String toString() {
    return 'Weather(id: $id, main: $main, description: $description, icon: $icon)';
  }

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json['id'] as int?,
        main: json['main'] as String?,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };

  Weather copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) {
    return Weather(
      id: id ?? this.id,
      main: main ?? this.main,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  WeatherEnum classifyWeather() {
    if (id == null) return WeatherEnum.unknown;
    if (id! >= 200 && id! <= 232) return WeatherEnum.stormy; //
    // if (id! >= 300 && id! <= 321) return WeatherEnum.rainy;
    // if (id! >= 500 && id! <= 531) return WeatherEnum.rainy;
    if (id! >= 300 && id! <= 599) return WeatherEnum.rainy; //
    if (id! >= 600 && id! <= 622) return WeatherEnum.snowy; //
    if (id! >= 701 && id! <= 781) return WeatherEnum.foggy; //
    if (id! == 800) return WeatherEnum.sunny; //
    if (id! >= 801 && id! <= 804) return WeatherEnum.cloudy;
    return WeatherEnum.unknown;
  }
}

enum WeatherEnum {
  unknown('Unknown'),
  stormy('Stormy'),
  rainy('Rainy'),
  snowy('Snowy'),
  foggy('Foggy'),
  sunny('Sunny'),
  cloudy('Cloudy');

  final String displayName;
  const WeatherEnum(this.displayName);
}
