//
//  PasteboardUtil.swift
//  iUpload
//
//  Created by MLeo on 2019/8/20.
//  Copyright © 2019 iChochy. All rights reserved.
//

import Cocoa

class PasteboardUtil {

    static func setPasteboard(_ fileName:String){
        let baseConfig = BaseConfig.share.getConfig()
        guard let config = baseConfig else{
            return
        }
        var content:String = ""
        let name = NSString.init(string: fileName).deletingPathExtension
        let filePath = config.domain.appendingPathComponent(fileName).absoluteString
        let text = String.init(format: "![%@](%@)", name,filePath)
        content.append(text)
        content.append("\r")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
    
    static func setPasteboard(_ files:Array<UploadFile>){
        let baseConfig = BaseConfig.share.getConfig()
        guard let config = baseConfig else{
            return
        }
        var content:String = ""
        files.forEach { (file) in
            let name = NSString.init(string: file.fileName).deletingPathExtension
            let filePath = config.domain.appendingPathComponent(file.fileName).absoluteString
            let text = String.init(format: "![%@](%@)", name,filePath)
            content.append(text)
            content.append("\r")
        }
        if content.isEmpty{
            return
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: NSPasteboard.PasteboardType.string)
    }
    
    
    
    
}
