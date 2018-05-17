import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'dart:async';
import 'dart:convert';

void main() => runApp( Github());

class Github extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Github Users',
      theme:  ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  GithubUsersList(title: 'Github users'),
    );
  }
}

class GithubUsersList extends StatefulWidget {
  GithubUsersList({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  GithubUsersListState createState() =>  GithubUsersListState();
}

class GithubUsersListState extends State<GithubUsersList> {
//  int _counter = 0;
//  List items = List<String>.generate(10000, (i) => "Item $i");
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }

  List data;

  Future<String> getData() async {
    final response = await http.get(
        Uri.encodeFull("https://api.github.com/search/users?q=luis"),
        headers: { "Accept": "application/json"}
    );

    this.setState(() {
      data = json.decode(response.body)["items"];
      print(data[1]["login"]);
    });

    return "Success!";
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body:
        CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Github Users'),
                  background: Image.asset( "assets/coder.jpg", fit: BoxFit.cover),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                sliver: SliverFixedExtentList(
                    itemExtent: 172.0,
                    delegate: SliverChildBuilderDelegate(
                          (builder, index) =>
                            Card(
                              child:
                                Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.all( 16.0),
                                              child: CircleAvatar(
                                                radius: 50.0,
                                                backgroundImage: NetworkImage( data[index]["avatar_url"]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                            child:
                                            Container(
                                              padding: EdgeInsets.only( top: 16.0, left: 16.0),
                                              child:
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding( padding: EdgeInsets.only( bottom: 16.0)),
                                                    Text(data[index]["login"], style: Theme.of(context).textTheme.title),
                                                    Padding( padding: EdgeInsets.only( bottom: 6.0)),
                                                    Text('Type : ' + data[index]["type"]),
                                                    Padding( padding: EdgeInsets.only( right: 15.0)),
                                                    Text('Score : ' + data[index]["score"].toString())
                                                  ],
                                                ),
                                            )
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only( left: 6.0, bottom: 6.0),
                                      child: Text(data[index]["url"]),
                                    )
                                  ],
                                )

                            ),
                        childCount: data != null ? data.length : 0
                    )
                ),
              )
            ]
        )
    );
  }
}
