// ignore_for_file: public_member_api_docs, sort_constructors_first
class SelectedDateConversionEntity {
  DateTime? selectedGeorgianDate;
  String? selectedOldHijriDate;
  String? selectedNewHijriDate;
  SelectedDateConversionEntity({
    this.selectedGeorgianDate,
    this.selectedOldHijriDate,
    this.selectedNewHijriDate,
  });

  @override
  String toString() =>
      'SelectedDateConversionEntity(selectedGeorgianDate: $selectedGeorgianDate, selectedOldHijriDate: $selectedOldHijriDate, selectedNewHijriDate: $selectedNewHijriDate)';

  SelectedDateConversionEntity copyWith({
    DateTime? selectedGeorgianDate,
    String? selectedOldHijriDate,
    String? selectedNewHijriDate,
  }) {
    return SelectedDateConversionEntity(
      selectedGeorgianDate: selectedGeorgianDate ?? this.selectedGeorgianDate,
      selectedOldHijriDate: selectedOldHijriDate ?? this.selectedOldHijriDate,
      selectedNewHijriDate: selectedNewHijriDate ?? this.selectedNewHijriDate,
    );
  }
}
