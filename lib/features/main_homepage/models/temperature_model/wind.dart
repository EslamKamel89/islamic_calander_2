class Wind {
	double? speed;
	int? deg;

	Wind({this.speed, this.deg});

	@override
	String toString() => 'Wind(speed: $speed, deg: $deg)';

	factory Wind.fromJson(Map<String, dynamic> json) => Wind(
				speed: (json['speed'] as num?)?.toDouble(),
				deg: json['deg'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'speed': speed,
				'deg': deg,
			};

	Wind copyWith({
		double? speed,
		int? deg,
	}) {
		return Wind(
			speed: speed ?? this.speed,
			deg: deg ?? this.deg,
		);
	}
}
