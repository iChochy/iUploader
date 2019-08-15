//
//  ImageInfo.swift
//  iUpload
//
//  Created by MLeo on 2019/3/22.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class FileInfo {
    
    static var index:Int = 0

    let name:String
    var data:Data
    var type:String
    
    init(name:String?,data:Data,type:String) {
        self.name = FileInfo.getName(name)
        self.data = data
        self.type = type
    }
    
    
    func getFileName() -> String{
        return NSString(string:name).appendingPathExtension(type)!
    }
    
    private static func getName(_ name:String?) -> String{
        guard name == nil else {
            return name!
        }
        index += 1
        let name = CLong(NSDate.init().timeIntervalSince1970*1000000)
        return String(name)+String(index)
    }
    
    
}
