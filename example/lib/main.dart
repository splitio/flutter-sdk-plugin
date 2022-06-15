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
  Splitio _split = Splitio();
  SplitClient? _client;

  @override
  void initState() {
    super.initState();
    initSplit();
  }

  Future<void> initSplit() async {
    print("initSplit-start");
    await _split.init('qer622vvc3ka6arore2qgibqgtqakip5bh76', 'key1',
        configuration: SplitConfiguration(enableDebug: true));

    _client = await _split.client('key1', waitForReady: true);
    print("initSplit-end");

    if (!mounted) return;

    setState(() {
      _matchingKey = _client?.matchingKey ?? 'Unknown';
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
          child: Text('Running with key: $_matchingKey\n'),
        ),
      ),
    );
  }
}
