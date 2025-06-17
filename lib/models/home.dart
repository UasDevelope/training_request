class HomeModel {
  final String userName;
  final String imageUrl;
  final String bookingId;
  final String assignedDriver;
  final String DrivingPermit;
  final String Location;
  final String date;
  final String time;
  final String payment;
  final String status;
  HomeModel({
    required this.userName,
    required this.imageUrl,
    required this.bookingId,
    required this.assignedDriver,
    required this.DrivingPermit,
    required this.Location,
    required this.date,
    required this.time,
    required this.payment,
    required this.status,
  });
  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
      userName: map["userName"] ?? '',
      imageUrl: map["imageUrl"] ?? '',
      bookingId: map["bookingId"] ?? '',
      assignedDriver: map["assignedDriver"] ?? '',
      DrivingPermit: map["DrivingPermit"] ?? '',
      Location: map["Location"] ?? '',
      date: map["date"] ?? '',
      time: map["time"] ?? '',
      payment: map["payment"] ?? '',
      status: map["status"] ?? '',
    );
  }
}
