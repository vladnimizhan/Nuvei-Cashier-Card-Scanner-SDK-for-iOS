//
//  WebViewController.swift
//  NuveiCashierCardScannerSDK
//
//  Created by Michael Kessler on 23/06/2020.
//  Copyright © 2020 Nuvei. All rights reserved.
//

import UIKit
import WebKit
import NuveiCashierCardScanner

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var initialURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NuveiCashierCardScanner.connect(to: webView)
        
        webView.load(URLRequest(url: initialURL))
        
        print("NuveiCashierCardScanner Version: ", NuveiCashierCardScanner.versionNumber())
    }
}
