import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
//import 'package:web_session/web_session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webify/models/contact.dart';
import 'package:webify/table_multi_scroll.dart';
import 'dart:convert';

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
  var _msg = "Not loaded";
  var _apiURL = 'http://localhost:7000/api/asset/contacts';

  //'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/subaru?format=json';
  List<Contact> _list = List();
  var _dataCore = List<List<String>>();
  var _firstCol = List<String>();
  var _firstRow = List<String>(); // heading really

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    print('Calling API...');
    var response = await http.get(_apiURL);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _msg = "";
        var lst = (json.decode(response.body) as List)
            .map((strContact) => Contact.fromJson(strContact)).toList();
        _buildDataForMultiScrollTable(lst);
      });

      //print("Response: ${response.statusCode}");

    } else {
      throw Exception('Failed to load data');
    }
  }

  _buildDataForMultiScrollTable(List<Contact> list) {
    for (var ct in list) {
      if (_firstRow.length < 1) {
        _firstRow.add(ct.Name);
        _firstRow.add(ct.Role);
        _firstRow.add(ct.Company);
        _firstRow.add(ct.Phone);
        _firstRow.add(ct.Email);
        continue;
      }

      _firstCol.add(ct.Name);

      var dataRow = List();
      dataRow.add(ct.Role);
      dataRow.add(ct.Company);
      dataRow.add(ct.Phone);
      dataRow.add(ct.Email);
      _dataCore.add(dataRow);
    }
  }

  void _launchURL() async {
    const url = 'https://flutter.io|abcdefg1234567';
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
              Text(_isLoading ? "Loading..." : _msg),
              RaisedButton(child: Text("Get Data"),
                onPressed: _fetchData,
              ),
//              CustomDataTable(
//                dataRows: _dataCore,
//                fixedColumn: _firstCol,
//                fixedRow: _firstRow,
//                cellBuilder: (data) {
//                  return Text('$data', style: TextStyle(color: Colors.black45));
//                },
//              ),

            ],
          ),
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _launchURL, // _fetchData, //
//        tooltip: 'Go to Flutter.io',
//        child: Icon(Icons.navigate_next),
//      ),
    );
  }
}
