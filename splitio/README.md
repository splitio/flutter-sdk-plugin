# Split Flutter plugin

## Overview
This is the official Flutter plugin designed to work with Split, the platform for controlled rollouts, which serves features to your users via feature flags to manage your complete customer experience.

[![Twitter Follow](https://img.shields.io/twitter/follow/splitsoftware.svg?style=social&label=Follow&maxAge=1529000)](https://twitter.com/intent/follow?screen_name=splitsoftware)

## Compatibility
|                | Android | iOS      | Web      |
|----------------|---------|----------|----------|
| **Support**    | SDK 21+ | iOS 12+   | Any      |

## Getting started

Add `splitio` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

Here is a small example of how to perform an evaluation.

```dart
import 'package:splitio/splitio.dart';

final Splitio _split = Splitio('YOUR_SDK_KEY', 'USER_KEY');

/// Get treatment
_split.client(onReady: (client) async {
  final String treatment = await client.getTreatment('FEATURE_FLAG_NAME');

  if (treatment == 'on') {
    /// Insert code here to show on treatment
  } else if (treatment == 'off') {
    /// Insert code here to show off treatment
  } else {
    /// Insert your control treatment code here
  }
}
```

For a more elaborate usage example see [here](https://github.com/splitio/flutter-sdk-plugin/blob/splitio/main/example/lib/main.dart).

For additional information, refer to our docs page.

## Submitting issues

The Split team monitors all issues submitted to this [issue tracker](https://github.com/splitio/flutter-sdk-plugin/issues). We encourage you to use this issue tracker to submit any bug reports, feedback, and feature enhancements. We'll do our best to respond in a timely manner.

## Contributing
Please see [contributors guide](https://github.com/splitio/flutter-sdk-plugin/blob/splitio/main/CONTRIBUTORS-GUIDE.md) to find all you need to submit a Pull Request (PR).

## License
Licensed under the Apache License, Version 2.0. See: [Apache License](https://www.apache.org/licenses/).

## About Split

Split is the leading Feature Delivery Platform for engineering teams that want to confidently deploy features as fast as they can develop them. Split’s fine-grained management, real-time monitoring, and data-driven experimentation ensure that new features will improve the customer experience without breaking or degrading performance. Companies like Twilio, Salesforce, GoDaddy and WePay trust Split to power their feature delivery.

To learn more about Split, contact hello@split.io, or get started with feature flags for free at https://www.split.io/signup.

Split has built and maintains SDKs for:

* .NET [Github](https://github.com/splitio/dotnet-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/net-sdk/)
* Android [Github](https://github.com/splitio/android-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/android-sdk/)
* Angular [Github](https://github.com/splitio/angular-sdk-plugin) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/angular-utilities/)
* Elixir thin-client [Github](https://github.com/splitio/elixir-thin-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/elixir-thin-client-sdk/)
* Flutter [Github](https://github.com/splitio/flutter-sdk-plugin) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/flutter-plugin/)
* GO [Github](https://github.com/splitio/go-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/go-sdk/)
* iOS [Github](https://github.com/splitio/ios-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/ios-sdk/)
* Java [Github](https://github.com/splitio/java-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/java-sdk/)
* JavaScript [Github](https://github.com/splitio/javascript-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/javascript-sdk/)
* JavaScript for Browser [Github](https://github.com/splitio/javascript-browser-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/browser-sdk/)
* Node.js [Github](https://github.com/splitio/javascript-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/nodejs-sdk/)
* PHP [Github](https://github.com/splitio/php-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/php-sdk/)
* PHP thin-client [Github](https://github.com/splitio/php-thin-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/php-thin-client-sdk/)
* Python [Github](https://github.com/splitio/python-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/python-sdk/)
* React [Github](https://github.com/splitio/react-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/react-sdk/)
* React Native [Github](https://github.com/splitio/react-native-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/react-native-sdk/)
* Redux [Github](https://github.com/splitio/redux-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/client-side-sdks/redux-sdk/)
* Ruby [Github](https://github.com/splitio/ruby-client) [Docs](https://developer.harness.io/docs/feature-management-experimentation/sdks-and-infrastructure/server-side-sdks/ruby-sdk/)

For a comprehensive list of open source projects visit our [Github page](https://github.com/splitio?utf8=%E2%9C%93&query=%20only%3Apublic%20).

**Learn more about Split:**

Visit [split.io/product](https://www.split.io/product) for an overview of Split, or visit our documentation at [help.split.io](https://help.split.io) for more detailed information.
