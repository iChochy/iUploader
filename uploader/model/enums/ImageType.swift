//
//  ImageType.swift
//  iUpload
//
//  Created by MLeo on 2019/3/22.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

enum ImageType:String {
    case jpg
    case png
    case gif
    
    static func fileType(type:String) -> NSBitmapImageRep.FileType{
        switch type {
        case ImageType.jpg.rawValue:
            return NSBitmapImageRep.FileType.jpeg
        case ImageType.png.rawValue:
            return NSBitmapImageRep.FileType.png
        case ImageType.gif.rawValue:
            return NSBitmapImageRep.FileType.gif
        default:
            return NSBitmapImageRep.FileType.jpeg
        }
    }
    
    
}
