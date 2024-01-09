import 'package:command_accepted/Functions/auth_method.dart';
import 'package:command_accepted/Functions/notification_service.dart';
import 'package:command_accepted/Responsive/mobile_screen_layout.dart';
import 'package:command_accepted/Responsive/responsive_layout_screen.dart';
import 'package:command_accepted/Responsive/tablet_screen_layout.dart';
import 'package:command_accepted/Screens/sign_up_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/global_variables.dart';
import 'package:command_accepted/Utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isPasswordShown = false;
  static final notifications = NotificationsService();
  // @override
  // void dispose() {
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'Success') {
      await notifications.requestPermission();
      await notifications.getToken();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              tabletScreenLayout: tabletScreenLayout(),
            ),
          ),
          (Route<dynamic> route) => false);
    } else {
      //
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: MediaQuery.of(context).size.width > phoneSize
            ? const EdgeInsets.only(right: 400, left: 400)
            : const EdgeInsets.only(right: 20, left: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 180),
              Text('COMAC', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 1),
              Text('Command Accepted',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 50),
              TextField(
                controller: _emailController,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(
                    color: highlightColor,
                  ),
                  hintStyle: TextStyle(
                    color: highlightColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                style: Theme.of(context).textTheme.headlineSmall,
                autocorrect: false,
                obscuringCharacter: "•",
                obscureText: !_isPasswordShown,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: highlightColor,
                  ),
                  hintStyle: TextStyle(
                    color: highlightColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: highlightColor,
                          ),
                        )
                      : Text('Log in',
                          style: Theme.of(context).textTheme.headlineSmall),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?",
                        style: Theme.of(context).textTheme.headlineSmall),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text(
                        "Sign up",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
