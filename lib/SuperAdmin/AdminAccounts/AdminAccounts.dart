import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';


import 'AddAdmin.dart';
import 'AdminViewList.dart';
import 'Controller.dart';
import 'Model.dart';
import 'ViewAdmin.dart';

class AdminCreate extends StatefulWidget {
  final String username;
  final String fullname;

  const AdminCreate({super.key, required this.username, required this.fullname});

  @override
  State<AdminCreate> createState() => _ClaimedTab();
}

class _ClaimedTab extends State<AdminCreate> {
  bool _showEditablePage = false;
  bool _showAddAdminPage = false;
  AdminModel? _adminaccount;
 bool _isLoading = false;
  String _errorMessage = '';

    final LoginController _loginController = LoginController();
  @override
  void initState() {
    super.initState();
  }

  void _onEditDocument(AdminModel admin) {
    setState(() {
      _adminaccount = admin;
      _showEditablePage = true;
      _showAddAdminPage = false;
    });
  }

  void _onAddNew() {

    setState(() {
      _adminaccount = null;
      _showAddAdminPage = true;
      _showEditablePage = false;
    });
  }

  void _onSaveDocument() {
    setState(() {
      _showEditablePage = false;
    });
  }


Future<String?> _onAddNewDocument() async {
  TextEditingController passwordController = TextEditingController();
   final FocusNode passwordFocusNode = FocusNode();
  bool passwordVisibility = false;

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
 final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
      
      return AlertDialog(


        shape: RoundedRectangleBorder
       (borderRadius: BorderRadius.circular(15)),
       title: Row(
        children: [
          Icon(MaterialCommunityIcons.shield_key,
          color: Colors.green.shade900,
          size: 24,),
          Gap(fontsize/120),
          Text('Account Confirmation',
          style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize/60,
                  color: Colors.green.shade900,))
        ],
       ),
       content: Column(
        mainAxisSize: MainAxisSize.min,
         children: [
           Text(
            'Please enter your password to add new admin account.',
            style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fontsize/120,
                  color: Colors.black,)
           ),
           Gap(fontsize/80),
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
                                      
                                       
                                      
                                      isDense: true),
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 80,
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
         ],
       ),
       actions: [
        TextButton(
            onPressed: () {
              _login(passwordController.text);
              Navigator.of(context).pop(passwordController.text);
            },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),),
            child: Text('Submit',
             style: GoogleFonts.poppins(
                                    fontSize: fontsize / 80,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
            ),
          ),
       ],
   
      );
    },
  );
}

 void _login(String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; 
    });

    final loginModel = LoginModel(
      username: widget.username,
      password: password
    );

    final response = await _loginController.login(loginModel);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {

      _showSuccessMessage('Admin verified Successfully');
      _onAddNew();

    } else {
      // Show error message if login fails
      setState(() {
        _errorMessage = response['error'] ?? 'An error occurred. Please try again.';
      });
      _showErrorMessage('An error occurred. Please try again. ');
    }
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
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    'Hello,',
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Text(
                    ' ${widget.fullname}! ',
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Container(
                      height: height / 20,
                      child: Lottie.asset('assets/hi.json', fit: BoxFit.cover)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: fontsize / 80),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    formatted,
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(fontsize / 100.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: AssetImage('assets/dashboardbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(fontsize / 80.0),
                    child: Row(
                      children: [
                        AdminAccounts(
                          onDocumentSelect: _onEditDocument, onAddAccount: _onAddNewDocument,
                          
                        ),
                        EditPage(
                          showEditablePage: _showEditablePage,
                          adminAccounts: _adminaccount,
                          onSave:_onSaveDocument,
                          onCancel: () {},
                        ),
                        AddAdminPage(
                          showAddPage: _showAddAdminPage,
                        
                          onSave: _onSaveDocument,
                          onCancel: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

