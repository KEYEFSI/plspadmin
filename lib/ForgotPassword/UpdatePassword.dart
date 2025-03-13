import 'package:plsp/ForgotPassword/forgotcontroller.dart';
import 'package:plsp/Login/login.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Update extends StatefulWidget {
  final String username;

  const Update({super.key, required this.username});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> with SingleTickerProviderStateMixin {
  final UpdatePasswordController _controller = UpdatePasswordController();
  late FocusNode _passwordFocus;
  late FocusNode _ConfirmpasswordFocus;
  late TextEditingController _passwordController;
  late TextEditingController _ConfirmpasswordController;
  bool _isLoading = false;

  bool _passwordVisibility = false;
  bool get passwordVisibility => _passwordVisibility;

  set passwordVisibility(bool value) {
    _passwordVisibility = value;
  }

  bool _ConfirmpasswordVisibility = false;
  bool get ConfirmpasswordVisibility => _ConfirmpasswordVisibility;

  set ConfirmpasswordVisibility(bool value) {
    _ConfirmpasswordVisibility = value;
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _ConfirmpasswordController = TextEditingController();
    _passwordFocus = FocusNode();
    _ConfirmpasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  void _checkPassword() async {
    if (_passwordController.text != _ConfirmpasswordController.text) {
      _showErrorMessage('Oops!', "Password Mismatch");
    } else if (!validatePassword(_passwordController.text)) {
      _showErrorMessage(
          'Oops','Password must be at least 8 characters long and include an uppercase letter, a number, and a special character');
      _isLoading = false;
    } else {
      await _handleUpdatePassword();
    }
  }

  Future<void> _handleUpdatePassword() async {
    final username = widget.username; // Ensure widget.username is accessible
    final newPassword = _passwordController.text;

    final result = await _controller.updatePassword(
        username, newPassword); // Ensure this method is defined

    setState(() {
      if (result.error != null) {
        _showErrorMessage('Oh no!', result.error!);
      } else {
        _showSuccessMessage('Yey!', result.message!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginWidget()), // Ensure LoginWidget is correctly defined
        );
      }
    });
  }

  void _showSuccessMessage(String message, String details) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 11,
        duration: Duration(seconds: 2),
        content: Container(
          height: height / 9,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(children: [
            Lottie.asset('assets/success.json', fit: BoxFit.contain),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Success!',
                    style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                        fontSize: fontsize / 80, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            )
          ]),
        )));
  }

  void _showErrorMessage(String message, String details) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 11,
          duration: Duration(seconds: 2),
          content: Container(
            height: height / 9,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(children: [
              Lottie.asset('assets/error.json', fit: BoxFit.contain),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      details,
                      style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              )
            ]),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundlogin.jpg'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: fontsize / 8,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 20, horizontal: fontsize / 80),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: fontsize / 3.0),
                    padding: EdgeInsets.symmetric(
                        vertical: height / 20, horizontal: fontsize / 80),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Theme.of(context).primaryColor,
                          offset: const Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(fontsize / 80.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Update Your Password',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.bold,
                            )),
                        Gap(height / 80),
                        Text(
                          "Let's get your password updated.",
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Gap(height / 80),
                        Container(
                          height: height / 20,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 80,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              prefixIcon: Icon(
                                MaterialCommunityIcons.shield_key,
                                color: Colors.green.shade900,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(() {
                                  _passwordVisibility = !_passwordVisibility;
                                }),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                    _passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: fontsize / 80),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize / 80),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a document name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Gap(height / 100),
                        Container(
                          height: height / 20,
                          child: TextFormField(
                            controller: _ConfirmpasswordController,
                            obscureText: !_ConfirmpasswordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 80,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              prefixIcon: Icon(
                                MaterialCommunityIcons.shield_key,
                                color: Colors.green.shade900,
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(() {
                                  _ConfirmpasswordVisibility =
                                      !_ConfirmpasswordVisibility;
                                }),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                    _ConfirmpasswordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: fontsize / 80),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize / 80),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a document name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Gap(height / 100),
                        _isLoading
                            ? Lottie.asset('assets/Loading.json',
                                fit: BoxFit.contain)
                            : Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _checkPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFF006400), // Dark green
                                    padding: EdgeInsets.symmetric(
                                        vertical: fontsize / 80,
                                        horizontal: height / 42),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Continue',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: fontsize / 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
