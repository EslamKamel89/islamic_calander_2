import 'package:dartz/dartz.dart';
import 'package:islamic_calander_2/core/Errors/failure.dart';
import 'package:islamic_calander_2/core/enums/month_enums.dart';
import 'package:islamic_calander_2/core/enums/moon_phase_enums.dart';
import 'package:islamic_calander_2/features/date_info/data/models/date_info_model.dart';
import 'package:islamic_calander_2/features/date_info/domain/entities/moon_info_model.dart';

abstract class DateInfoRepo {
  Future<Either<Failure, List<DateInfoModel>>> getDateInfoYear(int year);
  Future<Either<Failure, List<DateInfoModel>>> getDateInfoMonth(int year, MonthEnum month);
  Future<Either<Failure, List<MoonInfoModel>>> getMoonInfoMonth(int year, MoonPhaseEnum moonPhase);
}
