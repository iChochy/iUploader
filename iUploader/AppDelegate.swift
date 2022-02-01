//
//  AppDelegate.swift
//  iUploader
//
//  Created by MLeo on 2019/3/7.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa
import Carbon


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func load(){
        let _ = BaseConfig.share.getConfig()
        var uploader:Uploader = QNUploaderService()
        uploader.delegate = UploadDelegateService()
        FileUploadService.share.uploader = uploader
        NSApp.servicesProvider = CustomSystemServices() //注册服务
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        load()
    }
    
     func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

