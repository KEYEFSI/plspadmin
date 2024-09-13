import 'dart:io';
import 'package:plsp/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plsp/FinanceAdmin/Admin/AdminController.dart';
import 'package:plsp/FinanceAdmin/Admin/AdminModel.dart';
import 'package:plsp/common/common.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class EditProfile extends StatefulWidget {
  final String username;

  const EditProfile({super.key, required this.username});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;

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
    _addressController = TextEditingController();
    _birthdayController = TextEditingController();

    _fetchProfile(); // Fetch the profile on init
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await _controller.fetchAdminProfile(widget.username);
      setState(() {
        futureProfile = Future.value(profile);

        // Update controllers with fetched data
        _usernameController.text = profile?.username ?? '';
        _fullnameController.text = profile?.fullname ?? '';
        _firstNameController.text = profile?.firstName ?? '';
        _middleNameController.text = profile?.middleName ?? '';
        _lastNameController.text = profile?.lastName ?? '';
        _usertypeController.text = profile?.usertype ?? '';
        _profileImageController.text = profile?.profileImage ?? '';
        _numberController.text = profile?.number ?? '';
        _addressController.text = profile?.address ?? '';
        _birthdayController.text = profile?.birthday != null
            ? DateFormat('MMM dd, yyyy').format(profile!.birthday!.toLocal())
            : '';
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
      _showDialog();

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginWidget()),
      );
    } catch (e) {
      _showerrorDialog();
    }
  }

  Future<void> _updateProfile() async {
    final username = _usernameController.text;
    final fullname =
        '${_firstNameController.text.isEmpty ? null : _firstNameController.text} ${_middleNameController.text.isEmpty ? null : _middleNameController.text} ${_lastNameController.text.isEmpty ? null : _lastNameController.text}';
    final firstName =
        _firstNameController.text.isEmpty ? null : _firstNameController.text;
    final middleName =
        _middleNameController.text.isEmpty ? null : _middleNameController.text;
    final lastName =
        _lastNameController.text.isEmpty ? null : _lastNameController.text;
    final usertype =
        _usertypeController.text.isEmpty ? null : _usertypeController.text;
    final address =
        _addressController.text.isEmpty ? null : _addressController.text;
    final number =
        _numberController.text.isEmpty ? null : _numberController.text;

    final profileImagePath = _profileImage?.path;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username is required')),
      );
      return;
    }

    try {
      final model = UpdateProfileModel(
        username: username,
        fullname: fullname,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        usertype: usertype,
        address: address,
        number: number,
        birthday: _selectedDate,
      );

      await UpdateprofileAdmin.updateAdminProfile(model, profileImagePath);

      _showDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade900,
        ),
      );
    } catch (e) {
      _showerrorDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade700,
        ),
      );
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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

  void _showerrorDialog() {
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
                      'assets/error.json',
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
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<AdminProfileModel?>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child:  Lottie.asset(
                                                 'assets/Loading.json',
                                                  fit: BoxFit.contain,
                                                ),);
            } else if (snapshot.hasError) {
              return Center(child:  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain));
            } else if (!snapshot.hasData) {
              return Center(child:  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain));
            } else {
              final profile = snapshot.data;

              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: AssetImage('assets/dashboardbg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Expanded(
                        child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(fontsize / 80,
                          height / 42, fontsize / 80, height / 42),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 100,
                                          top: height / 80),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Welcome back, ',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade900,
                                              fontSize: fontsize / 80,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          Text(
                                            '${profile!.fullname}!',
                                            style: GoogleFonts.poppins(
                                              color: Colors.green.shade900,
                                              fontSize: fontsize / 70,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 50.0),
                                      child: Text(
                                        'Feel free to update your profile information below.',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade900,
                                          fontSize: fontsize / 120,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: fontsize / 100,
                                            ),
                                            child: Container(
                                              width: fontsize / 9,
                                              height: fontsize / 9,
                                              child: Stack(children: [
                                                Center(
                                                  child: Container(
                                                    width: fontsize / 10,
                                                    height: fontsize / 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
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
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: _profileImage !=
                                                                    null
                                                                ? FileImage(File(
                                                                    _profileImage!
                                                                        .path))
                                                                : profile?.profileImage !=
                                                                        null
                                                                    ? NetworkImage(
                                                                        '$Purl${profile!.profileImage}',
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
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xff80ff72),
                                                            Color(0xff7ee8fa),
                                                          ],
                                                          begin: Alignment
                                                              .topRight,
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
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    fontsize / 100, 0, 0, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Username/ID',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 120,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: fontsize / 300),
                                                TextFormField(
                                                  controller:
                                                      _usernameController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Username',
                                                    labelStyle:
                                                        GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    prefixIcon: Icon(
                                                      MaterialCommunityIcons
                                                          .account_tie,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontsize / 120),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter the Username';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                    height: fontsize / 200),
                                                Text(
                                                  'Password',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 120,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: fontsize / 300),
                                                TextFormField(
                                                  controller:
                                                      _passwordController,
                                                  obscureText:
                                                      !_passwordVisibility,
                                                  decoration: InputDecoration(
                                                    labelText: 'Password',
                                                    labelStyle:
                                                        GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    prefixIcon: Icon(
                                                      MaterialCommunityIcons
                                                          .shield_key,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                    suffixIcon: InkWell(
                                                      onTap: () => setState(() {
                                                        _passwordVisibility =
                                                            !_passwordVisibility;
                                                      }),
                                                      focusNode: FocusNode(
                                                          skipTraversal: true),
                                                      child: Icon(
                                                        _passwordVisibility
                                                            ? Icons
                                                                .visibility_outlined
                                                            : Icons
                                                                .visibility_off_outlined,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 120,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter password';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: fontsize / 100,
                                                ),
                                                Container(
                                                  width: double
                                                      .infinity, // Full width
                                                  height: height / 21,
                                                  child: ElevatedButton.icon(
                                                    onPressed: _updateAdmin,
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
                                                                .circular(12.0),
                                                      ),
                                                    ),
                                                    icon: Icon(
                                                      MaterialCommunityIcons
                                                          .account_check, // Replace with your desired icon
                                                      size: fontsize / 80,
                                                      color: Colors
                                                          .white, // Adjust size as needed
                                                    ),
                                                    label: Text(
                                                      'Update Account',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 120,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Theme.of(context)
                                                            .dividerColor, // Text color
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor, // Background color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 80.0),
                                            child: VerticalDivider(
                                              thickness: 1,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: fontsize / 120.0,
                                                right: fontsize / 120,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'First Name',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _firstNameController,
                                                    decoration: InputDecoration(
                                                      labelText: 'First Name',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 210,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter the First Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: fontsize / 200,
                                                  ),
                                                  Text(
                                                    'Middle Name',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _middleNameController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Middle Name',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 210,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter the Middle Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: fontsize / 200,
                                                  ),
                                                  Text(
                                                    'Last Name',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _lastNameController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Last Name',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 210,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter the Last Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: fontsize / 200,
                                                  ),
                                                  Text(
                                                    'Birthdate',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _birthdayController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Birthdate',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize: fontsize /
                                                            120.0, // Adjust as needed
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                      suffixIcon:
                                                          GestureDetector(
                                                        onTap: () async {
                                                          final datePicked =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate: DateTime
                                                                    .now()
                                                                .subtract(Duration(
                                                                    days: 365 *
                                                                        100)),
                                                            lastDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 365 *
                                                                        100)),
                                                            builder: (context,
                                                                child) {
                                                              return Theme(
                                                                data: ThemeData
                                                                        .light()
                                                                    .copyWith(
                                                                  primaryColor:
                                                                      Color(
                                                                          0xFF006400),
                                                                  buttonTheme:
                                                                      ButtonThemeData(
                                                                    textTheme:
                                                                        ButtonTextTheme
                                                                            .primary,
                                                                  ),
                                                                  dialogBackgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  datePickerTheme:
                                                                      DatePickerThemeData(
                                                                    dayStyle: TextStyle(
                                                                        color: Colors
                                                                            .green
                                                                            .shade100),
                                                                  ),
                                                                ),
                                                                child: child!,
                                                              );
                                                            },
                                                          );

                                                          if (datePicked !=
                                                              null) {
                                                            setState(() {
                                                              _selectedDate =
                                                                  datePicked;
                                                              _birthdayController
                                                                  .text = DateFormat(
                                                                      'MMM dd, yyyy')
                                                                  .format(_selectedDate!
                                                                      .toLocal());
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.calendar_today,
                                                          color: Colors
                                                              .green.shade900,
                                                        ),
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
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
                                                  Text(
                                                    'Contact Number',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _numberController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Contact Number',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 210,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your Contact Number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: fontsize / 200,
                                                  ),
                                                  Text(
                                                    'Your Address',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: fontsize / 300),
                                                  TextFormField(
                                                    controller:
                                                        _addressController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Address Format: Brgy. Municipality, City, Province',
                                                      labelStyle:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 210,
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      prefixIcon: Icon(
                                                        MaterialCommunityIcons
                                                            .account_tie,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your Contact Number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: fontsize / 100,
                                                  ),
                                                  Container(
                                                    width: double
                                                        .infinity, // Full width
                                                    height:
                                                        height / 21, // Height
                                                    child: ElevatedButton.icon(
                                                      onPressed: _updateProfile,
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
                                                        size: fontsize / 80,
                                                        color: Colors
                                                            .white, // Adjust size as needed
                                                      ),
                                                      label: Text(
                                                        'Update Account',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              fontsize / 120,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Theme.of(
                                                                  context)
                                                              .dividerColor, // Text color
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor, // Background color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Center(
                                                  child: Lottie.asset(
                                                      'assets/editprofile.json',
                                                      fit: BoxFit.cover)))
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
                    )),
                  ),
                ),
              ));
            }
          }),
    );
  }
}
