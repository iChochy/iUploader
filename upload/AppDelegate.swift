//
//  AppDelegate.swift
//  qupload
//
//  Created by MLeo on 2019/3/7.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa
import Carbon


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func appLoad(){
//        let _ = BaseConfig.share.getConfig()
        var uploader:Uploader = QNUploaderService.share
        uploader.delegate = UploadResultService()
        FileUploadService.share.uploader = uploader
        NSApp.servicesProvider = CustomServices() //注册服务
        PasteboardMonitor.share.monitor() //粘贴板监控
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appLoad()
    }
    
     func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
}

