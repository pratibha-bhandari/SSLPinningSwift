//
//  ViewController.swift
//  SSLPinningSample
//
//  Created by Ada on 15/12/20.
//  Copyright © 2020 Pratibha. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var networkManager = NetworkManager.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testAPI()
    }
    
    func testAPI() {
        let host = "www.google.co.uk"
        networkManager.pinningWithPublicKey(host: host)
        //networkManager.pinningWithCertificate(host: host)
        let urlString = "https://\(host)"
        networkManager.sessionManager?.request(urlString).response(completionHandler: { (response) in
            print("Status code: \(String(describing: response.response?.statusCode))")
            if response.error == nil {
                print("Connection successful")
            } else {
                print("Error")
            }
        })
    }

}

