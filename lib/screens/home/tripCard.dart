import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:training_request/models/order.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

import '../../blocs/home/bloc.dart';
import '../../blocs/home/event.dart';
import '../../utils/const/app_string.dart';
import '../../widgets/custom_button.dart';

class TripCard extends StatelessWidget {
  final OrderModel data;

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
          const SizedBox(height: 16),
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: '\$${data.price.toStringAsFixed(2)}',
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
                child: const Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Colors.grey),
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
                  const Dash(
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
                      text:
                          data.cachedCity != null && data.cachedCountry != null
                              ? "${data.cachedCountry}, ${data.cachedCity}"
                              : data.locationName,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: data.cachedAddress ?? "",
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      text: data.locationName,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: data.locationName,
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
                  child: data.assignedDriver?.isNotEmpty == true
                      ? AppText(
                          text: data.assignedDriver![0].toUpperCase(),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColor.grey,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: data.assignedDriver ?? 'No Driver Assigned',
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text:
                          'ID: ${data.bookingId.substring(data.bookingId.length - 5)}',
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                const Spacer(),
                AppText(
                  text: 'No of Hours: ${data.hours}',
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Proposals (if any)
          if (data.proposals != null && data.proposals!.isNotEmpty)
            ...data.proposals!.map((proposal) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Proposal by ${proposal.serviceProvider.fullName}",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    AppText(
                      text: "Price: \$${proposal.price.toStringAsFixed(2)}",
                      color: AppColor.blue,
                      fontWeight: FontWeight.w600,
                    ),
                    AppText(
                      text:
                          "Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(proposal.date))}",
                      color: AppColor.grey,
                    ),
                    AppText(
                      text: "Time: ${proposal.time}",
                      color: AppColor.grey,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            height: 36,
                            borderRadius: 9,
                            backgroundColor: Colors.white,
                            border: const BorderSide(width: 1),
                            textColor: AppColor.black,
                            text: AppStrings.labelReject,
                            onPressed: () {
                              context.read<HomeBloc>().add(
                                    HomeAcceptJobEvent(
                                      proposalId: proposal.id,
                                      purpose: "reject",
                                    ),
                                  );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            height: 36,
                            borderRadius: 9,
                            backgroundColor: AppColor.appColor,
                            textColor: AppColor.whitish,
                            text: AppStrings.labelAccept,
                            onPressed: () {
                              context.read<HomeBloc>().add(
                                    HomeAcceptJobEvent(
                                      proposalId: proposal.id,
                                      purpose: "accept",
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
