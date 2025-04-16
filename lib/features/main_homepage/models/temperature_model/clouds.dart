class Clouds {
	int? all;

	Clouds({this.all});

	@override
	String toString() => 'Clouds(all: $all)';

	factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
				all: json['all'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'all': all,
			};

	Clouds copyWith({
		int? all,
	}) {
		return Clouds(
			all: all ?? this.all,
		);
	}
}
