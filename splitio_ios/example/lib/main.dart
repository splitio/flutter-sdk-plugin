import 'package:flutter/material.dart';
import 'package:splitio_ios/splitio_ios.dart';

/// Replace these with valid values
const String _apiKey = 'api-key';
const String _matchingKey = 'user-id';

void main() {
  runApp(const SplitioExampleApp());
}

/// Splitio example home widget
class SplitioExampleApp extends StatefulWidget {
  /// Default Constructor
  const SplitioExampleApp({Key? key}) : super(key: key);

  @override
  State<SplitioExampleApp> createState() {
    return _SplitioExampleAppState();
  }
}

class _SplitioExampleAppState extends State<SplitioExampleApp> {
  bool _sdkReady = false;
  bool _sdkReadyFromCache = false;

  final _split = SplitioIOS();

  @override
  void initState() {
    super.initState();
    _initClients();
  }

  void _initClients() {
    _split.init(apiKey: _apiKey, matchingKey: _matchingKey, bucketingKey: null);

    _split.getClient(matchingKey: _matchingKey, bucketingKey: null);

    _split
        .onReady(matchingKey: _matchingKey, bucketingKey: null)
        ?.then((value) {
      setState(() {
        _sdkReady = true;
      });
    });

    _split
        .onReadyFromCache(matchingKey: _matchingKey, bucketingKey: null)
        ?.then((value) {
      setState(() {
        _sdkReadyFromCache = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('split.io example app'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'SDK ready: $_sdkReady',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                'SDK ready from cache: $_sdkReadyFromCache',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                child: TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter split name'),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              Visibility(
                  visible: !(_sdkReady || _sdkReadyFromCache),
                  child: const CircularProgressIndicator())
            ],
          )),
        )),
      ),
    );
  }
}
