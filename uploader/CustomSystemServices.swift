//
//  CustomServices.swift
//  iUpload
//
//  Created by MLeo on 2019/3/18.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 自定义系统服务
class CustomSystemServices{

    

    
    /// 右键上传服务
    ///
    /// - Parameters:
    ///   - pasteboard: pasteboard description
    ///   - userData: userData description
    ///   - error: error description
    @objc func handleServices(_ pasteboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        FileUploadService.share.asyncUploadWithPasteboard(pasteboard: pasteboard)
    }
    
}
