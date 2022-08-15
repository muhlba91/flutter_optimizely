import 'package:flutter_optimizely/flutter_optimizely.dart';
import 'package:flutter_optimizely/flutter_optimizely_method_channel.dart';
import 'package:flutter_optimizely/flutter_optimizely_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterOptimizelyPlatform
    with MockPlatformInterfaceMixin
    implements FlutterOptimizelyPlatform {
  @override
  Future<Set<String>> getAllEnabledFeatures() =>
      Future<Set<String>>.value(<String>{'elements'});

  @override
  Future<Map<String, dynamic>> getAllFeatureVariables(String featureKey) =>
      Future<Map<String, dynamic>>.value(<String, dynamic>{
        'integer': 1,
        'key': 'value',
      });

  @override
  Future<void> init(String sdkKey, {int periodicDownloadInterval = 10 * 60}) {
    expect(sdkKey, 'key');
    expect(periodicDownloadInterval, 1);
    return Future<void>.value();
  }

  @override
  Future<void> initSync(
    String sdkKey,
    String datafile, {
    int periodicDownloadInterval = 10 * 60,
  }) {
    expect(sdkKey, 'key');
    expect(datafile, 'datafile');
    expect(periodicDownloadInterval, 1);
    return Future<void>.value();
  }

  @override
  Future<bool> isFeatureEnabled(String featureKey) {
    expect(featureKey, 'key');
    return Future<bool>.value(true);
  }

  @override
  Future<void> setUser(String userId, Map<String, dynamic> attributes) {
    expect(userId, 'user');
    expect(attributes, <String, dynamic>{
      'key': 'value',
    });
    return Future<void>.value();
  }
}

void main() {
  final FlutterOptimizelyPlatform initialPlatform =
      FlutterOptimizelyPlatform.instance;

  test('$MethodChannelFlutterOptimizely is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterOptimizely>());
  });

  test('getAllEnabledFeatures', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    expect(
      await flutterOptimizelyPlugin.getAllEnabledFeatures(),
      <String>{'elements'},
    );
  });

  test('getAllFeatureVariables', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    expect(
      await flutterOptimizelyPlugin.getAllFeatureVariables('key'),
      <String, dynamic>{
        'integer': 1,
        'key': 'value',
      },
    );
  });

  test('init', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    await flutterOptimizelyPlugin.init('key', periodicDownloadInterval: 1);
  });

  test('initSync', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    await flutterOptimizelyPlugin.initSync(
      'key',
      'datafile',
      periodicDownloadInterval: 1,
    );
  });

  test('isFeatureEnabled', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    expect(await flutterOptimizelyPlugin.isFeatureEnabled('key'), true);
  });

  test('setUser', () async {
    final FlutterOptimizely flutterOptimizelyPlugin = FlutterOptimizely();
    final MockFlutterOptimizelyPlatform fakePlatform =
        MockFlutterOptimizelyPlatform();
    FlutterOptimizelyPlatform.instance = fakePlatform;

    await flutterOptimizelyPlugin.setUser(
      'user',
      <String, dynamic>{
        'key': 'value',
      },
    );
  });
}
