//
//  CaseyNetCache.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Alamofire
import CommonCrypto

class CaseyNetCache: NSObject {

    static private let __netCache:CaseyNetCache = {
        
        let netCache = CaseyNetCache()
        
        netCache.createCacheDocument()
        return netCache
        
    }()
    
    
    
    static func shareInstance() -> CaseyNetCache {
        
        return __netCache
    }
    
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cleanCacheOfMemory), name: UIApplication.didReceiveMemoryWarningNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cleanCacheOfDisk), name: UIApplication.didEnterBackgroundNotification , object: nil)
    }
    
    
   
    
    private let _localCache:NSCache<AnyObject, AnyObject> =  NSCache<AnyObject, AnyObject>()
    private let _ioQueue = DispatchQueue.init(label: "__CaseyNetCacheQueue", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
    
    
    
    func getCache(_ url: URLConvertible,
                method: HTTPMethod,
                parameters: Parameters?,
                encoding: ParameterEncoding,
                headers: HTTPHeaders?,
                cacheDuration:Float) -> Data? {
        
        // 缓存策略暂未处理
        
        
        if cacheDuration <= 0 {
            return nil
        }
        
        
        let paramStr = String.init(format: "%@-%@-%@-%@", url as! CVarArg, method as! CVarArg, parameters ?? "", headers ?? "")
        let cacheKey = paramStr.md5NetKey()
        
        
        if let cacheData = _localCache.object(forKey: cacheKey as AnyObject) as? Data {
            
            return cacheData
        }
        
        
        let document = cacheDoument() as NSString
        let filePath = document.appendingPathComponent(cacheKey)
        
        
        if !checkShouldSkipCache(ofDuration: cacheDuration, filePath: filePath) {
            
            return NSData.init(contentsOfFile: filePath) as Data?
            
        }
        
        
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
    
    
    fileprivate func createCacheDocument(){
        
        
        _ioQueue.async {
            
            let newBoolPtr = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
            if  FileManager.default.fileExists(atPath: self.cacheDoument(), isDirectory: newBoolPtr) {
                
                if newBoolPtr.pointee.boolValue {
                    
                    return
                    
                }else {
                    
                    do{
                        try FileManager.default.removeItem(atPath: self.cacheDoument())
                    }catch{
                        print("Remove CacheDocument error: \(error)")
                    }
                    
                }
            }
            
            
            
            do{
                try FileManager.default.createDirectory(atPath: self.cacheDoument(), withIntermediateDirectories: true, attributes: nil)
                let url = NSURL.init(fileURLWithPath: self.cacheDoument())
                try url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                
            }catch {
                
                print("CacheDocument error: \(error)")
            }
            
        }
        
       
    }
    
    
    
    func cacheDoument() -> String {
        
        let rootDocument = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! as NSString
        let cacheDoument = rootDocument.appendingPathComponent("CaseyNetCacheDocument")
        return cacheDoument
    }
    
    
    @objc fileprivate func cleanCacheOfMemory() {
        
        _localCache.removeAllObjects()
    }
    
    
    @objc fileprivate  func cleanCacheOfDisk() {
        
        cleanDiskCacheCatetory()
    }
    
    
}


fileprivate extension String {
    
    
    func md5NetKey() -> String {
        
        
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deallocate()
        
        return String(format: hash as String)
    }
    
    
    
}

