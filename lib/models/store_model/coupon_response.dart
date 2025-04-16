class CouponListResponse {
  int? id;
  String? code;
  String? amount;
  String? status;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? discountType;
  String? description;
  // Null? dateExpires;
  // Null? dateExpiresGmt;
  int? usageCount;
  bool? individualUse;
  // List<Null>? productIds;
  // List<Null>? excludedProductIds;
  // Null? usageLimit;
  // Null? usageLimitPerUser;
  // Null? limitUsageToXItems;
  bool? freeShipping;
  List<int>? productCategories;
  // List<Null>? excludedProductCategories;
  bool? excludeSaleItems;
  String? minimumAmount;
  String? maximumAmount;
  // List<Null>? emailRestrictions;
  List<String>? usedBy;
  List<MetaData>? metaData;
  // Links? lLinks;

  CouponListResponse(
      {this.id,
        this.code,
        this.amount,
        this.status,
        this.dateCreated,
        this.dateCreatedGmt,
        this.dateModified,
        this.dateModifiedGmt,
        this.discountType,
        this.description,
        // this.dateExpires,
        // this.dateExpiresGmt,
        this.usageCount,
        this.individualUse,
        // this.productIds,
        // this.excludedProductIds,
        // this.usageLimit,
        // this.usageLimitPerUser,
        // this.limitUsageToXItems,
        this.freeShipping,
        this.productCategories,
        // this.excludedProductCategories,
        this.excludeSaleItems,
        this.minimumAmount,
        this.maximumAmount,
        // this.emailRestrictions,
        this.usedBy,
        this.metaData,
        // this.lLinks
      });

  CouponListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    amount = json['amount'];
    status = json['status'];
    dateCreated = json['date_created'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModified = json['date_modified'];
    dateModifiedGmt = json['date_modified_gmt'];
    discountType = json['discount_type'];
    description = json['description'];
    // dateExpires = json['date_expires'];
    // dateExpiresGmt = json['date_expires_gmt'];
    usageCount = json['usage_count'];
    individualUse = json['individual_use'];
    // if (json['product_ids'] != null) {
    //   productIds = <Null>[];
    //   json['product_ids'].forEach((v) {
    //     productIds!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['excluded_product_ids'] != null) {
    //   excludedProductIds = <Null>[];
    //   json['excluded_product_ids'].forEach((v) {
    //     excludedProductIds!.add(Null.fromJson(v));
    //   });
    // }
    // usageLimit = json['usage_limit'];
    // usageLimitPerUser = json['usage_limit_per_user'];
    // limitUsageToXItems = json['limit_usage_to_x_items'];
    freeShipping = json['free_shipping'];
    productCategories = json['product_categories'].cast<int>();
    // if (json['excluded_product_categories'] != null) {
    //   excludedProductCategories = <Null>[];
    //   json['excluded_product_categories'].forEach((v) {
    //     excludedProductCategories!.add(Null.fromJson(v));
    //   });
    // }
    excludeSaleItems = json['exclude_sale_items'];
    minimumAmount = json['minimum_amount'];
    maximumAmount = json['maximum_amount'];
    // if (json['email_restrictions'] != null) {
    //   emailRestrictions = <Null>[];
    //   json['email_restrictions'].forEach((v) {
    //     emailRestrictions!.add(new Null.fromJson(v));
    //   });
    // }
    usedBy = json['used_by'].cast<String>();
    if (json['meta_data'] != null) {
      metaData = <MetaData>[];
      json['meta_data'].forEach((v) {
        metaData!.add(MetaData.fromJson(v));
      });
    }
    // lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['amount'] = amount;
    data['status'] = status;
    data['date_created'] = dateCreated;
    data['date_created_gmt'] = dateCreatedGmt;
    data['date_modified'] = dateModified;
    data['date_modified_gmt'] = dateModifiedGmt;
    data['discount_type'] = discountType;
    data['description'] = description;
    // data['date_expires'] = dateExpires;
    // data['date_expires_gmt'] = dateExpiresGmt;
    data['usage_count'] = usageCount;
    data['individual_use'] = individualUse;
    // if (this.productIds != null) {
    //   data['product_ids'] = this.productIds!.map((v) => v.toJson()).toList();
    // }
    // if (this.excludedProductIds != null) {
    //   data['excluded_product_ids'] =
    //       this.excludedProductIds!.map((v) => v.toJson()).toList();
    // }
    // data['usage_limit'] = usageLimit;
    // data['usage_limit_per_user'] = usageLimitPerUser;
    // data['limit_usage_to_x_items'] = limitUsageToXItems;
    data['free_shipping'] = freeShipping;
    data['product_categories'] = productCategories;
    // if (this.excludedProductCategories != null) {
    //   data['excluded_product_categories'] =
    //       this.excludedProductCategories!.map((v) => v.toJson()).toList();
    // }
    data['exclude_sale_items'] = excludeSaleItems;
    data['minimum_amount'] = minimumAmount;
    data['maximum_amount'] = maximumAmount;
    // if (this.emailRestrictions != null) {
    //   data['email_restrictions'] =
    //       this.emailRestrictions!.map((v) => v.toJson()).toList();
    // }
    data['used_by'] = usedBy;
    if (metaData != null) {
      data['meta_data'] = metaData!.map((v) => v.toJson()).toList();
    }
    // if (lLinks != null) {
    //   data['_links'] = lLinks!.toJson();
    // }
    return data;
  }
}

class MetaData {
  int? id;
  String? key;
  // String? value;

  MetaData({this.id, this.key
    // , this.value
  });

  MetaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    // value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    // data['value'] = value;
    return data;
  }
}

// class Links {
//   List<Self>? self;
//   List<Collection>? collection;
//
//   Links({this.self, this.collection});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     if (json['self'] != null) {
//       self = <Self>[];
//       json['self'].forEach((v) {
//         self!.add(new Self.fromJson(v));
//       });
//     }
//     if (json['collection'] != null) {
//       collection = <Collection>[];
//       json['collection'].forEach((v) {
//         collection!.add(new Collection.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.self != null) {
//       data['self'] = this.self!.map((v) => v.toJson()).toList();
//     }
//     if (this.collection != null) {
//       data['collection'] = this.collection!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Self {
//   String? href;
//
//   Self({this.href});
//
//   Self.fromJson(Map<String, dynamic> json) {
//     href = json['href'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['href'] = this.href;
//     return data;
//   }
// }
