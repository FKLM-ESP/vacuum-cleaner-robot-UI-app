import 'dart:async';

import 'package:app/comms/interface.dart';
import 'package:app/utils/app_scroll_behavior.dart';
import 'package:app/view/battery_monitor.dart';
import 'package:app/view/control_buttons.dart';
import 'package:app/view/imu_monitor.dart';
import 'package:app/view/log_view.dart';
import 'package:app/view/map.dart';
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
  // explicit, private methods not accessible in initializers
  ObjectKey n = ObjectKey(DateTime.now());
  late Timer timer;

  ObjectKey _genObjectKey() {
    return ObjectKey(DateTime.now());
  }

  @override
  void initState() {
    super.initState();

    // Hacky, but refreshes the MapView widget
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      setState(() {
        n = _genObjectKey();
      });
    });
  }

  final _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: BatteryMonitor(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: PageView(
                scrollBehavior: AppScrollBehavior(),
                controller: _controller,
                children: [
                  MapView(
                    // force the map to be redrawn
                    key: n,
                  ),
                  const LogView()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
            child: ImuMonitor(),
          ),
          const ControlPanel(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: Interface().sendTestRoutine,
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.lightBlue,
              )),
              child: const Text(
                "Test",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
