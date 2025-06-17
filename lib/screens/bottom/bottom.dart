import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/nav/bloc.dart';
import 'package:training_request/blocs/nav/state.dart';
import 'package:training_request/screens/bottom/widget/custom_bottom.dart';

import '../../blocs/nav/event.dart';
import '../booking/booking.dart';
import '../chat/chat.dart';
import '../setting/setting.dart';
import '../tabar/tabar.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TabarScreen(),
      BookingScreen(),
      ChatUsers(),
      SettingsScreen(),
    ];

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is ChangeIndexStat) currentIndex = state.index;

        return Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: currentIndex,
            onTap: (index) {
              context.read<NavBloc>().add(ChangeIndex(Index: index));
            },
          ),
        );
      },
    );
  }
}
