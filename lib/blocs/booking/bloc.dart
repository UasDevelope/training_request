import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_request/api/api_exception.dart';
import 'package:training_request/blocs/booking/events.dart';
import 'package:training_request/blocs/booking/state.dart';
import 'package:training_request/repositories/CurrentLocationRepository.dart';
import 'package:training_request/repositories/booking_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingStat> {
  final TextEditingController Nohrs = TextEditingController();
  CurrentLocationRepository currentLocationRepository;
  final TextEditingController price = TextEditingController();
  final TextEditingController writeSomething = TextEditingController();
  final TextEditingController date = TextEditingController();
  DateTime? selectedDate;

  BookingRepository bookingRepository;
  BookingBloc(this.bookingRepository, this.currentLocationRepository)
    : super(BookingInitialState()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());
      final (lat, long, locationName) =
          await currentLocationRepository.getCurrentLocation();

      try {
        var response = await bookingRepository.bookingRequest(
          hours: event.NoHrs,
          date: event.date,
          price: event.price,
          latitude: lat,
          longitude: long,
          locationName: locationName,
        );
        emit(BookingSuccess(message: response["message"]));
      } on BadExceptionRequest catch (e) {
        emit(BookingError(message: e.message));
      } catch (e) {
        emit(BookingError(message: e.toString()));
      }
    });
    on<UpdateDateTime>((event, emit) {
      selectedDate = event.dateTime;

      final formatted = DateFormat("yyyy-MM-dd HH:mm").format(event.dateTime);
      date.text = formatted; // Clean format without .000

      emit(UpdateDateTimeState(dateTime: event.dateTime));
      log("Selected date: $formatted");
    });
  }
}
