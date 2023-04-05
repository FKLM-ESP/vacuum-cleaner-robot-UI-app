import 'dart:async';

import 'package:app/view/control_buttons.dart';
import 'package:app/view/map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vacuum Robot Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Vacuum Robot Controller'),
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
  DateTime n = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Hacky, but refreshes the MapView widget
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      setState(() {
        n = DateTime.now();
      });
      if (kDebugMode) {
        print("Refreshed main widget");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mapWidget = MapView(
      key: ObjectKey(n),
    );
    var controlPanel = const ControlPanel();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: mapWidget,
            ),
          ),
          controlPanel,
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
