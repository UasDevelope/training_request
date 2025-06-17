import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_string.dart';

import '../home/home.dart';

class TabarScreen extends StatelessWidget {
  const TabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text("👋 Welcome back, Frank!"),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColor.appColor,
            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColor.blue,
            unselectedLabelColor: AppColor.blue,
            dividerColor: Colors.white,
            tabs: [
              Tab(text: AppStrings.statusNew),
              Tab(text: AppStrings.statusActive),
              Tab(text: AppStrings.statusInProgress),
              Tab(text: AppStrings.statusCompleted),
            ],
          ),
        ),
        body: TabBarView(
          children: [HomeScreen(), HomeScreen(), HomeScreen(), HomeScreen()],
        ),
      ),
    );
  }
}
