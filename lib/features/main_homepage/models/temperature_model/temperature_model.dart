import 'clouds.dart';
import 'coord.dart';
import 'main.dart';
import 'sys.dart';
import 'weather.dart';
import 'wind.dart';

class TemperatureModel {
	Coord? coord;
	List<Weather>? weather;
	String? base;
	Main? main;
	int? visibility;
	Wind? wind;
	Clouds? clouds;
	int? dt;
	Sys? sys;
	int? timezone;
	int? id;
	String? name;
	int? cod;

	TemperatureModel({
		this.coord, 
		this.weather, 
		this.base, 
		this.main, 
		this.visibility, 
		this.wind, 
		this.clouds, 
		this.dt, 
		this.sys, 
		this.timezone, 
		this.id, 
		this.name, 
		this.cod, 
	});

	@override
	String toString() {
		return 'TemperatureModel(coord: $coord, weather: $weather, base: $base, main: $main, visibility: $visibility, wind: $wind, clouds: $clouds, dt: $dt, sys: $sys, timezone: $timezone, id: $id, name: $name, cod: $cod)';
	}

	factory TemperatureModel.fromJson(Map<String, dynamic> json) {
		return TemperatureModel(
			coord: json['coord'] == null
						? null
						: Coord.fromJson(json['coord'] as Map<String, dynamic>),
			weather: (json['weather'] as List<dynamic>?)
						?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
						.toList(),
			base: json['base'] as String?,
			main: json['main'] == null
						? null
						: Main.fromJson(json['main'] as Map<String, dynamic>),
			visibility: json['visibility'] as int?,
			wind: json['wind'] == null
						? null
						: Wind.fromJson(json['wind'] as Map<String, dynamic>),
			clouds: json['clouds'] == null
						? null
						: Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
			dt: json['dt'] as int?,
			sys: json['sys'] == null
						? null
						: Sys.fromJson(json['sys'] as Map<String, dynamic>),
			timezone: json['timezone'] as int?,
			id: json['id'] as int?,
			name: json['name'] as String?,
			cod: json['cod'] as int?,
		);
	}



	Map<String, dynamic> toJson() => {
				'coord': coord?.toJson(),
				'weather': weather?.map((e) => e.toJson()).toList(),
				'base': base,
				'main': main?.toJson(),
				'visibility': visibility,
				'wind': wind?.toJson(),
				'clouds': clouds?.toJson(),
				'dt': dt,
				'sys': sys?.toJson(),
				'timezone': timezone,
				'id': id,
				'name': name,
				'cod': cod,
			};

	TemperatureModel copyWith({
		Coord? coord,
		List<Weather>? weather,
		String? base,
		Main? main,
		int? visibility,
		Wind? wind,
		Clouds? clouds,
		int? dt,
		Sys? sys,
		int? timezone,
		int? id,
		String? name,
		int? cod,
	}) {
		return TemperatureModel(
			coord: coord ?? this.coord,
			weather: weather ?? this.weather,
			base: base ?? this.base,
			main: main ?? this.main,
			visibility: visibility ?? this.visibility,
			wind: wind ?? this.wind,
			clouds: clouds ?? this.clouds,
			dt: dt ?? this.dt,
			sys: sys ?? this.sys,
			timezone: timezone ?? this.timezone,
			id: id ?? this.id,
			name: name ?? this.name,
			cod: cod ?? this.cod,
		);
	}
}
