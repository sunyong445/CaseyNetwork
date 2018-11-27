//
//  Dictionary+ConvertModel.swift
//  A06HybridRNApp
//
//  Created by Casey on 19/11/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//


import Foundation

public extension Dictionary {
  
  func convertModel<T:Codable>(_ type:T.Type) -> T? {
    
    do {
      
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0))
      
      let model =  try JSONDecoder().decode(T.self, from: jsonData)
      
      return  model
      
    }catch {
      
      print("字典转模型失败:\(error)")
        return nil
    }
  }
  
}


public extension Array {
  
  func convertModel<T:Codable>(_ type:T.Type) -> [T]? {
    
    var temp: [T] = []
    
    for element in self {
      
      if let data = element as? [String:Any] {
        
        if let model =  data.convertModel(T.self){
          
          temp.append(model)
        }
        
      }
      
    }
    return temp
  }
}
