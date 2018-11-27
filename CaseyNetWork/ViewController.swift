//
//  ViewController.swift
//  CaseyNetWork
//
//  Created by Casey on 16/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit
import Alamofire

let URLPath = "http://svr.tuliu.com/center/front/app/util/updateVersions"
/*versions_id = 1   system_type = 1*/


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testNetWork()
     //   testNetWorkTwo()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        
        
        
    }
    
    
    
    
    
    
    func testNetWork()  {
        
        
        let param = ["versions_id":"1", "system_type":"1"]
        CaseyNetwork().requestURLEncodingsPost(URLPath, parameters: param, headers: nil) { (result:VersionModel?, error, cache) in
            
            if error != nil {
                 print(error)
                
            }else {
                print(result)
            }
        }
        
    }
    
    func testNetWorkTwo()  {
        
        
        let param = ["versions_id":"1", "system_type":"1"]
        CaseyNetwork().requestURLEncodingsPost(URLPath, parameters: param, headers: nil) { (result, error, cache) in
            
            if error != nil {
                
            
                print(error)
                
                
            }else {
                print(result)
            }
        }
        
    }
    
    
    func convertModel()  {
        
        
        var dictInfo:[String:Any] = ["loginName":"ckunlun69"]
        dictInfo["productId"] = "A06"
        dictInfo["person"] = ["name":"casey", "age":"22"]
        dictInfo["testArr"] = ["name","casey", "age"]
        
        

        
        do {
            
//            let jsonData = try JSONSerialization.data(withJSONObject: dictInfo, options: .init(rawValue: 0))
//
//            let testModel =  try JSONDecoder().decode(TestModel.self, from: jsonData)
            
            
            
            let testModel = dictInfo.convertModel(TestModel.self)
            
            print(testModel?.loginName ?? "error")
            print(testModel?.productId ?? "error")
            print(testModel?.person?.name ?? "error")
            print(testModel?.person?.age ?? "error")
            print(testModel?.testArr ?? "error")
            
            
            let dd =  ViewController.self
            let tt = ViewController.classForCoder()
            
        }catch {
            
        }
        
        
        let arr = [["name":"casey", "age":"22"],["name":"casey2", "age":"26"]]
        
        let modelArr = arr.convertModel(Person.self)
        
        for personT in modelArr {
            
            print(personT.name)
            print(personT.age)
        }
    }
    
    
}
