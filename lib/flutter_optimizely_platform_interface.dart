import 'package:flutter_optimizely/flutter_optimizely_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterOptimizelyPlatform extends PlatformInterface {
  FlutterOptimizelyPlatform() : super(token: _token);

  // ignore: no-object-declaration
  static final Object _token = Object();

  static FlutterOptimizelyPlatform _instance = MethodChannelFlutterOptimizely();

  static FlutterOptimizelyPlatform get instance => _instance;

  static set instance(FlutterOptimizelyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(
    String sdkKey, {
    int periodicDownloadInterval = 10 * 60,
  }) =>
      throw UnimplementedError('init() has not been implemented.');

  Future<void> initSync(
    String sdkKey,
    String datafile, {
    int periodicDownloadInterval = 10 * 60,
  }) =>
      throw UnimplementedError('initSync() has not been implemented.');

  Future<void> setUser(
    String userId,
    Map<String, dynamic> attributes,
  ) =>
      throw UnimplementedError('setUser() has not been implemented.');

  Future<bool> isFeatureEnabled(String featureKey) =>
      throw UnimplementedError('isFeatureEnabled() has not been implemented.');

  Future<Set<String>> getAllEnabledFeatures() => throw UnimplementedError(
        'getAllEnabledFeatures() has not been implemented.',
      );

  Future<Map<String, dynamic>> getAllFeatureVariables(String featureKey) =>
      throw UnimplementedError(
        'getAllFeatureVariables() has not been implemented.',
      );
}
