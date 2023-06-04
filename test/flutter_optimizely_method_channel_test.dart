// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/services.dart';
import 'package:flutter_optimizely/flutter_optimizely_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: long-method
void main() {
  final MethodChannelFlutterOptimizely platform =
      MethodChannelFlutterOptimizely();
  const MethodChannel channel = MethodChannel('flutter_optimizely');

  const String sdkKey = 'sdk';
  const String datafile = 'file';
  const int periodicDownloadInterval = 1;
  const String userId = 'user';
  const String featureKey = 'feature';

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'init':
          expect(
            methodCall.arguments['sdk_key'],
            sdkKey,
          );
          expect(
            methodCall.arguments['periodic_download_interval'],
            periodicDownloadInterval,
          );
        case 'initSync':
          expect(
            methodCall.arguments['sdk_key'],
            sdkKey,
          );
          expect(
            methodCall.arguments['periodic_download_interval'],
            periodicDownloadInterval,
          );
          expect(
            methodCall.arguments['datafile'],
            datafile,
          );
        case 'setUser':
          expect(
            methodCall.arguments['user_id'],
            userId,
          );
          expect(
            methodCall.arguments['attributes'],
            <String, dynamic>{
              'attribute': 1,
              'key': 'value',
            },
          );
        case 'isFeatureEnabled':
          expect(
            methodCall.arguments['feature_key'],
            featureKey,
          );
          return false;
        case 'getAllFeatureVariables':
          expect(
            methodCall.arguments['feature_key'],
            featureKey,
          );
          return <String, dynamic>{'variable': 'variable'};
        case 'getAllEnabledFeatures':
          return <String, dynamic>{featureKey: null};
        default:
          break;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('init', () async {
    await platform.init(
      sdkKey,
      periodicDownloadInterval: periodicDownloadInterval,
    );
  });

  test('initSync', () async {
    await platform.initSync(
      sdkKey,
      datafile,
      periodicDownloadInterval: periodicDownloadInterval,
    );
  });

  test('setUser', () async {
    await platform.setUser(
      userId,
      <String, dynamic>{
        'attribute': 1,
        'key': 'value',
      },
    );
  });

  test('isFeatureEnabled', () async {
    expect(await platform.isFeatureEnabled(featureKey), false);
  });

  test('getAllFeatureVariables', () async {
    expect(await platform.getAllFeatureVariables(featureKey), <String, dynamic>{
      'variable': 'variable',
    });
  });

  test('getAllEnabledFeatures', () async {
    expect(await platform.getAllEnabledFeatures(), <String>{featureKey});
  });
}
