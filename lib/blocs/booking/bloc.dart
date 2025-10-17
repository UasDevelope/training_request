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
  double selectedPrice = 5.0; // Default price

  BookingRepository bookingRepository;
  BookingBloc(this.bookingRepository, this.currentLocationRepository)
    : super(BookingInitialState()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());
      
      try {
        // Try to get location, but don't fail if user hasn't granted permission
        double lat = 0.0;
        double long = 0.0;
        String locationName = "Location not provided";
        
        try {
          final (latitude, longitude, locName) =
              await currentLocationRepository.getCurrentLocation();
          lat = latitude;
          long = longitude;
          locationName = locName;
        } catch (locationError) {
          log("Location not available: $locationError");
          // Continue without location
        }

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
    on<ClearController>(clearController);
    
    on<RequestLocationForBooking>((event, emit) async {
      try {
        final (lat, long, locationName) =
            await currentLocationRepository.getCurrentLocation();
        emit(LocationObtainedForBooking(lat: lat, long: long, locationName: locationName));
      } catch (e) {
        emit(BookingError(message: "Location not available. You can continue without location."));
      }
    });
    
    on<CompleteBooking>((event, emit) async {
      emit(BookingLoading());
      try {
        final response = await bookingRepository.completeBooking(
          bookingId: event.bookingId,
        );
        emit(CompleteBookingSuccess(message: response["message"]));
      } on BadExceptionRequest catch (e) {
        emit(CompleteBookingError(message: e.message));
      } catch (e) {
        emit(CompleteBookingError(message: e.toString()));
      }
    });
    
    on<UpdatePrice>((event, emit) {
      selectedPrice = event.price;
      price.text = event.price.toString();
      emit(PriceUpdatedState(price: event.price));
    });
  }

  void clearController(ClearController event, Emitter<BookingStat> emit) {
    Nohrs.clear();
    price.clear();
    writeSomething.clear();
    date.clear();
    selectedPrice = 5.0; // Reset to default price
  }
}
