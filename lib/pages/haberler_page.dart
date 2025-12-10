import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class HaberlerPage extends StatefulWidget {
  const HaberlerPage({super.key});

  @override
  State<HaberlerPage> createState() => _HaberlerPageState();
}

class _HaberlerPageState extends State<HaberlerPage> {
  final _service = NewsService();
  late Future<List<NewsArticle>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _service.getirBusinessNews();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      //açılmazsa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Did Not Open Connection Or Adress',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C853),
        centerTitle: true,
        title: const Text(
          "Market News",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final news = snapshot.data ?? [];
          if (news.isEmpty) {
            return const Center(
              child: Text('Did Not News'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureNews = _service.getirBusinessNews();
              });
            },
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                final article = news[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openUrl(article.url),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        if (article.imageUrl.isNotEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              article.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (article.description.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                            child: Text(
                              article.description,
                              maxLines: 3,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
