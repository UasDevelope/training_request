class BookingModel {
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

  BookingModel({
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
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
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
class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}
class Proposal {
  final String id;
  final ServiceProvider serviceProvider;
  final int hours;
  final double price;
  final String date;
  final String time;
  final String specialRequirements;
  final String status;
  final CurrentLocation? currentLocation;
  final String submittedAt;

  Proposal({
    required this.id,
    required this.serviceProvider,
    required this.hours,
    required this.price,
    required this.date,
    required this.time,
    required this.specialRequirements,
    required this.status,
    required this.submittedAt,
    this.currentLocation,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['_id'],
      serviceProvider: ServiceProvider.fromJson(json['serviceProviderId']),
      hours: json['hours'],
      price: (json['price'] as num).toDouble(),
      date: json['date'],
      time: json['time'],
      specialRequirements: json['specialRequirements'],
      status: json['status'],
      submittedAt: json['submittedAt'],
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
    );
  }
}
class ServiceProvider {
  final String id;
  final String fullName;

  ServiceProvider({
    required this.id,
    required this.fullName,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['_id'],
      fullName: json['fullName'],
    );
  }
}
class CurrentLocation {
  final String type;
  final List<double> coordinates;
  final String capturedAt;

  CurrentLocation({
    required this.type,
    required this.coordinates,
    required this.capturedAt,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
      capturedAt: json['capturedAt'],
    );
  }
}
