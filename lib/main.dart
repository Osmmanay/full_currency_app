import 'package:flutter/material.dart';
import 'package:full_currency_app/pages/haberler_page.dart';
import 'package:full_currency_app/pages/kripto_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Curency',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF00C853),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  /* gram altın sayfasındaki altın miktarı girilen text field,
  burada textfield içine yazılan değerler edit controller ile 
  girilenGram adlı değişken içine tanımlandı dispose ile 
  girilen değer temizlendi */
  
  final TextEditingController _gramController =
      TextEditingController();
  double? _girilenGram;

  @override
  void dispose() {
    _gramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Basit bir başlık stili
    const baslikStili = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    // Şimdilik sabit altın fiyatları (örnek)
    final List<Map<String, dynamic>> altinlar = [
      {'ad': 'Gram Altın', 'fiyat': 2500.0},
      {'ad': 'Çeyrek Altın', 'fiyat': 4100.0},
      {'ad': 'Yarım Altın', 'fiyat': 8200.0},
      {'ad': 'Tam Altın', 'fiyat': 16400.0},
      {'ad': 'Ons Altın', 'fiyat': 2500.0},
    ];

    // Şimdilik sabit döviz kurları (örnek)
    final List<Map<String, dynamic>> dovizler = [
      {'ad': 'USD', 'fiyat': 32.5},
      {'ad': 'EUR', 'fiyat': 35.0},
      {'ad': 'GBP', 'fiyat': 41.2},
    ];

    // Şimdilik sahte banka verisi
    final List<Map<String, dynamic>> bankalar = [
      {'banka': 'Ziraat Bankası', 'gramAltin': 2490.0},
      {'banka': 'İş Bankası', 'gramAltin': 2505.0},
      {'banka': 'VakıfBank', 'gramAltin': 2488.0},
      {'banka': 'Halkbank', 'gramAltin': 2498.0},
      {'banka': 'Garanti BBVA', 'gramAltin': 2510.0},
    ];

    Map<String, dynamic>? enUcuzBankaGramBazli;
    List<Map<String, dynamic>> bankalarToplam = [];
    if (_girilenGram != null && _girilenGram! > 0) {
      //count price for all banks
      bankalarToplam = bankalar.map((bank) {
        final fiyat = bank['gramAltin'] as double;
        final toplamTutar = fiyat * _girilenGram!;
        return {
          'banka': bank['banka'],
          'gramAltin': fiyat,
          'toplamTutar': toplamTutar,
        };
      }).toList();

      //find cheapist price
      enUcuzBankaGramBazli = bankalarToplam.reduce((
        min,
        banka,
      ) {
        if (banka['toplamTutar'] < min['toplamTutar']) {
          return banka;
        }
        return min;
      });

      // low and high line
      bankalarToplam.sort((a, b) {
        return a['toplamTutar'].compareTo(b['toplamTutar']);
      });
    }
    // En ucuz gram altın hangi bankada?
    final Map<String, dynamic> enUcuzGramAltinBankasi =
        bankalar.reduce((min, banka) {
          if (banka['gramAltin'] < min['gramAltin']) {
            return banka;
          }
          return min;
        });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Golden Price", style: baslikStili),
        const SizedBox(height: 8),
        //goldens list
        ...altinlar.map(
          (altin) => Card(
            color: Colors.grey[300],

            child: ListTile(
              title: Text(altin['ad']),
              trailing: Text(
                '${altin['fiyat']}TL',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Exchange Rates', style: baslikStili),
        const SizedBox(height: 8),

        //Markets list
        ...dovizler.map(
          (rate) => Card(
            color: Colors.grey[300],
            child: ListTile(
              title: Text(rate['ad']),
              trailing: Text(
                '${rate['fiyat']}TL',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Gram Gold by Banks",
          style: baslikStili,
        ),

        //cheapist gram golden price info card
        Card(
          color: Colors.green.shade50,
          child: ListTile(
            leading: const Icon(
              Icons.star,
              color: Colors.green,
            ),
            title: Text(
              "Cheapist Gram Golden",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(enUcuzGramAltinBankasi['banka']),
            trailing: Text(
              '${enUcuzGramAltinBankasi['gramAltin']}TL',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'How Many Grams of Gold Would You Like to Buy?',
          style: baslikStili,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _gramController,
          keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Example : 5',
          ),
          onChanged: (deger) {
            final temiz = deger.trim().replaceAll(',', '.');
            final gram = double.tryParse(temiz);
            setState(() {
              _girilenGram = gram;
            });
          },
        ),
        if (enUcuzBankaGramBazli != null) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.orange.shade50,
            child: ListTile(
              leading: const Icon(
                Icons.calculate,
                color: Colors.orange,
              ),
              title: Text(
                "${_girilenGram!.toStringAsFixed(2)} Available Bank For Gram",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(enUcuzBankaGramBazli['banka']),
              trailing: Text(
                '${enUcuzBankaGramBazli['toplamTutar'].toStringAsFixed(2)}TL',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],

        if (_girilenGram != null && _girilenGram! > 0)
          ...bankalarToplam.map(
            (banka) => Card(
              color: Colors.grey[300],
              child: ListTile(
                title: Text(banka['banka']),
                subtitle: Text(
                  'Gram Price: ${banka['gramAltin']}TL',
                ),
                trailing: Text(
                  '${banka['toplamTutar'].toStringAsFixed(2)}TL',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: const Text(
            'Gram Golden Price By Banks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //all banks lists
        ...bankalar.map(
          (bankverileri) => Card(
            color: Colors.grey[300],
            child: ListTile(
              title: Text(bankverileri['banka']),
              trailing: Text(
                '${bankverileri['gramAltin']}TL',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text("My Currency"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Markets"),
            Tab(text: "Converter"),
            Tab(text: "Crypto"),
            Tab(text: "News"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MarketsPage(),
          CurrencyConverterPage(),
          KriptoPage(),
          HaberlerPage(),
        ],
      ),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() =>
      _CurrencyConverterPageState();
}

class _CurrencyConverterPageState
    extends State<CurrencyConverterPage> {
  final TextStyle yaziTipi = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  // şimdilik apisiz kurlar listesi oluşturacağız
  final Map<String, double> kurlarTL = {
    'TRY': 1,
    'USD': 42,
    'EUR': 49,
    'GBP': 56,
  };

  late final List<String> items = kurlarTL.keys.toList();

  String _selectedSource = 'USD';
  String _selectedTarget = 'TRY';

  final TextEditingController _miktarHafizasi =
      TextEditingController();

  double? _sonuc;

  @override
  void dispose() {
    _miktarHafizasi.dispose();
    super.dispose();
  }

  void _hesapla() {
    //kullanıcınnın girdiği miktar temize çekilir
    final miktarStr = _miktarHafizasi.text
        .trim()
        .replaceAll(',', '.');

    //string -> double
    final miktar = double.tryParse(miktarStr);

    //hatalı giriş (sayı değil) null gönder
    if (miktar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid number"),
        ),
      );
      return;
    }

    // take source from map
    final kaynakKur = kurlarTL[_selectedSource];
    final hedefKur = kurlarTL[_selectedTarget];

    // 1) source to Try
    final tlKarsilik = miktar * kaynakKur!;
    final sonuc = tlKarsilik / hedefKur!;

    setState(() {
      _sonuc = sonuc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C853),
        title: Center(
          child: Text(
            "Currency Page",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Source Currency", style: yaziTipi),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSource,
              items: items
                  .map(
                    (para) => DropdownMenuItem(
                      value: para,
                      child: Text(para),
                    ),
                  )
                  .toList(),
              onChanged: (yeniDeger) {
                if (yeniDeger == null) return;
                setState(() {
                  _selectedSource = yeniDeger;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text("Target Currency", style: yaziTipi),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              initialValue: _selectedTarget,
              items: items
                  .map(
                    (para) => DropdownMenuItem(
                      value: para,
                      child: Text(para),
                    ),
                  )
                  .toList(),
              onChanged: (yeniDeger) {
                if (yeniDeger == null) return;
                setState(() {
                  _selectedTarget = yeniDeger;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text("Amount", style: yaziTipi),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),

              controller: _miktarHafizasi,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Amount To Convert",
              ),
            ),
            const SizedBox(height: 8),

            //count button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C853),
                ),
                onPressed: _hesapla,
                child: const Text(
                  "Calculate",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (_sonuc != null)
              Text(
                "Result: ${_miktarHafizasi.text} $_selectedSource = "
                "${_sonuc!.toStringAsFixed(2)} $_selectedTarget",
                style: yaziTipi,
              ),
          ],
        ),
      ),
    );
  }
}
