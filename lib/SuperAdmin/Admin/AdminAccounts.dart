import 'package:plsp/SuperAdmin/Admin/AdminController.dart';
import 'package:plsp/SuperAdmin/Admin/AdminModel.dart';
import 'package:plsp/SuperAdmin/Admin/Create.dart';
import 'package:plsp/SuperAdmin/Admin/Design.dart';
import 'package:plsp/SuperAdmin/Admin/FinanceAccounts.dart';
import 'package:plsp/SuperAdmin/Admin/RegistrarAccounts.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AdminAccounts extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Badge Account'),
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
          child: Expanded(
            flex: 8,
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
        ),
      )),
    );
  }
}
