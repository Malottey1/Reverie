class OrderDetail {
  final int productId;
  final String productName;
  final String productImage;
  final double price;

  OrderDetail({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      price: double.parse(json['price'].toString()),
    );
  }
}