//
//  ViewControllerViewModel.swift
//  ProgressShowingApp
//
//  Created by mac on 29/04/21.
//  Copyright © 2021 RV. All rights reserved.
//

import Foundation
import JavaScriptCore

typealias JSONDictionary = [String:Any]
final class ViewControllerViewModel {
    
    let context = JSContext()
    var jsHandler = JSFunctionCaller()
    
    func loadFile() {
        // 1
        guard let
          commonJSPath = Bundle.main.path(forResource: "test-task", ofType: "js") else {
            print("Unable to read resource files.")
            return
        }
        
        // 2
        do {
          let common = try String(contentsOfFile: commonJSPath, encoding: String.Encoding.utf8)
          _ = context?.evaluateScript(common)
        } catch (let error) {
          print("Error while processing script file: \(error)")
        }
        
        
    }
    
    func loadJSFile() {
        // load javascript file in String
        // needed update from http://k33g.github.io/2014/06/10/SWIFT-01.html

        let fileLocation = Bundle.main.path(forResource: "test-task", ofType: "js")!

        print(fileLocation)
        let jsSource : String
          do {
            jsSource = try String(contentsOfFile: fileLocation)
          } catch {
            jsSource = "Nope."
          }

        //print(jsSource)
        
        guard let path = Bundle.main.path(forResource: "test-task", ofType: "js"),
          let script = try? String(contentsOfFile: path, encoding: .utf8) else {
            fatalError("cannot load script")
        }

        let jsResult = context?.evaluateScript(script)
        print(jsResult)
        
        if let javascriptUrl = Bundle.main.url(forResource: "test-task", withExtension: "js") {
            jsHandler.loadSourceFile(atUrl: javascriptUrl)
        }
        //jsHandler.setObject(object: "1", withName: "startOperation")
        let result = jsHandler.evaluateJavaScript("startOperation('11')")
        if let product = result?.toObject() as? [String:Any] {
            print("created product with name \(product)")
        }
    }
}
