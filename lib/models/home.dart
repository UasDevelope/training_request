class HomeModel {
  final double studentLat;
  final double studentLong;
  final String studentLocation;
  final String studentStateCountry;
  final double driverLat;
  final double driverLong;
  final String driverLocation;
  final String driverStateCountry;
  final double studentRating;
  final String studentProfilePic;
  final String studentName;
  final String requestHours;
  final double price;
  final String bookingId;
  final String status;

  HomeModel({
    required this.studentLat,
    required this.studentLong,
    required this.studentLocation,
    required this.studentStateCountry,
    required this.driverLat,
    required this.driverLong,
    required this.driverLocation,
    required this.driverStateCountry,
    required this.studentRating,
    required this.studentProfilePic,
    required this.studentName,
    required this.requestHours,
    required this.price,
    required this.bookingId,
    required this.status,
  });

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      studentLat: (map['studentLat'] ?? 0).toDouble(),
      studentLong: (map['studentLong'] ?? 0).toDouble(),
      studentLocation: map['studentLocation'] ?? '',
      studentStateCountry: map['studentStateCountry'] ?? '',
      driverLat: (map['driverLat'] ?? 0).toDouble(),
      driverLong: (map['driverLong'] ?? 0).toDouble(),
      driverLocation: map['driverLocation'] ?? '',
      driverStateCountry: map['driverStateCountry'] ?? '',
      studentRating: (map['studentRating'] ?? 0).toDouble(),
      studentProfilePic: map['studentProfilePic'] ?? '',
      studentName: map['studentName'] ?? '',
      requestHours: map['requestHours'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      bookingId: map['bookingId'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentLat': studentLat,
      'studentLong': studentLong,
      'studentLocation': studentLocation,
      'studentStateCountry': studentStateCountry,
      'driverLat': driverLat,
      'driverLong': driverLong,
      'driverLocation': driverLocation,
      'driverStateCountry': driverStateCountry,
      'studentRating': studentRating,
      'studentProfilePic': studentProfilePic,
      'studentName': studentName,
      'requestHours': requestHours,
      'price': price,
      'bookingId': bookingId,
      'status': status,
    };
  }
}
