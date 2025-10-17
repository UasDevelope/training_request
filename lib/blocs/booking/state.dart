import 'package:equatable/equatable.dart';

abstract class BookingStat extends Equatable {
  const BookingStat();
  @override
  List<Object> get props => [];
}

class BookingLoading extends BookingStat {
  const BookingLoading();
  @override
  List<Object> get props => [];
}

class BookingInitialState extends BookingStat {
  const BookingInitialState();
  @override
  List<Object> get props => [];
}

class UpdateDateTimeState extends BookingStat {
  final DateTime dateTime;
  const UpdateDateTimeState({required this.dateTime});
  UpdateDateTimeState copyWith({DateTime? dateTime}) {
    return UpdateDateTimeState(dateTime: dateTime!);
  }

  @override
  List<Object> get props => [dateTime];
}

class BookingSuccess extends BookingStat {
  final String message;
  const BookingSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class BookingError extends BookingStat {
  final String message;
  const BookingError({required this.message});
  @override
  List<Object> get props => [message];
}

class LocationObtainedForBooking extends BookingStat {
  final double lat;
  final double long;
  final String locationName;
  const LocationObtainedForBooking({
    required this.lat,
    required this.long,
    required this.locationName,
  });
  @override
  List<Object> get props => [lat, long, locationName];
}

class CompleteBookingSuccess extends BookingStat {
  final String message;
  const CompleteBookingSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

class CompleteBookingError extends BookingStat {
  final String message;
  const CompleteBookingError({required this.message});
  @override
  List<Object> get props => [message];
}

class PriceUpdatedState extends BookingStat {
  final double price;
  const PriceUpdatedState({required this.price});
  @override
  List<Object> get props => [price];
}