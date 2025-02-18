class LocationInfoModel {
  String? road;
  String? neighbourhood;
  String? city;
  String? state;
  String? iso31662Lvl4;
  String? country;
  String? countryCode;
  String? county;

  LocationInfoModel({
    this.road,
    this.neighbourhood,
    this.city,
    this.state,
    this.iso31662Lvl4,
    this.country,
    this.countryCode,
    this.county,
  });

  @override
  String toString() {
    return 'LocationInfoModel(road: $road, neighbourhood: $neighbourhood,county:$county city: $city, state: $state, iso31662Lvl4: $iso31662Lvl4, country: $country, countryCode: $countryCode)';
  }

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      road: json['road'] as String?,
      neighbourhood: json['neighbourhood'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      iso31662Lvl4: json['ISO3166-2-lvl4'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      county: json['county'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'road': road,
        'neighbourhood': neighbourhood,
        'city': city,
        'state': state,
        'ISO3166-2-lvl4': iso31662Lvl4,
        'country': country,
        'country_code': countryCode,
      };
}
