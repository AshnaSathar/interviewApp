import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/view/users/custom_pages/email_verification.dart';
import 'package:flutter_application_1/view/users/home_page.dart';
import 'package:flutter_application_1/view/users/registration_page.dart';
// import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Container(
            //   height: height,
            //   width: width,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       transform: GradientRotation(1.5),
            //       colors: [
            //         ColorConstants.primaryColor,
            //         ColorConstants.secondaryColor
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              width: width,
              height: height,
              child: Image.asset(
                "/Users/ashnasathar/interviewApp/flutter_application_1/assets/images/wallpaper.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: [
                Container(
                  width: width,
                  height: height / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.forum, color: Colors.black),
                            SizedBox(width: 10),
                            Text("Interview",
                                style: TextStyles.h1
                                    .copyWith(color: Colors.black)),
                          ],
                        ),
                        Text("Your path to the perfect job starts here!",
                            style: TextStyle(
                                fontFamily: 'Sigmar',
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                shadows: [
                                  Shadow(
                                    offset: Offset(3, 3),
                                    blurRadius: 8,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ])),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text("Email", style: TextStyles.normalText),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _controller.emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyles.normalText,
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text("Password", style: TextStyles.normalText),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _controller.passwordController,
                          obscureText: _controller.obscureText,
                          style: TextStyle(),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyles.normalText,
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _controller.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.toggleObscureText();
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  value: _controller.rememberMe,
                                  activeColor: ColorConstants.secondaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.rememberMe = value;
                                    });
                                  },
                                ),
                                Text("Remember me", style: TextStyle()),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/forget_password');
                              },
                              child:
                                  Text("Forgot Password?", style: TextStyle()),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: height * .1,
                            width: width,
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (!_controller.isLoading) {
                                    setState(() {
                                      _controller.isLoading = true;
                                    });

                                    String? role = await _controller.login();
                                    if (role != null) {
                                      if (role == 'admin' && context.mounted) {
                                        context.push('/admin-dashboard');
                                      } else if (role == 'user' &&
                                          context.mounted) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(_controller.errorMessage)),
                                      );
                                    }

                                    setState(() {
                                      _controller.isLoading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  height: height * .06,
                                  width: width,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white38),
                                    color:
                                        const Color.fromARGB(255, 255, 179, 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: _controller.isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.amber)
                                      : Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyles.h6.copyWith(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle()),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ));
                                  // context.push('/registration');
                                },
                                child: Text("Sign Up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
