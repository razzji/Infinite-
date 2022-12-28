import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:infinite_auto_redialer/Screens/home.dart';

import 'Screens/about.dart';
import 'Screens/settings.dart';
import 'drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infinite Auto Caller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Infinite Auto Caller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentPage = DrawerSections.home;
  @override
  Widget build(BuildContext context) {
    {
      var container;

      if (currentPage == DrawerSections.home) {
        container = homePage();
      } else if (currentPage == DrawerSections.setting) {
        container = settingsPage();
      } else if (currentPage == DrawerSections.about) {
        container = aboutPage();
      }
      ;

      return Scaffold(
        appBar: AppBar(
          title: Text('Infinite Auto Caller'),
          centerTitle: true,
        ),
        body: container,
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem(1, "home", Icons.home_outlined,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Settings", Icons.settings_outlined,
              currentPage == DrawerSections.setting ? true : false),
          menuItem(3, "About", Icons.offline_bolt,
              currentPage == DrawerSections.about ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.setting;
            } else if (id == 3) {
              currentPage = DrawerSections.about;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  setting,
  about,
}
