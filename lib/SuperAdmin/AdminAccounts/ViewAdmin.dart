import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'Controller.dart';
import 'Model.dart';
import 'package:plsp/common/common.dart';

class EditPage extends StatefulWidget {
  final bool showEditablePage;
  final AdminModel? adminAccounts;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final int? selectedIndex;

  const EditPage({
    super.key,
    required this.showEditablePage,
    required this.adminAccounts,
    required this.onSave,
    required this.onCancel,
    this.selectedIndex,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final DeleteAdminController _deleteAdminController = DeleteAdminController();
  bool isLoading = false;
  String? errorMessage;

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
  
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return widget.showEditablePage
        ? Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: fontsize / 80.0),
                child: Container(
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/backgroundlogin.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: widget.adminAccounts?.profileImage != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      '$Purl${widget.adminAccounts?.profileImage}',
                                      headers: kHeader,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/backgroundlogin.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24))),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                fontsize / 200, 0, 0, fontsize / 200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(fontsize / 80),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: fontsize / 80.0),
                                        child: Text('Profile Information',
                                            style: GoogleFonts.outfit(
                                              color: Colors.green.shade900,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontsize / 60,
                                            )),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.green.shade900,
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: fontsize / 80.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text('Admin ID:',
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        Colors.green.shade300,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 100,
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                widget.adminAccounts
                                                        ?.username ??
                                                    '',
                                                style: GoogleFonts.outfit(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontsize / 80,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: fontsize / 80.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text('Full Name:',
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        Colors.green.shade300,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 100,
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                widget.adminAccounts
                                                        ?.fullname ??
                                                    '',
                                                style: GoogleFonts.outfit(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontsize / 80,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: fontsize / 80.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text('Email:',
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        Colors.green.shade300,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 100,
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                widget.adminAccounts?.gmail ??
                                                    '',
                                                style: GoogleFonts.outfit(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: fontsize / 80,
                                                  
                                                ),
                                                maxLines: 1,
                                               overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: fontsize / 80.0),
                                        child: Row(children: [
                                          Expanded(
                                            child: Text('Phone No. :',
                                                style: GoogleFonts.outfit(
                                                  color: Colors.green.shade300,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontsize / 100,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              widget.adminAccounts?.number ??
                                                  '',
                                              style: GoogleFonts.outfit(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: fontsize / 80,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(1, 0),
                                  child: Tooltip(
                                    message: 'Delete this Admin?',
                                    textStyle: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: fontsize / 100,
                                        fontWeight: FontWeight.bold),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: fontsize / 80),
                                      child: Container(
                                        width: fontsize / 20,
                                        child: ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () async {
                                                  final username = widget
                                                          .adminAccounts!
                                                          .username ??
                                                      '';
                                                  if (username.isEmpty) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    isLoading = true;
                                                    errorMessage = null;
                                                  });

                                                  final success =
                                                      await _deleteAdminController
                                                          .removeAdmin(
                                                              username);

                                                  setState(() {
                                                    isLoading = false;
                                                    widget.onSave;
                                                  });

                                                  if (success) {
                                                    _showSuccessMessage('Admin removed Successfully!');
                                                    setState(() {
                                                      widget.onSave();
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage =
                                                          _deleteAdminController
                                                              .errorMessage;
                                                    });

                                                    _showErrorMessage('${_deleteAdminController
                                                              .errorMessage}');
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                20,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.red.shade900,
                                                  Colors.redAccent.shade700,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  MaterialIcons.delete_forever,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
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
                    ],
                  ),
                )),
          )
        : const SizedBox.shrink();
  }
}
