import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_request/blocs/booking/bloc.dart';
import 'package:training_request/blocs/booking/events.dart';
import 'package:training_request/blocs/booking/state.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/utils/validator.dart';
import 'package:training_request/widgets/app_text.dart';
import 'package:training_request/widgets/custom_button.dart';
import 'package:training_request/widgets/form_field.dart';

import '../../services/dateTime.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _body(context));
  }

  Widget _body(BuildContext context) {
    return BlocListener<BookingBloc, BookingStat>(
      listener: (context, state) {},
      child: BlocBuilder<BookingBloc, BookingStat>(
        builder: (context, state) {
          var bookingBloc = context.read<BookingBloc>();
          if (state is UpdateDateTimeState) {}
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Center(
                  child: Image.asset(AppImages.logo, height: 100, width: 100),
                ),
                SizedBox(height: 60),
                // const AppText(
                //   text: AppStrings.personalInformation,
                //   fontSize: 18,
                //   fontWeight: FontWeight.w600,
                // ),

                // const SizedBox(height: 12),
                // AppTextFormField(
                //   controller: TextEditingController(),
                //   hintText: AppStrings.enterFullName,
                //   validator: AppValidators.validateRequired,
                //   prefixIcon: AppImages.profile,
                // ),
                const SizedBox(height: 12),

                // AppTextFormField(
                //   controller: TextEditingController(),
                //   hintText: AppStrings.enterEmail,
                //   validator: AppValidators.emailValidate,
                //   prefixIcon: AppImages.email,
                // ),
                // const SizedBox(height: 12),
                // AppTextFormField(
                //   controller: TextEditingController(),
                //   hintText: AppStrings.enterContactNumber,
                //   validator: AppValidators.phoneValidate,
                //   isPhoneField: true,
                // ),
                SizedBox(height: 24),
                AppText(
                  text: AppStrings.trainingDetails,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 12),
                AppTextFormField(
                  onTap: () {},
                  controller: bookingBloc.Nohrs,
                  hintText: AppStrings.enterNoOfHours,
                  validator: AppValidators.validateRequired,
                  prefixIcon: AppImages.time,
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: bookingBloc.date,
                  hintText: AppStrings.selectDate,
                  readOnly: true,
                  onTap: () async {
                    final picked = await DateTimeHelper.pickDateTime(context);
                    if (picked != null) {
                      final formatted = DateFormat(
                        "dd MMM yyyy – hh:mm a",
                      ).format(picked);
                      bookingBloc.date.text = formatted;
                      log(formatted);
                      context.read<BookingBloc>().add(
                        UpdateDateTime(dateTime: picked),
                      );
                    }
                  },
                  prefixIcon: AppImages.calendar,
                ),
                const SizedBox(height: 12),
                AppTextFormField(
                  controller: bookingBloc.price,
                  hintText: AppStrings.enterPrice,

                  validator: AppValidators.validateRequired,
                  prefixIcon: AppImages.coin,
                ),

                const SizedBox(height: 12),
                AppTextFormField(
                  controller: bookingBloc.writeSomething,
                  hintText: AppStrings.enterRequirements,
                ),

                SizedBox(height: 24),
                AppButton(
                  text: AppStrings.requestTraining,
                  onPressed: () {
                    context.read<BookingBloc>().add(
                      CreateBooking(
                        NoHrs: int.parse(bookingBloc.Nohrs.text),
                        date: bookingBloc.selectedDate!,
                        price: double.parse(bookingBloc.price.text),
                        specialRequirements: bookingBloc.writeSomething.text,
                      ),
                    );
                  },
                  backgroundColor: AppColor.appColor,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // TODO: Handle request
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColor.green,
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //     ),
                //     child: const Text(AppStrings.requestTraining, style: TextStyle(color: Colors.white)),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
