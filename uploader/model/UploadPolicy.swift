//
//  UploadPolicy.swift
//  qupload
//
//  Created by MLeo on 2019/3/8.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

struct UploadPolicy: Codable {
    let scope:String;
    let deadline:Int;
    
    init(bucket:String,fileName:String?) {
        self.scope = fileName == nil ? bucket:bucket+":"+fileName!
        self.deadline = Int(Date.init().timeIntervalSince1970)+3600
    }

}
