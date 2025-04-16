class CheckoutResponse {
  int? orderId;
  String? status;
  String? orderKey;
  String? orderNumber;
  String? customerNote;
  int? customerId;
  BillingAddress? billingAddress;
  ShippingAddress? shippingAddress;
  String? paymentMethod;
  PaymentResult? paymentResult;
  // List<Null>? additionalFields;
  // Extensions? extensions;

  CheckoutResponse({this.orderId, this.status, this.orderKey, this.orderNumber, this.customerNote, this.customerId, this.billingAddress, this.shippingAddress, this.paymentMethod, this.paymentResult,
    // this.additionalFields,
    // this.extensions
  });

  CheckoutResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    status = json['status'];
    orderKey = json['order_key'];
    orderNumber = json['order_number'];
    customerNote = json['customer_note'];
    customerId = json['customer_id'];
    billingAddress = json['billing_address'] != null ? BillingAddress.fromJson(json['billing_address']) : null;
    shippingAddress = json['shipping_address'] != null ? ShippingAddress.fromJson(json['shipping_address']) : null;
    paymentMethod = json['payment_method'];
    paymentResult = json['payment_result'] != null ? PaymentResult.fromJson(json['payment_result']) : null;
    // if (json['additional_fields'] != null) {
    //   additionalFields = <Null>[];
    //   json['additional_fields'].forEach((v) { additionalFields!.add(new Null.fromJson(v)); });
    // }
    // extensions = json['extensions'] != null ? new Extensions.fromJson(json['extensions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['status'] = status;
    data['order_key'] = orderKey;
    data['order_number'] = orderNumber;
    data['customer_note'] = customerNote;
    data['customer_id'] = customerId;
    if (billingAddress != null) {
      data['billing_address'] = billingAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    data['payment_method'] = paymentMethod;
    if (paymentResult != null) {
      data['payment_result'] = paymentResult!.toJson();
    }
    // if (this.additionalFields != null) {
    //   data['additional_fields'] = this.additionalFields!.map((v) => v.toJson()).toList();
    // }
    // if (this.extensions != null) {
    //   data['extensions'] = this.extensions!.toJson();
    // }
    return data;
  }
}

class BillingAddress {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  BillingAddress({this.firstName, this.lastName, this.company, this.address1, this.address2, this.city, this.state, this.postcode, this.country, this.email, this.phone});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class ShippingAddress {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? phone;

  ShippingAddress({this.firstName, this.lastName, this.company, this.address1, this.address2, this.city, this.state, this.postcode, this.country, this.phone});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['country'] = country;
    data['phone'] = phone;
    return data;
  }
}

class PaymentResult {
  String? paymentStatus;
  List<Null>? paymentDetails;
  String? redirectUrl;

  PaymentResult({this.paymentStatus, this.paymentDetails, this.redirectUrl});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['payment_status'];
    // if (json['payment_details'] != null) {
    //   paymentDetails = <Null>[];
    //   json['payment_details'].forEach((v) { paymentDetails!.add(new Null.fromJson(v)); });
    // }
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_status'] = paymentStatus;
    // if (paymentDetails != null) {
    //   data['payment_details'] = paymentDetails!.map((v) => v.toJson()).toList();
    // }
    data['redirect_url'] = redirectUrl;
    return data;
  }
}

// class Extensions {
//
//
//   Extensions({});
//
// Extensions.fromJson(Map<String, dynamic> json) {
// }
//
// Map<String, dynamic> toJson() {
// final Map<String, dynamic> data = new Map<String, dynamic>();
// return data;
// }
// }