//
//  ViewController.swift
//  ProgressShowingApp
//
//  Created by mac on 29/04/21.
//  Copyright © 2021 RV. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class ViewController: UIViewController, WKScriptMessageHandler {

    let viewModel = ViewControllerViewModel()
    var webView : WKWebView = WKWebView()
    let context = JSContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.loadJSFile()
        self.webView.uiDelegate = self
        
        let strUrl =  Bundle.main.path(forResource: "test-task", ofType: "js")!
        if let url = URL(fileURLWithPath: strUrl) as? URL {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            callJSFunctionFromSwift()
        }
    }

    func callJSFunctionFromSwift(){
        //webView.evaluateJavaScript("startOperation('id')", completionHandler: nil)
        webView.evaluateJavaScript("startOperation('1')") { (data, error) in
            print(data as Any)
            print(error as Any)
        }
    }
    
    
    // Call this function from `viewDidLoad()`
    private func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "testMethod")
        // You can add more methods here, e.g.
        // contentController.add(self, name: "onComplete")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message from JS")

        if message.name == "testMethod" {
            print("Message from webView: \(message.body)")
            sendToJavaScript(params: [
                "foo": "bar"
            ])
        }

        // You can add more handlers here, e.g.
        // if message.name == "onComplete" {
        //     print("Message from webView from onComplete: \(message.body)")
        // }
    }

    func sendToJavaScript(params: JSONDictionary) {
        print("Sending data back to JS")
        let paramsAsString = asString(jsonDictionary: params)
        self.webView.evaluateJavaScript("getDataFromNative(\(paramsAsString))", completionHandler: nil)
    }

    func asString(jsonDictionary: JSONDictionary) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }

    @objc func testMethod() {
        print("test method called")
    }
}

extension ViewController : WKUIDelegate {
    
}
