import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_coin.dart';

class CryptoService {
  static const _baseUrl =
      'https://api.coingecko.com/api/v3/coins/markets';
  Future<List<CryptoCoin>> getirTopCoins() async {
    final url = Uri.parse(
      '$_baseUrl?vs_currency=try'
      '&ids=bitcoin,ethereum,tether,binancecoin,ripple'
      '&sparkline=false',
    );
    final cevap = await http.get(url);
    if (cevap.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(cevap.body) as List<dynamic>;
      return data
          .map(
            (e) => CryptoCoin.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      throw Exception(
        'Not Found Crypto Data. Code: ${cevap.statusCode}',
      );
    }
  }
}
