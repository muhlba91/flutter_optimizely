package io.niftyside.flutter_optimizely

import android.app.Activity
import androidx.annotation.NonNull
import com.optimizely.ab.OptimizelyUserContext
import com.optimizely.ab.android.sdk.OptimizelyClient
import com.optimizely.ab.android.sdk.OptimizelyManager
import com.optimizely.ab.optimizelydecision.OptimizelyDecideOption
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.TimeUnit

/** FlutterOptimizelyPlugin */
class FlutterOptimizelyPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity

  private lateinit var optimizely: OptimizelyClient
  private lateinit var user: OptimizelyUserContext

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_optimizely")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "init" -> {
        val sdkKey = call.argument<String>("sdk_key")
        val periodicDownloadInterval = call.argument<Int>("periodic_download_interval")
        init(sdkKey!!, periodicDownloadInterval!!.toLong(), result)
      }
      "initSync" -> {
        val sdkKey = call.argument<String>("sdk_key")
        val periodicDownloadInterval = call.argument<Int>("periodic_download_interval")
        val dataFile = call.argument<String>("datafile")
        initSync(sdkKey!!, dataFile!!, periodicDownloadInterval!!.toLong(), result)
      }
      "setUser" -> {
        val userId = call.argument<String>("user_id")
        val attributes = call.argument<MutableMap<String, Any>>("attributes")
        setUser(userId!!, attributes!!, result)
      }
      "isFeatureEnabled" -> {
        val featureKey = call.argument<String>("feature_key")
        val featureEnabled = isFeatureEnabled(featureKey!!)
        result.success(featureEnabled)
      }
      "getAllEnabledFeatures" -> {
        val features = getAllEnabledFeatures()
        result.success(features.associateWith { _ -> null })
      }
      "getAllFeatureVariables" -> {
        val featureKey = call.argument<String>("feature_key")
        val variables = getAllFeatureVariables(featureKey!!)
        result.success(variables)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {}

  private fun init(sdkKey: String, periodicDownloadInterval: Long, @NonNull result: Result) {
    val optimizelyManager = OptimizelyManager.builder()
      .withSDKKey(sdkKey)
      .withEventDispatchInterval(periodicDownloadInterval, TimeUnit.SECONDS)
      .withDatafileDownloadInterval(60L * 15L, TimeUnit.SECONDS)
      .build(activity.applicationContext)

    optimizelyManager.initialize(activity.applicationContext, null) { client: OptimizelyClient ->
      optimizely = client
      result.success("")
    }
  }

  private fun initSync(sdkKey: String, dataFile: String, periodicDownloadInterval: Long, @NonNull result: Result) {
    val optimizelyManager = OptimizelyManager.builder()
      .withSDKKey(sdkKey)
      .withEventDispatchInterval(periodicDownloadInterval, TimeUnit.SECONDS)
      .withDatafileDownloadInterval(60L * 15L, TimeUnit.SECONDS)
      .build(activity.applicationContext)

    optimizely = optimizelyManager.initialize(activity.applicationContext, dataFile)
    result.success("")
  }

  private fun setUser(userId: String, attributes: MutableMap<String, Any>, @NonNull result: Result) {
    val userContext = optimizely.createUserContext(userId, attributes)
    if (userContext != null && userContext.userId == userId) {
      user = userContext
      result.success(userId)
    } else {
      result.error("UnknownError", "Optimizely User Context could not be set.", userId)
    }
  }

  private fun isFeatureEnabled(featureKey: String): Boolean {
    val decision = user.decide(featureKey)
    return decision.enabled
  }

  private fun getAllEnabledFeatures(): MutableSet<String> {
    val options: List<OptimizelyDecideOption> = listOf(OptimizelyDecideOption.ENABLED_FLAGS_ONLY)
    val decisions = user.decideAll(options)
    return decisions.keys
  }

  private fun getAllFeatureVariables(featureKey: String): Map<String, Any>? {
    val decision = user.decide(featureKey)
    return decision.variables.toMap()
  }
}
