//
//  CaseyNetWork+Coable.swift
//  CaseyNetWork
//
//  Created by Casey on 26/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Foundation
import Alamofire


extension CaseyNetwork {
    
    
    
    func request<T:Codable> (_ url: URLConvertible,
                  method: HTTPMethod = .get,
                  parameters: Parameters? = nil,
                  encoding: ParameterEncoding = JSONEncoding.default,
                  headers: HTTPHeaders? = nil,
                  responsePaser: ResonseParseFormat = ResonseParseFormat.JSON,
                  readCache:Bool = false,
                  cacheDuration:Float = 0,
                  completionHandler:@escaping ((T?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        var newParameter = parameters
        if let _ =  CaseyNetwork.requestBodyParamCommon{
            newParameter = CaseyNetwork.requestBodyParamCommon?(parameters)
        }
        var newHeads = headers
        if let _ =  CaseyNetwork.requestHeaderParamCommon{
            newHeads =  CaseyNetwork.requestHeaderParamCommon?(headers, newParameter)
        }
        
        
        if readCache && cacheDuration > 0 {
            
            if let cacheData = self._localCache.getCache(url, method: method, parameters: newParameter, encoding: encoding, headers: newHeads) {
                
                
                print("have cacheData: \(cacheData)")
                
                do {
                    
                    let jsonData = try JSONSerialization.jsonObject(with: cacheData, options: .allowFragments) as? Dictionary<String, Any>
                    
                    let model = jsonData?.convertModel(T.self)
                    completionHandler(model, nil, true)
                    
                    
                }catch {
                    
                    // 异常暂未处理
                    let error = CaseyNetError("404", "暂未配置错误类型")
                    completionHandler(nil, error, false)
                }
                
                return
            }
            
        }
        
        
        let newCompletionHandler:((DataResponse<Any>) -> Void) =  { response in
            
            
            if cacheDuration > 0 {
                
                if let data = response.data {
                    self._localCache.saveCache(url, method: method, parameters: newParameter, encoding: encoding, headers: newHeads, data: data)
                }
            }
            
            
            var resultDict: Dictionary<String, AnyObject>?
            var error:CaseyNetError?
            switch response.result {
                
                
            case .success:
                
                if let JSON = response.result.value, let jsonDic = JSON as? Dictionary<String, AnyObject>  {
                    
                    resultDict = jsonDic
                    
                }
                
            default:
                
                error = CaseyNetError("404", "网络数据异常")
                
                
            }
            
            
            if let (result, excError) =  CaseyNetwork.exceptionHandleOfData?(resultDict)  {
                
                if((excError) != nil){
                    completionHandler(nil, excError, false)
                }else{
                    
                    
                    let model = result?.convertModel(T.self)
                    completionHandler(model, excError, false)
                }
                
            }else{
                
                let model = resultDict?.convertModel(T.self)
                completionHandler(model, error, false)
            }
            
            
            
            
            
        }
        
        if responsePaser == .JSON {
            
            
            Alamofire.request(url, method: method, parameters: newParameter, encoding: encoding, headers: newHeads).responseJSON { (response) in
                
                
                newCompletionHandler(response)
            }
            
            
        }else {
            
            print("该响应数据格式暂未处理, 目前被定义为异常格式")
            
        }
        
        
    }
    
    
    
    
    func requestJsonPost<T:Codable> (_ url: URLConvertible,
                          parameters: Parameters?,
                          headers: HTTPHeaders? = nil,
                          completionHandler:@escaping ((T?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestJsonGet<T:Codable> (_ url: URLConvertible,
                         parameters: Parameters?,
                         headers: HTTPHeaders? = nil,
                         completionHandler:@escaping ((T?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestURLEncodingsPost<T:Codable> (_ url: URLConvertible,
                                             parameters: Parameters?,
                                             headers: HTTPHeaders? = nil,
                                             completionHandler:@escaping ((T?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestURLEncodingGet<T:Codable> (_ url: URLConvertible,
                                parameters: Parameters?,
                                headers: HTTPHeaders? = nil,
                                completionHandler:@escaping ((T?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
}
