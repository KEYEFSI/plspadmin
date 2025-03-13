import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/Students/ApprovedAccts/ISaccounts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApprovedAccounts extends StatefulWidget {
  const ApprovedAccounts({
    super.key,
  });

  @override
  State<ApprovedAccounts> createState() => _ApprovedAccountsState();
}

class _ApprovedAccountsState extends State<ApprovedAccounts> {

@override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: [
        Gap(height / 101),
        Text(
          'Student Accounts',
          style: GoogleFonts.poppins(
            fontSize: fontsize / 60,
            color: Colors.green.shade900,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Colors.green.shade900,
        ),
        Gap(height / 101),
      
                const Expanded(
                  child: ISAccounts()
                  
                ),
              ],
            ),
          );
        
      
    
  }
}











