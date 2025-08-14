import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:splitio_platform_interface/splitio_platform_interface.dart';
import 'package:splitio_platform_interface/split_evaluation_options.dart';

class SplitioPlatformStub
    with MockPlatformInterfaceMixin
    implements SplitioPlatform {
  String methodName = '';
  Map<String, dynamic> methodArguments = {};

  @override
  Future<bool> clearAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'clearAttributes';
    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };
    return Future.value(true);
  }

  @override
  Future<void> destroy(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'destroy';
    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return Future.value();
  }

  @override
  Future<void> flush(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'flush';
    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };
    return Future.value();
  }

  @override
  Future<Map<String, dynamic>> getAllAttributes(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'getAllAttributes';
    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return Future.value({});
  }

  @override
  Future getAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    methodName = 'getAttribute';
    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'attributeName': attributeName
    };

    return Future.value();
  }

  @override
  Future<void> getClient(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'getClient';

    methodArguments = {
      'matchingKey': matchingKey,
    };

    if (bucketingKey != null) {
      methodArguments['bucketingKey'] = bucketingKey;
    }

    return Future.value();
  }

  @override
  Future<String> getTreatment(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatment';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'splitName': splitName,
      'attributes': attributes
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value('');
  }

  @override
  Future<SplitResult> getTreatmentWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required String splitName,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentWithConfig';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'splitName': splitName,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value(const SplitResult('on', null));
  }

  @override
  Future<Map<String, String>> getTreatments(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatments';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'splitName': splitNames,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfig(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> splitNames,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentsWithConfig';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'splitName': splitNames,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentsByFlagSet';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'flagSet': flagSet,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Future<Map<String, String>> getTreatmentsByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentsByFlagSets';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'flagSets': flagSets,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSet(
      {required String matchingKey,
      required String? bucketingKey,
      required String flagSet,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentsWithConfigByFlagSet';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'flagSet': flagSet,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Future<Map<String, SplitResult>> getTreatmentsWithConfigByFlagSets(
      {required String matchingKey,
      required String? bucketingKey,
      required List<String> flagSets,
      Map<String, dynamic> attributes = const {},
      EvaluationOptions evaluationOptions = const EvaluationOptions.empty()}) {
    methodName = 'getTreatmentsWithConfigByFlagSets';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'flagSets': flagSets,
      'attributes': attributes,
    };

    if (evaluationOptions.properties.isNotEmpty) {
      methodArguments['evaluationOptions'] = evaluationOptions.toJson();
    }

    return Future.value({});
  }

  @override
  Stream<Impression> impressionsStream() {
    methodName = 'impressionsStream';

    return const Stream.empty();
  }

  @override
  Future<void> init(
      {required String apiKey,
      required String matchingKey,
      required String? bucketingKey,
      SplitConfiguration? sdkConfiguration}) {
    methodName = 'init';

    methodArguments = {
      'matchingKey': matchingKey,
      'apiKey': apiKey,
      'sdkConfiguration': sdkConfiguration?.configurationMap ?? {},
    };

    if (bucketingKey != null) {
      methodArguments['bucketingKey'] = bucketingKey;
    }

    return Future.value();
  }

  @override
  Future<void>? onReady(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'onReady';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return Future.value();
  }

  @override
  Future<void>? onReadyFromCache(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'onReadyFromCache';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return Future.value();
  }

  @override
  Future<void>? onTimeout(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'onTimeout';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return Future.value();
  }

  @override
  Stream<void>? onUpdated(
      {required String matchingKey, required String? bucketingKey}) {
    methodName = 'onUpdated';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey
    };

    return const Stream.empty();
  }

  @override
  Future<bool> removeAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName}) {
    methodName = 'removeAttribute';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'attributeName': attributeName
    };

    return Future.value(true);
  }

  @override
  Future<bool> setAttribute(
      {required String matchingKey,
      required String? bucketingKey,
      required String attributeName,
      required value}) {
    methodName = 'setAttribute';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'attributeName': attributeName,
      'value': value,
    };

    return Future.value(true);
  }

  @override
  Future<bool> setAttributes(
      {required String matchingKey,
      required String? bucketingKey,
      required Map<String, dynamic> attributes}) {
    methodName = 'setAttributes';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'attributes': attributes
    };

    return Future.value(true);
  }

  @override
  Future<SplitView?> split({required String splitName}) {
    methodName = 'split';

    methodArguments = {'splitName': splitName};

    return Future.value(null);
  }

  @override
  Future<List<String>> splitNames() {
    methodName = 'splitNames';

    return Future.value([]);
  }

  @override
  Future<List<SplitView>> splits() {
    methodName = 'splits';

    return Future.value([]);
  }

  @override
  Future<bool> track(
      {required String matchingKey,
      required String? bucketingKey,
      required String eventType,
      String? trafficType,
      double? value,
      Map<String, dynamic> properties = const {}}) {
    methodName = 'track';

    methodArguments = {
      'matchingKey': matchingKey,
      'bucketingKey': bucketingKey,
      'eventType': eventType
    };

    if (properties.isNotEmpty) {
      methodArguments['properties'] = properties;
    }

    if (trafficType != null) {
      methodArguments['trafficType'] = trafficType;
    }

    if (value != null) {
      methodArguments['value'] = value;
    }

    return Future.value(true);
  }

  @override
  Future<UserConsent> getUserConsent() {
    methodName = 'getUserConsent';

    return Future.value(UserConsent.granted);
  }

  @override
  Future<void> setUserConsent(bool enabled) {
    methodName = 'setUserConsent';
    methodArguments['value'] = enabled;

    return Future.value(null);
  }
}
