import UIKit
import Flutter
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let dictionaryChannel = FlutterMethodChannel(name: "dictionary_search",
                                              binaryMessenger: controller.binaryMessenger)
    dictionaryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "searchDictionary":
            guard let args = call.arguments else {
                return
            }
            if let searchDictArgs = args as? Dictionary<String, Any>,
                let queryWord = searchDictArgs["queryWord"] as? String {
                self.searchDictionary(result: result,controller: controller, queryWord: queryWord)
            } else {
                result(FlutterError(code: "-1", message: "Invalid Argument", details: nil))
            }
            result(FlutterError(code: "-1", message: "Invalid Argument", details: nil))
        case "isWordInDictionary":
            guard let args = call.arguments else {
                return
            }
            if let searchDictArgs = args as? Dictionary<String, Any>,
                let queryWord = searchDictArgs["queryWord"] as? String {
                self.isWordInDictionary(result: result,controller: controller, queryWord: queryWord)
            } else {
                result(FlutterError(code: "-1", message: "Invalid Argument", details: nil))
            }
            result(FlutterError(code: "-1", message: "Invalid Argument", details: nil))
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func searchDictionary(result: FlutterResult, controller: FlutterViewController, queryWord: String){
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: queryWord) {
            let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: queryWord)
            controller.present(ref, animated: true, completion: nil)
        }
    }
    
    func isWordInDictionary(result: FlutterResult, controller: FlutterViewController, queryWord: String){
        let isInDictionary = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: queryWord)
        result(Bool(isInDictionary))
    }
}
