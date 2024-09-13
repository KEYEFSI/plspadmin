import 'dart:convert';


import 'package:plsp/Documents/DocumentController.dart';
import 'package:plsp/Documents/DocumentModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;



class EditPage extends StatefulWidget {
  final bool showEditablePage;
  final Document? editableDocument;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditPage({
    super.key,
    required this.showEditablePage,
    required this.editableDocument,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  late TextEditingController _requirements1Controller;
  late TextEditingController _requirements2Controller;
  late TextEditingController _priceController;
  
   final _formKey = GlobalKey<FormState>();

    final DocumentController _controller = DocumentController(kUrl);
 
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant EditPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editableDocument != oldWidget.editableDocument) {
      _initializeControllers();
    }
  }

  void showDeleteDialog(BuildContext context) {
  showDialog(
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
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Cancel'),
          ),
          TextButton(
          onPressed: () {
    _deleteDocument(); 
    Navigator.of(context).pop(); 
  },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


   Future<void> _deleteDocument() async {
         
    try {
      await _controller.deleteDocument(_nameController.text);

       _showDialogDelete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }finally {
      widget.onCancel(); // Always call onCancel after attempting delete
    }

  }

  void _initializeControllers() {
    _nameController = TextEditingController(
        text: widget.editableDocument?.Document_Name ?? '');
    _requirements1Controller = TextEditingController(
        text: widget.editableDocument?.Requirements1 ?? '');
    _requirements2Controller = TextEditingController(
        text: widget.editableDocument?.Requirements2 ?? '');
    _priceController = TextEditingController(
        text: widget.editableDocument?.Price?.toStringAsFixed(2) ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _requirements1Controller.dispose();
    _requirements2Controller.dispose();
    _priceController.dispose();
    super.dispose();
  }

 Future<void> _saveDocument() async {
  if (_formKey.currentState!.validate()) {
    final document = Document(
      Document_Name: _nameController.text,
      Requirements1: _requirements1Controller.text,
      Requirements2: _requirements2Controller.text,
      Price: double.tryParse(_priceController.text) ?? 0.0,
    );

    final url = Uri.parse('$kUrl/FMSR_SaveOrUpdateDocument');
    
    try {
      final response = await http.post(
        url,
        headers: kHeader,
        body: jsonEncode(document.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
         _showDialogSuccess();
          widget.onSave(); 
        
        } else {
          throw Exception(jsonResponse['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to save or update document');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save/update document')),
      );
    }
  }
}

void _showDialogSuccess() {
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

void _showDialogDelete() {
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
                    'assets/Delete.json',
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
      final fontsize = 
        MediaQuery.of(context).size.width;
        final height =  MediaQuery.of(context).size.height;


    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: fontsize/80.0, top: height/42, bottom: height/42),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: widget.showEditablePage
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: fontsize/80.0, right: fontsize/80.0, top: height/42),
                        child: Row(
                          children: [
                            Lottie.asset(
                              widget.editableDocument == null
                                  ? 'assets/add_doc.json'
                                  : 'assets/Document.json',
                              width: fontsize / 40,
                              height: fontsize / 40,
                            ),
                            Text(
                              widget.editableDocument == null
                                  ? 'Add Document'
                                  : 'Edit Document',
                              style: GoogleFonts.poppins(
                                  fontSize: fontsize / 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: height/101,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Gap(height/42),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Document Name',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 106,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize/106
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a document name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Price',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 106,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize/106
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _requirements1Controller,
                            decoration: InputDecoration(
                              labelText: 'First Requirement',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 106,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize/106
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the first requirement';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _requirements2Controller,
                            decoration: InputDecoration(
                              labelText: 'Second Requirement',
                              labelStyle: GoogleFonts.poppins(
                                fontSize: fontsize / 106,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: fontsize/106
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the second requirement';
                              }
                              return null;
                            },
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: fontsize / 70,
                      ),
                        Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: ElevatedButton(
                        onPressed: _saveDocument,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade900,
                                Colors.greenAccent.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MaterialIcons.move_to_inbox,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.editableDocument == null
                                    ? 'Save'
                                    : 'Update',
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize/106,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: ElevatedButton(
                        onPressed: 
                       () {
    showDeleteDialog(context);
  },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade900,
                                Colors.redAccent.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MaterialIcons.delete_forever,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.editableDocument == null
                                    ? 'Cancel'
                                    : 'Delete',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
              : Center(
                  child: Lottie.asset('assets/Document.json',
                  fit: BoxFit.cover),

                  
                ),
        ),
      ),
    );
  }
}
           