//
//  CaseyNetwork+MultipleTask.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Foundation

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
                    
                    
                    requestInfo.completionHandler(dataResponse, error, isCache)
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
                    
                    
                    requestInfo.completionHandler(dataResponse, error, isCache)
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
    
}
