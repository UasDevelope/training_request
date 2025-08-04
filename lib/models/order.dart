import 'booking.dart';

class OrderModel {
  final String bookingId;
  final int hours;
  final String date;
  final String time;
  final double price;
  final Location location;
  final String locationName;
  final String? assignedDriver;
  final String? driverPermitNumber;
  final List<Proposal>? proposals;
  String? cachedCity; // Added for geocoding
  String? cachedCountry; // Added for geocoding
  String? cachedAddress; // Added for geocoding

  OrderModel({
    required this.bookingId,
    required this.hours,
    required this.date,
    required this.time,
    required this.price,
    required this.location,
    required this.locationName,
    this.assignedDriver,
    this.driverPermitNumber,
    this.proposals,
    this.cachedCity,
    this.cachedCountry,
    this.cachedAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      bookingId: json['bookingId'],
      hours: json['hours'],
      date: json['date'],
      time: json['time'],
      price: (json['price'] as num).toDouble(),
      location: Location.fromJson(json['location']),
      locationName: json['locationName'],
      assignedDriver: json['assignedDriver'],
      driverPermitNumber: json['driverPermitNumber'],
      proposals: json['proposals'] != null
          ? List<Proposal>.from(
              json['proposals'].map((x) => Proposal.fromJson(x)))
          : null,
    );
  }
}
