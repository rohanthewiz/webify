import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
//import 'package:web_session/web_session.dart';
import 'package:url_launcher/url_launcher.dart';

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
    //  'http://localhost:8880/v1/auth/status';
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

  void _launchURL() async {
    const url = 'https://flutter.io';
    //html.window.console.log("Hi there");
    //print(html.window.cookieStore.getAll());

//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await WebSession.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    print('Platform version $platformVersion');

    await launch(url);
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_isLoading ? "Loading..." : _data),
              RaisedButton(child: Text("Get Data"),
                onPressed: _fetchData,)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchURL, // _fetchData, //
        tooltip: 'Get Data',
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}
