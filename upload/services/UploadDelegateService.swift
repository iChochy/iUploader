//
//  UploadResultService.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 上传委托服务
class UploadDelegateService: UploadDelegate {
    
    private var files:Dictionary<String, Array<UploadFile>> = [:]
    
    func fileUpload(_ file: UploadFile) {
        if !file.status {
            CustomNotification.share.sendError(message: file.message)
        }
        let result = FileStorageService.share.addUploadFile(file)
        if result {
            let files = FileStorageService.share.getListByKey(file.key)
            fileUploadFinish(files)
        }
    }
    
    
    func fileUploadFinish(_ files:Array<UploadFile>?){
        guard let files = files else{
            return
        }
        let current = files.filter({ (file) -> Bool in
            return file.status
        })
        if current.isEmpty{
            return
        }
        setPasteboard(current)
        var message = "完成上传，"
        if current.count == files.count {
            message += "\(current.count)个文件上传成功"
        }else{
            message += "\(current.count)个文件上传成功，\(files.count-current.count)个文件上传失败"
        }
        CustomNotification.share.sendSuccess(message: message)
    }
    
    

    
    private func setPasteboard(_ files:Array<UploadFile>){
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
    
    
    
    func fileUploadProgress(key: String, percent: Float) {
        CustomNotification.share.sendProgress(percent: percent)
        print("fileUploadProgress")
    }
    
    
}
