class OrderDetailModel {
  bool? status;
  String? message;
  List<Products>? products;
  List<String>? billings;
  List<Others>? others;

  OrderDetailModel(
      {this.status, this.message, this.products, this.billings, this.others});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['Products'] != null) {
      products = <Products>[];
      json['Products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    billings = json['Billings'].cast<String>();
    if (json['Others'] != null) {
      others = <Others>[];
      json['Others'].forEach((v) {
        others!.add(Others.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (products != null) {
      data['Products'] = products!.map((v) => v.toJson()).toList();
    }
    data['Billings'] = billings;
    if (others != null) {
      data['Others'] = others!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  int? variationId;
  String? productName;
  int? quantity;
  double? total;

  Products(
      {this.productId,
        this.variationId,
        this.productName,
        this.quantity,
        this.total});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    variationId = json['variation_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    total = json['total'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['total'] = total;
    return data;
  }
}

class Others {
  String? orderId;
  String? date;
  String? total;
  String? paymentMethod;
  String? status;
  dynamic nIF;
  dynamic student;
  dynamic courso;

  Others(
      {this.orderId,
        this.date,
        this.total,
        this.paymentMethod,
        this.status,
        this.nIF,
        this.student,
        this.courso});

  Others.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    date = json['date'];
    total = json['total'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    nIF = json['NIF'];
    student = json['Student'];
    courso = json['Courso'].runtimeType == List ? json['Courso'].cast<String>() : json['Courso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['date'] = date;
    data['total'] = total;
    data['payment_method'] = paymentMethod;
    data['status'] = status;
    data['NIF'] = nIF;
    data['Student'] = student;
    data['Courso'] = courso;
    return data;
  }
}
