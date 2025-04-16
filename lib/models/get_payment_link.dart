class GetPaymentLink {
  int? id;
  int? parentId;
  String? status;
  String? currency;
  String? version;
  bool? pricesIncludeTax;
  String? dateCreated;
  String? dateModified;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? cartTax;
  String? total;
  String? totalTax;
  int? customerId;
  String? orderKey;
  Billing? billing;
  Shipping? shipping;
  String? paymentMethod;
  String? paymentMethodTitle;
  String? transactionId;
  String? customerIpAddress;
  String? customerUserAgent;
  String? createdVia;
  String? customerNote;
  // Null? dateCompleted;
  // Null? datePaid;
  String? cartHash;
  String? number;
  List<MetaData>? metaData;
  List<LineItems>? lineItems;
  List<TaxLines>? taxLines;
  // List<Null>? shippingLines;
  // List<Null>? feeLines;
  // List<Null>? couponLines;
  List<Null>? refunds;
  String? paymentUrl;
  bool? isEditable;
  bool? needsPayment;
  bool? needsProcessing;
  String? dateCreatedGmt;
  String? dateModifiedGmt;
  // Null? dateCompletedGmt;
  // Null? datePaidGmt;
  int? storeCreditUsed;
  String? currencySymbol;
  // Links? lLinks;

  GetPaymentLink(
      {this.id,
        this.parentId,
        this.status,
        this.currency,
        this.version,
        this.pricesIncludeTax,
        this.dateCreated,
        this.dateModified,
        this.discountTotal,
        this.discountTax,
        this.shippingTotal,
        this.shippingTax,
        this.cartTax,
        this.total,
        this.totalTax,
        this.customerId,
        this.orderKey,
        this.billing,
        this.shipping,
        this.paymentMethod,
        this.paymentMethodTitle,
        this.transactionId,
        this.customerIpAddress,
        this.customerUserAgent,
        this.createdVia,
        this.customerNote,
        // this.dateCompleted,
        // this.datePaid,
        this.cartHash,
        this.number,
        this.metaData,
        this.lineItems,
        this.taxLines,
        // this.shippingLines,
        // this.feeLines,
        // this.couponLines,
        this.refunds,
        this.paymentUrl,
        this.isEditable,
        this.needsPayment,
        this.needsProcessing,
        this.dateCreatedGmt,
        this.dateModifiedGmt,
        // this.dateCompletedGmt,
        // this.datePaidGmt,
        this.storeCreditUsed,
        this.currencySymbol,
        // this.lLinks
      });

  GetPaymentLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    status = json['status'];
    currency = json['currency'];
    version = json['version'];
    pricesIncludeTax = json['prices_include_tax'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    discountTotal = json['discount_total'];
    discountTax = json['discount_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    cartTax = json['cart_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    billing =
    json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null
        ? Shipping.fromJson(json['shipping'])
        : null;
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    transactionId = json['transaction_id'];
    customerIpAddress = json['customer_ip_address'];
    customerUserAgent = json['customer_user_agent'];
    createdVia = json['created_via'];
    customerNote = json['customer_note'];
    // dateCompleted = json['date_completed'];
    // datePaid = json['date_paid'];
    cartHash = json['cart_hash'];
    number = json['number'];
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    if (json['tax_lines'] != null) {
      taxLines = <TaxLines>[];
      json['tax_lines'].forEach((v) {
        taxLines!.add(TaxLines.fromJson(v));
      });
    }
    // if (json['shipping_lines'] != null) {
    //   shippingLines = <Null>[];
    //   json['shipping_lines'].forEach((v) {
    //     shippingLines!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['fee_lines'] != null) {
    //   feeLines = <Null>[];
    //   json['fee_lines'].forEach((v) {
    //     feeLines!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['coupon_lines'] != null) {
    //   couponLines = <Null>[];
    //   json['coupon_lines'].forEach((v) {
    //     couponLines!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['refunds'] != null) {
    //   refunds = <Null>[];
    //   json['refunds'].forEach((v) {
    //     refunds!.add(Null.fromJson(v));
    //   });
    // }
    paymentUrl = json['payment_url'];
    isEditable = json['is_editable'];
    needsPayment = json['needs_payment'];
    needsProcessing = json['needs_processing'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModifiedGmt = json['date_modified_gmt'];
    // dateCompletedGmt = json['date_completed_gmt'];
    // datePaidGmt = json['date_paid_gmt'];
    storeCreditUsed = json['store_credit_used'];
    currencySymbol = json['currency_symbol'];
    // lLinks = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['status'] = status;
    data['currency'] = currency;
    data['version'] = version;
    data['prices_include_tax'] = pricesIncludeTax;
    data['date_created'] = dateCreated;
    data['date_modified'] = dateModified;
    data['discount_total'] = discountTotal;
    data['discount_tax'] = discountTax;
    data['shipping_total'] = shippingTotal;
    data['shipping_tax'] = shippingTax;
    data['cart_tax'] = cartTax;
    data['total'] = total;
    data['total_tax'] = totalTax;
    data['customer_id'] = customerId;
    data['order_key'] = orderKey;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['transaction_id'] = transactionId;
    data['customer_ip_address'] = customerIpAddress;
    data['customer_user_agent'] = customerUserAgent;
    data['created_via'] = createdVia;
    data['customer_note'] = customerNote;
    // data['date_completed'] = dateCompleted;
    // data['date_paid'] = datePaid;
    data['cart_hash'] = cartHash;
    data['number'] = number;
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    if (taxLines != null) {
      data['tax_lines'] = taxLines!.map((v) => v.toJson()).toList();
    }
    // if (shippingLines != null) {
    //   data['shipping_lines'] =
    //       shippingLines!.map((v) => v.toJson()).toList();
    // }
    // if (feeLines != null) {
    //   data['fee_lines'] = feeLines!.map((v) => v.toJson()).toList();
    // }
    // if (couponLines != null) {
    //   data['coupon_lines'] = couponLines!.map((v) => v.toJson()).toList();
    // }
    // if (refunds != null) {
    //   data['refunds'] = refunds!.map((v) => v.toJson()).toList();
    // }
    data['payment_url'] = paymentUrl;
    data['is_editable'] = isEditable;
    data['needs_payment'] = needsPayment;
    data['needs_processing'] = needsProcessing;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified_gmt'] = dateModifiedGmt;
    // data['date_completed_gmt'] = dateCompletedGmt;
    // data['date_paid_gmt'] = datePaidGmt;
    data['store_credit_used'] = storeCreditUsed;
    data['currency_symbol'] = currencySymbol;
    // if (lLinks != null) {
    //   data['_links'] = lLinks!.toJson();
    // }
    return data;
  }
}

class Billing {
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

  Billing(
      {this.firstName,
        this.lastName,
        this.company,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.postcode,
        this.country,
        this.email,
        this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
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

class Shipping {
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

  Shipping(
      {this.firstName,
        this.lastName,
        this.company,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.postcode,
        this.country,
        this.phone});

  Shipping.fromJson(Map<String, dynamic> json) {
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

class MetaData {
  int? id;
  String? key;
  String? value;

  MetaData({this.id, this.key, this.value});

  MetaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}

class LineItems {
  int? id;
  String? name;
  int? productId;
  int? variationId;
  int? quantity;
  String? taxClass;
  String? subtotal;
  String? subtotalTax;
  String? total;
  String? totalTax;
  List<Taxes>? taxes;
  List<MetaData>? metaData;
  String? sku;
  double? price;
  Image? image;
  // Null? parentName;

  LineItems(
      {this.id,
        this.name,
        this.productId,
        this.variationId,
        this.quantity,
        this.taxClass,
        this.subtotal,
        this.subtotalTax,
        this.total,
        this.totalTax,
        this.taxes,
        this.metaData,
        this.sku,
        this.price,
        this.image,
        // this.parentName
      });

  LineItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    taxClass = json['tax_class'];
    subtotal = json['subtotal'];
    subtotalTax = json['subtotal_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    if (json['taxes'] != null) {
      taxes = <Taxes>[];
      json['taxes'].forEach((v) {
        taxes!.add(Taxes.fromJson(v));
      });
    }
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    sku = json['sku'];
    price = json['price'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    // parentName = json['parent_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = productId;
    data['variation_id'] = variationId;
    data['quantity'] = quantity;
    data['tax_class'] = taxClass;
    data['subtotal'] = subtotal;
    data['subtotal_tax'] = subtotalTax;
    data['total'] = total;
    data['total_tax'] = totalTax;
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    data['sku'] = sku;
    data['price'] = price;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    // data['parent_name'] = parentName;
    return data;
  }
}

class Taxes {
  int? id;
  String? total;
  String? subtotal;

  Taxes({this.id, this.total, this.subtotal});

  Taxes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total'] = total;
    data['subtotal'] = subtotal;
    return data;
  }
}

// class MetaData {
//   int? id;
//   String? key;
//   Value? value;
//   String? displayKey;
//   Value? displayValue;
//
//   MetaData({this.id, this.key, this.value, this.displayKey, this.displayValue});
//
//   MetaData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     key = json['key'];
//     value = json['value'] != null ? Value.fromJson(json['value']) : null;
//     displayKey = json['display_key'];
//     displayValue = json['display_value'] != null
//         ? Value.fromJson(json['display_value'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['key'] = key;
//     if (value != null) {
//       data['value'] = value!.toJson();
//     }
//     data['display_key'] = displayKey;
//     if (displayValue != null) {
//       data['display_value'] = displayValue!.toJson();
//     }
//     return data;
//   }
// }

class Value {
  double? incl;
  double? excl;

  Value({this.incl, this.excl});

  Value.fromJson(Map<String, dynamic> json) {
    incl = json['incl'];
    excl = json['excl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['incl'] = incl;
    data['excl'] = excl;
    return data;
  }
}

class Image {
  String? id;
  String? src;

  Image({this.id, this.src});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['src'] = src;
    return data;
  }
}

class TaxLines {
  int? id;
  String? rateCode;
  int? rateId;
  String? label;
  bool? compound;
  String? taxTotal;
  String? shippingTaxTotal;
  int? ratePercent;
  List<MetaData>? metaData;

  TaxLines(
      {this.id,
        this.rateCode,
        this.rateId,
        this.label,
        this.compound,
        this.taxTotal,
        this.shippingTaxTotal,
        this.ratePercent,
        this.metaData});

  TaxLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rateCode = json['rate_code'];
    rateId = json['rate_id'];
    label = json['label'];
    compound = json['compound'];
    taxTotal = json['tax_total'];
    shippingTaxTotal = json['shipping_tax_total'];
    ratePercent = json['rate_percent'];
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate_code'] = rateCode;
    data['rate_id'] = rateId;
    data['label'] = label;
    data['compound'] = compound;
    data['tax_total'] = taxTotal;
    data['shipping_tax_total'] = shippingTaxTotal;
    data['rate_percent'] = ratePercent;
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class MetaData {
//   int? id;
//   String? key;
//   String? value;
//   String? displayKey;
//   String? displayValue;
//
//   MetaData({this.id, this.key, this.value, this.displayKey, this.displayValue});
//
//   MetaData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     key = json['key'];
//     value = json['value'];
//     displayKey = json['display_key'];
//     displayValue = json['display_value'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['key'] = key;
//     data['value'] = value;
//     data['display_key'] = displayKey;
//     data['display_value'] = displayValue;
//     return data;
//   }
// }

// class Links {
//   List<Self>? self;
//   List<Collection>? collection;
//   List<Customer>? customer;
//
//   Links({this.self, this.collection, this.customer});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     if (json['self'] != null) {
//       self = <Self>[];
//       json['self'].forEach((v) {
//         self!.add(Self.fromJson(v));
//       });
//     }
//     if (json['collection'] != null) {
//       collection = <Collection>[];
//       json['collection'].forEach((v) {
//         collection!.add(Collection.fromJson(v));
//       });
//     }
//     if (json['customer'] != null) {
//       customer = <Customer>[];
//       json['customer'].forEach((v) {
//         customer!.add(Customer.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (self != null) {
//       data['self'] = self!.map((v) => v.toJson()).toList();
//     }
//     if (collection != null) {
//       data['collection'] = collection!.map((v) => v.toJson()).toList();
//     }
//     if (customer != null) {
//       data['customer'] = customer!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}
