# flutter_optimizely

**ATTENTION!** This plugin is deprecated and archived. It will **NOT** be updated anymore!

[![](https://img.shields.io/github/license/muhlba91/flutter_optimizely?style=for-the-badge)](LICENSE)
[![](https://img.shields.io/github/workflow/status/muhlba91/flutter_optimizely/Verify?style=for-the-badge)](https://github.com/muhlba91/flutter_optimizely/actions)
[![](https://img.shields.io/github/release-date/muhlba91/flutter_optimizely?style=for-the-badge)](https://github.com/muhlba91/flutter_optimizely/releases)
[![](https://img.shields.io/pub/v/flutter_optimizely?style=for-the-badge)](https://pub.dev/packages/flutter_optimizely)
[![](https://img.shields.io/pub/publisher/niftyside.io?style=for-the-badge)](https://pub.dev/publishers/niftyside.io/packages)
[![](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)
<a href="https://www.buymeacoffee.com/muhlba91" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="28" width="150"></a>

A Flutter plugin for [Optimizely](https://optimizely.com).
This plugin has been derived from [https://github.com/HomeX-It/optimizely-dart](https://github.com/HomeX-It/optimizely-dart).

---

## Getting Started

Currently Optimizely does not offer a dedicated Flutter SDK.

This Flutter plugin is bridging the gap between a Flutter application and the native Optimizely SDKs for [Android](https://github.com/optimizely/android-sdk) and [iOS/Swift](https://github.com/optimizely/swift-sdk).

## Usage

**ATTENTION: You MUST initialize the plugin/manager AND set up the user BEFORE using any functions!**

Currently, the only functions supported are:

- `isFeatureEnabled` (e.g. see [https://docs.developers.optimizely.com/full-stack/docs/is-feature-enabled-android](https://docs.developers.optimizely.com/full-stack/docs/is-feature-enabled-android))
- `getAllFeatureVariables` (e.g. see [https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android](https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android))
- `getAllEnabledFeatures` (e.g. see [https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android](https://docs.developers.optimizely.com/full-stack/docs/get-all-feature-variables-android))

### Example

```dart
import 'package:flutter_optimizely/flutter_optimizely.dart';

class MyClass {
    final _flutterOptimizelyPlugin = FlutterOptimizely();

    // if you have a data file at hand, you can initialize synchronously
    // hint: this will make the plugin available faster
    Future<void> initOptimizelySync() async {
        final String dataFile = await DefaultAssetBundle.of(context).loadString('assets/datafile.json');
        await _flutterOptimizelyPlugin.initSync(
            sdkKey,
            dataFile,
        );
        await _flutterOptimizelyPlugin.setUser('user', <String, dynamic>{
            'isLoggedIn': true,
        });
    }

    // if you don't have a data file at hand, or want to let the manager download it, initialize the plugin asynchronously
    Future<void> initOptimizelyAsync() async {
        final String dataFile = await DefaultAssetBundle.of(context).loadString('assets/datafile.json');
        await _flutterOptimizelyPlugin.init(
            sdkKey,
        );
        await _flutterOptimizelyPlugin.setUser('user', <String, dynamic>{
            'isLoggedIn': true,
        });
    }

    // examples on how to make use of the provided functions
    Future<void> anyAction() async {
        final bool isFeatureEnabled = await _flutterOptimizelyPlugin.isFeatureEnabled('feature_key');
        final Map<String, dynamic> variables = await _flutterOptimizelyPlugin.getAllFeatureVariables('feature_key');
        final Set<String> enabledFeatures = await _flutterOptimizelyPlugin.getAllEnabledFeatures();
    }
}
```

## Installation

Add `flutter_optimizely` as a dependency in your project's `pubspec.yaml`.

```yaml
dependencies:
  flutter_optimizely: ^x.y.z
```

Then run `flutter pub get` in your project directory.

---

## Contributing

We welcome community contributions to this project.

## Supporting

If you enjoy the application and want to support my efforts, please feel free to buy me a coffe. :)

<a href="https://www.buymeacoffee.com/muhlba91" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="75" width="300"></a>
