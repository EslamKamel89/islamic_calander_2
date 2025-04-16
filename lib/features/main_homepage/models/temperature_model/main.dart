class Main {
	double? temp;
	double? feelsLike;
	double? tempMin;
	double? tempMax;
	int? pressure;
	int? humidity;
	int? seaLevel;
	int? grndLevel;

	Main({
		this.temp, 
		this.feelsLike, 
		this.tempMin, 
		this.tempMax, 
		this.pressure, 
		this.humidity, 
		this.seaLevel, 
		this.grndLevel, 
	});

	@override
	String toString() {
		return 'Main(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity, seaLevel: $seaLevel, grndLevel: $grndLevel)';
	}

	factory Main.fromJson(Map<String, dynamic> json) => Main(
				temp: (json['temp'] as num?)?.toDouble(),
				feelsLike: (json['feels_like'] as num?)?.toDouble(),
				tempMin: (json['temp_min'] as num?)?.toDouble(),
				tempMax: (json['temp_max'] as num?)?.toDouble(),
				pressure: json['pressure'] as int?,
				humidity: json['humidity'] as int?,
				seaLevel: json['sea_level'] as int?,
				grndLevel: json['grnd_level'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'temp': temp,
				'feels_like': feelsLike,
				'temp_min': tempMin,
				'temp_max': tempMax,
				'pressure': pressure,
				'humidity': humidity,
				'sea_level': seaLevel,
				'grnd_level': grndLevel,
			};

	Main copyWith({
		double? temp,
		double? feelsLike,
		double? tempMin,
		double? tempMax,
		int? pressure,
		int? humidity,
		int? seaLevel,
		int? grndLevel,
	}) {
		return Main(
			temp: temp ?? this.temp,
			feelsLike: feelsLike ?? this.feelsLike,
			tempMin: tempMin ?? this.tempMin,
			tempMax: tempMax ?? this.tempMax,
			pressure: pressure ?? this.pressure,
			humidity: humidity ?? this.humidity,
			seaLevel: seaLevel ?? this.seaLevel,
			grndLevel: grndLevel ?? this.grndLevel,
		);
	}
}
