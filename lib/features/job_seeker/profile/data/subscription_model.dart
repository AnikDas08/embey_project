class PackageModel {
  final String id;
  final String name;
  final double price;
  final String priceId;
  final String product;
  final String paymentLink;
  final String forType;
  final List<String> features;
  final String recurring;
  final String status;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.priceId,
    required this.product,
    required this.paymentLink,
    required this.forType,
    required this.features,
    required this.recurring,
    required this.status,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      priceId: json['priceId'] ?? '',
      product: json['product'] ?? '',
      paymentLink: json['payment_link'] ?? '',
      forType: json['for'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      recurring: json['recurring'] ?? '',
      status: json['status'] ?? '',
    );
  }

  bool get isFree => price == 0;

  String get priceText => isFree ? '\$0' : '\$${price.toStringAsFixed(2)}';

  String get subtitle => isFree ? 'Free Plan (Starter)' : recurring;
}