import 'package:dartz/dartz.dart';
import 'package:islamic_calander_2/core/Errors/failure.dart';
import 'package:islamic_calander_2/features/date_conversion/data/models/selected_date_conversion_model.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/data_selector.dart';

abstract class DateConversionRepo {
  Future<Either<Failure, SelectedDateConversionModel>> getDateConversion(
      DateTime selectedDate, DataProcessingOption selectedOption);
}
