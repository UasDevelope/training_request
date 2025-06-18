
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';


import '../../models/home.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../widgets/app_text.dart';

class TripCard extends StatelessWidget {
  final HomeModel data;

  const TripCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 16),

          // Price & Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: '\$${data.price?.toStringAsFixed(2) ?? '0.00'}',
                color: AppColor.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      data.studentRating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          // Route Details
          // Route Details with vertical indicator
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical timeline
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  Dash(
                    direction: Axis.vertical,
                    length: 50,
                    dashLength: 5,
                    dashColor: Colors.black,
                  ),
                  const Icon(Icons.location_on, color: Colors.black),
                ],
              ),
              const SizedBox(width: 12),

              // Address texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: data.studentLocation ?? "Start Address",
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: data.studentStateCountry ?? "",
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 12),
                    AppText(
                      text: data.driverLocation ?? "End Address",
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: data.driverStateCountry ?? "",
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // User Info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(AppImages.profile),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text:
                      data.studentName ?? 'User Name',
                     fontWeight: FontWeight.bold,
                    ),
                    AppText(text:
                      'ID: ${data.bookingId ?? 'Unknown'}',
                     color: Colors.grey,
                      fontWeight:FontWeight.w400,
                    ),
                  ],
                ),
                const Spacer(),
                AppText(text:
                  'No of Hours : ${data.requestHours ?? 0}',
                 fontWeight: FontWeight.w300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
