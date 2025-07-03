import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBooking extends BookingEvent {
  final int NoHrs;
  final DateTime date;
  // final String timeSlot;
  final double price;
  final String specialRequirements;
  const CreateBooking({
    required this.NoHrs,
    required this.date,
    // required this.timeSlot,
    required this.price,
    required this.specialRequirements,
  });

  @override
  List<Object> get props => [NoHrs, date, price, specialRequirements];
}

class CancelBooking extends BookingEvent {
  final String bookingId;

  const CancelBooking({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

// Update the selected dateTime
class UpdateDateTime extends BookingEvent {
  final DateTime dateTime;

  const UpdateDateTime({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class ClearController extends BookingEvent{}
