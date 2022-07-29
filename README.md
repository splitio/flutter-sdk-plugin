# split.io

The official Flutter plugin for split.io, the platform for controlled rollouts, which serves features to your users via a Split feature flag to manage your complete customer experience.

|                | Android | iOS      |
|----------------|---------|----------|
| **Support**    | SDK 21+ | iOS 9+* |

## Features

* Perform Split evaluations.
* Track user events.

## Installation

Add `splitio` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

### Usage

Here is a small example of how to perform an evaluation.

```dart
import 'package:splitio/split_client.dart';
import 'package:splitio/splitio.dart';

final Splitio _split = Splitio('YOUR_API_KEY', 'KEY');

/// Get treatment
_split.client(onReady: (client) async {
  final String treatment = await client.getTreatment('SPLIT_NAME');

  if (treatment == 'on') {
    /// Insert code here to show on treatment
  } else if (treatment == 'off') {
    /// Insert code here to show off treatment
  } else {
    /// Insert your control treatment code here
  }
}
```

For a more elaborate usage example see [here](https://github.com/splitio/flutter-sdk-plugin/blob/main/example/lib/main.dart).

For additional information, refer to our docs page.
