import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyHomeState();
  }
}

class _MyHomeState extends State<MyHomePage> {
  String? data;
  List<dynamic>? news;

  String? endata;
  List<dynamic>? ennews;

  @override
  void initState() {
    super.initState();
    getData();
    getDataenter();
  }

  void getData() async {
    http.Response response = await http.get(Uri.parse("https://inshortsapi.vercel.app/news?category=sports"));
    data = response.body;
    setState(() {
      news = jsonDecode(data!)['data'];
    });
  }

  void getDataenter() async {
    http.Response response = await http.get(Uri.parse("https://inshortsapi.vercel.app/news?category=startup"));
    endata = response.body;
    setState(() {
      ennews = jsonDecode(endata!)['data'];
    });
  }

  Widget searchbar() {
    return Card(
      elevation: 50,
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: const ListTile(
          leading: Icon(Icons.search),
          title: Text(
            "Search....",
            style: TextStyle(color: Color.fromARGB(217, 37, 35, 35)),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Tabbars() {
    return const DefaultTabController(
      length: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left:1,right:500,top:2,bottom:3),
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text("Sports")),
                  Tab(child: Text("Business")),
                  Tab(child: Text("Technology")),
                  Tab(child: Text("Entertainment")),
                  Tab(child: Text("Health")),
                  Tab(child: Text("Science")),
                  Tab(child: Text("World")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fortext() {
    return const Padding(
      padding: EdgeInsets.only(left: 2, top: 10, right: 250),
      child: Text(
        "Trending News",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(34, 158, 158, 158),
        ),
      ),
    );
  }

  Widget buildHorizontalScrollCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ennews == null
            ? [const CircularProgressIndicator()]
            : ennews!.map((article) {
                return Card(
                  margin: const EdgeInsets.all(9),
                  elevation: 50,
                  child: Container(
                    width: 200,
                    height: 250,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            article['imageUrl'],
                            fit: BoxFit.cover,
                            height: 140,
                            width: 180,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          article['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, right: 30),
                          child: Text(article['date']),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(124, 149, 119, 154),
        leading: const Icon(Icons.workspaces_filled),
        actions: const [Icon(Icons.more_horiz_rounded)],
        title: const Center(
          child: Text(
            "News",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          searchbar(),
          Tabbars(),
          buildHorizontalScrollCards(),
          fortext(),
          Expanded(
            child: news == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: news!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var article = news![index];
                      return Card(
                        margin: const EdgeInsets.all(9),
                        elevation: 50,
                        child: Column(
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  height: 200,
                                  width: 100, // Increased width
                                  child: Image.network(
                                    article['imageUrl'],
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(article['date']),
                                  const SizedBox(width: 12),
                                  Text(article['time']),
                                ],
                              ),
                              title: Text(
                                article['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, left: 3, right: 3),
                              child: Text(
                                article['content'],
                                style: const TextStyle(color: Color.fromARGB(246, 0, 0, 0)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
