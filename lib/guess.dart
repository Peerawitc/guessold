import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart'; // or flutter_spinbox.dart for both
import 'package:guessold/database.dart';
import 'package:http/http.dart' as http;

class guess extends StatefulWidget {
  const guess({Key? key}) : super(key: key);

  @override
  _guessState createState() => _guessState();
}

class _guessState extends State<guess> {
  int _input = 0;
  double year = 0;
  double mon  = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER'S AGE"),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // ไล่เฉดจากมุมบนซ้ายไปมุมล่างขวาของ Container
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // ไล่เฉดจากสีแดงไปสีน้ำเงิน
            colors: [
              Colors.lightBlueAccent.shade200,
              Colors.redAccent.shade200,
              Colors.cyanAccent,
              //Colors.pinkAccent.shade100,
              //Colors.purpleAccent.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "อายุอาจารย์",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ],
              ),
              Padding(
                child: SpinBox(
                  value: 0,
                  max: 100,
                  min: 0,
                  onChanged: (value) => year=value,
                  decoration: InputDecoration(labelText: 'Year'),
                ),
                padding: const EdgeInsets.all(16),
              ),
              Padding(
                child: SpinBox(
                  value: 0,
                  max: 11,
                  min: 0,
                  onChanged: (value) =>mon=value,
                  decoration: InputDecoration(labelText: 'Month'),
                ),
                padding: const EdgeInsets.all(16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                  child: Text(
                    'ทาย',
                    style: TextStyle(fontSize: 20.0,color: Colors.black),
                  ),
                  onPressed:(

                      ){
                    _test(year, mon);
                  },

                ),
              ),


            ],
          ),

        ),
      ),
    );
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _test(double year,double mon) async {
    var url = Uri.parse(
        "https://cpsu-test-api.herokuapp.com/guess_teacher_age");
    var response = await http.post(url, body: {
      'year': year,
      'mon': mon
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);
      String status = jsonBody['status'];
      String? message = jsonBody['message'];
      List<dynamic> data = jsonBody['data'];

      print('STATUS: $status');
      print('MESSAGE: $message');
      print('data: $data');
      var getdata = data.map((e) => database(text: e["text"], value:e ["value"])).toList();

    }
  }

}