import 'package:equatable/equatable.dart';

abstract class ApiConstants extends Equatable {
  static get BASEURL => "https://training-syste-be.vercel.app/api";
  static get registerTrainerr => '$BASEURL/auth/register';
  static get login => "$BASEURL/auth/login";
  static get updateLocation => "$BASEURL/users/location";
  static get makeBooking => "$BASEURL/bookings";
  static get feedback => "$BASEURL/feedback";
  static get fetchBooking=>"$BASEURL/Bookings";
  static get getHistory => "$BASEURL/users/transaction-history";
}
