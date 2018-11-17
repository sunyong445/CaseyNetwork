//
//  CaseyNetCache.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Alamofire

class CaseyNetCache: NSObject {

    static private let __netCache:CaseyNetCache = {
        
        let netCache = CaseyNetCache()
        return netCache
        
    }()
    
    static func shareInstance() -> CaseyNetCache {
        
        return __netCache
    }
    
    
    
    func getCache(_ url: URLConvertible,
                method: HTTPMethod,
                parameters: Parameters?,
                encoding: ParameterEncoding,
                headers: HTTPHeaders?) -> Data? {
        
        // 缓存策略暂未处理
        return nil
    
    }
    
    
    func saveCache(_ url: URLConvertible,
                   method: HTTPMethod,
                   parameters: Parameters?,
                   encoding: ParameterEncoding,
                   headers: HTTPHeaders?,
                   data:Data?)  {
        
        // 保存缓存暂未处理
        
    }
    
}
