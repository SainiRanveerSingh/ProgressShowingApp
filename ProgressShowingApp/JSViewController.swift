//
//  JSViewController.swift
//  ProgressShowingApp
//
//  Created by mac on 02/05/21.
//  Copyright © 2021 RV. All rights reserved.
//

import UIKit
import WebKit

class JSViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate {
    var theWebView: WKWebView?
    var webView : WKWebView = WKWebView()
    var javascript: Javascript?
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "test-task", ofType: "js")!
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)

        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        /*
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self,
                                   name: "interOp")
        */

        theWebView = WKWebView(frame: self.view.frame,
                             configuration: config)
        theWebView!.load(request)
        self.view.addSubview(theWebView!)
        self.theWebView?.uiDelegate = self
        /*
        theWebView!.evaluateJavaScript("startOperation('1')") { (data, error) in
            print(data as Any)
            print(error as Any)
        }
        */
        sendToJavascript(id: "1")
        let idValue = "1"
        let script = "startOperation(\(idValue))" //.innerText = \"\(idValue)\""

        theWebView!.evaluateJavaScript(script) { (result, error) in
            if let result = result {
                print("Label is updated with message: \(result)")
            } else if let error = error {
                print("An error occurred: \(error)")
            }
        }
        
        self.javascript = Javascript(webView: theWebView!)
        callJavaFunction(id:"1")
        setupWebview()
    }
    
    //----
    func setupWebview() {
        let strUrl =  Bundle.main.path(forResource: "test-task", ofType: "js")!
        if let url = URL(fileURLWithPath: strUrl) as? URL {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            callJSFunctionFromSwift()
            
            setupWebView()
            sendToJavaScript()
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
        contentController.add(self, name: "jsMethod")
        // You can add more methods here, e.g.
        // contentController.add(self, name: "onComplete")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message from JS")

        if message.name == "jsMethod" {
            print("Message from webView: \(message.body)")
        }

    }

    func sendToJavaScript() {
        print("Sending data back to JS")
        self.webView.evaluateJavaScript("startOperation(\("1"))", completionHandler: nil)
    }

    @objc func testMethod() {
        print("test method called")
    }
    //----
    
    func sendToJavascript(id: String) {
      theWebView!.evaluateJavaScript("startOperation(\(id))") { (data, error) in
          print(data as Any)
          print(error as Any)
      }
    }
    

    func callJavaFunction(id: String) {
        self.javascript!.exec("startOperation(\(id))", completion: { (result: JavascriptResult) in
          if let errorMessage = result.errorMessage {
            self.showMessage(errorMessage, title: "Javascript Error")
          }
          else if let retVal = result.returnValue {
            print("Javascript Returned Value: '\(retVal)'")
          }

          print("result: \(result)")
        })
    }

    func showMessage(_ message: String, title: String?) {
      let actualTitle = title ?? ""
      let alert = UIAlertController(title: actualTitle, message: message, preferredStyle: .alert)
      let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okButton)

      self.present(alert, animated: true, completion: nil)
    }
}
