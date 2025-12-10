import 'package:flutter/material.dart';
import '../models/crypto_coin.dart';
import '../services/crypto_service.dart';

class KriptoPage extends StatefulWidget {
  const KriptoPage({super.key});

  @override
  State<KriptoPage> createState() => _KriptoPageState();
}

class _KriptoPageState extends State<KriptoPage> {
  final _service = CryptoService();
  late Future<List<CryptoCoin>> _futureCoins;
  @override
  void initState() {
    super.initState();
    _futureCoins = _service.getirTopCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF00C853),
        title: const Text(
          'Crypto Market',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureCoins,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Hata: ${snapshot.error}'),
            );
          }
          final coins = snapshot.data ?? [];
          if (coins.isEmpty) {
            return const Center(
              child: Text("Not Found Data"),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureCoins = _service.getirTopCoins();
              });
            },
            child: ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];
                final isNegative = coin.change24h < 0;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      coin.imageUrl,
                    ),
                  ),
                  title: Text(
                    '${coin.name} (${coin.symbol.toUpperCase()})',
                  ),
                  subtitle: Text(
                    'Price: ${coin.currentPrice.toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    '${coin.change24h.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isNegative
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
