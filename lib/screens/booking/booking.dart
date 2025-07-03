import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:training_request/blocs/booking/bloc.dart';
import 'package:training_request/blocs/booking/events.dart';
import 'package:training_request/blocs/booking/state.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/utils/toast_helper.dart';
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
    return BlocBuilder<BookingBloc, BookingStat>(
      buildWhen: (previous, current) => current is BookingLoading || current is BookingSuccess,
      builder: (context, state) {
        var bookingBloc = context.read<BookingBloc>();

        if (state is BookingLoading) {
          Future.microtask(() {
            if (ModalRoute.of(context)?.isCurrent ?? true) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: CircularProgressIndicator(color: AppColor.appColor),
                ),
              );
            }
          });
        } else {
          Future.microtask(() {
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          });

          if (state is BookingSuccess) {
            ToastHelper.showToast(message: state.message);
            bookingBloc.add(ClearController());
          } else if (state is BookingError) {
            ToastHelper.showToast(message: state.message, type: ToastType.error);
            bookingBloc.add(ClearController());
          }
        }

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
              const SizedBox(height: 12),
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
                    final formatted = DateFormat("dd MMM yyyy – hh:mm a").format(picked);
                    bookingBloc.date.text = formatted;
                    log(formatted);
                    bookingBloc.add(UpdateDateTime(dateTime: picked));
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
                  bookingBloc.add(
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
            ],
          ),
        );
      },
    );
  }
}
