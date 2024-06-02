import 'package:chat/themes/dark.dart';
import 'package:chat/themes/light.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/settings_screen.dart';
import 'package:chat/screens/users_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/main_screen.dart';
import 'package:chat/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWidget(MainScreen(), LoginScreen()),
        '/login': (context) => const AuthWidget(MainScreen(), LoginScreen()),
        '/register': (context) =>
            const AuthWidget(MainScreen(), RegisterScreen()),
        '/settings': (context) =>
            const AuthWidget(SettingsScreen(), LoginScreen()),
        '/chat': (context) => AuthWidget(
              ChatScreen(
                (ModalRoute.of(context)!.settings.arguments as List)[0],
                (ModalRoute.of(context)!.settings.arguments as List)[1],
                (ModalRoute.of(context)!.settings.arguments as List)[2],
              ),
              const LoginScreen(),
              requireArguments: true,
            ),
        '/users': (context) => const AuthWidget(UsersScreen(), LoginScreen()),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWidget extends StatelessWidget {
  final Widget authenticatedScreen;
  final Widget unauthenticatedScreen;
  final bool requireArguments;

  const AuthWidget(this.authenticatedScreen, this.unauthenticatedScreen,
      {this.requireArguments = false, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Auth.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          return const ErrorWidget("An error occurred.");
        } else if (snapshot.hasData && snapshot.data!) {
          if (requireArguments) {
            final arguments = ModalRoute.of(context)?.settings.arguments;
            if (arguments == null) {
              return const LoginScreen();
            }
          }
          return authenticatedScreen;
        } else {
          return unauthenticatedScreen;
        }
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  const ErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
