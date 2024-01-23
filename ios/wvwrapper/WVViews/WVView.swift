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

class WV: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    var webView: WKWebView!
    var delegate: WVDelegate!
    
    var createWebView: WKWebView?
    
    override func loadView() {
        let contentController = WKUserContentController()
        //js bridge
        WVI.allCases.forEach{
            contentController.add(self, name: $0.rawValue)
        }
        
        let wkPreferences = WKPreferences()
        //window.open 허용
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        webConfiguration.preferences = wkPreferences
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //사파리에서 꾹 누르면 미리보기 시트 뜨는거 취소
        webView.allowsLinkPreview = false
        
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
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completionHandler()
                }))
                present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.text = defaultText
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(nil)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //createWebview해주기전에
        //이미 만든 createWebview가 있다면 기존것은 지워주고 createWebview 해준다.
        //그렇지 않으면 createWebview가 겹쳐서 원래 webview로 돌아가지 못하는 현상이발생할수도 있다.
        //재현: open('some url') -> open('some url2') 하고 close하면 원래 웹뷰로 못돌아감
        if let beforeCreatedWebview = createWebView {
            webViewDidClose(beforeCreatedWebview)
        }
        createWebView = WKWebView(frame: view.bounds, configuration: configuration)
        createWebView?.uiDelegate = self
        createWebView?.navigationDelegate = self
        
        // 현재 뷰 컨트롤러에 추가
        view.addSubview(createWebView!)
        // 새로운 WKWebView 반환
        return createWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        createWebView?.removeFromSuperview()
        createWebView = nil
    }
}
