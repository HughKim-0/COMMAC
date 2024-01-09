import 'dart:typed_data';

import 'package:command_accepted/Functions/auth_method.dart';
import 'package:command_accepted/Responsive/mobile_screen_layout.dart';
import 'package:command_accepted/Responsive/responsive_layout_screen.dart';
import 'package:command_accepted/Responsive/tablet_screen_layout.dart';
import 'package:command_accepted/Screens/login_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:command_accepted/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _isPasswordEightLetters = false;
  bool _oneNumberPassword = false;
  bool _confirmPassword = false;
  bool _isPasswordShown1 = false;
  bool _isPasswordShown2 = false;

  onConfirmPasswordChanged(String password) {
    // no space
    _confirmPasswordController.text = password;
    _confirmPasswordController.selection =
        TextSelection.collapsed(offset: _confirmPasswordController.text.length);

    setState(() {
      _confirmPassword = false;
      if (password == _passwordController.text) {
        _confirmPassword = true;
      }
    });
  }

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9;]');

    // no space
    _passwordController.text = password;
    _passwordController.selection =
        TextSelection.collapsed(offset: _passwordController.text.length);

    setState(() {
      _isPasswordEightLetters = false;
      if (password.length >= 8 && password.length <= 20) {
        _isPasswordEightLetters = true;
      }

      _oneNumberPassword = false;
      if (numericRegex.hasMatch(password)) {
        _oneNumberPassword = true;
      }
      _confirmPassword = false;
      if (password == _confirmPasswordController.text) {
        _confirmPassword = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = 'Error';
    if (_emailController.text == "" || _passwordController.text == "") {
      result = 'Please fill out all fields';
      Fluttertoast.showToast(msg: result);
    } else if (!_isPasswordEightLetters) {
      result = 'Password must have minimum 8 letters';
      Fluttertoast.showToast(msg: result);
    } else if (!_oneNumberPassword) {
      result = 'Password must have a number';
      Fluttertoast.showToast(msg: result);
    } else if (!_confirmPassword) {
      result = 'Confirm password wasn\'t matched with password';
      Fluttertoast.showToast(msg: result);
    } else {
      String response = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
      );

      if (response != 'Success') {
        showSnackBar(response, context);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      tabletScreenLayout: tabletScreenLayout(),
                    )),
            (Route<dynamic> route) => false);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text('COMAC', style: Theme.of(context).textTheme.headlineLarge),
            Text('Command Accepted',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 35),
            const SizedBox(height: 20),
            TextField(
              controller: _userNameController,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                labelText: 'Name',
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
              controller: _emailController,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                labelText: 'Email',
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
              obscureText: !_isPasswordShown1,
              autocorrect: false,
              obscuringCharacter: "•",
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: highlightColor,
                ),
                hintStyle: TextStyle(
                  color: highlightColor,
                ),
              ),
              onChanged: (value) =>
                  onPasswordChanged(_passwordController.text.trim()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              style: Theme.of(context).textTheme.headlineSmall,
              obscureText: !_isPasswordShown2,
              autocorrect: false,
              obscuringCharacter: "•",
              decoration: InputDecoration(
                labelText: 'Confirm password',
                labelStyle: TextStyle(
                  color: highlightColor,
                ),
                hintStyle: TextStyle(
                  color: highlightColor,
                ),
              ),
              onChanged: (value) => onConfirmPasswordChanged(
                  _confirmPasswordController.text.trim()),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: signUpUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: highlightColor,
                        ),
                      )
                    : Text('Sign up',
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
                  child: Text("Do you have an account?",
                      style: Theme.of(context).textTheme.headlineSmall),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    child: Text("Log in",
                        style: Theme.of(context).textTheme.headlineSmall),
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
