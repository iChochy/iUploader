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
    
    
    func fileUploadProgress(key: String, percent: Float) {
        CustomNotification.share.sendProgress(percent: percent)
    }
    
    private func fileUploadFinish(_ files:Array<UploadFile>?){
        guard let files = files else{
            return
        }
        let current = files.filter({ (file) -> Bool in
            return file.status
        })
        if current.isEmpty{
            return
        }
        PasteboardUtil.setPasteboard(current)
        var message = "完成上传，"
        if current.count == files.count {
            message += "\(current.count)个文件上传成功"
        }else{
            message += "\(current.count)个文件上传成功，\(files.count-current.count)个文件上传失败"
        }
        CustomNotification.share.sendSuccess(message: message)
    }
    
}
