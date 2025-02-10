import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:islamic_calander_2/core/enums/prayer_calc_method.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class SettingsDropdown extends StatefulWidget {
  const SettingsDropdown({super.key});
  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  PrayerCalcMethod selectedMethod = PrayerCalcMethod.muslimWorldLeague;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings,
        size: 36,
        // color: Theme.of(context).colorScheme.primary,
        color: Colors.white,
      ).animate(onPlay: (controller) => controller.repeat()).rotate(duration: 10000.ms, begin: 0, end: 2),
      onPressed: () {
        _showModernDropdown(context);
      },
      tooltip: 'Open Settings',
    );
  }

  void _showModernDropdown(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const CalcOptionsWidget());
  }
}

PrayerCalcMethod selectedPrayersMethod = PrayerCalcMethod.muslimWorldLeague;
ValueNotifier<PrayerCalcMethod> selectedPrayersNotifier =
    ValueNotifier<PrayerCalcMethod>(PrayerCalcMethod.muslimWorldLeague);

class CalcOptionsWidget extends StatefulWidget {
  const CalcOptionsWidget({super.key});
  @override
  State<CalcOptionsWidget> createState() => CalcOptionsWidgetState();
}

class CalcOptionsWidgetState extends State<CalcOptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          txt('Prayers Calculation Method', e: St.bold20),
          const Divider(),
          ...List.generate(PrayerCalcMethod.values.length, (index) {
            final prayerCalc = PrayerCalcMethod.values[index];
            return CalcMethodWidget(
              selectedMethod: selectedPrayersMethod,
              prayerCalc: prayerCalc,
              onTap: () {
                selectedPrayersMethod = prayerCalc;
                selectedPrayersNotifier.value = prayerCalc;
                setState(() {});
              },
            );
          }),
        ],
      ),
    );
  }
}

class CalcMethodWidget extends StatelessWidget {
  const CalcMethodWidget({super.key, required this.selectedMethod, required this.prayerCalc, required this.onTap});
  final PrayerCalcMethod selectedMethod;
  final PrayerCalcMethod prayerCalc;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: selectedMethod == prayerCalc ? context.primaryColor : null,
      borderOnForeground: true,
      child: ListTile(
        tileColor: selectedMethod == prayerCalc ? context.primaryColor : null,
        title:
            txt(prayerCalc.name(), maxLines: 20, e: St.bold16, c: selectedMethod == prayerCalc ? Colors.white : null),
        subtitle: txt(prayerCalc.description(),
            e: St.reg14, maxLines: 20, c: selectedMethod == prayerCalc ? Colors.white : null),
        onTap: onTap,
      ),
    );
  }
}
