import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_string.dart';
import 'package:training_request/blocs/user_profile/bloc.dart';
import 'package:training_request/repositories/user_profile_repository.dart';
import 'package:get_it/get_it.dart';

import '../order/order.dart';

class TabarScreen extends StatelessWidget {
  const TabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        GetIt.instance<UserProfileRepository>(),
      )..add(const LoadUserProfile()),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  return Text("👋 Welcome back, ${state.userName}!");
                } else if (state is UserProfileLoading) {
                  return Text("👋 Welcome back, Loading...");
                } else {
                  return Text("👋 Welcome back, User!");
                }
              },
            ),
            bottom: TabBar(
              isScrollable: true,
              labelColor: AppColor.appColor,
              automaticIndicatorColorAdjustment: true,
              indicatorColor: AppColor.blue,
              labelStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
              unselectedLabelColor: AppColor.blue,
              unselectedLabelStyle:  TextStyle(fontWeight: FontWeight.w900,fontSize: 14),
              dividerColor: Colors.white,
              tabs: [
                Tab(text: AppStrings.statusActive),
                Tab(text: AppStrings.statusSubmitted),
                Tab(text: AppStrings.statusInProgress),
                Tab(text: AppStrings.statusCompleted),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              OrderScreen(endPoint: ApiConstants.fetchPendingBookings),
              OrderScreen(endPoint: ApiConstants.fetchSubmittedBookings,inSubmitted: true,),
              OrderScreen(endPoint: ApiConstants.fetchInProgressBookings,inProgress: true,),
              OrderScreen(endPoint: ApiConstants.fetchCompletedBookings),
            ],
          ),
        ),
      ),
    );
  }
}




