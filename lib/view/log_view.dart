import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../comms/interface.dart';

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  LogViewState createState() => LogViewState();
}

class LogViewState extends State<LogView> with AutomaticKeepAliveClientMixin {
  late String _outputText;
  final Interface _interface = Interface();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _interface.sendlogStrings = () {
      setState(() {
        _outputText = _interface.logStrings.join("\n");
      });
      if (kDebugMode) {
        print("Updated text log");
      }
      Future.delayed(const Duration(milliseconds: 100)).then((val) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    };

    _outputText = "";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          child: Text(
            _outputText,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
