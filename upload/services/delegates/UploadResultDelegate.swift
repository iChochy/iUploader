//
//  FileUploadDelegate.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

protocol UploadResultDelegate {
    
    /// 上传成功
    ///
    /// - Parameters:
    ///   - key: id
    ///   - fileName: 文件名称
    ///   - fileData: 文件信息
    ///   - message: 信息
    func fileUploadSuccess(key:String,fileName:String,fileData: Data,message:String)
    
    
    /// 上传失败
    ///
    /// - Parameters:
    ///   - key: id
    ///   - fileName: 文件名称
    ///   - fileData: 文件信息
    ///   - message: 信息
    func fileUploadError(key:String,fileName:String,fileData: Data,message:String)
    
    
    /// 上传进度
    ///
    /// - Parameters:
    ///   - key: id
    ///   - percent: 进度
    func fileUploadProgress(key:String,percent:Float)
    

}
