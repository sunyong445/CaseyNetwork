//
//  CaseyNetCache+Disk.swift
//  CaseyNetWork
//
//  Created by Casey on 28/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import Foundation
import UIKit


extension CaseyNetCache {
    
    
    
    /* 判断缓存是否有效  true:不跳过缓存， false跳过缓存*/
    func checkShouldSkipCache(ofDuration:Float, filePath:String) -> Bool {
        
        
        if !cacheExistInDick(filePath: filePath) {
            
            return true
        }
        
        let fileDuration = cacheFileDuration(filePath: filePath)
        if  fileDuration <  ofDuration{
            
            do {
                try FileManager.default.removeItem(atPath: filePath)
            }catch {
                
            }
            
            return true
        }
        
        return false
    }
    
    
    
   fileprivate func cacheExistInDick(filePath:String) -> Bool {
        
        if  FileManager.default.fileExists(atPath: filePath) {
            
            return true
        }
        return false
        
    }
    
    
    
    fileprivate func cacheFileDuration(filePath:String) -> Float {
        
        do {
            
            let fileProperty =  try FileManager.default.attributesOfItem(atPath: filePath)
            let duration =  fileProperty[FileAttributeKey.modificationDate] as? Float
            return duration ?? 0
            
        }catch{
            
            print("netCache file error \(error)")
        }
        
        return 0
    }
    
    
    /* 清除缓存策略 */
    func  cleanDiskCacheCatetory() {
        
        let application = UIApplication.shared
        let bagTask = application.beginBackgroundTask(withName: "cleanDiskCache") {
            
            //UIApplication.shared.endBackgroundTask(bagTask)
        }
        
        backgroundCleanDiskCacheCatetory(tag: bagTask)
    }
    
    func backgroundCleanDiskCacheCatetory(tag:UIBackgroundTaskIdentifier) {
        
        // 清除缓存
        
        
        UIApplication.shared.endBackgroundTask(tag)
        
        
    }
    
}
