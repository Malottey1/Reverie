class CartItem {
  final int cartId;
  final int productId;
  final String title;
  final String imageUrl;
  final double price;
  final String size;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.size,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cart_id'],
      productId: json['product_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      price: double.parse(json['price'].toString()),
      size: json['size_name'],
    );
  }
}