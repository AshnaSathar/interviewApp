import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/color_constants.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
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
    // _controller.loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  transform: GradientRotation(1.5),
                  colors: [
                    ColorConstants.primaryColor,
                    ColorConstants.secondaryColor
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: width,
                  height: height / 3,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum, color: Colors.white),
                        SizedBox(width: 10),
                        Text("Interview",
                            style: TextStyles.h1.copyWith(color: Colors.white)),
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
                        Text("Email",
                            style: TextStyles.normalText
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 15),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _controller.emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyles.normalText
                                .copyWith(color: Colors.white),
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text("Password",
                            style: TextStyles.normalText
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _controller.passwordController,
                          obscureText: _controller.obscureText,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyles.normalText
                                .copyWith(color: Colors.white),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _controller.obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
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
                                Text("Remember me",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/forget_password');
                              },
                              child: Text("Forgot Password?",
                                  style: TextStyle(color: Colors.white)),
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
                                        context.push('/home');
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: _controller.isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyles.h6.copyWith(
                                              color:
                                                  ColorConstants.primaryColor,
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
                                  style: TextStyle(color: Colors.white)),
                              TextButton(
                                onPressed: () {
                                  context.push('/registration');
                                },
                                child: Text("Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
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
