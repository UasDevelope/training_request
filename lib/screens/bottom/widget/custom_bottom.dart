import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_request/utils/const/app_img.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(AppImages.home, "Home", 0),
          _buildNavItem(AppImages.calendar, "Booking", 1),
          _buildNavItem(AppImages.chat, "Chat", 2),
          _buildNavItem(AppImages.setting, "Setting", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, color: isSelected ? Colors.green : Colors.grey,height:30,width:30,),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
