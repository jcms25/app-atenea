class ProductItem {
  int? id;
  String? name;
  String? slug;
  int? parent;
  String? type;
  String? variation;
  String? permalink;
  String? sku;
  String? shortDescription;
  String? description;
  bool? onSale;
  Prices? prices;
  String? priceHtml;
  String? averageRating;
  int? reviewCount;
  List<Images>? images;
  List<Categories>? categories;
  // List<Null>? tags;
  List<Attributes>? attributes;
  List<Variations>? variations;
  bool? hasOptions;
  bool? isPurchasable;
  bool? isInStock;
  bool? isOnBackorder;
  bool? lowStockRemaining;
  bool? soldIndividually;
  AddToCart? addToCart;

  ProductItem({this.id, this.name, this.slug, this.parent, this.type, this.variation, this.permalink, this.sku, this.shortDescription, this.description, this.onSale, this.prices, this.priceHtml, this.averageRating, this.reviewCount, this.images, this.categories, this.attributes, this.variations, this.hasOptions, this.isPurchasable, this.isInStock, this.isOnBackorder, this.lowStockRemaining, this.soldIndividually, this.addToCart});

  ProductItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    parent = json['parent'];
    type = json['type'];
    variation = json['variation'];
    permalink = json['permalink'];
    sku = json['sku'];
    shortDescription = json['short_description'];
    description = json['description'];
    onSale = json['on_sale'];
    prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    priceHtml = json['price_html'];
    averageRating = json['average_rating'];
    reviewCount = json['review_count'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) { images!.add(Images.fromJson(v)); });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) { categories!.add(Categories.fromJson(v)); });
    }
    // if (json['tags'] != null) {
    //   tags = <Null>[];
    //   json['tags'].forEach((v) { tags!.add(Null.fromJson(v)); });
    // }
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) { attributes!.add(Attributes.fromJson(v)); });
    }
    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) { variations!.add(Variations.fromJson(v)); });
    }
    hasOptions = json['has_options'];
    isPurchasable = json['is_purchasable'];
    isInStock = json['is_in_stock'];
    isOnBackorder = json['is_on_backorder'];
    lowStockRemaining = json['low_stock_remaining'];
    soldIndividually = json['sold_individually'];
    addToCart = json['add_to_cart'] != null ? AddToCart.fromJson(json['add_to_cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['parent'] = parent;
    data['type'] = type;
    data['variation'] = variation;
    data['permalink'] = permalink;
    data['sku'] = sku;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['on_sale'] = onSale;
    if (prices != null) {
      data['prices'] = prices!.toJson();
    }
    data['price_html'] = priceHtml;
    data['average_rating'] = averageRating;
    data['review_count'] = reviewCount;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    // if (this.tags != null) {
    //   data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    // }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    data['has_options'] = hasOptions;
    data['is_purchasable'] = isPurchasable;
    data['is_in_stock'] = isInStock;
    data['is_on_backorder'] = isOnBackorder;
    data['low_stock_remaining'] = lowStockRemaining;
    data['sold_individually'] = soldIndividually;
    if (addToCart != null) {
      data['add_to_cart'] = addToCart!.toJson();
    }
    // if (this.extensions != null) {
    //   data['extensions'] = this.extensions!.toJson();
    // }
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

  Prices({this.price, this.regularPrice, this.salePrice, this.priceRange, this.currencyCode, this.currencySymbol, this.currencyMinorUnit, this.currencyDecimalSeparator, this.currencyThousandSeparator, this.currencyPrefix, this.currencySuffix});

  Prices.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    priceRange = json['price_range'] != null ? PriceRange.fromJson(json['price_range']) : null;
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
    data['price'] = price;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    if (priceRange != null) {
      data['price_range'] = priceRange!.toJson();
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

class PriceRange {
  String? minAmount;
  String? maxAmount;

  PriceRange({this.minAmount, this.maxAmount});

  PriceRange.fromJson(Map<String, dynamic> json) {
    minAmount = json['min_amount'];
    maxAmount = json['max_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_amount'] = minAmount;
    data['max_amount'] = maxAmount;
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

  Images({this.id, this.src, this.thumbnail, this.srcset, this.sizes, this.name, this.alt});

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

class Categories {
  int? id;
  String? name;
  String? slug;
  String? link;

  Categories({this.id, this.name, this.slug, this.link});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['link'] = link;
    return data;
  }
}

class Attributes {
  int? id;
  String? name;
  dynamic taxonomy;
  bool? hasVariations;
  List<Terms>? terms;

  Attributes({this.id, this.name, this.taxonomy, this.hasVariations, this.terms});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxonomy = json['taxonomy'];
    hasVariations = json['has_variations'];
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) { terms!.add(Terms.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['taxonomy'] = taxonomy;
    data['has_variations'] = hasVariations;
    if (terms != null) {
      data['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Terms {
  int? id;
  String? name;
  String? slug;

  Terms({this.id, this.name, this.slug});

  Terms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Variations {
  int? id;
  List<VariationAttributes>? attributes;

  Variations({this.id, this.attributes});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['attributes'] != null) {
      attributes = <VariationAttributes>[];
      json['attributes'].forEach((v) { attributes!.add(VariationAttributes.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationAttributes {
  String? name;
  String? value;

  VariationAttributes({this.name, this.value});

  VariationAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class AddToCart {
  String? text;
  String? description;
  String? url;
  int? minimum;
  int? maximum;
  int? multipleOf;

  AddToCart({this.text, this.description, this.url, this.minimum, this.maximum, this.multipleOf});

  AddToCart.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    description = json['description'];
    url = json['url'];
    minimum = json['minimum'];
    maximum = json['maximum'];
    multipleOf = json['multiple_of'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['description'] = description;
    data['url'] = url;
    data['minimum'] = minimum;
    data['maximum'] = maximum;
    data['multiple_of'] = multipleOf;
    return data;
  }
}

