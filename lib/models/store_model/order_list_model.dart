class OrderList {
  bool? status;
  String? message;
  List<OrderItem>? data;

  OrderList({this.status, this.message, this.data});

  OrderList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <OrderItem>[];
      json['data'].forEach((v) {
        data!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  String? orderId;
  String? date;
  String? total;
  String? status;
  String? invoiceLink;

  OrderItem({this.orderId, this.date, this.total, this.status,this.invoiceLink});

  OrderItem.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    date = json['date'];
    total = json['total'];
    status = json['status'];
    invoiceLink = json["packing_slip"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['date'] = date;
    data['total'] = total;
    data['status'] = status;
    data["packing_slip"] = invoiceLink;
    return data;
  }
}
