import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  var _data = "Not loaded";
  var _apiURL =
    'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/subaru?format=json';

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    print('Calling API...');
    var response = await http.get(_apiURL);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _data = response.body;

      });
      print("Response: ${response.statusCode}");
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_isLoading ? "Loading.." : _data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Get Data',
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}
