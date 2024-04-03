class StockRecord {
  final String productName;
  final int quantityAvailable;
  final double unitPrice;

  StockRecord({
    required this.productName,
    required this.quantityAvailable,
    required this.unitPrice,
  });

  // Factory constructor to convert Firestore document snapshot to StockRecord object
  factory StockRecord.fromFirestore(Map<String, dynamic> data) {
    return StockRecord(
      productName: data['product_name'] ?? '',
      quantityAvailable: data['quantity_available'] ?? 0,
      unitPrice: (data['unit_price'] ?? 0).toDouble(),
    );
  }
}
