class OrderDetail {
  final int productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;
  final String orderId;

  OrderDetail({
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.orderId,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productId: json['product_id'],
      imageUrl: json['image_url'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      orderId: json['order_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'image_url': imageUrl,
      'title': title,
      'price': price,
      'quantity': quantity,
      'order_id': orderId,
    };
  }
}