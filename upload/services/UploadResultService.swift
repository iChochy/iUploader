//
//  UploadResultService.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class UploadResultService: UploadResultDelegate {
    func fileUploadSuccess(key: String, fileName: String, fileData: Data, message: String) {
        CustomNotification.share.sendSuccess(key: key, fileData: fileData, message: message)
        setPasteboard(fileName: fileName)
        print("fileUploadSuccess")
    }
    
    private func setPasteboard(fileName:String){
        let baseConfig = BaseConfig.share.getConfig()
        guard let config = baseConfig else{
            return
        }
        let name = NSString.init(string: fileName).deletingPathExtension
        let imageUrl = config.domain.appendingPathComponent(fileName).absoluteString
        let text = String.init(format: "![%@](%@)", name,imageUrl)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: NSPasteboard.PasteboardType.string)
    }
    
    
    func fileUploadError(key: String, fileName: String, fileData: Data, message: String) {
        CustomNotification.share.sendError(key: key, fileData: fileData, message: message)
        print("fileUploadError")
    }
    
    func fileUploadProgress(key: String, percent: Float) {
        CustomNotification.share.sendProgress(percent: percent)
        print("fileUploadProgress")
    }
    

}
