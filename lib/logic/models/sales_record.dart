import 'dart:convert';

class SalesRecord {
  final String buyer;
  final String productName;
  final int quantity;
  final double totalPrice;

  SalesRecord({
    required this.buyer,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
  });

  // Factory constructor to convert Firestore document snapshot to SalesRecord object
  Map<String, dynamic> toJson() {
    return {
      'buyer': buyer,
      'product_name': productName,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}