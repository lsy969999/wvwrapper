//
//  WVView+JsonDictParse.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import Foundation
import WebKit
/**
 wv interface parsing parameter
 **/
extension WV {
    func jsonDictParsing(
        webView: WKWebView,
        delegate: WVDelegate,
        name: WVI,
        dict: [String: Any]
    ) {
        switch name {
        case WVI.greeting:
            guard let callbackStr = dict["callbackStr"] as? String,
                  let param1 = dict["param1"] as? String
            else {
                print("greeting dict parsing mismatch")
                return
            }
            let greeting = self.delegate.greeting(param1: param1)
            webView.evaluateJavaScript("\(callbackStr)('\(greeting)')")
        default:
            print("WVI Not match")
        }
    }
}
