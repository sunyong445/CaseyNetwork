//
//  CaseyNetReqestInfo.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Alamofire

struct CaseyNetReqestInfo {

    
    var url: URLConvertible = ""
    var method: HTTPMethod = HTTPMethod.post
    
    var parameters: Parameters?
    var encoding: ParameterEncoding = JSONEncoding.default
    var headers: HTTPHeaders?
    var responsePaser:CaseyNetwork.ResonseParseFormat = .JSON
    var readCache:Bool = false
    var cacheDuration:Float = 0
    var completionHandler: ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)?
    
  
  
    init() {
      
    }
  
}
