import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/globals/calc_method_settings.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class PrayerCalcOptions extends StatefulWidget {
  const PrayerCalcOptions({super.key});

  @override
  State<PrayerCalcOptions> createState() => _PrayerCalcOptionsState();
}

class _PrayerCalcOptionsState extends State<PrayerCalcOptions> {
  @override
  void initState() {
    selectedPrayersNotifier.addListener(_listner);
    super.initState();
  }

  @override
  void dispose() {
    selectedPrayersNotifier.removeListener(_listner);

    super.dispose();
  }

  void _listner() {
    pr(selectedPrayersNotifier.value, 'updating the selected value');
    selectedPrayersMethod = selectedPrayersNotifier.value;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        txt('CALC_METHOD'.tr(), e: St.bold20),
        const Divider(),
        ...List.generate(IslamicOrganization.values.length, (index) {
          final prayerCalc = IslamicOrganization.values[index];
          return CalcMethodWidget(
            selectedMethod: selectedPrayersNotifier.value,
            prayerCalc: prayerCalc,
            onTap: () {
              selectedPrayersMethod = prayerCalc;
              selectedPrayersNotifier.value = prayerCalc;
              setState(() {});
              Navigator.of(context).pop();
            },
          );
        }),
      ],
    );
  }
}

class CalcMethodWidget extends StatelessWidget {
  const CalcMethodWidget({super.key, required this.selectedMethod, required this.prayerCalc, required this.onTap});
  final IslamicOrganization selectedMethod;
  final IslamicOrganization prayerCalc;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: selectedMethod == prayerCalc ? context.primaryColor : null,
      borderOnForeground: true,
      child: ListTile(
        tileColor: selectedMethod == prayerCalc ? context.primaryColor : null,
        title: txt(isEnglish() ? prayerCalc.fullString : prayerCalc.arabicString,
            maxLines: 20, e: St.bold18, c: selectedMethod == prayerCalc ? Colors.white : null),
        // subtitle: txt(prayerCalc.description(),
        //     e: St.reg14,
        //     maxLines: 20,
        //     c: selectedMethod == prayerCalc ? Colors.white : null),
        onTap: onTap,
      ),
    );
  }
}
