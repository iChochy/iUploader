//
//  ToUploadDelegate.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

protocol Uploader {
    
    var delegate:UploadResultDelegate! {get set}
    
    /// 文件上传
    ///
    /// - Parameter info: 文件信息
    func uploadWithImage(image: ImageInfo)
    
}
