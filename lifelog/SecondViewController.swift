//
//  SecondViewController.swift
//  save-health-data
//
//  Created by Shigeru Hagiwara on 2020/09/04.
//  Copyright © 2020 Shigeru Hagiwara. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {

    @IBOutlet weak var helpWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpWebView.uiDelegate = self
        helpWebView.navigationDelegate = self

        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "helpPages")!
        helpWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        helpWebView.load(request)
    }
}
