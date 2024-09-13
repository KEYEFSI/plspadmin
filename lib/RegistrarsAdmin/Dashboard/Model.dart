class RequestCountsToday {
  final int collegeStudentsCount;
  final int paidDocumentsCount;
  final int unpaidDocumentsCount;
  final int claimedDocumentsCount;
  final double paidPercentageChange;
  final double unpaidPercentageChange;
  final double claimedPercentageChange;
  final bool isPaidIncreasing;
  final bool isUnpaidIncreasing;
  final bool isClaimedIncreasing;

  RequestCountsToday({
    required this.collegeStudentsCount,
    required this.paidDocumentsCount,
    required this.unpaidDocumentsCount,
    required this.claimedDocumentsCount,
    required this.paidPercentageChange,
    required this.unpaidPercentageChange,
    required this.claimedPercentageChange,
    required this.isPaidIncreasing,
    required this.isUnpaidIncreasing,
    required this.isClaimedIncreasing,
  });

  factory RequestCountsToday.fromJson(Map<String, dynamic> json) {
    return RequestCountsToday(
      collegeStudentsCount: json['collegeStudentsCount'] ?? 0,  // Fallback to 0 if null
      paidDocumentsCount: json['paidDocumentsCountAll'] ?? 0,   // Fallback to 0 if null
      unpaidDocumentsCount: json['unpaidDocumentsCountAll'] ?? 0, // Fallback to 0 if null
      claimedDocumentsCount: json['claimedDocumentsCountToday'] ?? 0, // Fallback to 0 if null
      paidPercentageChange: (json['paidPercentageChange'] ?? 0.0).toDouble(), // Ensure it's double
      unpaidPercentageChange: (json['unpaidPercentageChange'] ?? 0.0).toDouble(), // Ensure it's double
      claimedPercentageChange: (json['claimedPercentageChange'] ?? 0.0).toDouble(), // Ensure it's double
      isPaidIncreasing: json['isPaidIncreasing'] ?? false, // Fallback to false if null
      isUnpaidIncreasing: json['isUnpaidIncreasing'] ?? false, // Fallback to false if null
      isClaimedIncreasing: json['isClaimedIncreasing'] ?? false, // Fallback to false if null
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
  final String today;
  final int claimableRequests;
  final int nonClaimableRequests;
  final int claimedRequests;

  RequestStats({
    required this.today,
    required this.claimableRequests,
    required this.nonClaimableRequests,
    required this.claimedRequests,
  });

  // Factory constructor to create a RequestStats object from JSON data
  factory RequestStats.fromJson(Map<String, dynamic> json) {
    return RequestStats(
      today: json['today'],
      claimableRequests: json['paidDocuments']['claimableRequests'] ?? 0,
      nonClaimableRequests: json['paidDocuments']['nonClaimableRequests'] ?? 0,
      claimedRequests: json['accomplishedDocuments']['claimedRequests'] ?? 0,
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