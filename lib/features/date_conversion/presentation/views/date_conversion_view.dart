import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/cubits/date_conversion/date_conversion_cubit.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/data_selector.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/table_widget.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/wisdom_coursel.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/year_search_widget.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class DateConversionView extends StatefulWidget {
  const DateConversionView({super.key});
  @override
  State<DateConversionView> createState() => _DateConversionViewState();
}

class _DateConversionViewState extends State<DateConversionView> {
  late DateConversionCubit controller;
  @override
  void initState() {
    super.initState();
    controller = context.read<DateConversionCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: txt('New Hijri Calendar', e: St.bold20)),
        resizeToAvoidBottomInset: false,
        drawer: const DefaultDrawer(),
        body: Scrollbar(
          thickness: 10,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Sizer(),
                YearSearchWidget(
                  handleInputChange: (String year) => controller.goToYear(year),
                ),
                const TableWidget(),
                // const Spacer(),
                SizedBox(height: 20.h),
                const DataSelector(),
                // const Spacer(),
                SizedBox(height: 20.h),
                WisdomCarousel(),
                SizedBox(height: 20.h),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
