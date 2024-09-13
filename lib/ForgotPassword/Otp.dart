// import 'package:studentapp/Graduates/Graduatesnav.dart';
// import 'package:studentapp/Is/Isnav.dart';
import 'package:plsp/ForgotPassword/UpdatePassword.dart';
import 'package:plsp/ForgotPassword/forgotcontroller.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTP extends StatefulWidget {
  final String username;

  const OTP({super.key, required this.username});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> with SingleTickerProviderStateMixin {

  final VerifyTokenController _controller = VerifyTokenController();
  bool _isLoading = false;

  final TextEditingController _pin1Controller = TextEditingController();
  final TextEditingController _pin2Controller = TextEditingController();
  final TextEditingController _pin3Controller = TextEditingController();
  final TextEditingController _pin4Controller = TextEditingController();
  final TextEditingController _pin5Controller = TextEditingController();
  final TextEditingController _pin6Controller = TextEditingController();






  @override
  void initState() {
    super.initState();

   
  }

  @override
  void dispose() {
         _pin1Controller.dispose();
    _pin2Controller.dispose();
    _pin3Controller.dispose();
    _pin4Controller.dispose();
    _pin5Controller.dispose();
    _pin6Controller.dispose();
    super.dispose();
  }

   void _handleVerifyToken() async {
    // Concatenate the values of the token fields
    final token = _pin1Controller.text +
        _pin2Controller.text +
        _pin3Controller.text +
        _pin4Controller.text +
        _pin5Controller.text +
        _pin6Controller.text;

    // Show loading spinner
    setState(() {
      _isLoading = true;
    });

    // Call the verify token method
    final result = await _controller.verifyToken(token);

    setState(() {
      _isLoading = false; 
      if (result.error != null) {
        _showErrorMessage('Oh snap!', result.error!);
      } else {
        _showSuccessMessage('Success', result.message!);
   Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Update(
                          username: widget.username,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100), // Added some spacing from top
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
                    constraints:  BoxConstraints(maxWidth:fontsize/3),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Verification Code',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.bold,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 68),
                          child: Text(
                            'We have sent the verification code to your email',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 120,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                controller: _pin1Controller,
                                onSaved: (pin1) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                    hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height: fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                  controller: _pin2Controller,
                                 onSaved: (pin2) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                    hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height: fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                controller: _pin3Controller,
                                 onSaved: (pin3) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                    hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height: fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                controller: _pin4Controller,
                                 onSaved: (pin4) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                    hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height:fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                controller: _pin5Controller,
                                 onSaved: (pin5) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                    hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                            SizedBox(
                              height: fontsize / 32,
                              width: fontsize / 32,
                              child: TextFormField(
                                controller: _pin6Controller,
                                 onSaved: (pin6) {},
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300,
                                    fontSize: fontsize/80
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(height / 80),
                        if (_isLoading)
                          Lottie.asset('assets/Loading.json',
                              fit: BoxFit.contain)
                        else
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleVerifyToken,
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
              // Added some spacing from bottom
            ],
          ),
        ),
      ),
    );
  }
}
