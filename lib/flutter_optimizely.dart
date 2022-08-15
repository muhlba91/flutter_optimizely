import 'package:flutter_optimizely/flutter_optimizely_platform_interface.dart';

class FlutterOptimizely {
  Future<void> init(
    String sdkKey, {
    int periodicDownloadInterval = 10 * 60,
  }) async =>
      FlutterOptimizelyPlatform.instance.init(
        sdkKey,
        periodicDownloadInterval: periodicDownloadInterval,
      );

  Future<void> initSync(
    String sdkKey,
    String datafile, {
    int periodicDownloadInterval = 10 * 60,
  }) async =>
      FlutterOptimizelyPlatform.instance.initSync(
        sdkKey,
        datafile,
        periodicDownloadInterval: periodicDownloadInterval,
      );

  Future<void> setUser(
    String userId,
    Map<String, dynamic> attributes,
  ) async =>
      FlutterOptimizelyPlatform.instance.setUser(
        userId,
        attributes,
      );

  Future<bool> isFeatureEnabled(String featureKey) async =>
      FlutterOptimizelyPlatform.instance.isFeatureEnabled(
        featureKey,
      );

  Future<Set<String>> getAllEnabledFeatures() async =>
      FlutterOptimizelyPlatform.instance.getAllEnabledFeatures();

  Future<Map<String, dynamic>> getAllFeatureVariables(
    String featureKey,
  ) async =>
      FlutterOptimizelyPlatform.instance.getAllFeatureVariables(
        featureKey,
      );
}
