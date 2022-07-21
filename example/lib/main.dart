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
      configuration: SplitConfiguration(
          enableDebug: true,
          trafficType: "user",
          persistentAttributesEnabled: true));
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

  void _initClients() async {
    _client = await _split.client(
        matchingKey: 'key1',
        onReady: (value) => {print('SKD READY'), _client = value},
        onReadyFromCache: (value) => {print('SKD READY FROM CACHE')});

    _client?.setAttributes({
      'name': 'gaston',
      'bool_attr': true,
      'number_attr': 25.56,
      'string_attr': 'attr-value',
      'list_attr': ['one', 'two'],
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
                child: const Text('Evaluate android_test_2')),
            ElevatedButton(onPressed: track, child: const Text('Track event')),
            ElevatedButton(
                onPressed: getAttribute, child: const Text('Get attribute')),
            ElevatedButton(onPressed: flush, child: const Text('Flush')),
            ElevatedButton(onPressed: destroy, child: const Text('Destroy')),
          ],
        )),
      ),
    );
  }

  void performEvaluation() async {
    // var treatment = await _client?.getTreatmentWithConfig('android_test_2');
    Map<String, String>? treatment =
        await _client?.getTreatments(['android_test_2', 'android_test_3']);
    if (treatment != null) {
      print('Treatment is: ' + treatment.toString());
    }
  }

  void track() {
    _client?.track("eventType", trafficType: "account", value: 25, properties: {
      "age": 50
    }).then((value) => print('Track result is: ' + value.toString()));
  }

  void getAttribute() async {
    _client
        // ?.getAttribute('test_attribute_2')
        ?.getAttributes()
        .then((value) {
      print('Attribute value is: ' + value.toString());
      _client?.removeAttribute('name');
    });
  }

  void flush() async {
    _client?.flush();
  }

  void destroy() async {
    _client?.destroy();
  }
}
