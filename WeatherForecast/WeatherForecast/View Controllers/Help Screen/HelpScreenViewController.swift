//
//  HelpScreenViewController.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 02/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit
import WebKit

class HelpScreenViewController: UIViewController {

    let webView = WKWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "help", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        
    }

}

