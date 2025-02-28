class DinningMonthListResponse {
  bool? status;
  String? message;
  DinningMonthData? data;

  DinningMonthListResponse({this.status, this.message, this.data});

  DinningMonthListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['data'] != null ? DinningMonthData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DinningMonthData {
  String? year;
  String? months;
  List<String>? days;

  DinningMonthData({this.year, this.months, this.days});

  DinningMonthData.fromJson(Map<String, dynamic> json) {
    year = json['Year'];
    months = json['months'];
    days = json['days'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Year'] = year;
    data['months'] = months;
    data['days'] = days;
    return data;
  }
}
