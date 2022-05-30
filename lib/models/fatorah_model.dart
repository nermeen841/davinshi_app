// ignore_for_file: prefer_typing_uninitialized_variables

class SaveOrderModel {
  int? statuse;
  Order? order;
  SaveOrderModel({this.statuse, this.order});

  SaveOrderModel.fromJson(Map<String, dynamic> json) {
    statuse = json['status'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

class Order {
  int? id;
  int? productCount;
  var orderPrice;
  var shippingPrice;
  var totalPrice;
  var discount;
  var invoiceId;
  var invoicelink;
  String? createdAt;
  String? paymentMethod;
  List<ProductsData>? productsData;
  ShippingAddress? shippingAddress;
  Order(
      {this.id,
      this.shippingAddress,
      this.productCount,
      this.createdAt,
      this.discount,
      this.invoiceId,
      this.invoicelink,
      this.orderPrice,
      this.paymentMethod,
      this.productsData,
      this.shippingPrice,
      this.totalPrice});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCount = json['products_count'];
    orderPrice = json['order_price'];
    shippingPrice = json['shipping_price'];
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    discount = json['discount'];
    invoiceId = json['invoice_id'];
    invoicelink = json['invoice_link'];
    if (json['products'] != null) {
      productsData = <ProductsData>[];
      json['products'].forEach((v) {
        productsData!.add(ProductsData.fromJson(v));
      });
    }
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }
}

class ProductsData {
  int? id;
  String? image;

  ProductsData({this.id, this.image});
  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json["img_src"] + "/" + json['img'];
  }
}

class ShippingAddress {
  int? id;
  String? title;
  String? name;
  String? email;
  String? phone;
  String? address;
  ShippingAddress(
      {this.id, this.address, this.email, this.phone, this.name, this.title});
  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }
}
