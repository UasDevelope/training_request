// // custom_drawer.dart
// import 'package:driver/core/app_routes.dart';
// import 'package:driver/utils/const/app_color.dart';
// import 'package:driver/utils/const/app_img.dart';
// import 'package:driver/widgets/app_text.dart';
// import 'package:flutter/material.dart';
//
// class CustomDrawer extends StatelessWidget {
//   final String userName;
//   final String profileImage; // Can be a network or asset path
//
//   const CustomDrawer({
//     Key? key,
//     required this.userName,
//     required this.profileImage,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           DrawerHeader(
//             padding: const EdgeInsets.all(6),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage(
//                     profileImage,
//                   ), // or use NetworkImage
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       text: "Welcome back,",
//                       color: AppColor.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                     ),
//                     AppText(
//                       text: userName,
//                       color: AppColor.black,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 16,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(AppImages.clock, "Recent Orders", () {
//             Navigator.pushNamed(context, AppRoutes.order);
//           }),
//           _buildDrawerItem(AppImages.earning, "Earnings", () {
//             Navigator.pushNamed(context, AppRoutes.earning);
//           }),
//           // _buildDrawerItem(AppImages.notification, "Notifications", () {
//           //   Navigator.pushNamed(context, AppRoutes.notification);
//           // }),
//           _buildDrawerItem(AppImages.chat, "Messages", () {
//             Navigator.pushNamed(context, AppRoutes.message);
//           }),
//           _buildDrawerItem(AppImages.setting, "Account Settings", () {
//             Navigator.pushNamed(context, AppRoutes.settings);
//           }),
//           _buildDrawerItem(AppImages.help, "Help & feedback", () {
//             Navigator.pushNamed(context, AppRoutes.help);
//           }),
//           const Spacer(),
//           ListTile(
//             leading: Icon(Icons.logout, color: AppColor.red),
//             title: AppText(
//               text: "Log out",
//               color: AppColor.red,
//               fontWeight: FontWeight.w400,
//               fontSize: 16,
//             ),
//             onTap: () {
//               // Handle log out
//             },
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(String icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Image.asset(icon, height: 30, width: 30, color: AppColor.black),
//       title: AppText(
//         text: title,
//         fontWeight: FontWeight.w600,
//         fontSize: 14,
//         color: AppColor.black,
//       ),
//       onTap: onTap,
//     );
//   }
// }
