import 'dart:convert';

import 'package:covid19_tracker/pages/countryPage.dart';
import 'package:covid19_tracker/panels/infoPanel.dart';
import 'package:covid19_tracker/panels/mosteffectedcountries.dart';
import 'package:covid19_tracker/panels/worldwidepannel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:covid19_tracker/dataresource.dart';
import 'package:http/http.dart'as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map worldData;
  fetchWorldwideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }
  
  List countryData;
  fetchCountryData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldwideData();
    fetchCountryData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light ? Icons.lightbulb_outline : Icons.highlight), 
            onPressed: () {
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light);
            }),
        ],
        backgroundColor: primaryBlack,
        centerTitle: false,
        title: Text('COVID-19 TRACKER APP'),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              color: Colors.orange[100],
              child: Text(DataSource.quote,style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Worldwide', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CountryPage()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryBlack,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text('Regional', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),)
                    ),
                  ),
                ],
              ),
            ),
            WorldWidePannel(worldData: worldData,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Most affected Countries', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),
            countryData==null ? Container() : MostAffectedPanel(countryData: countryData,),
            InfoPanel(),
            SizedBox(height: 20,),
            Center(child: Text('WE ARE TOGETHER IN THE FIGHT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
            SizedBox(height: 50,),
          ],
        ),
      ) 
    );
  }
}