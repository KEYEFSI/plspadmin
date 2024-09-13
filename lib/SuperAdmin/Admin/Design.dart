import 'package:plsp/SuperAdmin/Admin/Create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Design extends StatelessWidget {
  const Design({
    super.key,
    required this.fontsize,
  });

  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
            EdgeInsetsDirectional.fromSTEB(fontsize / 100, 0, 0, fontsize / 100),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Lottie.asset(
            'assets/DesignAcc.json',
            fit: BoxFit.contain
          ),
        ),
      ),
    );
  }
}