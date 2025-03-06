import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString("email");
    String? password = prefs.getString("password");

    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      context.push('/login');
    } else {
      context.push('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Container(
          //   height: height,
          //   width: width,
          //   decoration: BoxDecoration(
          //       gradient:
          //           LinearGradient(transform: GradientRotation(1.5), colors: [
          //     ColorConstants.primaryColor,
          //     ColorConstants.primaryColor,
          //     const Color.fromARGB(255, 27, 73, 165),
          //   ])),
          // ),
          Container(
            child: Image.asset(
              "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/laptop_wallpaper.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height / 2,
                      width: width,
                      child: Column(
                        children: [
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.forum,
                                color: ColorConstants.primaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Interview",
                                  style: TextStyle(
                                      fontFamily: 'Sigmar',
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 8,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ]))
                            ],
                          ),
                          Text(
                            "Master Every Interview with Confidence",
                            style: TextStyle(
                              fontFamily: 'Sigmar',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              shadows: [
                                // Shadow(
                                // offset: Offset(3, 3),
                                // blurRadius: 8,
                                // color: Colors.white.withOpacity(0.5),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => _checkLoginStatus(),
                              child: Container(
                                height: height * .05,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorConstants.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.3), // Slightly transparent shadow
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0,
                                          3), // Horizontal and vertical offset
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Get In",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
