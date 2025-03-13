class DocumentCount {
  final int count;

  DocumentCount({required this.count});

  factory DocumentCount.fromJson(Map<String, dynamic> json) {
    return DocumentCount(
      count: json['count'],
    );
  }
}

class Document {
  final String? Document_Name;
  final String? Requirements1;
  final String? Requirements2;
  final double? Price;
  final String? Hint1;
  final String? Hint2;

  Document({
    this.Document_Name,
    this.Requirements1,
    this.Requirements2,
    this.Price,
    this.Hint1,
    this.Hint2,
  });

  // Factory constructor to create a Document from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      Document_Name: json['Document_Name'] as String?,
      Requirements1: json['Requirements1'] as String?,
      Requirements2: json['Requirements2'] as String?,
      Price: (json['Price'] as num?)?.toDouble(),
      Hint1: json['Hint1'] as String?,
      Hint2: json['Hint2'] as String?,
    );
  }

  // Convert Document to JSON
  Map<String, dynamic> toJson() {
    return {
      'Document_Name': Document_Name,
      'Requirements1': Requirements1,
      'Requirements2': Requirements2,
      'Price': Price,
      'Hint1': Hint1,
      'Hint2': Hint2,
    };
  }
}
