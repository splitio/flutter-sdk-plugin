import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splitio/split_client.dart';
import 'package:splitio/split_configuration.dart';
import 'package:splitio/splitio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _matchingKey = 'Unknown';
  final Splitio _split = Splitio('api-key', 'key1',
      configuration: SplitConfiguration(enableDebug: true));
  SplitClient? _client;

  @override
  void initState() {
    super.initState();
    setupState();
    initSplit();
  }

  void setupState() {
    if (!mounted) return;

    setState(() {
      _matchingKey = _client?.matchingKey ?? 'Unknown';
    });
  }

  Future<void> initSplit() async {
    print("initSplit-start");
    _split.init().then((value) => {_initClients()});
  }

  void _initClients() {
    _split
        .client((client) => {_client = client},
            matchingKey: 'key1', waitForReady: true)
        .then((value) {
      print("initSplit-clientRequested_for_key1");
    });

    _split
        .client((client) => {print('initSplit-end_forClient_key2')},
            matchingKey: 'key2', waitForReady: true)
        .then((value) {
      print("initSplit-secondClientRequested_for_key2");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Running with key: $_matchingKey\n'),
            ElevatedButton(
                onPressed: performEvaluation,
                child: const Text('Evaluate android_test_2'))
          ],
        )),
      ),
    );
  }

  void performEvaluation() async {
    String? treatment = await _client?.getTreatment('android_test_2');
    if (treatment != null) {
      print('Treatment is: ' + treatment);
    }
  }
}
