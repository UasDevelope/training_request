import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/home/bloc.dart';
import 'package:training_request/blocs/home/state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';

import '../../models/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body());
  }

  Widget _body() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingStat) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeLoadedStat) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.homeModel.length,
            itemBuilder: (context, index) {
              final item = state.homeModel[index];
              return _homeCard(item);
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _homeCard(HomeModel item) {
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
                CircleAvatar(
                  backgroundImage: AssetImage(item.imageUrl),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      AppText(
                        text: item.userName,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      AppText(
                        text: 'ID: ${item.bookingId}',
                        color: AppColor.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                AppText(
                  text: "No of Hours : ${item.time}",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ],
            ),
            const SizedBox(height: 12),

            AppText(
              text: "Assigned Driver : ${item.assignedDriver}",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),

            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  AppImages.driving,
                  color: AppColor.blue,
                  height: 30,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text: "Driving Permit Number : ${item.DrivingPermit}",
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
                  AppImages.mylocation,
                  color: AppColor.blue,
                  height: 30,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text: "Location: ${item.Location}",
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
                  text: item.date,
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
                    text: "${item.payment}\$",
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
