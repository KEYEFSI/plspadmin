import 'package:intl/intl.dart';
import 'package:plsp/SuperAdmin/Admin/AdminController.dart';
import 'package:plsp/SuperAdmin/Admin/AdminModel.dart';
import 'package:plsp/SuperAdmin/Admin/Create.dart';
import 'package:plsp/SuperAdmin/Admin/Design.dart';
import 'package:plsp/SuperAdmin/Admin/FinanceAccounts.dart';
import 'package:plsp/SuperAdmin/Admin/RegistrarAccounts.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AdminAccounts extends StatefulWidget {

  final String username;
  final String fullname;

 const AdminAccounts(
      {super.key, required this.username, required this.fullname});


  @override
  State<AdminAccounts> createState() => _AdminAccountsState();
}

class _AdminAccountsState extends State<AdminAccounts> {
  late Future<List<FinanceAdmin>> _financeaccounts;
  final FinanceAdminController financeaccounts =
      FinanceAdminController('$kUrl');
  late Future<List<RegistrarAdmin>> _registraraccounts;
  final RegistrarAdminController registraraccounts =
      RegistrarAdminController('$kUrl');

  Future<void> _fetchAllFinance() async {
    try {
      final fetchedAdmin = await financeaccounts.fetchFinanceAdmins();
      setState(() {
        _financeaccounts = Future.value(fetchedAdmin);
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  Future<void> _fetchAllRegistrar() async {
    try {
      final fetchedAdmin = await registraraccounts.fetchRegistrarAdmins();
      setState(() {
        _registraraccounts = Future.value(fetchedAdmin);
      });
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _financeaccounts = Future.value([]);
    _registraraccounts = Future.value([]);
    _fetchAllFinance();
    _fetchAllRegistrar();
  }

  void _onSaveDocument() {
    _fetchAllRegistrar();
    _fetchAllFinance();
  }

  @override
  Widget build(BuildContext context) {
    
 final fontsize = (MediaQuery.of(context).size.width);
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
                      child:
                          Lottie.asset('assets/hi.json', fit: BoxFit.cover)),
        
                  
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
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                  image: AssetImage(
                    'assets/dashboardbg.png',
                  ),
                  fit: BoxFit.cover)),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Create(
                    fontsize: fontsize,
                    onSave: _onSaveDocument,
                  ),
                  Design(fontsize: fontsize)
                ],
              ),
            ),
            Finance_Admin(
              fontsize: fontsize,
              Finance: _financeaccounts,
               onDelete: _onSaveDocument,
            ),
            Registrar_Admin(
              fontsize: fontsize,
              Finance: _registraraccounts,
              onDelete: _onSaveDocument,
            ),
          ]),
        ),
      )),
    );
  }
}
