import 'package:plsp/Documents/DocumentController.dart';
import 'package:plsp/Documents/DocumentModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ListViewer extends StatefulWidget {
  final void Function(Document) onDocumentSelect;
  final VoidCallback onAddNew;
  final Future<List<Document>> documentsFuture;

  const ListViewer({
    super.key,
    required this.onDocumentSelect,
    required this.onAddNew,
    required this.documentsFuture,
  });

  @override
  State<ListViewer> createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late Future<DocumentCount> _docCount;
  late FMSRDocumentCountController _controller;
  List<Document> _filteredDocuments = [];
  late Future<List<Document>> _documentsFuture;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _controller = FMSRDocumentCountController(apiUrl: '$kUrl');
    _docCount = _controller.fetchRequestsCount();
    _searchController.addListener(_filterDocuments);
    _documentsFuture = widget.documentsFuture;
  }

  @override
  void didUpdateWidget(ListViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.documentsFuture != oldWidget.documentsFuture) {
      setState(() {
        _documentsFuture = widget.documentsFuture;
        _selectedIndex = null;
        _filterDocuments();
      });
    }
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
    widget.onAddNew();
  }

  void _onDocumentTap(Document document) {
    widget.onDocumentSelect(document);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 2,
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
                  height: height / 100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'All Documents',
                          style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Tooltip(
                            message: 'Total Documents',
                            textStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: fontsize / 80,
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
                                          fontSize: fontsize / 75,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade900),
                                    );
                                  } else {
                                    return const Text('0');
                                  }
                                })),
                        Expanded(
                          child: Align(
                            alignment: const Alignment(1, 0),
                            child: Tooltip(
                              message: 'Add Document',
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: fontsize / 80,
                                  fontWeight: FontWeight.bold),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade900,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Container(
                                width: fontsize / 30,
                                height: fontsize / 30,
                                child: GestureDetector(
                                  onTap: _onAddButtonPressed,
                                  child: Lottie.asset(
                                    'assets/add_doc.json',
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: fontsize/120, top: 4, right: fontsize/120),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: fontsize/137,
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
                      fontSize: fontsize/137,
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                flex: 13,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: fontsize / 37),
                        child: Row(
                          children: [
                            Gap(fontsize/80),
                            Expanded(
                              child: Text(
                                'Document Name',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 137),
                              ),
                            ),
                            SizedBox(
                              width: fontsize / 60,
                            ),
                            Expanded(
                              child: Text(
                                'Price',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 137),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'First Requirement',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 137),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Second Requirement',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 137),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Expanded(
                        child: FutureBuilder<List<Document>>(
                          future: _documentsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Lottie.asset('assets/Loading.json'));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Lottie.asset('assets/Loading.json'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
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
                                    onTap: () {
                                      _onDocumentTap(document);
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: fontsize/160, right: fontsize/160),
                                          child: Container(
                                            width: double.infinity,
                                            height: height/15,
                                            decoration: BoxDecoration(
                                              gradient: isSelected
                                                ? LinearGradient(
                                                    colors: [
                                                      Colors.greenAccent.shade700,
                                                      Colors.white
                                                    ],
                                                    stops: [0, 1],
                                                    begin: AlignmentDirectional(
                                                        -1, 0),
                                                    end: AlignmentDirectional(
                                                        1, 0),
                                                  )
                                                : null,
                                            color: isSelected
                                                ? null
                                                : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                             
                                               
                                            ),
                                            child: Row(
                                              children: [
                                                Lottie.asset(
                                                  isSelected
                                                      ? 'assets/Document.json'
                                                      : 'assets/DocumentNew.json',
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    document.Document_Name ??
                                                        'Unnamed Document',
                                                    style: GoogleFonts.poppins(
                                                        color: isSelected?   Colors.black: Colors.green.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 140),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: fontsize / 60,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Php ${document.Price?.toStringAsFixed(2) ?? 'N/A'}',
                                                    style: GoogleFonts.poppins(
                                                        color: isSelected
                                                            ? Colors
                                                                .black
                                                            : Colors.green.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 106),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    ' ${document.Requirements1 ?? 'N/A'}',
                                                    style: GoogleFonts.poppins(
                                                        color: isSelected
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${document.Requirements2 ?? 'N/A'}',
                                                    style: GoogleFonts.poppins(
                                                        color: isSelected
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 120),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height/101),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
