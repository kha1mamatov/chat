import 'package:chat/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.18),
            const Text(
              "WELCOME!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 37,
              ),
            ),
            SizedBox(height: size.height * 0.14),
            myTextField("Enter username", Colors.white, emailController, false),
            myTextField("Password", Colors.black26, passwordController, true),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Recovery Password               ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final result = await apiService.login(
                        emailController.text,
                        passwordController.text,
                      );

                      if (result['status'] == 'success') {
                        await Auth.saveUserId(result['user_id'].toString());
                        await Navigator.pushReplacementNamed(context, '/');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.10),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                    child: Text.rich(
                    TextSpan(
                      text: "Not a member? ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "Register now",
                          style: TextStyle(
                            color: linkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container myTextField(String hint, Color color,
      TextEditingController controller, bool isPassword) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !isPasswordVisible : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 19,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: color,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
