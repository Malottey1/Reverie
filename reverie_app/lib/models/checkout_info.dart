class CheckoutInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String billingName;
  final String billingAddress;
  final String billingCity;
  final String billingState;
  final String billingCountry;
  final String shippingFirstName;
  final String shippingLastName;
  final String shippingAddress;
  final String shippingCity;
  final String shippingState;
  final String shippingCountry;

  CheckoutInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.billingName,
    required this.billingAddress,
    required this.billingCity,
    required this.billingState,
    required this.billingCountry,
    required this.shippingFirstName,
    required this.shippingLastName,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingState,
    required this.shippingCountry,
  });

  factory CheckoutInfo.fromJson(Map<String, dynamic> json) {
    return CheckoutInfo(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      billingName: json['billing_name'] ?? '',
      billingAddress: json['billing_address'] ?? '',
      billingCity: json['billing_city'] ?? '',
      billingState: json['billing_state'] ?? '',
      billingCountry: json['billing_country'] ?? '',
      shippingFirstName: json['shipping_first_name'] ?? '',
      shippingLastName: json['shipping_last_name'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      shippingCity: json['shipping_city'] ?? '',
      shippingState: json['shipping_state'] ?? '',
      shippingCountry: json['shipping_country'] ?? '',
    );
  }
}