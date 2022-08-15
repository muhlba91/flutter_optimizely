// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_optimizely/flutter_optimizely.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String sdkKey = 'OPTIMIZELY_API_KEY_NOT_PROVIDED';
  final _flutterOptimizelyPlugin = FlutterOptimizely();

  String _priceFilterFlag = 'unknown';
  String _minPriceVariable = 'unknown';

  @override
  void initState() {
    super.initState();
    initOptimizely();
  }

  Future<void> initOptimizely() async {
    final String dataFile =
        await DefaultAssetBundle.of(context).loadString('assets/datafile.json');
    print("optimizely datafile loaded");
    await _flutterOptimizelyPlugin.initSync(
      sdkKey,
      dataFile,
    );
    print("optimizely plugin initialized");
    await _flutterOptimizelyPlugin.setUser('user', <String, dynamic>{});
    print("optimizely user set");
  }

  Future<void> getPriceFilterFlag() async {
    String priceFilterFlag;
    try {
      bool? featureEnabled = await _flutterOptimizelyPlugin.isFeatureEnabled(
        'price_filter',
      );
      priceFilterFlag = 'price_filter feature is $featureEnabled.';
    } on PlatformException catch (e) {
      priceFilterFlag = "Failed to get feature: '${e.message}'.";
    }

    if (!mounted) return;

    setState(() {
      _priceFilterFlag = priceFilterFlag;
    });
  }

  Future<void> getPriceFilterMinPrice() async {
    String minPriceVariable;
    Map<String, dynamic> variables;
    try {
      variables = await _flutterOptimizelyPlugin.getAllFeatureVariables(
        'price_filter',
      );
      int? minPrice = variables['min_price'];
      minPriceVariable = "min_price variable is: ${minPrice.toString()}.";
    } catch (e) {
      minPriceVariable = "Failed to get min_price variable from feature: '$e'.";
    }

    if (!mounted) return;

    setState(() {
      _minPriceVariable = minPriceVariable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Optimizely Example App'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Center(
                child: Text(_priceFilterFlag),
              ),
              ElevatedButton(
                child: const Text('Get Price Filter Flag'),
                onPressed: () {
                  getPriceFilterFlag();
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(_minPriceVariable),
              ),
              ElevatedButton(
                child: const Text('Get Price Filter Min Price'),
                onPressed: () {
                  getPriceFilterMinPrice();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
