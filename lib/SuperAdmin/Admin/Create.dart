
import 'package:plsp/SuperAdmin/Admin/AdminController.dart';
import 'package:plsp/SuperAdmin/Admin/AdminModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class Create extends StatefulWidget {
   final VoidCallback onSave;

  const Create({
    super.key,
    required this.fontsize,
    required this.onSave,

  });

  final double fontsize;

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  late TextEditingController _firstnameController;
  late TextEditingController _middlenameController;
  late TextEditingController _lastnameController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
 
  
  final AdminController _adminController = AdminController();
  String? _selectedOption;
  bool _passwordVisibility = false;
  bool get passwordVisibility => _passwordVisibility;

  set passwordVisibility(bool value) {
    _passwordVisibility = value;
  }

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController();
    _middlenameController = TextEditingController();
    _lastnameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisibility = false;

  }

  void _register() async {
    final admin = AdminAccount(
      fullname: _firstnameController.text + ' ' + _middlenameController.text + ' '+ _lastnameController.text,
      firstName: _firstnameController.text,
      middleName: _middlenameController.text,
      lastName: _lastnameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      usertype: _selectedOption.toString(),
    );
  

    final success = await _adminController.registerAdmin(admin);

    if (success) {
        _showDialogSuccess();
       widget.onSave(); 
       _clear();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register admin.'),
      ));
    }
  }
  
  void _clear(){
    _firstnameController.clear();
    _middlenameController.clear();
    _lastnameController.clear();
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _selectedOption = null;
    });

  }
  

  void _showDialogSuccess() {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Show the dialog
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration(seconds: 2), () async {
              Navigator.of(context).pop();
            
            });
          });

          return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0, 
            contentPadding: EdgeInsets.zero, 
            content: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12), 
              ),
              child: Column(
                children: [
               
                  Lottie.asset(
                    'assets/success.json',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            actions: [],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
 final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(fontsize/80,
          height/42, 0, fontsize / 80),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12),
              child: Row(
                children: [
                  Lottie.asset('assets/add_acc.json',
                      width: fontsize / 30,
                      height: fontsize / 30),
                  Text(
                    'Add an Account',
                    style: GoogleFonts.poppins(
                        color: Colors.green.shade900,
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              height: 10,
              thickness: 2,
              color: Colors.green.shade900,
            ),
            Padding(
              padding:  EdgeInsets.all(fontsize/80),
              child: Column(
                children: [
                  Container(
                    height: height/17,
                    child: TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                 Gap(height/200),
                  Container(
                     height: height/17,
                    child: TextFormField(
                      controller: _middlenameController,
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Middle Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(height/200),
                  Container(
                     height: height/17,
                    child: TextFormField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                        fontWeight: FontWeight.bold,
                                 fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(height/200),
                  Container(
                   height: height/17,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username or ID',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                          FontAwesome.id_badge,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                                 fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(height/200),
                  Container(
                     height: height/17,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisibility,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                            size: 24.0,
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                                 fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a document name';
                        }
                        return null;
                      },
                    ),
                  ),
                 Gap(height/200),
                  Container(
                     height: height/17,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Admin Type',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: widget.fontsize / 120,
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
                          size: 24.0,
                        ),
                        
                      ),
                       dropdownColor: Colors.white,
                       
                      value: _selectedOption,
                      items: ['Finance Admin', 'Registrars Admin']
                          .map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: GoogleFonts.poppins(
                              fontSize: widget.fontsize / 120,
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
                  Gap(height/101),
                  Container(
                     height: height/17,
                            width: double.infinity, // Full width
                           // Height
                            child: ElevatedButton.icon(
                              onPressed:_register,
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
                               MaterialCommunityIcons.account_check, // Replace with your desired icon
                                size: 24.0,
                                color: Colors.white, // Adjust size as needed
                              ),
                              label: Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: widget.fontsize/160,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .dividerColor, // Text color
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
           
          ],
        ),
      ),
    );
  }
}
