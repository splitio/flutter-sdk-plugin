import Flutter
import UIKit

public class SwiftSplitioPlugin: NSObject, FlutterPlugin {
    
  private var methodParser: SplitMethodParser = DefaultSplitMethodParser()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "splitio", binaryMessenger: registrar.messenger())
    let instance = SwiftSplitioPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      methodParser.onMethodCall(methodName: call.method, arguments: call.arguments, result: result)
  }
}
