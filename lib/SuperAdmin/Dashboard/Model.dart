class RequestCountsToday {
  final int totalStudents;
  final int totalUnpaidRequests;
  final double percentageUnpaidRequests;
  final bool increaseUnpaidRequests;
  final int totalPaidRequests;
  final double percentagePaidRequests;
  final bool increasePaidRequests;
  final int claimedDocuments;
  final double percentageClaimedDocuments;
  final bool increaseClaimedDocuments;
  final int unclaimedDocuments;
  final double percentageUnclaimedDocuments;
  final bool increaseUnclaimedDocuments;

  RequestCountsToday({
    required this.totalStudents,
    required this.totalUnpaidRequests,
    required this.percentageUnpaidRequests,
    required this.increaseUnpaidRequests,
    required this.totalPaidRequests,
    required this.percentagePaidRequests,
    required this.increasePaidRequests,
    required this.claimedDocuments,
    required this.percentageClaimedDocuments,
    required this.increaseClaimedDocuments,
    required this.unclaimedDocuments,
    required this.percentageUnclaimedDocuments,
    required this.increaseUnclaimedDocuments,
  });

  factory RequestCountsToday.fromJson(Map<String, dynamic> json) {
    return RequestCountsToday(
      totalStudents: json['totalStudents'] as int,
      totalUnpaidRequests: json['unpaidRequests']['count'] as int,
      percentageUnpaidRequests:
          double.tryParse(json['unpaidRequests']['percentage'].toString()) ?? 0.0,
      increaseUnpaidRequests: json['unpaidRequests']['increase'] as bool,
      totalPaidRequests: json['paidRequests']['count'] as int,
      percentagePaidRequests:
          double.tryParse(json['paidRequests']['percentage'].toString()) ?? 0.0,
      increasePaidRequests: json['paidRequests']['increase'] as bool,
      claimedDocuments: json['claimedDocuments']['count'] as int,
      percentageClaimedDocuments:
          double.tryParse(json['claimedDocuments']['percentage'].toString()) ?? 0.0,
      increaseClaimedDocuments: json['claimedDocuments']['increase'] as bool,
      unclaimedDocuments: json['unclaimedDocuments']['count'] as int,
      percentageUnclaimedDocuments:
          double.tryParse(json['unclaimedDocuments']['percentage'].toString()) ?? 0.0,
      increaseUnclaimedDocuments: json['unclaimedDocuments']['increase'] as bool,
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