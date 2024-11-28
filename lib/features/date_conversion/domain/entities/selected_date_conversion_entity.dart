// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

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

  String? newHijriDateProccessed() {
    final t = prt('newHijriDateProccessed  - SelectedDateConversionEntity');
    try {
      if (selectedOldHijriDate == null || selectedNewHijriDate == null) {
        return selectedNewHijriDate;
      }
      String oldDay = selectedOldHijriDate!.split(' ')[1].trim();
      String newDay = selectedNewHijriDate!.split(',')[1].trim();
      String resultNewHijri = selectedNewHijriDate!.replaceFirst(',$newDay,', ',$oldDay,');
      // pr(oldDay, '$t - oldDay');
      // pr(newDay, '$t - newDay');
      pr(resultNewHijri, '$t - resultNewHijri');
      return resultNewHijri;
    } catch (e) {
      pr('Exeption in parsing: $e', t);
      return selectedNewHijriDate;
    }
  }
}
