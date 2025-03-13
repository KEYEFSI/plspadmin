import 'package:plsp/Login/login.dart';

import 'package:plsp/SuperAdmin/Payees/GraduatesPage.dart';
import 'package:plsp/SuperAdmin/SuperAdminNav/ProfileController.dart';
import 'package:plsp/SuperAdmin/SuperAdminNav/ProfileModel.dart';
import 'package:plsp/SuperAdmin/TCP/GraduatesPage.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarPage.dart';
import 'package:plsp/SuperAdmin/College/CollegePage.dart';
import 'package:plsp/SuperAdmin/Dashboard/Dashboardpage.dart';
import 'package:plsp/SuperAdmin/Graduates/GraduatesPage.dart';
import 'package:plsp/SuperAdmin/Integrated/IntegratedPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Admin copy/EditProfile.dart';
import '../AdminAccounts/AdminAccounts.dart';
import '../TransactionData/AdminAccounts.dart';

class SuperAdminNav extends StatefulWidget {
  final String username;

  const SuperAdminNav({super.key, required this.username});

  @override
  State<SuperAdminNav> createState() => _SuperAdminNavState();
}

class _SuperAdminNavState extends State<SuperAdminNav> {
  int selectedIndex = 0;
  late AdminProfileController _controller;
  AdminProfile? _adminProfile;
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
      icon: MaterialCommunityIcons.book_settings,
      tooltip: 'Documents Requests',
      lottieFile: 'assets/College.json',
    ),
    NavigationItem(
      icon: FontAwesome.child,
      tooltip: 'Integrated School Students',
      lottieFile: 'assets/IS.json',
    ),
    NavigationItem(
      icon: FontAwesome.mortar_board,
      tooltip: 'Graduates School Students',
      lottieFile: 'assets/Graduates.json',
    ),
    NavigationItem(
      icon: FontAwesome.drupal,
      tooltip: 'Payees Students',
      lottieFile: 'assets/Work.json',
    ),
    NavigationItem(
      icon: FontAwesome.bullseye,
      tooltip: 'TCP Students',
      lottieFile: 'assets/Goal.json',
    ),
 
    
    NavigationItem(
      icon: Foundation.calendar,
      tooltip: 'Calendar Holiday',
      lottieFile: 'assets/Calendar.json',
    ),
    NavigationItem(
      icon: FontAwesome5Solid.users,
      tooltip: 'Admin Accounts',
      lottieFile: 'assets/colle.json',
    ),
    NavigationItem(
      icon: MaterialCommunityIcons.microsoft_excel,
      tooltip: 'Transactions',
      lottieFile: 'assets/Files.json',
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
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      CollegePage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      IntegratedPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      GraduatesPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      PayeesPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      TCPPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
    
      CalendarPage(
        username: widget.username,
        fullname: _adminProfile?.fullname ?? 'na',
      ),
      AdminCreate(
          username: widget.username, fullname: _adminProfile?.fullname ?? ''),
      Export(
          username: widget.username, fullname: _adminProfile?.fullname ?? ''),
      EditSuperAdmin(
        username: widget.username,
        onSave: _fetchAdminProfile,
      ),
    ];
    final fontsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(left: fontsize / 160, bottom: fontsize / 160),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage('assets/Sidebar.png'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(fontsize / 160.0),
                      child: SizedBox(
                        width: fontsize / 20,
                        height: fontsize / 20,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.green.shade100,
                    ),
                    Profile(
                        isLoading: _isLoading,
                        adminProfile: _adminProfile,
                        fontsize: fontsize),
                    Divider(
                      thickness: 1,
                      color: Colors.green.shade100,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.start,
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
                    ),
                    const Divider(
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
                                  title: const Row(
                                    children: [
                                      Icon(Icons.exit_to_app,
                                          color: Colors.red),
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
                                  content: const Text(
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
                                      child: const Text('Cancel'),
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
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldLogout) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginWidget()),
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

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required bool isLoading,
    required AdminProfile? adminProfile,
    required this.fontsize,
  })  : _isLoading = isLoading,
        _adminProfile = adminProfile;

  final bool _isLoading;
  final AdminProfile? _adminProfile;
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
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
    required this.lottieFile,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

const gradientSelected = LinearGradient(
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
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center
                ,
                children: [
                  widget.selected
                      ? Lottie.asset(
                          widget.lottieFile, // Path to your Lottie animation
                          width: fontsize / 60,
                          height: fontsize / 60,
                        )
                      : Icon(
                          widget.icon,
                          color: Colors.white,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        widget.tooltip,
                        style: GoogleFonts.poppins(
                          color:
                              widget.selected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.selected
                              ? fontsize / 210
                              : fontsize / 220,
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
