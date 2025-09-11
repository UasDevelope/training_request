import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_request/blocs/order/bloc.dart';
import 'package:training_request/blocs/order/state.dart';
import 'package:training_request/blocs/booking/bloc.dart';
import 'package:training_request/blocs/booking/events.dart';
import 'package:training_request/blocs/booking/state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/models/order.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/utils/toast_helper.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';
import 'package:training_request/api/api_constants.dart';

import '../../blocs/order/event.dart';

class OrderScreen extends StatefulWidget {
  final String endPoint;
  final bool inProgress;
  final bool inSubmitted;

  const OrderScreen({
    required this.endPoint,
    this.inProgress = false,
    this.inSubmitted = false,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? _completedBookingId;

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(OrderLoadEvent(endPoint: widget.endPoint));
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return BlocListener<BookingBloc, BookingStat>(
      listener: (context, state) {
        if (state is CompleteBookingSuccess) {
          ToastHelper.showToast(message: state.message);
          // Refresh the order list after completion
          context.read<OrderBloc>().add(OrderLoadEvent(endPoint: widget.endPoint));
          // Navigate to rating screen after successful completion
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushNamed(context, AppRoutes.feedback, arguments: {
              'bookingId': _completedBookingId, // Pass the completed booking ID
            });
          });
        } else if (state is CompleteBookingError) {
          ToastHelper.showToast(message: state.message, type: ToastType.error);
        }
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        buildWhen: (previous, current) =>
            current is OrderLoadingStat ||
            current is OrderLoadedStat ||
            current is ProposalLoadingStat ||
            current is ProposalLoadedStat,
        builder: (context, state) {
          if (state is OrderLoadingStat) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderLoadedStat) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              shrinkWrap: true,
              itemCount: state.orderModel.length,
              itemBuilder: (context, index) {
                final order = state.orderModel;
                return _orderCard(order[index], context, widget.inProgress, widget.inSubmitted);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 1);
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _orderCard(
    OrderModel item,
    BuildContext context,
    bool inProgress,
    bool isSubmitted,
  ) {
    return Card(
      elevation: 2,
      color: AppColor.whitish,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            log("End point is ${widget.endPoint}");
            
            // If this is a completed booking, navigate to rating screen
            if (widget.endPoint == ApiConstants.fetchCompletedBookings) {
              Navigator.pushNamed(context, AppRoutes.feedback, arguments: {
                'bookingId': item.bookingId,
              });
            } else {
              // For other booking statuses, navigate to map screen
              Navigator.pushNamed(context, AppRoutes.map, arguments: widget.endPoint);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // CircleAvatar(
                  //   backgroundImage: AssetImage(item.imageUrl),
                  //   radius: 24,
                  // ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        // AppText(
                        //   text: item.u,
                        //   fontWeight: FontWeight.w600,
                        //   fontSize: 16,
                        //   color: Colors.black,
                        // ),
                        AppText(
                          text:
                              'ID: ${item.bookingId.substring(item.bookingId.length - 5)}',
                          color: AppColor.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    text: "No of Hours : ${item.hours}",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ],
              ),
              SizedBox(height: 12),
              isSubmitted
                  ? SizedBox.shrink()
                  : AppText(
                      text:
                          "Assigned Driver: ${item.assignedDriver != null && item.assignedDriver!.isNotEmpty ? item.assignedDriver : 'Not Assigned'}",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
              isSubmitted ? SizedBox.shrink() : SizedBox(height: 6),
              isSubmitted
                  ? SizedBox.shrink()
                  : Row(
                      children: [
                        Image.asset(
                          AppImages.driving,
                          color: AppColor.blue,
                          height: 30,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppText(
                            text:
                                "Driving Permit Number: ${item.driverPermitNumber ?? "-"}",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.mylocation,
                    color: AppColor.blue,
                    height: 30,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: AppText(
                      text: item.locationName,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Image.asset(
                    AppImages.calendar, height: 30,
                    color: AppColor.blue,
                  ),
                  const SizedBox(width: 6),
                  AppText(
                    text: DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(item.date)),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 30),
                  const SizedBox(width: 4),
                  AppText(
                    text: item.time,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Price: ',
                  children: [
                    TextSpan(
                      text: "${item.price}\$",
                      style: TextStyle(
                        color: AppColor.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              !isSubmitted ? SizedBox.shrink() : SizedBox(height: 6),
              !isSubmitted
                  ? SizedBox.shrink()
                  : AppText(
                      text: "Proposals:",
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColor.blue,
                    ),
              item.proposals != null && item.proposals!.isNotEmpty
                  ? SizedBox(height: 12)
                  : SizedBox.shrink(),
              if (item.proposals != null && item.proposals!.isNotEmpty)
                ...item.proposals!.map((proposal) {
                  final serviceProvider = proposal.serviceProvider;
                  context.read<OrderBloc>().add(
                        FetchLocationDetailsEvent(
                          longitude: proposal.currentLocation!.coordinates[0],
                          latitude: proposal.currentLocation!.coordinates[1],
                        ),
                      );
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text:
                                    "ID: ${serviceProvider.id.substring(serviceProvider.id.length - 5)}",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.grey,
                              ),
                              AppText(
                                text: "No of Hours : ${proposal.hours}",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ],
                          ),
                          AppText(
                            text: serviceProvider.fullName,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.blue,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImages.mylocation,
                                color: AppColor.blue,
                                height: 25,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: BlocBuilder<OrderBloc, OrderState>(
                                  buildWhen: (previous, current) =>
                                      current is LocationLoadingState ||
                                      current is LocationLoaded,
                                  builder: (context, state) {
                                    if (state is LocationLoaded) {
                                      return AppText(
                                        text:
                                            " ${state.country},${state.city}, ${state.address}",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.black,
                                      );
                                    }
                                    return AppText(
                                      text: " Loading",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.black,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 6),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.calendar,
                                height: 25,
                                color: AppColor.blue,
                              ),
                              const SizedBox(width: 6),
                              AppText(
                                text: DateFormat(
                                  'dd-MM-yyyy',
                                ).format(DateTime.parse(proposal.date)),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black,
                              ),
                              const Spacer(),
                              const Icon(Icons.access_time, size: 25),
                              const SizedBox(width: 4),
                              AppText(
                                text: proposal.time,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.black,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  height: 36,
                                  borderRadius: 9,
                                  backgroundColor: Colors.white,
                                  border: BorderSide(width: 1),
                                  textColor: AppColor.black,
                                  text: AppStrings.labelReject,
                                  onPressed: () {
                                    context.read<OrderBloc>().add(
                                          AcceptRejectProposal(
                                            proposalId: proposal.id,
                                            purpose: "reject",
                                          ),
                                        );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: AppButton(
                                  height: 36,
                                  borderRadius: 9,
                                  backgroundColor: AppColor.appColor,
                                  textColor: AppColor.whitish,
                                  text: AppStrings.labelAccept,
                                  onPressed: () {
                                    context.read<OrderBloc>().add(
                                          AcceptRejectProposal(
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
                    ),
                  );
                }),
              const SizedBox(height: 6),
              inProgress ? const SizedBox(height: 10) : SizedBox.shrink(),
              inProgress
                  ? SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        borderRadius: 16,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        text: AppStrings.markComplete,
                        onPressed: () {
                          _completedBookingId = item.bookingId;
                          context.read<BookingBloc>().add(
                            CompleteBooking(bookingId: item.bookingId),
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
              if (inProgress) ...[
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    borderRadius: 16,
                    backgroundColor: AppColor.appColor,
                    textColor: Colors.white,
                    text: "Chat with Driver",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.orderChat,
                        arguments: {
                          'bookingId': item.bookingId,
                          'bookingTitle':
                              'Booking ${item.bookingId.substring(item.bookingId.length - 5)}',
                        },
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
