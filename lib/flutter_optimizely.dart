import 'package:flutter_optimizely/flutter_optimizely_platform_interface.dart';

/// Optimizely plugin for Flutter.
///
/// This class maps Optimizely methods to Flutter.
/// To get started you can initialize it synchronously, or asynchronously.
///
/// For example, asynchronous initialization can be implemented similar to:
///
/// ```dart
/// class MyClass {
///    final _flutterOptimizelyPlugin = FlutterOptimizely();
///
///    Future<void> initOptimizelyAsync() async {
///        final String dataFile = await DefaultAssetBundle.of(context).loadString('assets/datafile.json');
///        await _flutterOptimizelyPlugin.init(
///            sdkKey,
///        );
///        await _flutterOptimizelyPlugin.setUser('user', <String, dynamic>{
///            'isLoggedIn': true,
///        });
///    }
/// }
/// ```
class FlutterOptimizely {
  /// Initializes the Optimizely plugin asynchronously.
  ///
  /// Reference: https://docs.developers.optimizely.com/full-stack/docs/initialize-sdk-android#asynchronous-initialization).
  Future<void> init(
    String sdkKey, {
    int periodicDownloadInterval = 10 * 60,
  }) async =>
      FlutterOptimizelyPlatform.instance.init(
        sdkKey,
        periodicDownloadInterval: periodicDownloadInterval,
      );

  /// Initializes the Optimizely plugin synchronously.
  ///
  /// This will initialize Optimizely with the local datafile to speed up initialization.
  /// The `datafile` parameter needs to be the JSON content of it!
  ///
  /// Reference: https://docs.developers.optimizely.com/full-stack/docs/initialize-sdk-android#synchronous-initialization).
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

  /// Sets the user for this session.
  ///
  /// This user context is used for any other functions you call.
  Future<void> setUser(
    String userId,
    Map<String, dynamic> attributes,
  ) async =>
      FlutterOptimizelyPlatform.instance.setUser(
        userId,
        attributes,
      );

  /// Checks if the feature with the given `featureKey` is enabled.
  ///
  /// Reference: https://docs.developers.optimizely.com/full-stack/docs/is-feature-enabled-android
  Future<bool> isFeatureEnabled(String featureKey) async =>
      FlutterOptimizelyPlatform.instance.isFeatureEnabled(
        featureKey,
      );

  /// Lists all enabled feature keys for this user.
  ///
  /// Reference: https://docs.developers.optimizely.com/full-stack/docs/get-enabled-features-android
  Future<Set<String>> getAllEnabledFeatures() async =>
      FlutterOptimizelyPlatform.instance.getAllEnabledFeatures();

  /// Retrieves all feature variables for a given `featureKey`.
  ///
  /// Reference: https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android
  Future<Map<String, dynamic>> getAllFeatureVariables(
    String featureKey,
  ) async =>
      FlutterOptimizelyPlatform.instance.getAllFeatureVariables(
        featureKey,
      );
}
