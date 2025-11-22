import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/cubits/date_conversion/date_conversion_cubit.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/data_selector.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/table_widget.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/year_search_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:islamic_calander_2/main.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class DateConversionView extends StatefulWidget {
  const DateConversionView({super.key});
  @override
  State<DateConversionView> createState() => _DateConversionViewState();
}

class _DateConversionViewState extends State<DateConversionView> with RouteAware {
  late DateConversionCubit controller;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    super.initState();
    controller = context.read<DateConversionCubit>();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    bottomNavigationBarIndex = 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: txt('DATE_CONVERSION'.tr(), e: St.bold20)),
        resizeToAvoidBottomInset: false,
        // drawer: const DefaultDrawer(),
        bottomNavigationBar: CustomBottomNavBar(
          key: Key(bottomNavigationBarIndex.toString()),
        ),
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
                // const WisdomCarousel(),
                // SizedBox(height: 20.h),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
