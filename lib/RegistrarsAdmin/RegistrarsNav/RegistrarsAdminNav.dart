import 'package:plsp/Login/login.dart';
import 'package:plsp/RegistrarsAdmin/Admin/EditProfile.dart';
import 'package:plsp/RegistrarsAdmin/Obtainable/Obtainable.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Program.dart';
import 'package:plsp/RegistrarsAdmin/RegistrarsNav/ProfileController.dart';
import 'package:plsp/RegistrarsAdmin/RegistrarsNav/ProfileModel.dart';
import 'package:plsp/RegistrarsAdmin/StudentList/StudentData.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:plsp/RegistrarsAdmin/Requests/CollegePage.dart';

import '../Dashboard/DashboardPage.dart';

class RegistrarAdminNav extends StatefulWidget {
  final String username;

  const RegistrarAdminNav({super.key, required this.username});

  @override
  State<RegistrarAdminNav> createState() => _RegistrarAdminNavState();
}

class _RegistrarAdminNavState extends State<RegistrarAdminNav> {
  int selectedIndex = 0;
  late AdminProfileController _controller;
  AdminRegistrarProfile? _adminProfile;
  bool _isLoading = true;

  Future<void> _fetchAdminProfile() async {
    final profile = await _controller.fetchAdminProfile(widget.username);
    setState(() {
      _adminProfile = profile;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AdminProfileController();
    _fetchAdminProfile();
  }

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: MaterialIcons.dashboard,
      tooltip: 'Dashboard',
      lottieFile: 'assets/dashboard_side.json',
    ),
    NavigationItem(
      icon: Entypo.clock,
      tooltip: 'Pending Requests',
      lottieFile: 'assets/Pending.json',
    ),
    NavigationItem(
      icon: Ionicons.ios_document,
      tooltip: 'Requests',
      lottieFile: 'assets/Request.json',
    ),
    NavigationItem(
      icon: MaterialCommunityIcons.book_settings,
      tooltip: 'Obtainable Request',
      lottieFile: 'assets/College.json',
    ),
    NavigationItem(
      icon: Foundation.pricetag_multiple,
      tooltip: 'Student Data',
      lottieFile: 'assets/DocumentNew.json',
    ),
    NavigationItem(
      icon: MaterialCommunityIcons.badge_account,
      tooltip: 'Edit Profile',
      lottieFile: 'assets/Accounts.json',
    ),
    
  ];

  void select(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? '',
      ),
      Program(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? '',
      ),
      CollegePage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? '',
      ),
      ObtainablePage(
          username: widget.username, fullname: _adminProfile?.fullname ?? ''),
      StudentList(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? '',
      ),
      EditRegistrarProfile(
        username: widget.username,
        onSave: _fetchAdminProfile,
      ),
      
    ];

    final fontsize = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/Sidebar.png'), fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                      ),
                      width: fontsize / 20,
                      height: fontsize / 20,
                    ),
                  ),
                  Divider(
                    height: 16,
                    thickness: 1,
                    color: Colors.green.shade100,
                  ),
                  Profile(
                      isLoading: _isLoading,
                      adminProfile: _adminProfile,
                      fontsize: fontsize),
                  Divider(
                    height: 16,
                    thickness: 1,
                    color: Colors.green.shade100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: navigationItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      NavigationItem item = entry.value;
                      return NavBarItem(
                        lottieFile: item.lottieFile,
                        tooltip: item.tooltip,
                        icon: item.icon,
                        selected: selectedIndex == index,
                        onTap: () {
                          select(index);
                        },
                      );
                    }).toList(),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.greenAccent,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () async {
                          bool shouldLogout = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.exit_to_app, color: Colors.red),
                                    SizedBox(width: 10),
                                    Text(
                                      'Confirm Logout',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLogout) {
                            // Perform logout actions
                            final authService = AuthService();
                            await authService.logout();

                            // Navigate to the login screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginWidget()),
                            );
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14)),
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.greenAccent, width: 1))),
                          child: Row(
                            children: [
                              Lottie.asset('assets/Logout.json',
                                  width: fontsize / 40,
                                  height: fontsize / 40,
                                  fit: BoxFit.cover),
                              SizedBox(width: fontsize / 100),
                              Text(
                                'Logout',
                                style: GoogleFonts.poppins(
                                  color: Colors.redAccent.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontsize / 180,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: pages[selectedIndex], // Display the selected page
          ),
        ],
      ),
    );
  }
}

class AuthService {
  // Method to perform logout
  Future<void> logout() async {
    // Clear user session or authentication tokens
    // Example: SharedPreferences, SecureStorage, etc.
    // await _secureStorage.delete(key: 'authToken');

    // Example for SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('authToken');

    // Navigate to login screen
    // Use Navigator or GetX (if you are using GetX for navigation)
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required bool isLoading,
    required AdminRegistrarProfile? adminProfile,
    required this.fontsize,
  })  : _isLoading = isLoading,
        _adminProfile = adminProfile;

  final bool _isLoading;
  final AdminRegistrarProfile? _adminProfile;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isLoading
          ? Center(child: Lottie.asset('assets/Loading.json'))
          : _adminProfile == null
              ? Center(child: Text('Admin profile not found'))
              : Row(
                  children: [
                    Container(
                      width: fontsize / 40,
                      height: fontsize / 40,
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
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _adminProfile?.profileImage != null
                                  ? NetworkImage(
                                      '$Purl${_adminProfile?.profileImage}',
                                      headers: kHeader,
                                    )
                                  : AssetImage('assets/backgroundlogin.jpg')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _adminProfile!.usertype,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: fontsize / 150),
                            ),
                            Text(
                              _adminProfile!.fullname,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize / 150,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final bool selected;
  final String tooltip;
  final String lottieFile;

  final VoidCallback onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
    required this.lottieFile,
  }) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

final gradientSelected = LinearGradient(
  colors: [
    Color(0xff80ff72),
    // Color(0xff7ee8fa),
    Colors.white,
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.height +
        MediaQuery.of(context).size.width);
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(left: fontsize / 370, right: fontsize / 370),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: fontsize / 370),
            decoration: BoxDecoration(
              gradient: widget.selected ? gradientSelected : null,
              color: !widget.selected ? Colors.transparent : null,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  widget.selected
                      ? Lottie.asset(
                          widget.lottieFile, 
                          width: fontsize / 60,
                          height: fontsize / 60,
                        )
                      : Icon(
                          widget.icon,
                          color: Colors.white,
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.tooltip,
                        style: GoogleFonts.poppins(
                          color: widget.selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              widget.selected ? fontsize / 210 : fontsize / 220,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String tooltip;
  final String lottieFile;

  NavigationItem({
    required this.icon,
    required this.tooltip,
    required this.lottieFile,
  });
}
