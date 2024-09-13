// import 'package:studentapp/Graduates/Graduatesnav.dart';
// import 'package:studentapp/Is/Isnav.dart';

import 'package:plsp/FinanceAdmin/FinanceAdminNav/SuperAdminNav.dart';
import 'package:plsp/ForgotPassword/forgot.dart';
import 'package:plsp/Login/logincontroller.dart';
import 'package:plsp/Login/loginmodel.dart';
import 'package:plsp/Register/register.dart';
import 'package:plsp/RegistrarsAdmin/RegistrarsNav/RegistrarsAdminNav.dart';
import 'package:plsp/SuperAdmin/SuperAdminNav/SuperAdminNav.dart';
import 'package:plsp/Theme/button.dart';
import 'package:plsp/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/animation.dart';
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
  final String _errorMessage = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;

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

    _bounceAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: 1.seconds,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
          print('Username: $username');
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
            case 'Registrars Admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrarAdminNav(
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
      print('Error during login: $e');
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
    return  SafeArea(
        child: Scaffold(
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
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          Container(
                     width: fontsize/8,
                      
                    child: Image.asset(
                      'assets/logo.jpg',
                    
                      fit: BoxFit.contain,
                    ),
                                     ),     
                   
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height/20, horizontal: fontsize/80),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: fontsize/3),
                          padding: EdgeInsets.symmetric(vertical: height/20, horizontal: fontsize/80),
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Theme.of(context).primaryColor,
                                offset: const Offset(0.0, 2.0),
                              ),
                            ],
                           
                            borderRadius: BorderRadius.circular(fontsize/80),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome! ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize/120,
                                  color: Theme.of(context).hoverColor,
                                  fontWeight: FontWeight.bold,)
                              ),
                              Gap(fontsize/120),
                              Text(
                                'Fill out the information below in order to access your account.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize/120,
                                  color: Theme.of(context).hoverColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                                    Gap(fontsize/120),
                              TextField(
                                controller: emailAddressTextController,
                                focusNode: _model.emailAddressFocusNode,
                                autofillHints: const [AutofillHints.username],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Finance ID',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize:fontsize/120,
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
                                    size: fontsize/80,
                                  ),
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize/120,
                                  color: Theme.of(context).hoverColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                                   Gap(fontsize/120),
                              TextFormField(
                                controller: passwordTextController,
                                focusNode: _model.passwordFocusNode,
                                autofillHints: const [AutofillHints.password],
                                obscureText: !_model.passwordVisibility,
                                
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.poppins(
                                     fontSize:fontsize/120,
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
                                    size: fontsize/80,
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
                                      size: fontsize/80,
                                    ),
                                    
                                  ),
                                  
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize/120,
                                  color: Theme.of(context).hoverColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gap(fontsize/120),
                               
                             
                              if (_isLoading)
                               Container(
                                 child: Lottie.asset('assets/Loading.json',
                                 fit: BoxFit.contain),
                                 height: fontsize/24,
                               )
                                
                              else
                               Container(
                        width: double.infinity,
                        height: height/20,
                        child: ElevatedButton(
                          onPressed:handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF006400), // Dark green
                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Log in',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: fontsize/80,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                                                  ),
                                     Gap(fontsize/120),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Don't have an account yet?",
                                      style: GoogleFonts.poppins(
                                        fontSize: fontsize/120,
                                        color: Theme.of(context).hoverColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(1.0, 0.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterWidget()),
                                            );
                                          },
                                          child: Text(
                                            "Register",
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize/120,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: GoogleFonts.poppins(
                                      fontSize: fontsize/120,
                                      color:
                                          Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                 
                  ],
                ),
              ),
            ),
          ),
        ),
    
    );
      
    
  }
}
