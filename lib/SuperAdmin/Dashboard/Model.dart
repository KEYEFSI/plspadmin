class RequestCountsToday {
  final int totalUnpaidRequests;
  final int totalPaidRequests;
  final double percentageTotalRequests;
  final double percentagePaidRequests;
  final int? claimedDocuments;  // Nullable
  final int? unclaimedDocuments;  // Nullable
  final double percentageClaimedDocuments;
  final double percentageUnclaimedDocuments;
  final bool increaseTotalRequests;
  final bool increasePaidRequests;
  final bool increaseClaimedDocuments;
  final bool increaseUnclaimedDocuments;
  final int totalStudents;
  final List<RequestByDate> graduatesRequestsByDate;
  final List<RequestByDate> collegeRequestsByDate;
  final List<RequestByDate> isRequestsByDate;

  RequestCountsToday({
    required this.totalUnpaidRequests,
    required this.totalPaidRequests,
    required this.percentageTotalRequests,
    required this.percentagePaidRequests,
    this.claimedDocuments,
    this.unclaimedDocuments,
    required this.percentageClaimedDocuments,
    required this.percentageUnclaimedDocuments,
    required this.increaseTotalRequests,
    required this.increasePaidRequests,
    required this.increaseClaimedDocuments,
    required this.increaseUnclaimedDocuments,
    required this.totalStudents,
    required this.graduatesRequestsByDate,
    required this.collegeRequestsByDate,
    required this.isRequestsByDate,
  });

  factory RequestCountsToday.fromJson(Map<String, dynamic> json) {
    return RequestCountsToday(
      totalUnpaidRequests: json['totalUnpaidRequests'] as int,
      totalPaidRequests: json['totalPaidRequests'] as int,
      percentageTotalRequests: double.tryParse(json['percentageTotalRequests']?.toString() ?? '0.0') ?? 0.0,
      percentagePaidRequests: double.tryParse(json['percentagePaidRequests']?.toString() ?? '0.0') ?? 0.0,
      claimedDocuments: json['claimedDocuments'] != null ? int.tryParse(json['claimedDocuments']?.toString() ?? '0') : null,
      unclaimedDocuments: json['unclaimedDocuments'] != null ? int.tryParse(json['unclaimedDocuments']?.toString() ?? '0') : null,
      percentageClaimedDocuments: double.tryParse(json['percentageClaimedDocuments']?.toString() ?? '0.0') ?? 0.0,
      percentageUnclaimedDocuments: double.tryParse(json['percentageUnclaimedDocuments']?.toString() ?? '0.0') ?? 0.0,
      increaseTotalRequests: json['increaseTotalRequests'] as bool,
      increasePaidRequests: json['increasePaidRequests'] as bool,
      increaseClaimedDocuments: json['increaseClaimedDocuments'] as bool,
      increaseUnclaimedDocuments: json['increaseUnclaimedDocuments'] as bool,
      totalStudents: json['totalStudents'] as int,
      graduatesRequestsByDate: (json['graduatesRequestsByDate'] as List<dynamic>)
          .map((item) => RequestByDate.fromJson(item as Map<String, dynamic>))
          .toList(),
      collegeRequestsByDate: (json['collegeRequestsByDate'] as List<dynamic>)
          .map((item) => RequestByDate.fromJson(item as Map<String, dynamic>))
          .toList(),
      isRequestsByDate: (json['isRequestsByDate'] as List<dynamic>)
          .map((item) => RequestByDate.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RequestByDate {
  final String date;
  final int paidRequests;
  final int unpaidRequests;
  final String percentageChange;
  final bool isIncreased;

  RequestByDate({
    required this.date,
    required this.paidRequests,
    required this.unpaidRequests,
    required this.percentageChange,
    required this.isIncreased,
  });

  factory RequestByDate.fromJson(Map<String, dynamic> json) {
    return RequestByDate(
      date: json['date'] as String,
      paidRequests: json['paidRequests'] as int,
      unpaidRequests: json['unpaidRequests'] as int,
      percentageChange: json['percentageChange'] as String,
      isIncreased: json['isIncreased'] as bool,
    );
  }
}

class RequestStats {
  final int unpaidRequests;
  final int paidRequests;
  final int claimedDocuments;
  final int unclaimedDocuments;

  RequestStats({
    required this.unpaidRequests,
    required this.paidRequests,
    required this.claimedDocuments,
    required this.unclaimedDocuments,
  });

  // Factory constructor to parse JSON and handle null values
  factory RequestStats.fromJson(Map<String, dynamic> json) {
    return RequestStats(
      unpaidRequests: json['unpaidRequests'] ?? 0, // Fallback to 0 if null
      paidRequests: json['paidRequests'] ?? 0,     // Fallback to 0 if null
      claimedDocuments: json['claimedDocuments'] ?? 0, // Fallback to 0 if null
      unclaimedDocuments: json['unclaimedDocuments'] ?? 0, // Fallback to 0 if null
    );
  }
}

class RequestData {
  final DateTime date;
  final int paidRequests;
  final int unpaidRequests;
  final int claimedDocuments;
  final int unclaimedDocuments;

  RequestData({
    required this.date,
    required this.paidRequests,
    required this.unpaidRequests,
    required this.claimedDocuments,
    required this.unclaimedDocuments,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
     date: DateTime.parse(json['date']),
      paidRequests: json['paidRequests'] as int,
      unpaidRequests: json['unpaidRequests'] as int,
      claimedDocuments: json['claimedDocuments'] as int,
      unclaimedDocuments: json['unclaimedDocuments'] as int,
    );
  }

  // Convert the RequestData to a JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'paidRequests': paidRequests,
      'unpaidRequests': unpaidRequests,
      'claimedDocuments': claimedDocuments,
      'unclaimedDocuments': unclaimedDocuments,
    };
  }

  @override
  String toString() {
    return 'RequestData(date: $date, paidRequests: $paidRequests, unpaidRequests: $unpaidRequests, '
        'claimedDocuments: $claimedDocuments, unclaimedDocuments: $unclaimedDocuments)';
  }
}

class HolidayDate {
  final String eventName;
   final DateTime date;

  HolidayDate({
    required this.eventName,
    required this.date,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) {
    return HolidayDate(
      eventName: json['eventName'] as String,
      date: DateTime.parse(json['date']),
    );
  }
}

class CombinedData {
  final List<RequestData> requestsByDate;
  final List<HolidayDate> holidayDates;

  CombinedData({
    required this.requestsByDate,
    required this.holidayDates,
  });

  factory CombinedData.fromJson(Map<String, dynamic> json) {
    var requestDataList = (json['requestsByDate'] as List<dynamic>)
        .map((item) => RequestData.fromJson(item as Map<String, dynamic>))
        .toList();
    
    var holidayDateList = (json['holidayDates'] as List<dynamic>)
        .map((item) => HolidayDate.fromJson(item as Map<String, dynamic>))
        .toList();

    return CombinedData(
      requestsByDate: requestDataList,
      holidayDates: holidayDateList,
    );
  }
}