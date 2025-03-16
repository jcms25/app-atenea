class SubCategoryItemModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? parent;
  int? count;
  ImageDataModel? image;
  int? reviewCount;
  String? permalink;

  SubCategoryItemModel(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.parent,
        this.count,
        this.image,
        this.reviewCount,
        this.permalink});

  SubCategoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    parent = json['parent'];
    count = json['count'];
    image = json['image'] != null ? ImageDataModel.fromJson(json['image']) : null;
    reviewCount = json['review_count'];
    permalink = json['permalink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['parent'] = parent;
    data['count'] = count;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['review_count'] = reviewCount;
    data['permalink'] = permalink;
    return data;
  }
}

class ImageDataModel {
  int? id;
  String? src;
  String? thumbnail;
  String? srcset;
  String? sizes;
  String? name;
  String? alt;

  ImageDataModel(
      {this.id,
        this.src,
        this.thumbnail,
        this.srcset,
        this.sizes,
        this.name,
        this.alt});

  ImageDataModel.fromJson(Map<String, dynamic> json) {
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
