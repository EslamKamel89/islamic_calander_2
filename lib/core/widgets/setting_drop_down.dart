import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:islamic_calander_2/core/enums/prayer_calc_method.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/globals/calc_method_settings.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
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
      )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(duration: 10000.ms, begin: 0, end: 2),
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

class CalcOptionsWidget extends StatefulWidget {
  const CalcOptionsWidget({super.key});
  @override
  State<CalcOptionsWidget> createState() => CalcOptionsWidgetState();
}

class CalcOptionsWidgetState extends State<CalcOptionsWidget> {
  @override
  void initState() {
    selectedPrayersNotifier.addListener(() {
      pr(selectedPrayersNotifier.value, 'updating the selected value');
      selectedPrayersMethod = selectedPrayersNotifier.value;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          txt('Prayers Calculation Method', e: St.bold20),
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
      ),
    );
  }
}

class CalcMethodWidget extends StatelessWidget {
  const CalcMethodWidget(
      {super.key,
      required this.selectedMethod,
      required this.prayerCalc,
      required this.onTap});
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
        title: txt(prayerCalc.fullString,
            maxLines: 20,
            e: St.bold18,
            c: selectedMethod == prayerCalc ? Colors.white : null),
        // subtitle: txt(prayerCalc.description(),
        //     e: St.reg14,
        //     maxLines: 20,
        //     c: selectedMethod == prayerCalc ? Colors.white : null),
        onTap: onTap,
      ),
    );
  }
}
