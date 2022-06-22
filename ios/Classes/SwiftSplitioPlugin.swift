import Flutter
import UIKit

public class SwiftSplitioPlugin: NSObject, FlutterPlugin {

  private var methodParser: SplitMethodParser?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "splitio", binaryMessenger: registrar.messenger())
    let instance = SwiftSplitioPlugin()
    instance.methodParser = DefaultSplitMethodParser(methodChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      methodParser?.onMethodCall(methodName: call.method, arguments: call.arguments, result: result)
  }
}
