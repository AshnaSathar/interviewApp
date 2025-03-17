import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/textstyle_constants.dart';
import 'package:flutter_application_1/controller/authController.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Register",
          style: TextStyles.h5.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              // Profile Image
              Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/interview.jpeg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Name Field
              _buildTextField(_nameController, "Name", Icons.person),
              SizedBox(height: 10),
              // Email Field
              _buildTextField(_emailController, "Email", Icons.email),
              SizedBox(height: 10),
              // Password Field
              _buildPasswordField(_passwordController, "Password"),
              SizedBox(height: 10),
              // Confirm Password Field
              _buildPasswordField(
                  _confirmPasswordController, "Confirm Password",
                  isConfirmField: true),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: authProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) {
                    _showSnackBar("Name is required!");
                    return;
                  }
                  if (_emailController.text.trim().isEmpty ||
                      !_isValidEmail(_emailController.text.trim())) {
                    _showSnackBar("Enter a valid email!");
                    return;
                  }
                  if (_passwordController.text.trim().length < 6) {
                    _showSnackBar("Password must be at least 6 characters!");
                    return;
                  }
                  if (_passwordController.text.trim() !=
                      _confirmPasswordController.text.trim()) {
                    _showSnackBar("Passwords do not match!");
                    return;
                  }
                  authProvider.registerUser(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                    _nameController.text.trim(),
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }

  // Show SnackBar for errors
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Custom TextField Widget
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Custom Password Field with Toggle Visibility
  Widget _buildPasswordField(
    TextEditingController controller,
    String label, {
    bool isConfirmField = false,
  }) {
    return TextField(
      controller: controller,
      obscureText:
          isConfirmField ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, color: Colors.red),
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmField
                ? (_isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off)
                : (_isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (isConfirmField) {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
