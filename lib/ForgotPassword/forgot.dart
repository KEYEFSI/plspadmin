// import 'package:studentapp/Graduates/Graduatesnav.dart';
// import 'package:studentapp/Is/Isnav.dart';
import 'package:plsp/ForgotPassword/Otp.dart';
import 'package:plsp/ForgotPassword/forgotcontroller.dart';
import 'package:plsp/Login/login.dart';
import 'package:plsp/Theme/theme.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {

       late FocusNode _studentidFocus;
  final TextEditingController _studentidController = TextEditingController();
  final ForgotPasswordController _controller = ForgotPasswordController();
   bool _isLoading = false;
  @override
  void initState() {
    super.initState();
   
    _studentidFocus = FocusNode();
    
  }

  @override
  void dispose() {
    
    super.dispose();
  }


void _handleForgotPassword() async {
     setState(() {
      _isLoading = true;
    });

  
  final username = _studentidController.text;
  final result = await _controller.sendPasswordResetRequest(username);

  setState(() {
    if (result.error != null) {
      // Show error message
      _showErrorMessage('Oh no!', result.error!);
         setState(() {
      _isLoading = false;
    });

    } else {
      // Show success message
      _showSuccessMessage('Success', result.message);
         setState(() {
      _isLoading = false;
    });

       Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => OTP(
                          username: username,
                        )),
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
          child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: fontsize/80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            
                 GestureDetector
                  
                        ( onTap:() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginWidget()),
                                              ); },
                         
                      child: Padding(
                        padding:  EdgeInsets.only(top: fontsize/80),
                        child: Align(alignment: Alignment.topLeft,
                          child: Icon(Ionicons.arrow_back_outline,
                          color: Colors.white,
                          size: fontsize/80,),
                        ),
                      ),
                    ),
                const SizedBox(height: 100), // Added some spacing from top
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: fontsize/8,
               
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height/20, horizontal: fontsize/80),
                  child: Align(
                    alignment: Alignment.center,
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
                          )
                        ],
                        borderRadius: BorderRadius.circular(fontsize/80.0),
                      ),
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find your account',
                          
                            style: GoogleFonts.poppins(
                              fontSize: fontsize/80,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.bold,)
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: height/68),
                            child: Text(
                              'Enter your student ID',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: fontsize/120,
                                color: Theme.of(context).hoverColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _studentidController,
                            focusNode: _studentidFocus,
                            autofillHints: const [AutofillHints.username],
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Student ID',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize/120,
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
                              fontSize: fontsize/80,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.w500,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                     
                          Gap(height/80),
                          _isLoading ?
                           Lottie.asset('assets/Loading.json',
                           fit: BoxFit.contain)
                            
                          :
                           Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                        
                        _handleForgotPassword,
                      
                      
                   
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006400), // Dark green
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
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
