class Sys {
	int? type;
	int? id;
	String? country;
	int? sunrise;
	int? sunset;

	Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

	@override
	String toString() {
		return 'Sys(type: $type, id: $id, country: $country, sunrise: $sunrise, sunset: $sunset)';
	}

	factory Sys.fromJson(Map<String, dynamic> json) => Sys(
				type: json['type'] as int?,
				id: json['id'] as int?,
				country: json['country'] as String?,
				sunrise: json['sunrise'] as int?,
				sunset: json['sunset'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'type': type,
				'id': id,
				'country': country,
				'sunrise': sunrise,
				'sunset': sunset,
			};

	Sys copyWith({
		int? type,
		int? id,
		String? country,
		int? sunrise,
		int? sunset,
	}) {
		return Sys(
			type: type ?? this.type,
			id: id ?? this.id,
			country: country ?? this.country,
			sunrise: sunrise ?? this.sunrise,
			sunset: sunset ?? this.sunset,
		);
	}
}
