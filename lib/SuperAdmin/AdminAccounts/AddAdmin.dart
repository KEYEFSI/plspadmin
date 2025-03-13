import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'Controller.dart';
import 'Model.dart';

class AddAdminPage extends StatefulWidget {
  final bool showAddPage;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddAdminPage({
    super.key,
    required this.showAddPage,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middlenameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool passwordVisibility = false;



  @override
  void initState() {
    super.initState();
   
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
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
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  final CreateFinanceAdminController _createAdminController = CreateFinanceAdminController();

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  // Method to create the admin account
  void _createAdmin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    // Email validation
    final email = emailController.text;
    if (!_isValidEmail(email)) {
      // Show Snackbar if email is not valid
      _showErrorMessage('Please enter a valid email address');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Password validation
    final password = passwordController.text;
    if (!_isValidPassword(password)) {
      // Show Snackbar if password is not valid
      _showErrorMessage(
          'Password must contain at least one number and one uppercase letter');
      setState(() {
        _isLoading = false;
      });
      return; // Stop execution if password is invalid
    }

    final admin = CreateFinanceAdminModel(
      username: usernameController.text,
      password: password,
      firstName: firstnameController.text,
      middleName:
          middlenameController.text.isEmpty ? null : middlenameController.text,
      lastName: lastnameController.text,
      email: email,
     
    );

    final result = await _createAdminController.createFinanceAdmin(admin);

    setState(() {
      _isLoading = false;
      
      if (result['success']) {
        _successMessage = result['message'];

        _showSuccessMessage('Account created successfully');
        setState(() {
          widget.onSave();
        });
      } else {
        _showErrorMessage('Failed to Create an account');
        setState(() {
          widget.onSave();
        });
      }
    });
  }

// Function to validate email using a regular expression
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

// Function to validate password: Must contain at least one number and one uppercase letter
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d).+$'); // Password must contain at least one uppercase and one number
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return widget.showAddPage
        ? Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: fontsize / 80.0),
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/backgroundlogin.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(24)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(
                        children: [
                          Gap(height / 80),
                          Text(
                            'Add New Admin',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.green.shade900,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: fontsize / 80.0),
                            child: Column(
                              children: [
                                Gap(height / 80),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          'Let’s get started! Fill out first the Admin ID and Password',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontsize / 120,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0,
                                          )),
                                    ),
                                  ],
                                ),
                                Gap(height / 80),
                                TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      labelText: 'Admin ID',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Theme.of(context).primaryColor,
                                        size: fontsize / 80,
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 120),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Admin ID';
                                    }
                                    return null;
                                  },
                                ),
                                Gap(height / 80),
                                TextFormField(
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: !passwordVisibility,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).cardColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      filled: false,
                                      fillColor: Colors.green.shade900,
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Colors.green.shade900,
                                        size: fontsize / 80,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            passwordVisibility =
                                                !passwordVisibility;
                                          });
                                        },
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Icon(
                                          passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Theme.of(context).primaryColor,
                                          size: fontsize / 80,
                                        ),
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 120,
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(height / 80),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.green.shade900,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: fontsize / 80.0),
                            child: Column(
                              children: [
                                Gap(height / 80),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "Next, please enter the new admin's full name",
                                          style: GoogleFonts.poppins(
                                            fontSize: fontsize / 120,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0,
                                          )),
                                    ),
                                  ],
                                ),
                                Gap(height / 80),
                                TextFormField(
                                  controller: firstnameController,
                                  decoration: InputDecoration(
                                      labelText: 'Given Name',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Theme.of(context).primaryColor,
                                        size: fontsize / 80,
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 120),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Admin ID';
                                    }
                                    return null;
                                  },
                                ),
                                Gap(height / 80),
                                TextFormField(
                                  controller: middlenameController,
                                  decoration: InputDecoration(
                                      labelText: 'Middle Name',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Theme.of(context).primaryColor,
                                        size: fontsize / 80,
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 120),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Admin ID';
                                    }
                                    return null;
                                  },
                                ),
                                Gap(height / 80),
                                TextFormField(
                                  controller: lastnameController,
                                  decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Theme.of(context).primaryColor,
                                        size: fontsize / 80,
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 120),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Admin ID';
                                    }
                                    return null;
                                  },
                                ),
                                Gap(fontsize / 80)
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.green.shade900,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: fontsize / 80.0),
                            child: Column(
                              children: [
                                Gap(fontsize / 80),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "Enter the new admin's email, where the Admin ID and password will be sent, and select their assigned window.",
                                          style: GoogleFonts.poppins(
                                            fontSize: fontsize / 120,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0,
                                          )),
                                    ),
                                  ],
                                ),
                                Gap(fontsize / 80),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: fontsize / 120,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security_sharp,
                                        color: Theme.of(context).primaryColor,
                                        size: fontsize / 80,
                                      ),
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 120),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Admin User ID';
                                    }
                                    return null;
                                  },
                                ),
                                Gap(height / 80),
                                
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () {
                                          _createAdmin();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green.shade900,
                                                Colors.greenAccent.shade700,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MaterialIcons.move_to_inbox,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Create',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontsize / 106,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
          )
        : SizedBox.shrink();
  }
}
