// import 'package:studentapp/Graduates/Graduatesnav.dart';
// import 'package:studentapp/Is/Isnav.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:plsp/FinanceAdmin/FinanceAdminNav/SuperAdminNav.dart';
import 'package:plsp/ISADMIN/ISNav/SuperAdminNav.dart';
import 'package:plsp/Login/logincontroller.dart';
import 'package:plsp/Login/loginmodel.dart';
import 'package:plsp/RegistrarsAdmin/RegistrarsNav/RegistrarsAdminNav.dart';
import 'package:plsp/SuperAdmin/SuperAdminNav/SuperAdminNav.dart';
import 'package:plsp/SuperAdminRegistrar/RegistrarsNav/RegistrarsAdminNav.dart';
import 'package:plsp/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>
    with SingleTickerProviderStateMixin {
  late LoginModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailAddressTextController =
      TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final LoginController _loginController = LoginController();
  LoginController loginController = Get.put(LoginController());

  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
    _model.emailAddressTextController = TextEditingController();
    _model.emailAddressFocusNode = FocusNode();
    _model.passwordTextController = TextEditingController();
    _model.passwordFocusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _model.emailAddressTextController?.dispose();
    _model.emailAddressFocusNode?.dispose();
    _model.passwordTextController?.dispose();
    _model.passwordFocusNode?.dispose();
    _model.unfocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

 void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    player.play(AssetSource('success.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 7,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade700,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/success.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Awesome!,',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showErrorMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    // Play sound
    player.play(AssetSource('Error.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/error.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Oh snap!',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
  Future<void> handleLogin() async {
    if (emailAddressTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      _showErrorMessage('Please fill out both fields.');
      return;
    }

    String username = emailAddressTextController.text.trim();
    String password = passwordTextController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic>? result =
          await _loginController.loginUser(username, password);

      setState(() {
        _isLoading = false;
        if (result.containsKey('error')) {
          _showErrorMessage(result['error']);
        } else {
          _showSuccessMessage('Login Successful');
          String userType = result['usertype'];

          switch (userType) {
            case 'Super Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SuperAdminNav(username: username)),
              );
              break;
            case 'Finance Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FinanceAdminNav(
                          username: username ?? '',
                        )),
              );
              break;
            case 'Registrar Super Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrarsSuperAdminNav(
                          username: username,
                        )),
              );
              break;
            case 'Registrars Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrarAdminNav(
                          username: username,
                        )),
              );
              break;
 case 'IS Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => IsAdminNav(
                          username: username,
                        )),
              );
              break;

              
            default:
              _showErrorMessage('Invalid user type. Please contact support.');
              break;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showErrorMessage(
            'Access Denied, The credentials you entered are invalid. Please check your email and password and try again');
      });
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: fontsize / 8,
                child: Image.asset(
                  'assets/logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height / 20, horizontal: fontsize / 80),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: fontsize / 3),
                    padding: EdgeInsets.symmetric(
                        vertical: height / 20, horizontal: fontsize / 80),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Theme.of(context).primaryColor,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(fontsize / 80),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Welcome! ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.bold,
                            )),
                        Gap(fontsize / 120),
                        Text(
                          'Fill out the information below in order to access your account.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Gap(fontsize / 120),
                        TextField(
                          controller: emailAddressTextController,
                          focusNode: _model.emailAddressFocusNode,
                          autofillHints: const [AutofillHints.username],
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Admin ID',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 120,
                              color: primarytext,
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).cardColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: false,
                            fillColor: Theme.of(context).primaryColorLight,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                              size: fontsize / 80,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Gap(fontsize / 120),
                        TextFormField(
                          controller: passwordTextController,
                          focusNode: _model.passwordFocusNode,
                          autofillHints: const [AutofillHints.password],
                          obscureText: !_model.passwordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 120,
                              color: Theme.of(context).hoverColor,
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).cardColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: false,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            prefixIcon: Icon(
                              Icons.security_sharp,
                              color: Theme.of(context).primaryColor,
                              size: fontsize / 80,
                            ),
                            suffixIcon: InkWell(
                              onTap: () => setState(() {
                                _model.passwordVisibility =
                                    !_model.passwordVisibility;
                              }),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).primaryColor,
                                size: fontsize / 80,
                              ),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(fontsize / 120),
                        if (_isLoading)
                          SizedBox(
                            height: fontsize / 24,
                            child: Lottie.asset('assets/Loading.json',
                                fit: BoxFit.contain),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: height / 20,
                            child: ElevatedButton(
                              onPressed: handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF006400), // Dark green

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Log in',
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
              
            ],
          ),
        ),
      ),
    );
  }
}
