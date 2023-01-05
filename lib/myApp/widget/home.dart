import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const String routeName = "Home";

  const Home({super.key, required this.title});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('app_name'),
        //automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                "Hello Andy!!",
                textAlign: TextAlign.justify,
                textScaleFactor: 2.0,
              ),
            ),
            ListTile(
              title: Text("First"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Second"),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: const Center(
        child: Text("totoro"),
      ),
    );
  }

}