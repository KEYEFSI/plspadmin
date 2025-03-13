import 'package:plsp/Documents/DocumentController.dart';
import 'package:plsp/Documents/DocumentModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:plsp/Documents/ListViewDoc.dart';
import 'package:plsp/Documents/EditPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DocumentPage extends StatefulWidget {
final String username;
  final String fullname;

  const DocumentPage(
      {super.key, required this.username, required this.fullname});
  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  bool _showEditablePage = false;
  Document? _editableDocument;
  late Future<List<Document>> _documentsFuture;
  final GetDocuments documentController = GetDocuments('$kUrl');

  @override
  void initState() {
    super.initState();
    _documentsFuture = Future.value([]);
    _fetchAllDocuments();
  }
  
  void _onEditDocument(Document document) {
    setState(() {
      _editableDocument = document;
      _showEditablePage = true;
    });
  }

  void _onAddNewDocument() {
    setState(() {
      _editableDocument = null;
      _showEditablePage = true;
    });
  }

void _onSaveDocument()  {
  setState(() {
    _showEditablePage = false;
  });

   _fetchAllDocuments(); 
}


Future<void> _fetchAllDocuments() async {
try {
      final fetchedDocuments = await documentController.fetchStudentData();
      setState(() {
        _documentsFuture = Future.value(fetchedDocuments); 
      });
    } catch (e) {
      print('Error fetching documents: $e'); 
    }
}


  
  void _onCancel() {
    setState(() {
      _showEditablePage = false;
      _editableDocument = null;
      
    });

    _fetchAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = 
        MediaQuery.of(context).size.width;
        final height =  MediaQuery.of(context).size.height;
        final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMMM dd, yyyy');
    final String formatted = formatter.format(now);
    return Scaffold(
      appBar:  AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'Good Day,',
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
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 30),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/dashboardbg.png'), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              
              Expanded(
                flex: 9,
                child: Container(
                  child: Row(
                    children: [
                      ListViewer(
                        onDocumentSelect: _onEditDocument,
                        onAddNew: _onAddNewDocument,
                        documentsFuture: _documentsFuture,
                      ),
                      EditPage(
                        showEditablePage: _showEditablePage,
                        editableDocument: _editableDocument,
                        onSave: _onSaveDocument,
                        onCancel: _onCancel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
