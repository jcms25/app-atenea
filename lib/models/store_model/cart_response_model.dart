import 'package:colegia_atenea/models/store_model/product_item_model.dart';

class CartResponse {
  List<Items>? items;
  List<CouponItem>? coupons;
  // List<Null>? fees;
  CartTotal? totals;
  ShippingAddress? shippingAddress;
  BillingAddress? billingAddress;
  bool? needsPayment;
  bool? needsShipping;
  List<String>? paymentRequirements;
  bool? hasCalculatedShipping;
  // List<Null>? shippingRates;
  int? itemsCount;
  int? itemsWeight;
  // List<Null>? crossSells;
  // List<Null>? errors;
  List<String>? paymentMethods;
  CartExtension? extensions;

  CartResponse(
      {this.items,
        // this.coupons,
        // this.fees,
        this.totals,
        this.shippingAddress,
        this.billingAddress,
        this.needsPayment,
        this.needsShipping,
        this.paymentRequirements,
        this.hasCalculatedShipping,
        // this.shippingRates,
        this.itemsCount,
        this.itemsWeight,
        // this.crossSells,
        // this.errors,
        this.paymentMethods,
        this.extensions});

  CartResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    if (json['coupons'] != null) {
      coupons = <CouponItem>[];
      json['coupons'].forEach((v) {
        coupons!.add(CouponItem.fromJson(v));
      });
    }
    // if (json['fees'] != null) {
    //   fees = <Null>[];
    //   json['fees'].forEach((v) {
    //     fees!.add(Null.fromJson(v));
    //   });
    // }
    totals =
    json['totals'] != null ? CartTotal.fromJson(json['totals']) : null;
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
    billingAddress = json['billing_address'] != null
        ? BillingAddress.fromJson(json['billing_address'])
        : null;
    needsPayment = json['needs_payment'];
    needsShipping = json['needs_shipping'];
    paymentRequirements = json['payment_requirements'].cast<String>();
    hasCalculatedShipping = json['has_calculated_shipping'];
    // if (json['shipping_rates'] != null) {
    //   shippingRates = <Null>[];
    //   json['shipping_rates'].forEach((v) {
    //     shippingRates!.add(Null.fromJson(v));
    //   });
    // }
    itemsCount = json['items_count'];
    itemsWeight = json['items_weight'];
    // if (json['cross_sells'] != null) {
    //   crossSells = <Null>[];
    //   json['cross_sells'].forEach((v) {
    //     crossSells!.add(Null.fromJson(v));
    //   });
    // }
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(Null.fromJson(v));
    //   });
    // }
    paymentMethods = json['payment_methods'].cast<String>();
    extensions = json['extensions'] != null
        ? CartExtension.fromJson(json['extensions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (coupons != null) {
      data['coupons'] = coupons!.map((v) => v.toJson()).toList();
    }
    // if (fees != null) {
    //   data['fees'] = fees!.map((v) => v.toJson()).toList();
    // }
    if (totals != null) {
      data['totals'] = totals!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    if (billingAddress != null) {
      data['billing_address'] = billingAddress!.toJson();
    }
    data['needs_payment'] = needsPayment;
    data['needs_shipping'] = needsShipping;
    data['payment_requirements'] = paymentRequirements;
    data['has_calculated_shipping'] = hasCalculatedShipping;
    // if (shippingRates != null) {
    //   data['shipping_rates'] =
    //       shippingRates!.map((v) => v.toJson()).toList();
    // }
    data['items_count'] = itemsCount;
    data['items_weight'] = itemsWeight;
    // if (crossSells != null) {
    //   data['cross_sells'] = crossSells!.map((v) => v.toJson()).toList();
    // }
    // if (errors != null) {
    //   data['errors'] = errors!.map((v) => v.toJson()).toList();
    // }
    data['payment_methods'] = paymentMethods;
    if (extensions != null) {
      data['extensions'] = extensions!.toJson();
    }
    return data;
  }
}

class Items {
  String? key;
  int? id;
  String? type;
  int? quantity;
  QuantityLimits? quantityLimits;
  String? name;
  String? shortDescription;
  String? description;
  String? sku;
  dynamic lowStockRemaining;
  bool? backordersAllowed;
  bool? showBackorderBadge;
  bool? soldIndividually;
  String? permalink;
  List<Images>? images;
  List<Variation>? variation;
  // List<Null>? itemData;
  Prices? prices;
  CartTotal? totals;
  String? catalogVisibility;
  Extensions? extensions;

