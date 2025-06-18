import '../utils/const/app_img.dart';

class DummyMaps {
  List<Map<String, dynamic>> homeOffers = [
    {
      "userName": "John Doe",
      "imageUrl": AppImages.driving,
      "bookingId": "BK123456",
      "assignedDriver": "Alex Smith",
      "DrivingPermit": "DL-4523-XYZ",
      "Location": "Downtown, NY",
      "date": "2025-06-10",
      "time": "14:00",
      "payment": "\$120.00",
      "status": "Confirmed",
    },
    {
      "userName": "Jane Smith",
      "imageUrl": AppImages.person,
      "bookingId": "BK123457",
      "assignedDriver": "Emma Johnson",
      "DrivingPermit": "DL-1234-ABC",
      "Location": "Uptown, NY",
      "date": "2025-06-12",
      "time": "10:30",
      "payment": "\$95.00",
      "status": "Pending",
    },
  ];
}
