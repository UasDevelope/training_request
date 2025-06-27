import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/order/bloc.dart';
import 'package:training_request/blocs/order/state.dart';
import 'package:training_request/core/app_routes.dart';
import 'package:training_request/models/order.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';
import '../../models/home.dart';

class OrderScreen extends StatelessWidget {
  final String orderStatus;
  const OrderScreen({required this.orderStatus});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoadingStat) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderLoadedStat) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.homeModel.length,
            itemBuilder: (context, index) {
              final List<OrderModel> filteredList =
                  state.homeModel
                      .where((item) => item.status == orderStatus)
                      .toList();

              return filteredList.isEmpty
                  ? Center(child: Text("No data"))
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return _orderCard(filteredList[index], context);
                },
              );

            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _orderCard(OrderModel item, BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Image, Name, ID, Hours
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
                        text: 'ID: ${item.serviceProviderId}',
                        color: AppColor.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                AppText(
                  text: "No of Hours : ${item.date}",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ],
            ),
            SizedBox(height: 12),
            AppText(
              text: "Assigned Driver : ${item.serviceProviderId}",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  AppImages.driving,
                  color: AppColor.blue,
                  height: 30,
                ),
                SizedBox(width: 6),
                // Expanded(
                //   child: AppText(
                //     text: "Driving Permit Number : ${item.DrivingPermit}",
                //     fontSize: 16,
                //     fontWeight: FontWeight.w400,
                //     color: AppColor.black,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  AppImages.mylocation,
                  color: AppColor.blue,
                  height: 30,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text: "Location: ${item.locationName}",
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
                  AppImages.calendar,
                  height: 30,
                  color: AppColor.blue,
                ),
                const SizedBox(width: 6),
                AppText(
                  text: item.date.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 30),
                const SizedBox(width: 4),
                AppText(
                  text: item.date.toString(),
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                borderRadius: 16,
                backgroundColor: Colors.white,
                border: BorderSide(width: 1),
                textColor: AppColor.black,
                text: AppStrings.labelPayment,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.feedback);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
