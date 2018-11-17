//
//  ViewController.swift
//  CaseyNetWork
//
//  Created by Casey on 16/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        
        
    }
    
    
    
    
    func testNetWork()  {
        
        
        var dictInfo = ["loginName":"ckunlun69"]
        
        dictInfo["password"] = "RHUml/pw/tFL9UidorTipieP2JCRS0f58GBJ4Hrmt1RmleE2FTeC5VyVC4aQMIjBC7I00A4zs0kEOIRtqgEDxen0oTRmMlV+cV3rT5A1EArHbG7yaMKBkgltqK8gvDU1mUqjl9zCbF0h9fA1lDecskhiLS86sQoPt5QniAu6nP0="
        
        dictInfo["domainName"] = "www.pt-gateway.com"
        dictInfo["v"] = "2.0.0"
        dictInfo["parentId"] = ""
        dictInfo["productId"] = "A06"
        


        
       // request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
        
       // request("", method: .post, parameters: dictInfo, encoding: ParameterEncoding(), headers: nil)
        
    }
}

