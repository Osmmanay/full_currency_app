class CryptoCoin {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double change24h;
  final String imageUrl;

  CryptoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.change24h,
    required this.imageUrl,
  });

  factory CryptoCoin.fromJson(Map<String, dynamic> json) {
    return CryptoCoin(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      currentPrice: (json['current_price'] as num)
          .toDouble(),
      change24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ??
          0.0,
      imageUrl: json['image'] as String,
    );
  }
}
