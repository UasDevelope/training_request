import 'package:equatable/equatable.dart';

abstract class BookingStat extends Equatable {
  const BookingStat();
  List<Object> get props => [];
}

class BookingLoading extends BookingStat {
  BookingLoading();
  List<Object> get props => [];
}

class BookingInitialState extends BookingStat {
  const BookingInitialState();
  List<Object> get props => [];
}

class UpdateDateTimeState extends BookingStat {
  final DateTime dateTime;
  const UpdateDateTimeState({required this.dateTime});
  UpdateDateTimeState copyWith({DateTime? dateTime}) {
    return UpdateDateTimeState(dateTime: dateTime!);
  }

  List<Object> get props => [dateTime];
}

class BookingSuccess extends BookingStat {
  final String message;
  const BookingSuccess({required this.message});
  List<Object> get props => [message];
}

class BookingError extends BookingStat {
  final String message;
  const BookingError({required this.message});
  List<Object> get props => [message];
}
