import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:plsp/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plsp/SuperAdminRegistrar/Admin/AdminController.dart';
import 'package:plsp/SuperAdminRegistrar/Admin/AdminModel.dart';
import 'package:plsp/common/common.dart';
import 'package:lottie/lottie.dart';

class EditRegistrarProfile extends StatefulWidget {
  final String username;
  final VoidCallback onSave;

  const EditRegistrarProfile(
      {super.key, required this.username, required this.onSave});

  @override
  State<EditRegistrarProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditRegistrarProfile> {
  final AdminProfileController _controller = AdminProfileController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage; // Store picked image file

  late TextEditingController _usernameController;
  late TextEditingController _fullnameController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController;
  late TextEditingController _usertypeController;
  late TextEditingController _profileImageController;
  late TextEditingController _numberController;
  late TextEditingController _emailController;

  late Future<AdminProfileModel?> futureProfile;

  bool get passwordVisibility => _passwordVisibility;
  bool _passwordVisibility = false;
  set passwordVisibility(bool value) {
    _passwordVisibility = value;
  }

  DateTime? _selectedDate;
  final AdminUpdateController UpdateAdmin = AdminUpdateController();
  final AdminUpdateProfileController UpdateprofileAdmin =
      AdminUpdateProfileController();

  @override
  void initState() {
    super.initState();
    futureProfile = Future.value(null); // Initialize with null

    _usernameController = TextEditingController();
    _fullnameController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
    _usertypeController = TextEditingController();
    _profileImageController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();

    _fetchProfile();
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
  
  Future<void> _fetchProfile() async {
    try {
      final profile = await _controller.fetchAdminProfile(widget.username);
      setState(() {
        futureProfile = Future.value(profile);

        // Update controllers with fetched data
        _usernameController.text = profile?.username ?? '';
        _fullnameController.text = profile?.fullname ?? '';
        _usertypeController.text = profile?.usertype ?? '';
        _profileImageController.text = profile?.profileImage ?? '';
        _numberController.text = profile?.number ?? '';
        _emailController.text = profile?.gmail ?? '';
      });
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  void _updateAdmin() async {
    final model = AdminUpdateModel(
      username: widget.username,
      newUsername: _usernameController.text,
      newPassword: _passwordController.text,
    );

    try {
      await UpdateAdmin.updateAdmin(model);
      

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginWidget()),
      );
    } catch (e) {
    
    }
  }

  Future<void> _updateProfile() async {
    final username = _usernameController.text;
   
    final email = _emailController.text.isEmpty ? null : _emailController.text;
    final number =
        _numberController.text.isEmpty ? null : _numberController.text;

    final profileImagePath = _profileImage?.path;

    if (username.isEmpty) {
     _showErrorMessage('Username is required');
      return;
    }

    try {
      final model = UpdateProfileModel(
        username: username,
       
        email: email,
        number: number,
        
      );

       UpdateprofileAdmin.updateAdminProfile(model, profileImagePath);

      widget.onSave();
     
    _showSuccessMessage('Profile updated successfully');
    } catch (e) {
 
      _showErrorMessage('Failed to update profile');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<AdminProfileModel?>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/Loading.json',
                  fit: BoxFit.contain,
                ),
              );
            } else if (snapshot.hasError) {
              return Lottie.asset('assets/Empty.json', fit: BoxFit.contain);
            } else if (!snapshot.hasData) {
              return Lottie.asset('assets/Empty.json', fit: BoxFit.contain);
            } else {
              final profile = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: AssetImage('assets/dashboardbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(fontsize / 100,
                        fontsize / 100, fontsize / 100, fontsize / 100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: fontsize / 100, top: fontsize / 200),
                                child: Row(
                                  children: [
                                    Text(
                                      'Welcome back, ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade900,
                                        fontSize: fontsize / 60,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    Text(
                                      '${profile!.fullname}!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green.shade900,
                                        fontSize: fontsize / 60,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: fontsize / 50.0),
                                child: Text(
                                  'Feel free to update your profile information below.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade900,
                                    fontSize: fontsize / 80,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: fontsize / 7,
                                          height: fontsize / 7,
                                          child: Stack(children: [
                                            Center(
                                              child: Container(
                                                width: fontsize / 7,
                                                height: fontsize / 7,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xff80ff72),
                                                      Color(0xff7ee8fa),
                                                    ],
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          4.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: _profileImage !=
                                                                null
                                                            ? FileImage(File(
                                                                _profileImage!
                                                                    .path))
                                                            : profile.profileImage !=
                                                                    null
                                                                ? NetworkImage(
                                                                    '$Purl${profile.profileImage}',
                                                                    headers:
                                                                        kHeader,
                                                                  )
                                                                : AssetImage(
                                                                        'assets/backgroundlogin.jpg')
                                                                    as ImageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  Alignment.bottomRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: fontsize / 100,
                                                    right: fontsize / 100),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xff80ff72),
                                                        Color(0xff7ee8fa),
                                                      ],
                                                      begin:
                                                          Alignment.topRight,
                                                      end: Alignment
                                                          .bottomLeft,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                        MaterialCommunityIcons
                                                            .image_edit),
                                                    onPressed: _pickImage,
                                                    iconSize: fontsize / 80,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           fontsize / 100, 0, 0, 0),
                                        //   child: Column(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       Text(
                                        //         'Username/ID',
                                        //         style: GoogleFonts.poppins(
                                        //           fontSize: fontsize / 210,
                                        //           color: Colors.green.shade900,
                                        //           fontWeight: FontWeight.w500,
                                        //         ),
                                        //       ),
                                        //       SizedBox(height: fontsize / 300),
                                        //       TextFormField(
                                        //         controller: _usernameController,
                                        //         decoration: InputDecoration(
                                        //           labelText: 'Username',
                                        //           labelStyle:
                                        //               GoogleFonts.poppins(
                                        //             fontSize: fontsize / 210,
                                        //             color:
                                        //                 Colors.green.shade900,
                                        //             fontWeight: FontWeight.w500,
                                        //           ),
                                        //           enabledBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide: BorderSide(
                                        //               color: Theme.of(context)
                                        //                   .primaryColor,
                                        //               width: 2.0,
                                        //             ),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     12.0),
                                        //           ),
                                        //           focusedBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide: BorderSide(
                                        //               color: Theme.of(context)
                                        //                   .hintColor,
                                        //               width: 2.0,
                                        //             ),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     12.0),
                                        //           ),
                                        //           prefixIcon: Icon(
                                        //             MaterialCommunityIcons
                                        //                 .account_tie,
                                        //             color:
                                        //                 Colors.green.shade900,
                                        //           ),
                                        //         ),
                                        //         style: GoogleFonts.poppins(
                                        //           color: Colors.black,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //         validator: (value) {
                                        //           if (value == null ||
                                        //               value.isEmpty) {
                                        //             return 'Please enter the Username';
                                        //           }
                                        //           return null;
                                        //         },
                                        //       ),
                                        //       SizedBox(height: fontsize / 200),
                                        //       Text(
                                        //         'Password',
                                        //         style: GoogleFonts.poppins(
                                        //           fontSize: fontsize / 210,
                                        //           color: Colors.green.shade900,
                                        //           fontWeight: FontWeight.w500,
                                        //         ),
                                        //       ),
                                        //       SizedBox(height: fontsize / 300),
                                        //       TextFormField(
                                        //         controller: _passwordController,
                                        //         obscureText:
                                        //             !_passwordVisibility,
                                        //         decoration: InputDecoration(
                                        //           labelText: 'Password',
                                        //           labelStyle:
                                        //               GoogleFonts.poppins(
                                        //             fontSize: fontsize / 210,
                                        //             color:
                                        //                 Colors.green.shade900,
                                        //             fontWeight: FontWeight.w500,
                                        //           ),
                                        //           enabledBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide: BorderSide(
                                        //               color: Theme.of(context)
                                        //                   .primaryColor,
                                        //               width: 2.0,
                                        //             ),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     12.0),
                                        //           ),
                                        //           focusedBorder:
                                        //               OutlineInputBorder(
                                        //             borderSide: BorderSide(
                                        //               color: Theme.of(context)
                                        //                   .hintColor,
                                        //               width: 2.0,
                                        //             ),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     12.0),
                                        //           ),
                                        //           prefixIcon: Icon(
                                        //             MaterialCommunityIcons
                                        //                 .shield_key,
                                        //             color:
                                        //                 Colors.green.shade900,
                                        //           ),
                                        //           suffixIcon: InkWell(
                                        //             onTap: () => setState(() {
                                        //               _passwordVisibility =
                                        //                   !_passwordVisibility;
                                        //             }),
                                        //             focusNode: FocusNode(
                                        //                 skipTraversal: true),
                                        //             child: Icon(
                                        //               _passwordVisibility
                                        //                   ? Icons
                                        //                       .visibility_outlined
                                        //                   : Icons
                                        //                       .visibility_off_outlined,
                                        //               color: Theme.of(context)
                                        //                   .primaryColor,
                                        //               size: 24.0,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         style: GoogleFonts.poppins(
                                        //           color: Colors.black,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //         validator: (value) {
                                        //           if (value == null ||
                                        //               value.isEmpty) {
                                        //             return 'Please enter password';
                                        //           }
                                        //           return null;
                                        //         },
                                        //       ),
                                        //       SizedBox(
                                        //         height: fontsize / 100,
                                        //       ),
                                        //       Container(
                                        //         width: double
                                        //             .infinity, // Full width
                                        //         height: fontsize / 50, // Height
                                        //         child: ElevatedButton.icon(
                                        //           onPressed: _updateAdmin,
                                        //           style:
                                        //               ElevatedButton.styleFrom(
                                        //             backgroundColor: Colors
                                        //                 .transparent, // Set background color to transparent
                                        //             elevation:
                                        //                 20, // Remove elevation if you want to apply your own shadow
                                        //             shape:
                                        //                 RoundedRectangleBorder(
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                       12.0),
                                        //             ),
                                        //           ),
                                        //           icon: Icon(
                                        //             MaterialCommunityIcons
                                        //                 .account_check, // Replace with your desired icon
                                        //             size: 24.0,
                                        //             color: Colors
                                        //                 .white, // Adjust size as needed
                                        //           ),
                                        //           label: Text(
                                        //             'Update Account',
                                        //             style: GoogleFonts.poppins(
                                        //               fontSize: fontsize / 160,
                                        //               fontWeight:
                                        //                   FontWeight.w700,
                                        //               color: Theme.of(context)
                                        //                   .dividerColor, // Text color
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         decoration: BoxDecoration(
                                        //           color: Theme.of(context)
                                        //               .primaryColor, // Background color
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   12.0),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: fontsize / 120.0,
                                                    right: fontsize / 120,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: fontsize / 200,
                                                      ),
                                                      
                                                      SizedBox(
                                                          height:
                                                              fontsize / 300),
                                                      TextFormField(
                                                        controller:
                                                            _emailController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle:
                                                              GoogleFonts
                                                                  .poppins(
                                                            fontSize:
                                                                fontsize/60, 
                                                            color: Colors
                                                                .green.shade900,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          prefixIcon: Icon(
                                                            MaterialCommunityIcons
                                                                .account_tie,
                                                            color: Colors
                                                                .green.shade900,
                                                          ),
                                                        ),
                                                         style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter a valid date';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: fontsize / 200,
                                                      ),
                                                      
                                                      SizedBox(
                                                          height:
                                                              fontsize / 300),
                                                      TextFormField(
                                                        controller:
                                                            _numberController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Contact Number',
                                                          labelStyle:
                                                              GoogleFonts
                                                                  .poppins(
                                                            fontSize:
                                                                fontsize / 60,
                                                            color: Colors
                                                                .green.shade900,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          prefixIcon: Icon(
                                                            MaterialCommunityIcons
                                                                .account_tie,
                                                            color: Colors
                                                                .green.shade900,
                                                          ),
                                                          
                                                        ),
                                                        
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                         inputFormatters: [
                           
                            FilteringTextInputFormatter.digitsOnly,
                            
                            LengthLimitingTextInputFormatter(13),
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
                                                      SizedBox(
                                                        height: fontsize / 200,
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              fontsize / 300),
                                                      Container(
                                                        width: double
                                                            .infinity, // Full width
                                                        height: fontsize /
                                                            50, // Height
                                                        child:
                                                            ElevatedButton.icon(
                                                          onPressed:
                                                              _updateProfile,
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor: Colors
                                                                .transparent, // Set background color to transparent
                                                            elevation:
                                                                20, // Remove elevation if you want to apply your own shadow
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                          ),
                                                          icon: Icon(
                                                            MaterialCommunityIcons
                                                                .account_check, // Replace with your desired icon
                                                            size: 24.0,
                                                            color: Colors
                                                                .white, // Adjust size as needed
                                                          ),
                                                          label: Text(
                                                            'Update Account',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      160,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor, // Text color
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor, // Background color
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
            }
          }),
    );
  }
}
