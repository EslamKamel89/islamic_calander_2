class Coord {
	double? lon;
	double? lat;

	Coord({this.lon, this.lat});

	@override
	String toString() => 'Coord(lon: $lon, lat: $lat)';

	factory Coord.fromJson(Map<String, dynamic> json) => Coord(
				lon: (json['lon'] as num?)?.toDouble(),
				lat: (json['lat'] as num?)?.toDouble(),
			);

	Map<String, dynamic> toJson() => {
				'lon': lon,
				'lat': lat,
			};

	Coord copyWith({
		double? lon,
		double? lat,
	}) {
		return Coord(
			lon: lon ?? this.lon,
			lat: lat ?? this.lat,
		);
	}
}
