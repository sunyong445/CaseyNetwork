//
//  CaseyNetReqestInfo.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Alamofire

struct CaseyNetReqestInfo {

    
    var url: URLConvertible
    var method: HTTPMethod
    
    var parameters: Parameters?
    var encoding: ParameterEncoding
    var headers: HTTPHeaders?
    var responsePaser:CaseyNetwork.ResonseParseFormat
    var readCache:Bool
    var cacheDuration:Float
    var completionHandler: ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)
    
    
    init(_ url: URLConvertible,
         method: HTTPMethod,
         parameters: Parameters?,
         encoding: ParameterEncoding = JSONEncoding.default,
         headers: HTTPHeaders? = nil,
         responsePaser: CaseyNetwork.ResonseParseFormat = .JSON,
         readCache:Bool = false,
         cacheDuration:Float = 0,
         completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.responsePaser = responsePaser
        self.readCache = readCache
        self.cacheDuration = cacheDuration
        self.completionHandler = completionHandler
        
    }
    
    init(_ url: URLConvertible,
         method: HTTPMethod,
         parameters: Parameters?,
         headers: HTTPHeaders? = nil,
         completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)){
        
        
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = JSONEncoding.default
        self.headers = headers
        self.responsePaser = .JSON
        self.readCache = false
        self.cacheDuration = 0
        self.completionHandler = completionHandler
        
    }
}
