import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_optimizely/flutter_optimizely_platform_interface.dart';

class MethodChannelFlutterOptimizely extends FlutterOptimizelyPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('flutter_optimizely');

  @override
  Future<void> init(
    String sdkKey, {
    int periodicDownloadInterval = 10 * 60,
  }) async {
    await methodChannel.invokeMethod('init', <String, dynamic>{
      'sdk_key': sdkKey,
      'periodic_download_interval': periodicDownloadInterval,
    });
  }

  @override
  Future<void> initSync(
    String sdkKey,
    String datafile, {
    int periodicDownloadInterval = 10 * 60,
  }) async {
    await methodChannel.invokeMethod('initSync', <String, dynamic>{
      'sdk_key': sdkKey,
      'datafile': datafile,
      'periodic_download_interval': periodicDownloadInterval,
    });
  }

  @override
  Future<void> setUser(String userId, Map<String, dynamic> attributes) async {
    await methodChannel.invokeMethod('setUser', <String, dynamic>{
      'user_id': userId,
      'attributes': attributes,
    });
  }

  @override
  Future<bool> isFeatureEnabled(String featureKey) async {
    final bool? result = await methodChannel
        .invokeMethod<bool?>('isFeatureEnabled', <String, dynamic>{
      'feature_key': featureKey,
    });
    return result ?? false;
  }

  @override
  Future<Set<String>> getAllEnabledFeatures() async {
    final Map<dynamic, dynamic> result = await methodChannel
            .invokeMethod<Map<dynamic, dynamic>?>('getAllEnabledFeatures') ??
        <String, dynamic>{};
    return Set<String>.from(result.keys);
  }

  @override
  Future<Map<String, dynamic>> getAllFeatureVariables(
    String featureKey,
  ) async {
    final Map<dynamic, dynamic>? result =
        await methodChannel.invokeMethod<Map<dynamic, dynamic>?>(
      'getAllFeatureVariables',
      <String, dynamic>{
        'feature_key': featureKey,
      },
    );
    return Map<String, dynamic>.from(result ?? <String, dynamic>{});
  }
}
