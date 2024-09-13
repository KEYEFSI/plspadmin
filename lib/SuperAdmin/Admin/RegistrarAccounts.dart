import 'package:plsp/SuperAdmin/Admin/AdminController.dart';
import 'package:plsp/SuperAdmin/Admin/AdminModel.dart';
import 'package:plsp/SuperAdmin/SuperAdminNav/ProfileModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Registrar_Admin extends StatefulWidget {
  final Future<List<RegistrarAdmin>> Finance;
  final VoidCallback onDelete;

  const Registrar_Admin({
    super.key,
    required this.fontsize,
    required this.Finance,
    required this.onDelete,
  });

  final double fontsize;

  @override
  State<Registrar_Admin> createState() => _Registrar_AdminState();
}

class _Registrar_AdminState extends State<Registrar_Admin> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  List<RegistrarAdmin> _filteredAdmins = [];
  bool _isLoading = false;
  int? _selectedIndex;
  late Future<List<RegistrarAdmin>> _finance;
  final DeleteController adminController = DeleteController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _searchController.addListener(_filterAccounts);
    _finance = widget.Finance;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Registrar_Admin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.Finance != oldWidget.Finance) {
      setState(() {
        _finance = widget.Finance;
        _selectedIndex = null;
        _filterAccounts();
      });
    }
  }

  void _filterAccounts() async {
    final query = _searchController.text.toLowerCase();
    final accounts = await _finance;

    setState(() {
      _filteredAdmins = accounts.where((accounts) {
        final fullname = accounts.fullname?.toLowerCase() ?? '';
        final username = accounts.username?.toLowerCase() ?? '';
        return fullname.contains(query) || username.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
      final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, widget.fontsize / 100,
            widget.fontsize / 100, widget.fontsize / 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12),
                child: Row(
                  children: [
                    Lottie.asset('assets/money.json',
                          width: widget.fontsize / 30,
                        height: widget.fontsize / 30),
                    Text(
                      'Registrars Admin Accounts',
                      style: GoogleFonts.poppins(
                          color: Colors.green.shade900,
                          fontSize: widget.fontsize / 120,
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
                 padding: EdgeInsets.all(fontsize/80.0),
                child: Container(
                   height: height/20,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: GoogleFonts.poppins(
                         fontSize:fontsize/137,
                        color: Theme.of(context).primaryColor,
                      ),
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
                          color: Theme.of(context).primaryColorLight,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      filled: false,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      prefixIcon: Icon(
                        FontAwesome.search,
                        color: Theme.of(context).primaryColor,
                        size: fontsize/80,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                         fontSize:fontsize/137,
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<RegistrarAdmin>>(
                  future: _finance,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Lottie.asset('assets/Loading.json'));
                    } else if (snapshot.hasError) {
                      return Center(child: Lottie.asset('assets/Loading.json'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No documents found'));
                    } else {
                      final documents = snapshot.data!;
                      _filteredAdmins = _filteredAdmins.isEmpty &&
                              _searchController.text.isEmpty
                          ? documents
                          : _filteredAdmins;
                      return ListView.builder(
                        itemCount: _filteredAdmins.length,
                        itemBuilder: (context, index) {
                          final account = _filteredAdmins[index];
                          final isSelected = _selectedIndex == index;
                          final profileImageUrl = account.profileImage != null
                              ? '$Purl${account.profileImage}'
                              : null;
                         return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: Container(
                                    width: double.infinity,
                                          height: isSelected
                                              ? height / 14
                                              : height / 16,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                                ? LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.greenAccent.shade700
                                                      
                                                    ],
                                                    stops: [0, 1],
                                                    begin: AlignmentDirectional(
                                                        1, 0),
                                                    end: AlignmentDirectional(
                                                        -1, 0),
                                                  )
                                                : null,
                                            color: isSelected
                                                ? null
                                                : Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(12,
                                                  0, widget.fontsize / 245, 0),
                                          child: Container(
                                              width: fontsize / 32,
                                                      height: height / 16.95,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xff80ff72),
                                                  Color(0xff7ee8fa),
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: profileImageUrl != null
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                            profileImageUrl,
                                                            headers: kHeader,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                ),
                                                child: profileImageUrl == null
                                                    ? Icon(
                                                        Icons.person,
                                                        size: widget.fontsize /
                                                            122.375,
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                account.fullname ??
                                                    'Unnamed Document',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        widget.fontsize / 137),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  account.username ?? '',
                                                  style: GoogleFonts.poppins(
                                                      color: isSelected
                                                          ? Colors
                                                              .green.shade900
                                                          : Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          widget.fontsize /
                                                              120),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(thickness: 1,
                                        indent: height/101,
                                        endIndent: height/101,
                                        color: Colors.green.shade900,),

                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:  EdgeInsets.only(top: height/120.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Ionicons.call,
                                                        color:
                                                            Colors.green.shade900,
                                                        size:
                                                            widget.fontsize / 100,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          account.number ??
                                                              'NOT EDITED BY THE USER',
                                                          style: GoogleFonts.poppins(
                                                              color: isSelected
                                                                  ? Colors.green
                                                                      .shade900
                                                                  : Colors
                                                                      .blueGrey,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize: widget
                                                                      .fontsize /
                                                                  160,
                                                              letterSpacing: 0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                            
                                                      Icon(
                                                        Ionicons.ios_location,
                                                        color:
                                                            Colors.green.shade900,
                                                        size:
                                                            widget.fontsize / 100,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          account.address ??
                                                              'NOT EDITED BY THE USER',
                                                          style: GoogleFonts.poppins(
                                                              color: isSelected
                                                                  ? Colors.green
                                                                      .shade900
                                                                  : Colors.blueGrey,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize:
                                                                  widget.fontsize /
                                                                      160,
                                                              letterSpacing: 0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        isSelected
                                            ? Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    adminController.deleteAdmin(
                                                        account.username
                                                            .toString());
                                                            widget.onDelete();
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Lottie.asset(
                                                      'assets/Delete.json',
                                                      fit: BoxFit.contain,
                                                      width: isSelected
                                                          ? widget.fontsize / 50
                                                          : widget.fontsize /
                                                              100,
                                                      height:
                                                          widget.fontsize / 50,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
