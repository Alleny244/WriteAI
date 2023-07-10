import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool textScanning = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        textScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    print(args);
    print(args.runtimeType);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8a9bd4),
        centerTitle: true,
        title: const Text("Recognised Text"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (textScanning) ...[
              Container(
                  margin: EdgeInsets.all(40),
                  child: const CircularProgressIndicator(
                    color: Color(0xff8a9bd4),
                  ))
            ] else ...[
              Container(margin: EdgeInsets.all(10), child: Text(args['text'])),
            ]
          ]),
        ),
      ),
    );
  }
}
