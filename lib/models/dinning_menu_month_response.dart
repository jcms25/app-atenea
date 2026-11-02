import 'dinning_menu_response.dart';

class DinningMenuMonthResponse {
  bool? status;
  String? message;
  DinningMenuMonthData? data;

  DinningMenuMonthResponse({this.status, this.message, this.data});

  DinningMenuMonthResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['data'] != null
        ? DinningMenuMonthData.fromJson(json['data'])
        : null;
  }
}

class DinningMenuMonthData {
  int? month;
  int? year;
  String? firstMonth;
  String? lastMonth;
  String? pdfUrl;
  List<DinningMenuData> days = [];

  DinningMenuMonthData.fromJson(Map<String, dynamic> json) {
    month = int.tryParse('${json['month']}');
    year = int.tryParse('${json['year']}');
    firstMonth = json['first_month'];
    lastMonth = json['last_month'];
    pdfUrl = json['pdf_url'];
    if (json['days'] != null) {
      for (final item in json['days']) {
        days.add(DinningMenuData.fromJson(item));
      }
    }
  }
}
