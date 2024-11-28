import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Toggle between English and Arabic
        context.setLocale(context.locale.languageCode == 'en'
            ? const Locale('ar')
            : const Locale('en'));
      },
      child: Text(context.locale.languageCode == 'en'
          ? 'Switch to Arabic'
          : 'Switch to English'),
    );
  }
}
