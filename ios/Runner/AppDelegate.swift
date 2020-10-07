import UIKit
import Flutter
import Foundation
import SwiftyTesseract


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
        case "detectTextInImage":
            guard let args = call.arguments else {
                return
            }
            if let detectTextArgs = args as? Dictionary<String, Any>,
                let imagePath = detectTextArgs["imagePath"] as? String {
                // self.searchDictionary(result: result,controller: controller, queryWord: "test")
                self.detectTextInImage(result: result,controller: controller, imagePath: imagePath)
            } else {
                result(FlutterError(code: "-1", message: "Invalid Argument", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func searchDictionary(result: FlutterResult, controller: FlutterViewController, queryWord: String){
        let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: queryWord)
        controller.present(ref, animated: true, completion: nil)
    }

    func isWordInDictionary(result: FlutterResult, controller: FlutterViewController, queryWord: String){
        let isInDictionary = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: queryWord)
        result(Bool(isInDictionary))
    }

    func detectTextInImage(result: FlutterResult, controller: FlutterViewController, imagePath: String){
        let imageURL = URL(fileURLWithPath: imagePath)
        let image = UIImage(contentsOfFile: imageURL.path)
        if let unwrapped = image {
            let tesseract = SwiftyTesseract(language: .japanese)
            let res = tesseract.performOCR(on: unwrapped)
            do {
                let detectedText = try res.get()
                print(detectedText)
                result(detectedText)
            } catch {
                result("")
            }
        }
    }
}
