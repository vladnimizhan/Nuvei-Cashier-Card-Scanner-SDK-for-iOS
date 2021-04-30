//
//  WebViewController.swift
//  NuveiCashierCardScannerSDK
//
//  Created by Michael Kessler on 23/06/2020.
//  Copyright © 2020 Nuvei. All rights reserved.
//

import UIKit
import WebKit
import NuveiCashierScanner
import CodeScanner

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    var initialURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        NuveiCashierScanner.connect(to: webView)
        
        webView.load(URLRequest(url: initialURL))
        
        print("NuveiCashierCardScanner Version: ", NuveiCashierScanner.versionNumber())
    }
}
