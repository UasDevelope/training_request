import 'package:equatable/equatable.dart';

abstract class ApiConstants extends Equatable {
  static get BASEURL => "http://54.198.124.181:5000/api";
  static get SocketUrl => "http://54.198.124.181:5000/";
  static get registerTrainerr => '$BASEURL/auth/register';
  static get login => "$BASEURL/auth/login";
  static get updateLocation => "$BASEURL/users/location";
  static get makeBooking => "$BASEURL/bookings";
  static get feedback => "$BASEURL/feedback";
  static get fetchBooking => "$BASEURL/Bookings";
  static get getHistory => "$BASEURL/users/transaction-history";
  static get getChatHistory => "$BASEURL/chat";

  static get fetchPendingBookings => "$BASEURL/bookings/user/pending";
  static get fetchInProgressBookings => "$BASEURL/bookings/user/inprogress";
  static get fetchCompletedBookings => "$BASEURL/bookings/user/completed";
  static get fetchSubmittedBookings => "$BASEURL/bookings/user/submitted";
  static get socketChannel => "wss://training-syste-be.vercel.app";
  static get updateLocationEvent => "updateLocation";
}
