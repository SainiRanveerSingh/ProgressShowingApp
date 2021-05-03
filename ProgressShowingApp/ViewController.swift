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

class ViewController: UIViewController {

    let viewModel = ViewControllerViewModel()
    var webView : WKWebView = WKWebView()
    var jsContext: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.loadJSFile()
        initializeJS()
        Operation()
    }
    
    @IBAction func buttonActionJSView(_ sender: UIButton) {
        let objTarget = self.storyboard?.instantiateViewController(identifier: "JSViewController") as! JSViewController
        self.navigationController?.pushViewController(objTarget, animated: true)
    }

    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "test-task", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                self.jsContext.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
    }
    
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS Console:", logMessage)
    }
    
    func Operation() {
        if let startOperation = self.jsContext.objectForKeyedSubscript("startOperation(\(1));") {
            print(startOperation.toString() ?? "empty")
        }
    }
}
