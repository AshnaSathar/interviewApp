import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/resgister_controller.dart';
import 'package:flutter_application_1/view/users_pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/view/users/custom_pages/custom_text_field.dart';
import 'package:flutter_application_1/view/users/custom_pages/elevated_button.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime? selectedDOB;
  String verificationMessage = "";
  bool showResendButton = false;
  Timer? emailCheckTimer;

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to check if the user's email is verified.
    emailCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reload the user data to get the latest status.
        await user.reload();
        if (user.emailVerified) {
          timer.cancel();
          // Email is verified, register the user in Firestore.
          await Provider.of<RegisterController>(context, listen: false)
              .registerUserToRoles(
            email: emailController.text.trim(),
            username: usernameController.text.trim(),
          );
          // Navigate to the login page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    emailCheckTimer?.cancel();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width,
              child: Image.asset("assets/images/interview.jpeg"),
            ),
            Text(
              "Welcome to Interview App",
              style: TextStyles.h4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                label: "Email",
                controller: emailController,
                icon: Icons.email,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                label: "Username",
                controller: usernameController,
                icon: Icons.person,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                label: "Password",
                controller: passwordController,
                icon: Icons.lock,
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                label: "Confirm Password",
                controller: confirmPasswordController,
                icon: Icons.lock,
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  selectedDOB == null
                      ? "Select Date of Birth"
                      : "DOB: ${selectedDOB!.toLocal()}".split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDOB = pickedDate;
                    });
                  }
                },
              ),
            ),
            if (verificationMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  verificationMessage,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            if (showResendButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  label: "Resend Verification Email",
                  onPressed: () async {
                    await Provider.of<RegisterController>(context,
                            listen: false)
                        .resendVerificationEmail();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification email resent!"),
                      ),
                    );
                  },
                  color: Colors.blue,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                label: "Verify",
                onPressed: () async {
                  if (selectedDOB == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select your DOB!")),
                    );
                    return;
                  }
                  String email = emailController.text.trim();
                  String username = usernameController.text.trim();
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  String result = await Provider.of<RegisterController>(context,
                          listen: false)
                      .checkAndRegisterUser(
                    email: email,
                    username: username,
                    password: password,
                    confirmPassword: confirmPassword,
                    dob: selectedDOB!,
                  );

                  setState(() {
                    verificationMessage = result;
                    showResendButton = result.contains("not verified") ||
                        result.contains("Verification email sent");
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result)));
                },
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
