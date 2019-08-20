//
//  BaseInfo.swift
//  qupload
//
//  Created by MLeo on 2019/3/8.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class QNConfig: Codable {
    
    let accessKey:String
    let secretKey:String
    let bucket:String
    let domain:URL
    let rate:Double
    let compress:Int
    let conversion:Int
    
    init(accessKey:String,secretKey:String,bucket:String,domain:String,rate:Double,compress:Int,conversion:Int) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.bucket = bucket
        self.domain = URL.init(string: domain)!
        self.rate = rate
        self.compress = compress
        self.conversion = conversion
    }
    
    

}
