//
//  FileUploadDelegate.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 上传委托
protocol UploadDelegate {
    
    /// 文件上传
    ///
    /// - Parameters:
    ///   - file: 文件信息
    func fileUpload(_ file:UploadFile)
    
    /// 上传进度
    ///
    /// - Parameters:
    ///   - key: id
    ///   - percent: 进度
    func fileUploadProgress(key:String,percent:Float)
    

}
