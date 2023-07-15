import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = '';
  final TextEditingController _controller = TextEditingController();
  final _commonKeys = <String>[];

  Future<void> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      final keyCounts = <String, int>{};
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          for (final key in item.keys) {
            if (keyCounts.containsKey(key)) {
              keyCounts[key] = keyCounts[key]! + 1;
            } else {
              keyCounts[key] = 1;
            }
          }
        }
      }
      _commonKeys.clear();
      for (final entry in keyCounts.entries) {
        if (entry.value == data.length) {
          _commonKeys.add(entry.key);
        }
      }
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Fetch App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter the URL',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              fetchData(_controller.text);
            },
            child: Text('Fetch Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _commonKeys.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_commonKeys[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

