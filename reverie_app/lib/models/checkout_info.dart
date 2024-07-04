class CheckoutInfo {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String billingName;
  final String billingAddress;
  final String billingCity;
  final String billingState;
  final String billingCountry;
  final String billingPostalCode;
  final String shippingFirstName;
  final String shippingLastName;
  final String shippingAddress;
  final String shippingAddressLine2;
  final String shippingCity;
  final String shippingState;
  final String shippingCountry;
  final String shippingPostalCode;
  final double totalAmount;

  CheckoutInfo({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.billingName,
    required this.billingAddress,
    required this.billingCity,
    required this.billingState,
    required this.billingCountry,
    required this.billingPostalCode,
    required this.shippingFirstName,
    required this.shippingLastName,
    required this.shippingAddress,
    required this.shippingAddressLine2,
    required this.shippingCity,
    required this.shippingState,
    required this.shippingCountry,
    required this.shippingPostalCode,
    required this.totalAmount,
  });

  factory CheckoutInfo.fromJson(Map<String, dynamic> json) {
    return CheckoutInfo(
      userId: json['user_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      billingName: json['billing_name'] ?? '',
      billingAddress: json['billing_address'] ?? '',
      billingCity: json['billing_city'] ?? '',
      billingState: json['billing_state'] ?? '',
      billingCountry: json['billing_country'] ?? '',
      billingPostalCode: json['billing_postal_code'] ?? '',
      shippingFirstName: json['shipping_first_name'] ?? '',
      shippingLastName: json['shipping_last_name'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      shippingAddressLine2: json['shipping_address_line_2'] ?? '',
      shippingCity: json['shipping_city'] ?? '',
      shippingState: json['shipping_state'] ?? '',
      shippingCountry: json['shipping_country'] ?? '',
      shippingPostalCode: json['shipping_postal_code'] ?? '',
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
    );
  }
}