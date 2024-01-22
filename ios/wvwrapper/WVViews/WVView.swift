//
//  WVView.swift
//  wvwrapper
//
//  Created by SY L on 1/23/24.
//

import Foundation
import WebKit
import SwiftUI

struct WVView: UIViewControllerRepresentable {
    @ObservedObject var wvViewModel: WVViewModel
    func makeUIViewController(context: Context) -> some UIViewController {
        let wv = WV()
        wv.delegate = context.coordinator
        return wv
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("--[updateUIViewController]--")
    }
    func makeCoordinator() -> WVCoordinator {
        WVCoordinator(wvViewModel: wvViewModel)
    }
    
    class WVCoordinator:NSObject, WVDelegate {
        let wvViewModel: WVViewModel
        init(wvViewModel: WVViewModel) {
            self.wvViewModel = wvViewModel
        }
        func greeting(param1: String) -> String {
            self.wvViewModel.greeting(param1: param1)
        }
    }
}

class WV: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    var delegate: WVDelegate!
    
    override func loadView() {
        let contentController = WKUserContentController()
        WVI.allCases.forEach{
            contentController.add(self, name: $0.rawValue)
        }
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let name = WVI(rawValue: message.name),
           let jsonStr = message.body as? String,
           let jsonStrData = jsonStr.data(using: .utf8) {
            do {
                if let dict = try JSONSerialization.jsonObject(with: jsonStrData, options: []) as? [String: Any] {
                    self.jsonDictParsing(webView: self.webView, delegate: self.delegate, name: name, dict: dict)
                }
            } catch {
                let err = error.localizedDescription
                print("WKWebview catch err: \(err)")
                self.webView.evaluateJavaScript("webviewBridgeError('\(err)')")
            }
        } else {
            print("wv name not match")
        }
    }
}