  Items(
      {this.key,
        this.id,
        this.type,
        this.quantity,
        this.quantityLimits,
        this.name,
        this.shortDescription,
        this.description,
        this.sku,
        this.lowStockRemaining,
        this.backordersAllowed,
        this.showBackorderBadge,
        this.soldIndividually,
        this.permalink,
        this.images,
        this.variation,
        // this.itemData,
        this.prices,
        this.totals,
        this.catalogVisibility,
        this.extensions});

  Items.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    id = json['id'];
    type = json['type'];
    quantity = json['quantity'];
    quantityLimits = json['quantity_limits'] != null
        ? QuantityLimits.fromJson(json['quantity_limits'])
        : null;
    name = json['name'];
    shortDescription = json['short_description'];
    description = json['description'];
    sku = json['sku'];
    lowStockRemaining = json['low_stock_remaining'];
    backordersAllowed = json['backorders_allowed'];
    showBackorderBadge = json['show_backorder_badge'];
    soldIndividually = json['sold_individually'];
    permalink = json['permalink'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['variation'] != null) {
      variation = <Variation>[];
      json['variation'].forEach((v) {
        variation!.add(Variation.fromJson(v));
      });
    }
    // if (json['item_data'] != null) {
    //   itemData = <Null>[];
    //   json['item_data'].forEach((v) {
    //     itemData!.add(Null.fromJson(v));
    //   });
    // }
    prices =
    json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    totals =
    json['totals'] != null ? CartTotal.fromJson(json['totals']) : null;
    catalogVisibility = json['catalog_visibility'];
    extensions = json['extensions'] != null
        ? Extensions.fromJson(json['extensions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['id'] = id;
    data['type'] = type;
    data['quantity'] = quantity;
    if (quantityLimits != null) {
      data['quantity_limits'] = quantityLimits!.toJson();
    }
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['sku'] = sku;
    data['low_stock_remaining'] = lowStockRemaining;
    data['backorders_allowed'] = backordersAllowed;
    data['show_backorder_badge'] = showBackorderBadge;
    data['sold_individually'] = soldIndividually;
    data['permalink'] = permalink;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (variation != null) {
      data['variation'] = variation!.map((v) => v.toJson()).toList();
    }
    // if (itemData != null) {
    //   data['item_data'] = itemData!.map((v) => v.toJson()).toList();
    // }
    if (prices != null) {
      data['prices'] = prices!.toJson();
    }
    if (totals != null) {
      data['totals'] = totals!.toJson();
    }
    data['catalog_visibility'] = catalogVisibility;
    if (extensions != null) {
      data['extensions'] = extensions!.toJson();
    }
    return data;
  }
}

class QuantityLimits {
  int? minimum;
  int? maximum;
  int? multipleOf;
  bool? editable;

  QuantityLimits({this.minimum, this.maximum, this.multipleOf, this.editable});

  QuantityLimits.fromJson(Map<String, dynamic> json) {
    minimum = json['minimum'];
    maximum = json['maximum'];
    multipleOf = json['multiple_of'];
    editable = json['editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['minimum'] = minimum;
    data['maximum'] = maximum;
    data['multiple_of'] = multipleOf;
    data['editable'] = editable;
    return data;
  }
}

class Images {
  int? id;
  String? src;
  String? thumbnail;
  String? srcset;
  String? sizes;
  String? name;
  String? alt;

