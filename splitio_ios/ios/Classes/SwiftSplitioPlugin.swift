import Flutter
import UIKit

public class SwiftSplitioPlugin: NSObject, FlutterPlugin {

    private var methodParser: SplitMethodParser?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "split.io/splitio_ios", binaryMessenger: registrar.messenger())
        let instance = SwiftSplitioPlugin()
        let externalProvider: SplitFactoryProvider? = UIApplication.shared.delegate as? SplitFactoryProvider
        instance.methodParser = DefaultSplitMethodParser(methodChannel: channel, splitFactoryProvider: externalProvider)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        methodParser?.onMethodCall(methodName: call.method, arguments: call.arguments, result: result)
    }
}
