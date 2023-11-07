import 'package:flutter/material.dart';
import 'package:project1/api/request/hydra.dart';
import 'package:project1/api/request/user_endpoint.dart';
import 'package:project1/authentication/authentication_provider/authentication_provider.dart';
import 'package:project1/authentication/widget/login_screen.dart';

class Home extends StatefulWidget {
  static const String routeName = "Home";

  const Home({super.key, required this.title});
  final String title;
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _count = 0;


  @override
  Widget build(BuildContext context) {
    Future<List> p = UserEndpoint.gett();
    var futureBuilder = FutureBuilder(
      future: p,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Text('loading...');
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              return createListView(context, snapshot);
            }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('app_name'),
        automaticallyImplyLeading: true,
      ),
      drawer: _buildDrawer(context),
      body:  Center(
        child: TextButton(
          onPressed: () async {
              Hydra hydraUser =  await UserEndpoint.get();
              print(hydraUser.hydraMember);
              print(hydraUser.context);
              print(hydraUser.type);
              print(hydraUser.totalItems);
              hydraUser.hydraMember?.forEach((element) {print(element["@id"]);});
          },
          child: Text("Using Phone"),
        ),
      ),

    );

  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300'),
            ),
            accountEmail: Text('jane.doe@example.com'),
            accountName: Text(
              'Jane Doe',
              style: TextStyle(fontSize: 24.0),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text(
              'Houses',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginScreen(title: 'sss'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text(
              'Apartments',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginScreen(title: 'sss'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            title: const Text(
              'Townhomes',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginScreen(title: 'sss'),
                ),
              );
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Deconnexion',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              AuthenticationProvider.LogOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginScreen(title: 'sss'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<dynamic> values = snapshot.data;
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(title: Text(values[index]["userName"]),),
            new Text(values[index]["@id"]),
            const Divider(height: 2.0,),
          ],
        );
      },
    );
  }

}
