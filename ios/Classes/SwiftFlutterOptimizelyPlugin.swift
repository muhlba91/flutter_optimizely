import Flutter
import UIKit
import Optimizely

enum InitResult {
  case success
  case failure(Error)
}

public class SwiftFlutterOptimizelyPlugin: NSObject, FlutterPlugin {
  var optimizely: OptimizelyClient?
  var user: OptimizelyUserContext?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_optimizely", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterOptimizelyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? [String: Any] else {
      result(FlutterError(
        code: "arguments",
        message: "Missing or Invalid Arguments",
        details: nil
      ))
      return
    }

    switch call.method {
      case "init":
        do {
          let sdkKey: String = try arguments.argument(for: "sdk_key")
          let periodicDownloadInterval: Int = try arguments.argument(for: "periodic_download_interval")
          let client: OptimizelyClient = OptimizelyClient(sdkKey: sdkKey,
                                        periodicDownloadInterval: periodicDownloadInterval)

          client.start { initResult in
            switch initResult {
              case .failure(let error):
                result(error)
              case .success:
                self.optimizely = client
                result(nil)
            }
          }
        } catch {
          result(error)
        }
      case "initSync":
        do {
          let sdkKey: String = try arguments.argument(for: "sdk_key")
          let periodicDownloadInterval: Int = try arguments.argument(for: "periodic_download_interval")
          let dataFile: String = try arguments.argument(for: "datafile")
          let client: OptimizelyClient = OptimizelyClient(sdkKey: sdkKey,
                                        periodicDownloadInterval: periodicDownloadInterval)

          try client.start(datafile: dataFile)
          self.optimizely = client
          result(nil)
        } catch {
          result(error)
        }
      case "setUser":
        do {
          let client = try ensureClient()
          let userId: String = try arguments.argument(for: "user_id")
          let attributes: OptimizelyAttributes? = try arguments.optionalArgument(for: "attributes")

          let userContext: OptimizelyUserContext?
          if(attributes != nil && !attributes!.isEmpty) {
            userContext = client.createUserContext(userId: userId, attributes: attributes! as [String: Any])
          } else {
            userContext = client.createUserContext(userId: userId)
          }

          if(userContext?.userId == userId) {
            self.user = userContext
            result(nil)
          } else {
            result("UnknownError")
          }
        } catch {
          result(error)
        }
      case "isFeatureEnabled":
        do {
          let user = try ensureUser()
          let featureKey: String = try arguments.argument(for: "feature_key")
          let decision = user.decide(key: featureKey)
          result(decision.enabled)
        } catch {
          result(error)
        }
      case "getAllEnabledFeatures":
        do {
          let user = try ensureUser()
          let decisions = user.decideAll(options: [.enabledFlagsOnly])
          result(decisions.map { ($0.key, "") })
        } catch {
          result(error)
        }
      case "getAllFeatureVariables":
        do {
          let user = try ensureUser()
          let featureKey: String = try arguments.argument(for: "feature_key")
          let decision = user.decide(key: featureKey)
          result(decision.variables.toMap())
        } catch {
          result(error)
        }
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  func ensureClient() throws -> OptimizelyClient {
    guard let client = self.optimizely else {
      throw FlutterError(
        code: "client",
        message: "Optimizely client not initialized",
        details: nil
      )
    }
    return client
  }

  func ensureUser() throws -> OptimizelyUserContext {
    guard let userContext = self.user else {
      throw FlutterError(
        code: "user",
        message: "Optimizely user not initialized",
        details: nil
      )
    }
    return userContext
  }
}

// MARK: - Arguments
fileprivate extension Dictionary where Key == String, Value == Any {
    func argument<T>(for key: String) throws -> T {
        if self[key] == nil {
            throw FlutterError.missingArgument(for: key)
        }
        if let argument = self[key] as? T {
            return argument
        } else {
            throw FlutterError.invalidType(for: key)
        }
    }
    
    func optionalArgument<T>(for key: String) throws -> T? {
        if self[key] == nil {
            return nil
        }
        if let argument = self[key] as? T {
            return argument
        } else {
            throw FlutterError.invalidType(for: key)
        }
    }
}

// MARK: - Flutter Error
extension FlutterError: Error { }

fileprivate extension FlutterError {
    static func missingArgument(for key: String) -> FlutterError {
        return FlutterError(
            code: "argument",
            message: "Missing argument for key: \(key)",
            details: nil
        )
    }
    
    static func invalidType(for key: String) -> FlutterError {
        return FlutterError(
            code: "argument",
            message: "Invalid type for argument with key: \(key)",
            details: nil
        )
    }
}