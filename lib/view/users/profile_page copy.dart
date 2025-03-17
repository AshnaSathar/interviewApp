// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/constants/color_constants.dart';
// import 'package:flutter_application_1/view/users/edit_profile_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String name = "Ashna Sathar";
//   String email = "ashnasathar@gmail.com";
//   String dob = "January 25, 2000";
//   String mobile = "+91 8848687997";
//   String profileImage =
//       '/Users/ashnasathar/recipeApp/flutter_application_1/assets/AMP_imghappy-girl-taking-a-selfie_5f4a2e4438bf3.jpeg';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorConstants.primaryColor,
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               final updatedData = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditProfilePage(
//                     name: name,
//                     email: email,
//                     dob: dob,
//                     mobile: mobile,
//                     profileImage: profileImage,
//                     designation: '',
//                   ),
//                 ),
//               );

//               if (updatedData != null) {
//                 setState(() {
//                   name = updatedData["name"];
//                   email = updatedData["email"];
//                   dob = updatedData["dob"];
//                   mobile = updatedData["mobile"];
//                   profileImage = updatedData["profileImage"] ?? profileImage;
//                 });
//               }
//             },
//             child: const Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Text(
//                 "Edit Profile",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           double screenWidth = constraints.maxWidth;
//           double avatarRadius = screenWidth * 0.18;

//           if (avatarRadius > 100) avatarRadius = 100;

//           double fontSize = screenWidth < 400 ? 16 : 22;
//           double padding = screenWidth < 400 ? 12 : 16;

//           return Padding(
//             padding: EdgeInsets.all(padding),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: avatarRadius,
//                       backgroundImage: profileImage.startsWith('assets/')
//                           ? AssetImage(profileImage) as ImageProvider
//                           : FileImage(File(profileImage)),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     buildProfileInfo(Icons.email, email, fontSize),
//                     buildProfileInfo(Icons.calendar_today, dob, fontSize),
//                     buildProfileInfo(Icons.phone, mobile, fontSize),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildProfileInfo(IconData icon, String text, double fontSize) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blueAccent),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(fontSize: fontSize),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
