import 'package:plsp/Documents/DocumentController.dart';
import 'package:plsp/Documents/DocumentModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ListViewer extends StatefulWidget {
  const ListViewer({super.key});

  @override
  State<ListViewer> createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late Future<DocumentCount> _docCount;
  late FMSRDocumentCountController _controller;
  late Future<List<Document>> _documentsFuture;
  List<Document> _filteredDocuments = [];
  int? _selectedIndex;
  bool _showEditablePage = false;
  Document? _editableDocument;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _controller = FMSRDocumentCountController(apiUrl: '$kUrl');
    _docCount = _controller.fetchRequestsCount();
    final GetDocuments documentController = GetDocuments('$kUrl');
    _documentsFuture = documentController.fetchStudentData();

    _searchController.addListener(_filterDocuments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterDocuments() async {
    final query = _searchController.text.toLowerCase();

    final documents = await _documentsFuture;

    setState(() {
      _filteredDocuments = documents.where((document) {
        final name = document.Document_Name?.toLowerCase() ?? '';
        final requirement1 = document.Requirements1?.toLowerCase() ?? '';
        final requirement2 = document.Requirements2?.toLowerCase() ?? '';
        return name.contains(query) ||
            requirement1.contains(query) ||
            requirement2.contains(query);
      }).toList();
    });
  }

  void _onAddButtonPressed() {
    setState(() {
      _showEditablePage = true;
      _editableDocument = null; // Create a new document
    });
  }

  void _onDocumentTap(Document document) {
    setState(() {
      _showEditablePage = true;
      _editableDocument = document; // Edit the selected document
    });
  }

  void _saveDocument() {
    // Implement save logic here
    // After saving, reset the state to show the list again
    setState(() {
      _showEditablePage = false;
      _editableDocument = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.height +
        MediaQuery.of(context).size.width);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: _showEditablePage ? 0 : 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'All Documents',
                                style: GoogleFonts.poppins(
                                    fontSize: fontsize / 125,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900),
                              ),
                              const SizedBox(width: 8),
                              Tooltip(
                                  message: 'Total Documents',
                                  textStyle: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: fontsize / 185,
                                      fontWeight: FontWeight.bold),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade900,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: FutureBuilder<DocumentCount>(
                                      future: _docCount,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Lottie.asset('assets/Loading.json');
                                        } else if (snapshot.hasError) {
                                          return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            '(${snapshot.data!.count})',
                                            style: GoogleFonts.poppins(
                                                fontSize: fontsize / 150,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade900),
                                          );
                                        } else {
                                          return Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                                        }
                                      })),
                              Expanded(
                                child: Container(
                                  width: fontsize / 30,
                                  height: fontsize / 30,
                                  child: Align(
                                    alignment: const Alignment(1, 0),
                                    child: GestureDetector(
                                      onTap: _onAddButtonPressed,
                                      child: Lottie.asset(
                                        'assets/add_doc.json',
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 14.0,
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
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 13,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                        ),
                        child: FutureBuilder<List<Document>>(
                          future: _documentsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: Lottie.asset(
                                                  'assets/Loading.json',
                                                  fit: BoxFit.contain,
                                                ),);
                            } else if (snapshot.hasError) {
                              return Center(child:  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child:  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain));
                            } else {
                              final documents = snapshot.data!;
                              _filteredDocuments = _filteredDocuments.isEmpty &&
                                      _searchController.text.isEmpty
                                  ? documents
                                  : _filteredDocuments;
                              return ListView.builder(
                                itemCount: _filteredDocuments.length,
                                itemBuilder: (context, index) {
                                  final document = _filteredDocuments[index];
                                  final isSelected = _selectedIndex == index;
                                  return GestureDetector(
                                    onTap: () => _onDocumentTap(document),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 12),
                                          child: Container(
                                            width: double.infinity,
                                            height: fontsize / 45,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.green.shade100
                                                  : Colors.white,
                                              borderRadius: BorderRadius.circular(14),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: Colors.green,
                                                      width: 2.0,
                                                    )
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Lottie.asset(
                                                  isSelected
                                                      ? 'assets/Document.json'
                                                      : 'assets/DocumentNew.json',
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(document.Document_Name ??
                                                          'Unnamed Document', 
                                                          style: GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: fontsize / 200
                                                          ),
                                                      ),
                                                      Text(
                                                        'Requirements: ${document.Requirements1 ?? 'N/A'}, ${document.Requirements2 ?? 'N/A'}',
                                                        style: GoogleFonts.poppins(
                                                          color: isSelected ? Colors.green.shade900 : Colors.blueGrey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: fontsize / 200
                                                        ),
                                                      ),
                                                      Text(
                                                        'Price: Php ${document.Price?.toStringAsFixed(2) ?? 'N/A'}',
                                                        style: GoogleFonts.poppins(
                                                          color: isSelected ? Colors.green.shade900 : Colors.blueGrey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: fontsize / 200
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
       
          if (_showEditablePage)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    width: 600,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _editableDocument == null
                              ? 'Add Document'
                              : 'Edit Document',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Document Name',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                              text: _editableDocument?.Document_Name ?? ''),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Requirements 1',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                              text: _editableDocument?.Requirements1 ?? ''),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Requirements 2',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                              text: _editableDocument?.Requirements2 ?? ''),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: _editableDocument?.Price?.toString() ?? ''),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _saveDocument,
                              child: Text(_editableDocument == null
                                  ? 'Save'
                                  : 'Update'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showEditablePage = false;
                                  _editableDocument = null;
                                });
                              },
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
