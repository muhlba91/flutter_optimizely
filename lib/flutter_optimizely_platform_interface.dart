import 'package:flutter_optimizely/flutter_optimizely_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// A platform interface to communicate with Optimizely.
abstract class FlutterOptimizelyPlatform extends PlatformInterface {
  /// Initializes a new Optimizely platform using the given plugin `_token`.
  FlutterOptimizelyPlatform() : super(token: _token);

  // ignore: no-object-declaration
  static final Object _token = Object();

  static FlutterOptimizelyPlatform _instance = MethodChannelFlutterOptimizely();

  /// Returns the platform used to communicate with Optimizely.
  static FlutterOptimizelyPlatform get instance => _instance;

  // Sets the platform used to communicate with Optimizely.
  static set instance(FlutterOptimizelyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the Optimizely plugin asynchronously.
  Future<void> init(
    String sdkKey, {
    int periodicDownloadInterval = 10 * 60,
  }) =>
      throw UnimplementedError('init() has not been implemented.');

  /// Initializes the Optimizely plugin synchronously.
  ///
  /// This will initialize Optimizely with the local datafile to speed up initialization.
  /// The `datafile` parameter needs to be the JSON content of it!
  Future<void> initSync(
    String sdkKey,
    String datafile, {
    int periodicDownloadInterval = 10 * 60,
  }) =>
      throw UnimplementedError('initSync() has not been implemented.');

  /// Sets the user for this session.
  ///
  /// This user context is used for any other functions you call.
  Future<void> setUser(
    String userId,
    Map<String, dynamic> attributes,
  ) =>
      throw UnimplementedError('setUser() has not been implemented.');

  /// Checks if the feature with the given `featureKey` is enabled.
  Future<bool> isFeatureEnabled(String featureKey) =>
      throw UnimplementedError('isFeatureEnabled() has not been implemented.');

  /// Lists all enabled feature keys for this user.
  Future<Set<String>> getAllEnabledFeatures() => throw UnimplementedError(
        'getAllEnabledFeatures() has not been implemented.',
      );

  /// Retrieves all feature variables for a given `featureKey`.
  Future<Map<String, dynamic>> getAllFeatureVariables(String featureKey) =>
      throw UnimplementedError(
        'getAllFeatureVariables() has not been implemented.',
      );
}
