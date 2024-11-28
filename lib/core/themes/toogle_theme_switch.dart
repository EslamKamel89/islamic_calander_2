import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/themes/theme_cubit.dart';

class ToggleThemeSwitch extends StatelessWidget {
  const ToggleThemeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    return Switch(
      value: themeCubit.state.brightness == Brightness.dark,
      onChanged: (value) {
        themeCubit.toggleTheme();
      },
    );
  }
}
