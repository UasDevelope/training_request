class OrderResponse {
  final String message;
  final List<OrderModel> booking;
  OrderResponse({required this.message, required this.booking});
  factory OrderResponse.fromMap(Map<String, dynamic> map) {
    return OrderResponse(
      message: map["message"],
      booking:
      List<Map<String, dynamic>>.from(
        map["bookings"] ?? [],
      ).map((x) => OrderModel.fromJson(x)).toList(),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String? serviceProviderId;
  final int hours;
  final DateTime date;
  final int price;
  final String status;
  final String locationName;
  final List<dynamic> proposals;
  final String? acceptedProposalId;
  final DateTime createdAt;
  final Location location;

  OrderModel({
    required this.id,
    required this.userId,
    this.serviceProviderId,
    required this.hours,
    required this.date,
    required this.price,
    required this.status,
    required this.locationName,
    required this.proposals,
    this.acceptedProposalId,
    required this.createdAt,
    required this.location,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['userId'],
      serviceProviderId: json['serviceProviderId'],
      hours: json['hours'],
      date: DateTime.parse(json['date']),
      price: json['price'],
      status: json['status'],
      locationName: json['locationName'],
      proposals: json['proposals'] ?? [],
      acceptedProposalId: json['acceptedProposalId'],
      createdAt: DateTime.parse(json['createdAt']),
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'serviceProviderId': serviceProviderId,
      'hours': hours,
      'date': date.toIso8601String(),
      'price': price,
      'status': status,
      'locationName': locationName,
      'proposals': proposals,
      'acceptedProposalId': acceptedProposalId,
      'createdAt': createdAt.toIso8601String(),
      'location': location.toJson(),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}
