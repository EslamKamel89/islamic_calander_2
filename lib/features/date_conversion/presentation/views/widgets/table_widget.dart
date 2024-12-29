import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/cubits/date_conversion/date_conversion_cubit.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/conversion_date_info_loading_widget.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/data_selector.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DateConversionCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BlocBuilder<DateConversionCubit, DateConversionState>(
            buildWhen: (prev, current) {
              return current.buildWhen == 'UPDATE_TABLE_WIDGET';
            },
            builder: (context, state) {
              DateTime selectedGeorgianDate = controller.state.selectedGeorgianDate ?? DateTime.now();
              return TableCalendar(
                firstDay: state.firstDay,
                lastDay: state.lastDay,
                // focusedDay: state.selectedYear == null ? selectedDay : DateTime(state.selectedYear!, 1, 1),
                focusedDay: selectedGeorgianDate,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedGeorgianDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedGeorgianDate = selectedDay;
                  });
                  _showIslamicInfo(context, selectedDay);
                  controller.getSelectedDateInfo(selectedDay);
                },
                onFormatChanged: (format) {
                  // setState(() {
                  //   _calendarFormat = format;
                  // });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: context.secondaryHeaderColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonDecoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(10.w)),
                  headerMargin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // formatButtonTextStyle: TextStyle(
                  //   color: Theme.of(context).primaryColor,
                  //   fontSize: 16.0,
                  // ),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showIslamicInfo(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<DateConversionCubit, DateConversionState>(
          builder: (context, state) {
            if (state.getSelectedDateInfoState == ResponseState.loading) {
              return const ConversionDateInfoLoadingWidget();
            } else if (state.getSelectedDateInfoState == ResponseState.failure) {
              return const ConversionDateInfoFailureWidget();
            } else if (state.getSelectedDateInfoState == ResponseState.success) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                height: 280.h,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                  color: context.secondaryHeaderColor.withOpacity(0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    txt('Date Information', e: St.bold18, c: context.primaryColor),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDateRow(
                              image: 'calendar_5.png',
                              title: 'Georgian date',
                              date: DateFormat('d MMMM, yyyy')
                                  .format((state.selectedDateConversionEntity?.selectedGeorgianDate)!)),
                          _buildDateRow(
                              image: 'calendar_7.png',
                              title: 'Old Hijri date',
                              date: state.selectedDateConversionEntity?.selectedOldHijriDate ?? ''),
                          _buildDateRow(
                            image: 'calendar_3.png',
                            title: 'Upgraded Hijri',
                            date: state.selectedOption == DataProcessingOption.after
                                ? state.selectedDateConversionEntity?.newHijriUpdatedDateProccessed() ?? ''
                                : state.selectedDateConversionEntity?.newHijriUpdated ?? '',
                          ),
                          _buildDateRow(
                            image: 'calendar_9.png',
                            title: 'New Hijri date',
                            // date: state.selectedDateConversionEntity?.selectedNewHijriDate ?? '',
                            date: state.selectedOption == DataProcessingOption.after
                                ? state.selectedDateConversionEntity?.newHijriDateProccessed() ?? ''
                                : state.selectedDateConversionEntity?.selectedNewHijriDate ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }

  Widget _buildDateRow({required String title, required String date, required image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/images/$image',
            width: 20.w,
            height: 20.w,
          ),
          const Sizer(),
          txt('$title: ', e: St.semi14, c: context.primaryColor),
          txt(date, e: St.reg14),
        ],
      ),
    );
  }
}
