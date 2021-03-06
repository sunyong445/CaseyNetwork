//
//  CaseyNetwork.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//


import Alamofire


typealias NetFinish = (_ result:Any?, _ errorDesc:String?)->(Void)


class CaseyNetwork: NSObject {
    
    
    enum ResonseParseFormat: Int {
        case JSON = 0
        case XML = 1
        
    }
    
    let _localCache = CaseyNetCache.shareInstance()
    
    /* 提供给外部处理框架内的网络数据，有外部实现
     返回 true 数据有异常，
     返回 false 数据没问题*/
    static public var exceptionHandleOfData:(([String:Any]?) -> ([String:Any]? , CaseyNetError?)?)?
    
    /*
     公共请求参数体 配置
     */
    static public var requestBodyParamCommon:((Parameters?)->Parameters?)?
    
    /*
     公共请求头参数 配置
     */
    static public var requestHeaderParamCommon:((_ heads:HTTPHeaders?, _ bodyParam:Parameters?)->HTTPHeaders?)?
    
    /*
     url 请求地址
     method 请求方式
     parameters 参数体
     encoding 参数编码格式
     headers 请求头参数
     responsePaser 响应参数解析方式
     readCache 是否读缓存
     cacheDuration 缓存实效， 0即不存
     completionHandler 响应回掉
     */
    
    func request (_ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        responsePaser: ResonseParseFormat = ResonseParseFormat.JSON,
        readCache:Bool = false,
        cacheDuration:Float = 0,
        completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        var newParameter = parameters
        if let _ =  CaseyNetwork.requestBodyParamCommon{
            newParameter = CaseyNetwork.requestBodyParamCommon?(parameters)
        }
        var newHeads = headers
        if let _ =  CaseyNetwork.requestHeaderParamCommon{
            newHeads =  CaseyNetwork.requestHeaderParamCommon?(headers, newParameter)
        }
      
      
        if readCache && cacheDuration > 0 {
            
            if let cacheData = _localCache.getCache(url, method: method, parameters: newParameter, encoding: encoding, headers: newHeads, cacheDuration: cacheDuration) {
                
                
                print("have cacheData: \(cacheData)")
                
                do {
                    
                    let jsonData = try JSONSerialization.jsonObject(with: cacheData, options: .allowFragments) as? Dictionary<String, Any>
                    completionHandler(jsonData, nil, true)
                
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
                completionHandler(result, excError, false)
              }
              
            }else{
                
                completionHandler(resultDict, error, false)
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
    
    
    
    func requestJsonPost (_ url: URLConvertible,
                  parameters: Parameters?,
                  headers: HTTPHeaders? = nil,
                  completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestJsonGet (_ url: URLConvertible,
                          parameters: Parameters?,
                          headers: HTTPHeaders? = nil,
                          completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestURLEncodingsPost (_ url: URLConvertible,
                          parameters: Parameters?,
                          headers: HTTPHeaders? = nil,
                          completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
    
    func requestURLEncodingGet (_ url: URLConvertible,
                         parameters: Parameters?,
                         headers: HTTPHeaders? = nil,
                         completionHandler:@escaping ((Dictionary<String, Any>?, CaseyNetError?, _ isCache:Bool) -> Void)) {
        
        
        request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers, responsePaser: ResonseParseFormat.JSON, readCache: false, cacheDuration: 0, completionHandler:completionHandler)
        
        
    }
}