  Images(
      {this.id,
        this.src,
        this.thumbnail,
        this.srcset,
        this.sizes,
        this.name,
        this.alt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
    thumbnail = json['thumbnail'];
    srcset = json['srcset'];
    sizes = json['sizes'];
    name = json['name'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['src'] = src;
    data['thumbnail'] = thumbnail;
    data['srcset'] = srcset;
    data['sizes'] = sizes;
    data['name'] = name;
    data['alt'] = alt;
    return data;
  }
}

class Variation {
  String? attribute;
  String? value;

  Variation({this.attribute, this.value});

  Variation.fromJson(Map<String, dynamic> json) {
    attribute = json['attribute'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute'] = attribute;
    data['value'] = value;
    return data;
  }
}

class Prices {
  String? price;
  String? regularPrice;
  String? salePrice;
  PriceRange? priceRange;
  String? currencyCode;
  String? currencySymbol;
  int? currencyMinorUnit;
  String? currencyDecimalSeparator;
  String? currencyThousandSeparator;
  String? currencyPrefix;
  String? currencySuffix;
  RawPrices? rawPrices;

  Prices(
      {this.price,
        this.regularPrice,
        this.salePrice,
        this.priceRange,
        this.currencyCode,
        this.currencySymbol,
        this.currencyMinorUnit,
        this.currencyDecimalSeparator,
        this.currencyThousandSeparator,
        this.currencyPrefix,
        this.currencySuffix,
        this.rawPrices});

  Prices.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    priceRange = json['price_range'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyMinorUnit = json['currency_minor_unit'];
    currencyDecimalSeparator = json['currency_decimal_separator'];
    currencyThousandSeparator = json['currency_thousand_separator'];
    currencyPrefix = json['currency_prefix'];
    currencySuffix = json['currency_suffix'];
    rawPrices = json['raw_prices'] != null
        ? RawPrices.fromJson(json['raw_prices'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['price_range'] = priceRange;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_minor_unit'] = currencyMinorUnit;
    data['currency_decimal_separator'] = currencyDecimalSeparator;
    data['currency_thousand_separator'] = currencyThousandSeparator;
    data['currency_prefix'] = currencyPrefix;
    data['currency_suffix'] = currencySuffix;
    if (rawPrices != null) {
      data['raw_prices'] = rawPrices!.toJson();
    }
    return data;
  }
}

class RawPrices {
  int? precision;
  String? price;
  String? regularPrice;
  String? salePrice;

  RawPrices({this.precision, this.price, this.regularPrice, this.salePrice});

  RawPrices.fromJson(Map<String, dynamic> json) {
    precision = json['precision'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['precision'] = precision;
    data['price'] = price;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    return data;
  }
}

class Totals {
  String? lineSubtotal;
  String? lineSubtotalTax;
  String? lineTotal;
  String? lineTotalTax;
  String? currencyCode;
  String? currencySymbol;
  int? currencyMinorUnit;
  String? currencyDecimalSeparator;
  String? currencyThousandSeparator;
  String? currencyPrefix;
  String? currencySuffix;

  Totals(
      {this.lineSubtotal,
        this.lineSubtotalTax,
        this.lineTotal,
        this.lineTotalTax,
        this.currencyCode,
        this.currencySymbol,
        this.currencyMinorUnit,
        this.currencyDecimalSeparator,
        this.currencyThousandSeparator,
        this.currencyPrefix,
        this.currencySuffix});

  Totals.fromJson(Map<String, dynamic> json) {
    lineSubtotal = json['line_subtotal'];
    lineSubtotalTax = json['line_subtotal_tax'];
    lineTotal = json['line_total'];
    lineTotalTax = json['line_total_tax'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyMinorUnit = json['currency_minor_unit'];
    currencyDecimalSeparator = json['currency_decimal_separator'];
    currencyThousandSeparator = json['currency_thousand_separator'];
    currencyPrefix = json['currency_prefix'];
    currencySuffix = json['currency_suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line_subtotal'] = lineSubtotal;
    data['line_subtotal_tax'] = lineSubtotalTax;
    data['line_total'] = lineTotal;
    data['line_total_tax'] = lineTotalTax;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_minor_unit'] = currencyMinorUnit;
    data['currency_decimal_separator'] = currencyDecimalSeparator;
    data['currency_thousand_separator'] = currencyThousandSeparator;
    data['currency_prefix'] = currencyPrefix;
    data['currency_suffix'] = currencySuffix;
    return data;
  }
}

class Extensions {
  YithWoocommerceProductBundles? yithWoocommerceProductBundles;

  Extensions({this.yithWoocommerceProductBundles});

  Extensions.fromJson(Map<String, dynamic> json) {
    yithWoocommerceProductBundles =
    json['yith-woocommerce-product-bundles'] != null
        ? YithWoocommerceProductBundles.fromJson(
        json['yith-woocommerce-product-bundles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (yithWoocommerceProductBundles != null) {
      data['yith-woocommerce-product-bundles'] =
          yithWoocommerceProductBundles!.toJson();
    }
    return data;
  }
}

class YithWoocommerceProductBundles {
  bool? isBundle;
  bool? isBundledItem;
  BundleData? bundleData;
  ExtensionItemData? itemData;

  YithWoocommerceProductBundles({this.isBundle, this.isBundledItem,this.bundleData});

  YithWoocommerceProductBundles.fromJson(Map<String, dynamic> json) {
    isBundle = json['isBundle'];
    isBundledItem = json['isBundledItem'];
    bundleData = json['bundleData'] != null
        ? BundleData.fromJson(json['bundleData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isBundle'] = isBundle;
    data['isBundledItem'] = isBundledItem;
    if (bundleData != null) {
      data['bundleData'] = bundleData!.toJson();
    }
    if (itemData != null) {
      data['itemData'] = itemData!.toJson();
    }
    return data;
  }
}

class ExtensionItemData {
  bool? hasCustomName;
  String? name;
  bool? isHidden;
  bool? isThumbnailHidden;

  ExtensionItemData(
      {this.hasCustomName, this.name, this.isHidden, this.isThumbnailHidden});

  ExtensionItemData.fromJson(Map<String, dynamic> json) {
    hasCustomName = json['hasCustomName'];
    name = json['name'];
    isHidden = json['isHidden'];
    isThumbnailHidden = json['isThumbnailHidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasCustomName'] = hasCustomName;
    data['name'] = name;
    data['isHidden'] = isHidden;
    data['isThumbnailHidden'] = isThumbnailHidden;
    return data;
  }
}


class BundleData {
  bool? hasFixedPrice;
  List<String>? bundledItemKeys;

  BundleData({this.hasFixedPrice, this.bundledItemKeys});

  BundleData.fromJson(Map<String, dynamic> json) {
    hasFixedPrice = json['hasFixedPrice'];
    bundledItemKeys = json['bundledItemKeys'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasFixedPrice'] = hasFixedPrice;
    data['bundledItemKeys'] = bundledItemKeys;
    return data;
  }
}


class CartTotal {
  String? totalItems;
  String? totalItemsTax;
  String? totalFees;
  String? totalFeesTax;
  String? totalDiscount;
  String? totalDiscountTax;
  String? totalShipping;
  String? totalShippingTax;
  String? totalPrice;
  String? totalTax;
  List<TaxLines>? taxLines;
  String? currencyCode;
  String? currencySymbol;
  int? currencyMinorUnit;
  String? currencyDecimalSeparator;
  String? currencyThousandSeparator;
  String? currencyPrefix;
  String? currencySuffix;

  CartTotal(
      {this.totalItems,
        this.totalItemsTax,
        this.totalFees,
        this.totalFeesTax,
        this.totalDiscount,
        this.totalDiscountTax,
        this.totalShipping,
        this.totalShippingTax,
        this.totalPrice,
        this.totalTax,
        this.taxLines,
        this.currencyCode,
        this.currencySymbol,
        this.currencyMinorUnit,
        this.currencyDecimalSeparator,
        this.currencyThousandSeparator,
        this.currencyPrefix,
        this.currencySuffix});

  CartTotal.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    totalItemsTax = json['total_items_tax'];
    totalFees = json['total_fees'];
    totalFeesTax = json['total_fees_tax'];
    totalDiscount = json['total_discount'];
    totalDiscountTax = json['total_discount_tax'];
    totalShipping = json['total_shipping'];
    totalShippingTax = json['total_shipping_tax'];
    totalPrice = json['total_price'];
    totalTax = json['total_tax'];
    if (json['tax_lines'] != null) {
      taxLines = <TaxLines>[];
      json['tax_lines'].forEach((v) {
        taxLines!.add(TaxLines.fromJson(v));
      });
    }
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyMinorUnit = json['currency_minor_unit'];
    currencyDecimalSeparator = json['currency_decimal_separator'];
    currencyThousandSeparator = json['currency_thousand_separator'];
    currencyPrefix = json['currency_prefix'];
    currencySuffix = json['currency_suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_items'] = totalItems;
    data['total_items_tax'] = totalItemsTax;
    data['total_fees'] = totalFees;
    data['total_fees_tax'] = totalFeesTax;
    data['total_discount'] = totalDiscount;
    data['total_discount_tax'] = totalDiscountTax;
    data['total_shipping'] = totalShipping;
    data['total_shipping_tax'] = totalShippingTax;
    data['total_price'] = totalPrice;
    data['total_tax'] = totalTax;
    if (taxLines != null) {
      data['tax_lines'] = taxLines!.map((v) => v.toJson()).toList();
    }
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_minor_unit'] = currencyMinorUnit;
    data['currency_decimal_separator'] = currencyDecimalSeparator;
    data['currency_thousand_separator'] = currencyThousandSeparator;
    data['currency_prefix'] = currencyPrefix;
    data['currency_suffix'] = currencySuffix;
    return data;
  }
}

class TaxLines {
  String? name;
  String? price;
  String? rate;

  TaxLines({this.name, this.price, this.rate});

  TaxLines.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['rate'] = rate;
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

  ShippingAddress(
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

  BillingAddress(
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

class CartExtension {
  YithDynamicWcBlockManager? yithDynamicWcBlockManager;

  CartExtension({this.yithDynamicWcBlockManager});

  CartExtension.fromJson(Map<String, dynamic> json) {
    yithDynamicWcBlockManager = json['yith_dynamic_wc_block_manager'] != null
        ? YithDynamicWcBlockManager.fromJson(
        json['yith_dynamic_wc_block_manager'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (yithDynamicWcBlockManager != null) {
      data['yith_dynamic_wc_block_manager'] =
          yithDynamicWcBlockManager!.toJson();
    }
    return data;
  }
}

class YithDynamicWcBlockManager {
  String? ywdpdCouponLabel;
  String? ywdpdCouponCode;
  String? ywdpdCanAddCoupon;
  String? ywdpdFreeShippingNotices;
  String? ywdpdTotalDiscountMessage;

  YithDynamicWcBlockManager(
      {this.ywdpdCouponLabel,
        this.ywdpdCouponCode,
        this.ywdpdCanAddCoupon,
        this.ywdpdFreeShippingNotices,
        this.ywdpdTotalDiscountMessage});

  YithDynamicWcBlockManager.fromJson(Map<String, dynamic> json) {
    ywdpdCouponLabel = json['ywdpd_coupon_label'];
    ywdpdCouponCode = json['ywdpd_coupon_code'];
    ywdpdCanAddCoupon = json['ywdpd_can_add_coupon'];
    ywdpdFreeShippingNotices = json['ywdpd_free_shipping_notices'];
    ywdpdTotalDiscountMessage = json['ywdpd_total_discount_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ywdpd_coupon_label'] = ywdpdCouponLabel;
    data['ywdpd_coupon_code'] = ywdpdCouponCode;
    data['ywdpd_can_add_coupon'] = ywdpdCanAddCoupon;
    data['ywdpd_free_shipping_notices'] = ywdpdFreeShippingNotices;
    data['ywdpd_total_discount_message'] = ywdpdTotalDiscountMessage;
    return data;
  }
}


class CouponItem {
  String? code;
  String? discountType;
  CouponTotals? totals;

  CouponItem({this.code, this.discountType, this.totals});

  CouponItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    discountType = json['discount_type'];
    totals =
    json['totals'] != null ? CouponTotals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['discount_type'] = discountType;
    if (totals != null) {
      data['totals'] = totals!.toJson();
    }
    return data;
  }
}


class CouponTotals {
  String? totalDiscount;
  String? totalDiscountTax;
  String? currencyCode;
  String? currencySymbol;
  int? currencyMinorUnit;
  String? currencyDecimalSeparator;
  String? currencyThousandSeparator;
  String? currencyPrefix;
  String? currencySuffix;

  CouponTotals(
      {this.totalDiscount,
        this.totalDiscountTax,
        this.currencyCode,
        this.currencySymbol,
        this.currencyMinorUnit,
        this.currencyDecimalSeparator,
        this.currencyThousandSeparator,
        this.currencyPrefix,
        this.currencySuffix});

  CouponTotals.fromJson(Map<String, dynamic> json) {
    totalDiscount = json['total_discount'];
    totalDiscountTax = json['total_discount_tax'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    currencyMinorUnit = json['currency_minor_unit'];
    currencyDecimalSeparator = json['currency_decimal_separator'];
    currencyThousandSeparator = json['currency_thousand_separator'];
    currencyPrefix = json['currency_prefix'];
    currencySuffix = json['currency_suffix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_discount'] = totalDiscount;
    data['total_discount_tax'] = totalDiscountTax;
    data['currency_code'] = currencyCode;
    data['currency_symbol'] = currencySymbol;
    data['currency_minor_unit'] = currencyMinorUnit;
    data['currency_decimal_separator'] = currencyDecimalSeparator;
    data['currency_thousand_separator'] = currencyThousandSeparator;
    data['currency_prefix'] = currencyPrefix;
    data['currency_suffix'] = currencySuffix;
    return data;
  }
}