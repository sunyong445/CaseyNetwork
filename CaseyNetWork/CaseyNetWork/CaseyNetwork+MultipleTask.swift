//
//  CaseyNetwork+MultipleTask.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Foundation
import Alamofire

extension CaseyNetwork {

    
    static fileprivate let __caseyQueue: DispatchQueue = {
        
        let queue = DispatchQueue.init(label: "CaseyNetworkQueue", attributes: .concurrent)
        
        return queue
        
    }()
    
    
    /* 任务无顺序 并发执行*/
    func requestMultiTask(tasks:Array<CaseyNetReqestInfo>, completion:@escaping () -> Void) {
        
        
        
        CaseyNetwork.__caseyQueue.async {
        
            let group =  DispatchGroup.init()
            for requestInfo in tasks {
                
                group.enter()
                
                
                let newCompletion:((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void) = {  (dataResponse, error, isCache) in
                    
                    
                    requestInfo.completionHandler?(dataResponse, error, isCache)
                    group.leave()
                    
                }
                
                
                CaseyNetwork().request(requestInfo.url,
                                       method: requestInfo.method,
                                       parameters: requestInfo.parameters,
                                       encoding: requestInfo.encoding,
                                       headers: requestInfo.headers,
                                       responsePaser: requestInfo.responsePaser,
                                       readCache: requestInfo.readCache,
                                       cacheDuration: requestInfo.cacheDuration,
                                       completionHandler: newCompletion)
              
                
                
            }
            
            
            
            
            group.notify(queue: DispatchQueue.main, execute: {
                completion()
            })
        }
 
    }
    
    
    /* 任务按照数组里的顺序先后 同步执行 */
    
    func requestMultiTaskSyn(tasks:Array<CaseyNetReqestInfo>, completion:@escaping (()->(Void))) {
        
        
        
        CaseyNetwork.__caseyQueue.async {
            
            
            let semaphore = DispatchSemaphore.init(value: 0)
            for requestInfo in tasks {
                
                
                
                
                let newCompletion:((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void) = {  (dataResponse, error, isCache) in
                    
                    
                    requestInfo.completionHandler?(dataResponse, error, isCache)
                    semaphore.signal()
                    
                }
                
                
                CaseyNetwork().request(requestInfo.url,
                                       method: requestInfo.method,
                                       parameters: requestInfo.parameters,
                                       encoding: requestInfo.encoding,
                                       headers: requestInfo.headers,
                                       responsePaser: requestInfo.responsePaser,
                                       readCache: requestInfo.readCache,
                                       cacheDuration: requestInfo.cacheDuration,
                                       completionHandler: newCompletion)
              
                
                semaphore.wait()
            }
            

            completion()
        }
        
    }
  
  static func requestInfo (_ url: URLConvertible,
                method: HTTPMethod = .get,
                parameters: Parameters? = nil,
                encoding: ParameterEncoding = JSONEncoding.default,
                headers: HTTPHeaders? = nil,
                responsePaser: ResonseParseFormat = ResonseParseFormat.JSON,
                readCache:Bool = false,
                cacheDuration:Float = 0,
                completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) ->CaseyNetReqestInfo {
    
    
    
    var caseyRequestInfo = CaseyNetReqestInfo.init()
    caseyRequestInfo.url = url
    caseyRequestInfo.method = method
    caseyRequestInfo.parameters = parameters
    caseyRequestInfo.encoding = encoding
    caseyRequestInfo.headers = headers
    caseyRequestInfo.responsePaser = responsePaser
    caseyRequestInfo.readCache = readCache
    caseyRequestInfo.cacheDuration = cacheDuration
    caseyRequestInfo.completionHandler = completionHandler
    
    return caseyRequestInfo

    
  }
  
  static func requestInfoJsonPOST (_ url: URLConvertible,
                    parameters: Parameters?,
                    completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) ->CaseyNetReqestInfo {
    
    
    
    var caseyRequestInfo = CaseyNetReqestInfo.init()
    caseyRequestInfo.url = url
    caseyRequestInfo.method = .post
    caseyRequestInfo.parameters = parameters
    caseyRequestInfo.encoding = JSONEncoding.default
    caseyRequestInfo.headers = nil
    caseyRequestInfo.responsePaser = .JSON
    caseyRequestInfo.readCache = false
    caseyRequestInfo.cacheDuration = 0
    caseyRequestInfo.completionHandler = completionHandler
    
    return caseyRequestInfo
    
    
    
  }
  
  
}
