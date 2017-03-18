//
//  AboutNewViewController.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class AboutNewViewController: UIViewController {
//var delegate: AboutNewDelegate?
    @IBOutlet weak var webViewer: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let localfilePath = Bundle.main.url(forResource: "About", withExtension: "html");
        let myRequest = NSURLRequest(url: localfilePath!);
        webViewer.loadRequest(myRequest as URLRequest);
        self.view.addSubview(webViewer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
