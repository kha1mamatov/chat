import 'package:chat/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/services/api_service.dart';
import 'package:chat/services/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
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
            SizedBox(height: size.height * 0.14),
            const Text(
              "WELCOME!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 37,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            myTextField(
                "Enter username", Colors.white, usernameController, false),
            myTextField("Password", Colors.black26, passwordController, true),
            myTextField("Confirm the password", Colors.black26,
                passwordController2, true),
            const SizedBox(height: 10),
            SizedBox(height: size.height * 0.08),
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
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final validate = await UsernameValidator().validator(
                        usernameController.text,
                        passwordController.text,
                        passwordController2.text,
                      );
                      if (validate == null) {
                        final result = await apiService.register(
                          usernameController.text,
                          passwordController.text,
                        );

                        if (result['status'] == 'success') {
                          await Auth.saveUserId(result['user_id']);
                          await Navigator.pushReplacementNamed(context, '/');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'])),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validate)),
                        );
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.10),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: Text.rich(
                      TextSpan(
                        text: "Already a member? ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign in here",
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
          hintStyle: TextStyle(
            color: hintColor,
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
