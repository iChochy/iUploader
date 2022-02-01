//
//  UploadFile.swift
//  iUpload
//
//  Created by MLeo on 2019/8/14.
//  Copyright © 2019 iChochy. All rights reserved.
//

import Cocoa

class UploadFile: Codable {
    let key:String
    let fileName:String
    let fileData:Data
    let index:Int
    let count:Int
    var message:String?
    var status:Bool=false
    
    
    init(key:String,fileName:String,fileData:Data,index:Int,count:Int) {
        self.key = key
        self.fileName = fileName
        self.fileData = fileData
        self.index = index
        self.count = count
    }
    
    
    
}
