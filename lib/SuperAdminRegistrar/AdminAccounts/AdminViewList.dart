import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:plsp/SuperAdminRegistrar/AdminAccounts/Controller.dart';
import 'package:plsp/SuperAdminRegistrar/AdminAccounts/Model.dart';
import 'package:plsp/common/common.dart';

class AdminAccounts extends StatefulWidget {
  final void Function(AdminModel) onDocumentSelect;
  final void Function() onAddAccount;
  const AdminAccounts({
    super.key,
    required this.onDocumentSelect,
    required this.onAddAccount,
  });

  @override
  State<AdminAccounts> createState() => _AdminAccountsState();
}

class _AdminAccountsState extends State<AdminAccounts> {
  late AdminController _adminController;
  int? hoveredIndex;
  int? _selectedIndex;
  bool _showAddAdminPage = false;
  bool _showEditablePage = false;
  AdminModel? _adminaccount;
 final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";


  @override
  void initState() {
    super.initState();
    _adminController = AdminController();
  }

  @override
  void dispose() {
    _adminController.dispose();
    super.dispose();
  }

  void _onAccountTap(AdminModel admin) {
    widget.onDocumentSelect(admin);
    setState(() {
      _adminaccount = admin;
      _showEditablePage = true;
    });
  }

  void _onADDAccountTap() {
    widget.onAddAccount();
    setState(() {
      _showAddAdminPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Gap(height / 80),
              Text('Admin Accounts',
                  style: GoogleFonts.poppins(
                    fontSize: fontsize / 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  )),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.green.shade900,
              ),
              Gap(fontsize / 80),
               Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search admin by their fullname...',
             
              enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).hintColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    filled: false,
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    prefixIcon: Icon(
                                      FontAwesome.search,
                                      color: Theme.of(context).primaryColor,
                                    ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
        Gap(height/80),
              Row(
                children: [
                  Gap(fontsize / 80),
                  Text('Profile',
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        color: Colors.grey,
                      )),
                  Gap(fontsize / 80),
                  Expanded(
                    child: Text('Fullname',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Admin User ID',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Email',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Assign Window',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fontsize / 80),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<AdminModel>>(
                    stream: _adminController.adminStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Lottie.asset('assets/error.json', fit: BoxFit.contain);
                      }

              
     final admins = snapshot.data!
                  .where((admin) => admin.fullname!.toLowerCase().contains(_searchQuery))
                  .toList();

                      admins.sort((a, b) => a.window!.compareTo(b.window!));

                      return ListView.builder(
                          itemCount: admins.length,
                          itemBuilder: (context, index) {
                            final admin = admins[index];
                            final isSelected = _selectedIndex == index;
                            final isHovered = hoveredIndex == index;

                            final profileImageUrl = admin.profileImage != null
                                ? '$Purl${admin.profileImage}'
                                : null;
                            return MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    hoveredIndex = index;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    hoveredIndex = null;
                                  });
                                },
                                child: Transform(
                                    transform: isHovered
                                        ? (Matrix4.identity()
                                          ..scale(1.01)) // Scale up on hover
                                        : Matrix4.identity(),
                                    alignment: Alignment.center,
                                    child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: isHovered
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 5,
                                                  )
                                                ]
                                              : [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 2,
                                                  )
                                                ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            _onAccountTap(admin);
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: isSelected
                                                    ? LinearGradient(
                                                        colors: [
                                                          Colors.greenAccent
                                                              .shade700,
                                                          Colors.white
                                                        ],
                                                        stops: [0, 1],
                                                        begin:
                                                            AlignmentDirectional(
                                                                -1, 0),
                                                        end:
                                                            AlignmentDirectional(
                                                                1, 0),
                                                      )
                                                    : null,
                                                color: isHovered
                                                    ? Colors.white12
                                                    : Colors.white),
                                            child: Column(
                                              children: [
                                                Gap(height / 100),
                                                Row(children: [
                                                  Gap(fontsize / 80),
                                                  Container(
                                                    width: fontsize / 19.2,
                                                    height: height / 10.17,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.greenAccent,
                                                          Colors.green
                                                        ],
                                                        stops: [0, 1],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0, -1),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child:
                                                            profileImageUrl !=
                                                                    null
                                                                ? Image.network(
                                                                    profileImageUrl,
                                                                    width: 32,
                                                                    height:
                                                                        height /
                                                                            16.95,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    headers:
                                                                        kHeader,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 50,
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(fontsize / 80),
                                                  Expanded(
                                                    child: Text(
                                                        admin.fullname ?? '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        90,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        admin.username ?? '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              fontsize / 90,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        admin.gmail ?? '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              fontsize / 100,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  Gap(fontsize / 80),
                                                  Expanded(
                                                    child: Text(
                                                        'Window ${admin.window}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              fontsize / 100,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ]),
                                                Gap(height / 100),
                                              ],
                                            ),
                                          ),
                                        ))));
                          });
                    }),
              ),
              Align(
                alignment: const Alignment(1, 0),
                child: Tooltip(
                  message: 'Add New Admin',
                  textStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: fontsize / 100,
                      fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(14)),
                  child: Container(
                    width: fontsize / 20,
                    height: fontsize / 20,
                    child: GestureDetector(
                      onTap: () {
                        _onADDAccountTap();
                      },
                      child: Lottie.asset(
                        'assets/add_doc.json',
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
