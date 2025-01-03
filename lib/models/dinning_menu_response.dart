class DinningMenuResponse {
  bool? status;
  String? message;
  DinningMenuData? data;

  DinningMenuResponse({this.status, this.message, this.data});

  DinningMenuResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['data'] != null ? DinningMenuData.fromJson(json['data']) : null;
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

class DinningMenuData {
  String? menuId;
  String? menuDate;
  String? menuP1;
  String? menuP2;
  String? menuP3;
  String? menuP4;

  DinningMenuData(
      {this.menuId,
        this.menuDate,
        this.menuP1,
        this.menuP2,
        this.menuP3,
        this.menuP4});

  DinningMenuData.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    menuDate = json['menu_date'];
    menuP1 = json['menu_P1'];
    menuP2 = json['menu_P2'];
    menuP3 = json['menu_P3'];
    menuP4 = json['menu_P4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menu_id'] = menuId;
    data['menu_date'] = menuDate;
    data['menu_P1'] = menuP1;
    data['menu_P2'] = menuP2;
    data['menu_P3'] = menuP3;
    data['menu_P4'] = menuP4;
    return data;
  }
}
