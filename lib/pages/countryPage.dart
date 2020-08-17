import 'dart:convert';

import 'package:covid19_tracker/dataresource.dart';
import 'package:covid19_tracker/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {

  List countryData;
  fetchCountryData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: Search(countryData));
          }),
        ],
        backgroundColor: primaryBlack,
        title: Text('Country Stats')
      ),
      body: countryData==null ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              // color: Colors.black, // Can Do
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 130,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(countryData[index]['country'], style: TextStyle(fontWeight: FontWeight.bold),),
                        Image.network(countryData[index]['countryInfo']['flag'], height: 50, width: 60,),
                      ],
                    ),
                  ),
                  Expanded(child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('CONFIRMED : ' + countryData[index]['cases'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                        Text('ACTIVE : ' + countryData[index]['active'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text('RECOVERED : ' + countryData[index]['recovered'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        Text('DEATHS : ' + countryData[index]['deaths'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness==Brightness.dark?[100]:Colors.grey[900])),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        
        },
        itemCount: countryData==null ? 0 : countryData.length,
      ),
    );
  }
}