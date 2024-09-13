import 'package:plsp/Login/login.dart';
import 'package:plsp/Register/registercontroller.dart';
import 'package:plsp/Register/registermodel.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/animation.dart';

class AdminType extends StatefulWidget {
  final String firstname;
  final String middlename;
  final String lastname;
  final String email;
  final DateTime birthday;
  final String number;
  final String address;

  const AdminType(
      {super.key,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.email,
      required this.birthday,
      required this.number,
      required this.address});

  @override
  State<AdminType> createState() => _AdminTypeState();
}

class _AdminTypeState extends State<AdminType>
    with SingleTickerProviderStateMixin {
  late RegisterModel _model;
  
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get passwordVisibility => _passwordVisibility;
  bool _passwordVisibility = false;
  set passwordVisibility(bool value) {
    _passwordVisibility = value;
  }

  bool get confirmpasswordVisibility => _confirmpasswordVisibility;
  bool _confirmpasswordVisibility = false;
  set confirmpasswordVisibility(bool value) {
    _confirmpasswordVisibility = value;
  }

  String? _selectedOption;
  late TextEditingController _studentidController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmpasswordController;
  var valuechoose;

  var newValue = TextEditingController();
   final AdminController _studentController = AdminController();



  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    ;

    _studentidController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmpasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _model.emailAddressTextController?.dispose();
    _model.emailAddressFocusNode?.dispose();
    _model.fullnameFocusNode?.dispose();
  }

  void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 11,
        duration:  Duration(seconds: 2),
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
                    'Almost done! !',
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

 



   void _registerStudent() async {

    final String fullname = '${widget.firstname} ${widget.middlename} ${widget.lastname}';


    final student = Admin(
      fullname: fullname,
      firstName: widget.firstname,
      middleName: widget.middlename,
      lastName: widget.lastname,
      username: _studentidController.text,
      password: _passwordController.text,
      usertype: _selectedOption!,
      address: widget.firstname,
      number: widget.firstname,
      birthday:widget.birthday,
      gmail: widget.email,
    );

    bool success = await _studentController.registerAdmin(student);

    if (success) {
    _showSuccessMessage('Registered Successfully');
       _isLoading = false;
        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginWidget()),
                      );

    } else {
    _showErrorMessage('Registration Failed');
       _isLoading = false;
    }
  }


  void _showErrorMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 11,
          duration:  Duration(seconds: 2),
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
                      'Oh snap!',
                      style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      message,
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
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgroundlogin.jpg'),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: fontsize / 80),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Ionicons.arrow_back_outline,
                        color: Colors.white,
                        size: fontsize / 80,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: fontsize / 8,
                  
                    fit: BoxFit.contain,
                  ),
                ),
                Gap(height / 40),
                Container(
                  constraints: BoxConstraints(maxWidth: fontsize/3),
                  padding: const EdgeInsets.all(24.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Theme.of(context).primaryColor,
                        offset: const Offset(0.0, 2.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's your admin information?",
                        
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Theme.of(context).hoverColor,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 1,
                          letterSpacing: 0
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: fontsize/120.0),
                        child: Text(
                          'Please enter your Admin ID, create a secure password, and select your admin type',
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 80,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Gap(height / 80),
                      Container(
                          height: height/20,
                        child: TextFormField(
                          controller: _studentidController,
                          decoration: InputDecoration(
                            labelText: 'Admin ID',
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
                              MaterialCommunityIcons.account_tie,
                              color: Colors.green.shade900,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize / 80),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the First Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(height / 80),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisibility,
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
                                _passwordVisibility = !_passwordVisibility;
                              }),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).primaryColor,
                                size: fontsize/ 80
                              ),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize / 80,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(height / 82),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _confirmpasswordController,
                          obscureText: !_confirmpasswordVisibility,
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
                                _confirmpasswordVisibility = !_confirmpasswordVisibility;
                              }),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _confirmpasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).primaryColor,
                                size: fontsize/ 80
                              ),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: fontsize / 80,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(height / 82),
                      Container(
                        height: height / 20,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Admin Type',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
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
                              MaterialCommunityIcons.account_question,
                              color: Colors.green.shade900,
                              size: fontsize/ 80
                            ),
                          ),
                          dropdownColor: Colors.white,
                          value: _selectedOption,
                          items: [
                            'Super Admin',
                            'Finance Admin',
                            'Registrars Admin'
                          ].map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize / 100,
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                                selectionColor: Colors.transparent,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOption = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an admin type';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(height / 34),
                         _isLoading ? Lottie.asset('assets/Loading.json',
                      fit: BoxFit.contain): Container(
                        height: height / 20,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _registerStudent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: Icon(
                            MaterialCommunityIcons.account_check,
                            size: fontsize/ 80,
                            color: Colors.white,
                          ),
                          label: Text(
                           'Register',
                               
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginWidget()),
                      );
                    },
                    child: Text(
                      "I already have an account",
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
