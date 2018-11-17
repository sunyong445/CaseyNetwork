//
//  CaseyNetError.swift
//  CaseyNetWork
//
//  Created by Casey on 17/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

import UIKit


public struct CaseyNetError {
    
    var errorCode:String
    var errorDesc:String
    
    init(_ code:String, _ desc:String) {
        errorCode = code
        errorDesc = desc
    }
}
