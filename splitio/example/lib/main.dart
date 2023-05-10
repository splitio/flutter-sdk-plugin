import 'package:flutter/material.dart';
import 'package:splitio/splitio.dart';

/// Replace these with valid values
const String _sdkKey = 'sdk-key';
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
  String _featureFlagName = '';
  bool _sdkReady = false;
  bool _sdkReadyFromCache = false;
  late SplitClient _client;

  final Splitio _split = Splitio(_sdkKey, _matchingKey,
      configuration: SplitConfiguration(
        trafficType: "user",
      ));

  @override
  void initState() {
    super.initState();
    _initClients();
  }

  void _initClients() {
    _client = _split.client(
        matchingKey: _matchingKey,
        onReady: (client) {
          setState(() {
            _sdkReady = true;
          });
        });

    _client.whenReadyFromCache().then((value) {
      setState(() {
        _sdkReadyFromCache = true;
      });
    });

    _client.setAttributes({
      'name': 'splitio',
      'age': 1,
      'available': true,
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
                  decoration: const InputDecoration(
                      hintText: 'Enter feature flag name'),
                  onChanged: (text) {
                    setState(() {
                      _featureFlagName = text;
                    });
                  },
                ),
              ),
              Visibility(
                visible: _featureFlagName != '',
                child: ElevatedButton(
                    onPressed: performEvaluation,
                    child: Text('Evaluate: $_featureFlagName')),
              ),
              Visibility(
                  visible: _sdkReady || _sdkReadyFromCache,
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: track, child: const Text('Track event')),
                      ElevatedButton(
                          onPressed: getAttributes,
                          child: const Text('Get attributes')),
                      ElevatedButton(
                          onPressed: removeAttribute,
                          child: const Text('Remove age attribute')),
                      ElevatedButton(
                          onPressed: flush, child: const Text('Flush')),
                      ElevatedButton(
                          onPressed: destroy, child: const Text('Destroy')),
                    ],
                  )),
              Visibility(
                  visible: !(_sdkReady || _sdkReadyFromCache),
                  child: const CircularProgressIndicator())
            ],
          )),
        )),
      ),
    );
  }

  void performEvaluation() async {
    _client.getTreatment(_featureFlagName).then(
        (value) => {print('Evaluation value for $_featureFlagName is $value')});
  }

  void track() {
    _client.track("event-type", trafficType: "account", value: 25, properties: {
      "age": 50
    }).then((value) => print('Track result is: ' + value.toString()));
  }

  void getAttributes() async {
    var attributes = await _client.getAttributes();

    print('Attribute values: ' + attributes.toString());
  }

  void removeAttribute() async {
    _client.removeAttribute('age');
  }

  void flush() async {
    _client.flush();
  }

  void destroy() async {
    _client.destroy();
  }

  @override
  void dispose() {
    destroy();
    super.dispose();
  }
}
