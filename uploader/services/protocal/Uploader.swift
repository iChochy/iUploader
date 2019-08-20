//
//  ToUploadDelegate.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 上传协议
protocol Uploader {
    
    var delegate:UploadDelegate! {get set}
    
    
    /// 文件上传
    ///
    /// - Parameter image: 文件信息
    func uploadWithFile(file: FileInfo)
    /// 文件上传
    ///
    /// - Parameter images: 文件信息
    func uploadWithFiles(files: Array<FileInfo>)
    
}
