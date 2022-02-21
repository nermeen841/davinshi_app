// ignore_for_file: prefer_typing_uninitialized_variables

class SearchModel {
  int? status;
  Orders? orders;

  SearchModel({this.status, this.orders});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orders = json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}

class Orders {
  Product? product;

  Orders({this.product});

  Orders.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }

    return data;
  }
}

class Product {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  String? path;
  int? perPage;
  int? to;

  Product(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.path,
      this.perPage,
      this.to});

  Product.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];

    path = json['path'];
    perPage = json['per_page'];

    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;

    data['path'] = path;
    data['per_page'] = perPage;

    data['to'] = to;
    return data;
  }
}

class Data {
  int? id;
  String? nameAr;
  String? nameEn;
  String? slug;
  String? descriptionAr;
  String? descriptionEn;
  String? aboutBrandAr;
  String? aboutBrandEn;
  String? discountPercentage;
  var regularPrice;
  var salePrice;
  String? alt;
  bool? inSale;
  int? sort;
  bool? isRecommended;
  bool? hasOptions;
  bool? isBest;
  var endSale;
  String? startSale;
  int? isBrand;
  int? ratings;
  int? quantity;
  int? likesCount;
  String? img;
  String? imgSrc;

  Data(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.slug,
      this.descriptionAr,
      this.descriptionEn,
      this.aboutBrandAr,
      this.aboutBrandEn,
      this.discountPercentage,
      this.regularPrice,
      this.salePrice,
      this.alt,
      this.inSale,
      this.sort,
      this.isRecommended,
      this.hasOptions,
      this.isBest,
      this.endSale,
      this.startSale,
      this.isBrand,
      this.ratings,
      this.quantity,
      this.likesCount,
      this.img,
      this.imgSrc});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    slug = json['slug'];
    descriptionAr = json['description_ar'];
    descriptionEn = json['description_en'];
    aboutBrandAr = json['about_brand_ar'];
    aboutBrandEn = json['about_brand_en'];
    discountPercentage = json['discount_percentage'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    alt = json['alt'];
    inSale = json['in_sale'];
    sort = json['sort'];
    isRecommended = json['is_recommended'];
    hasOptions = json['has_options'];
    isBest = json['is_best'];
    endSale = json['end_sale'];
    startSale = json['start_sale'];
    isBrand = json['is_brand'];
    ratings = json['ratings'];
    quantity = json['quantity'];

    likesCount = json['likes_count'];
    img = json['img'];
    imgSrc = json['img_src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['slug'] = slug;
    data['description_ar'] = descriptionAr;
    data['description_en'] = descriptionEn;
    data['about_brand_ar'] = aboutBrandAr;
    data['about_brand_en'] = aboutBrandEn;
    data['discount_percentage'] = discountPercentage;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['alt'] = alt;
    data['in_sale'] = inSale;
    data['sort'] = sort;
    data['is_recommended'] = isRecommended;
    data['has_options'] = hasOptions;
    data['is_best'] = isBest;
    data['end_sale'] = endSale;
    data['start_sale'] = startSale;
    data['is_brand'] = isBrand;
    data['ratings'] = ratings;
    data['quantity'] = quantity;

    data['likes_count'] = likesCount;
    data['img'] = img;
    data['img_src'] = imgSrc;
    return data;
  }
}
