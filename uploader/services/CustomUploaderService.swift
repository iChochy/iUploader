//
//  FileUploadService.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 自定义上传服务
class CustomUploaderService:Uploader {
    var delegate: UploadDelegate!
    
    
    /// 图片上传
    ///
    /// - Parameter images: image description
    func uploadWithFile(file: FileInfo) {
        print("uploadWithImage")
    }

    /// 图片上传
    ///
    /// - Parameter images: image description
    func uploadWithFiles(files: Array<FileInfo>) {
        print("uploadWithImage")
    }
    
    
    ///   文件上传
    ///
    /// - Parameters:
    ///   - key: id
    ///   - fileName: 文件名称
    ///   - fileData: 文件信息
    ///   - message: 信息
    func fileUpload(_ file:UploadFile){
        delegate.fileUpload(file)
    }
    
    /// 上传进度
    ///
    /// - Parameters:
    ///   - key: id
    ///   - percent: 进度
    func fileUploadProgress(key:String,percent:Float){
        delegate.fileUploadProgress(key: key, percent: percent)
    }
    
    
    
    
}
