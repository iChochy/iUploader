//
//  BaseInfo.swift
//  iUploader
//
//  Created by MLeo on 2019/3/8.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

struct QNConfig: Codable {
    
    let accessKey:String
    let secretKey:String
    let bucket:String
    let domain:URL
    let rate:Double
    let compress:Int
    
    init(accessKey:String,secretKey:String,bucket:String,domain:String,rate:Double,compress:Int) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.bucket = bucket
        self.domain = URL.init(string: domain) ?? URL.init(string: "https://www.ichochy.com")!
        self.rate = rate
        self.compress = compress
    }
    
    

}
