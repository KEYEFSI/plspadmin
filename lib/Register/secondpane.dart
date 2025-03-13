import 'package:plsp/Login/login.dart';
import 'package:plsp/Register/StudentType.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


class SecondPane extends StatefulWidget {
  final String firstname;
  final String middlename;
  final String lastname;
  const SecondPane(
      {super.key,
      required this.firstname,
      required this.middlename,
      required this.lastname});

  @override
  State<SecondPane> createState() => _SecondPaneState();
}

class _SecondPaneState extends State<SecondPane>
    with SingleTickerProviderStateMixin {
  late TextEditingController _birthdayController;
  late TextEditingController _numberController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  DateTime? _selectedDate;
  bool _isLoading = false;

  String parseAndFormatDate(String birthdayText) {
    try {
      // Parse the text input into a DateTime object
      DateTime birthday = DateTime.parse(birthdayText);

      // Convert to local time
      DateTime localBirthday = birthday.toLocal();

      // Convert to ISO 8601 string
      return localBirthday.toIso8601String();
    } catch (e) {
      // Handle parsing error
      print("Error parsing date: $e");
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _birthdayController = TextEditingController();
    _numberController = TextEditingController();
    _addressController = TextEditingController();

    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleButtonPress(BuildContext context) {
    if (_emailController.text.isEmpty ||
        _birthdayController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _numberController.text.isEmpty) {
      // Show an error message
      _showErrorMessage('Please fill the information below');
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$')
        .hasMatch(_emailController.text)) {
      _showErrorMessage('Please fill in a correct Gmail address');
    } else {
      _showSuccessMessage('Now, could you provide your Student Information');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminType(
            firstname: widget.firstname,
            middlename: widget.middlename,
            lastname: widget.lastname,
            email: _emailController.text,
            birthday: _selectedDate!,
            number: _numberController.text,
            address: _addressController.text,
          ),
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 11,
        duration: Duration(seconds: 2),
        content: Container(
          height: height / 9,
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade700,
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
                    'Great!',
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

  void _showErrorMessage(String message) {
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
                    padding: EdgeInsets.only(top: fontsize / 80),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Ionicons.arrow_back_outline,
                        color: Colors.green.shade900,
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
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(height / 80),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500.0),
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
                        "What are your details?",
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Theme.of(context).hoverColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Could you provide me with your name, birthday, contact number, and address?',
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Gap(fontsize / 80),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _birthdayController,
                          decoration: InputDecoration(
                            labelText: 'Birthdate',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 80, // Adjust as needed
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
                              FontAwesome.birthday_cake,
                              color: Colors.green.shade900,
                              size: fontsize / 80,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                final datePicked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 365 * 100)),
                                  lastDate: DateTime.now()
                                      .add(Duration(days: 365 * 100)),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: Color(0xFF006400),
                                        buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        datePickerTheme: DatePickerThemeData(
                                          dayStyle: TextStyle(
                                              color: Colors.green.shade100),
                                        ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (datePicked != null) {
                                  setState(() {
                                    _selectedDate = datePicked;
                                    _birthdayController.text =
                                        DateFormat('MMM dd, yyyy')
                                            .format(_selectedDate!.toLocal());
                                  });
                                }
                              },
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize / 80),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid date';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(fontsize / 80),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
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
                              size: fontsize / 80,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize / 80),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email Number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(fontsize / 80),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _numberController,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: '+63#########',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              color: Colors.grey,
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
                              FontAwesome.phone,
                              color: Colors.green.shade900,
                              size: fontsize / 100,
                            ),
                          
                          ),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize / 80,
                              ),
                           
                              
                       
                          inputFormatters: [
                           
                            FilteringTextInputFormatter.digitsOnly,
                            
                            LengthLimitingTextInputFormatter(12),
                          ],
                          onChanged: (value) {
                            
                            if (!value.startsWith('+63')) {
                              _numberController.value = TextEditingValue(
                                text: '+63' + value.replaceAll('63', '',
                                 ),
                              
                                selection: TextSelection.collapsed(
                                  offset: '+63'.length +
                                      value.replaceAll('63', '').length,

                                ),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Contact Number';
                            }
                            if (!value.startsWith('09')) {
                              return 'Contact Number must start with 09';
                            } else if (value.length != 12) {
                              return 'Contact Number must be exactly 11 digits long';
                            }

                            return null;
                          },
                        ),
                      ),
                      Gap(fontsize / 80),
                      Container(
                        height: height / 20,
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
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
                              Ionicons.ios_location,
                              color: Colors.green.shade900,
                              size: fontsize / 80,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: fontsize / 80),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Contact Number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Gap(height / 80),
                      Container(
                        height: height / 20,
                        width: double.infinity, // Full width
                        // Height
                        child: ElevatedButton.icon(
                          onPressed: () => _handleButtonPress(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .transparent, // Set background color to transparent
                            elevation:
                                20, // Remove elevation if you want to apply your own shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: Icon(
                            MaterialCommunityIcons
                                .account_check, // Replace with your desired icon
                            size: 24.0,
                            color: Colors.white, // Adjust size as needed
                          ),
                          label: Text(
                            'Next',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).dividerColor, // Text color
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor, // Background color
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
