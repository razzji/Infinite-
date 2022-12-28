import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

enum EndTimeCharacter { minutes, seconds }

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController textEditingController = TextEditingController();

  TextEditingController endcalltimeController = TextEditingController();

  TextEditingController timeinput = TextEditingController();

  // int selectedValue = 0;

  // @override
  // Widget builder(BuildContext context) => ListView(
  //       padding: EdgeInsets.symmetric(vertical: 5),
  //       children: [
  //         RadioListTile<int>(
  //             value: 1,
  //             groupValue: selectedValue,
  //             title: Text('Minutes'),
  //             onChanged: (value) => setState(
  //                   () => selectedValue = 1,
  //                 )),
  //         RadioListTile<int>(
  //             value: 2,
  //             groupValue: selectedValue,
  //             title: Text('Seconds'),
  //             onChanged: (value) => setState(
  //                   () => selectedValue = 1,
  //                 )),
  //       ],
  //     );

  static const values = <String>['Minutes', 'Seconds'];
  String selectedValue = values.first;

  final selectedColor = Colors.green;
  final unselectedColor = Colors.black;

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: unselectedColor,
        ),
        child: Column(
          children: values.map(
            (value) {
              final selected = this.selectedValue == value;
              final color = selected ? selectedColor : unselectedColor;
              return RadioListTile<String>(
                value: value,
                groupValue: selectedValue,
                title: Text(
                  value,
                  style: TextStyle(color: color),
                ),
                activeColor: selectedColor,
                onChanged: (value) =>
                    setState(() => this.selectedValue = value!),
              );
            },
          ).toList(),
        ),
      );

  int timeLeft = 5;
  void _startCountDown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    timeLeft == 0 ? "done" : timeLeft.toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                ]),
          ),

          // Container(child: buildtimer()),
          Container(child: buildRadios()),
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
            margin: EdgeInsets.fromLTRB(25, 5, 20, 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: endcalltimeController,
              decoration: InputDecoration(
                  icon: Icon(Icons.timer),
                  labelText: "Enter Call End Time in Seconds"),
              onSaved: (endcallTime) {
                textEditingController.text = endcallTime!;
              },
            ),
          ),
          Container(
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: textEditingController,
              onSaved: (phoneNumber) {
                textEditingController.text = phoneNumber!;
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _callNumber(textEditingController.text);
            },
            icon: Icon(
              // <-- Icon
              Icons.phone,
              size: 24.0,
            ),
            label: Text('Call'), // <-- Text
          ),
        ],
      ),
    );
  }

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  _launchPhoneURL(String phoneNumber) async {
    String url = 'tel:' + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
