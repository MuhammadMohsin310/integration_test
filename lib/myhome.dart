import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class  MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
        'userId': '1',
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        posts.add(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to add post');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder API Integration'),
      ),
      body: Column(
        children: [
          posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          posts[index]['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        subtitle: Text(posts[index]['body']),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Title',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 214, 205, 205),
                      focusColor: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                      labelText: 'Body',
                      border: InputBorder.none,
                      hintText: 'Body',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 214, 205, 205),
                      focusColor: Colors.grey),
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () {
                    addPost(titleController.text, bodyController.text);
                  },
                  child: Container(
                    height: 50,
                    width: 190,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                        child: Text(
                      "Add Post",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
