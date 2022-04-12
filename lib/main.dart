import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MainPage.dart';
import 'data/unit_model.dart';

void main() {
  final unitModel = UnitModel();
  unitModel.initUnit();

  runApp(Provider(create: (_) => unitModel, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const MainPage();
        },
        '/about': (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('About Route'),
            ),
          );
        }
      },
    );
  }
}


