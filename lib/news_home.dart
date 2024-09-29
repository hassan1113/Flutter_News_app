import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'news_model.dart';
import 'package:intl/intl.dart';

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  late Future<List<News>> futureNews;
  String selectedCountry = 'us';

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsFromCountry(selectedCountry);
  }

  Future<List<News>> fetchNewsFromCountry(String country) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=f62824365a534e3884fe8c8f85268366'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news for country: $country');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/news.png', width: 40, height: 40),
            SizedBox(width: 10),
            Text('News App', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<News>>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final newsList = snapshot.data!;
                    return ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        final news = newsList[index];
                        return NewsCard(news: news);
                      },
                    );
                  } else {
                    return Center(child: Text('No news found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          news.urlToImage != null
              ? Image.network(news.urlToImage)
              : Container(height: 150, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              news.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              DateFormat('yMMMd').format(news.publishedAt),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(news.description),
          ),
        ],
      ),
    );
  }
}
