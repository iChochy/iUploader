//
//  Notification.swift
//  iUpload
//
//  Created by MLeo on 2019/3/14.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class CustomNotification :NSObject, NSUserNotificationCenterDelegate{
    enum name:String {
        case progress
        case notification
    }
    
    private var userNotificationCenter:NSUserNotificationCenter!
    
    private override init(){
        super.init()
        userNotificationCenter = NSUserNotificationCenter.default
        userNotificationCenter.delegate = self
    }
    
    static let share = CustomNotification.init()
    
    func sendSuccess(key:String,fileData: Data,message:String){
        let userNotification = NSUserNotification()
        userNotification.identifier = key
        userNotification.title = "成功"
        userNotification.contentImage = NSImage(data: fileData)
        userNotification.informativeText = message+"上传成功"
        userNotificationCenter.scheduleNotification(userNotification)
    }
    
    func sendError(key:String,fileData: Data?,message:String?){
        let userNotification = NSUserNotification()
        userNotification.identifier = key
        userNotification.title = "错误"
        if nil != fileData {
            userNotification.contentImage = NSImage(data: fileData!)
        }
        userNotification.informativeText = "错误信息："+message!
        userNotificationCenter.scheduleNotification(userNotification)
    }
    
    func sendProgress(percent:Float){
        var notification = Notification.init(name: Notification.Name.init(CustomNotification.name.progress.rawValue))
        let userInfo = ["progress":percent]
        notification.object = percent
        notification.userInfo = userInfo
        NotificationCenter.default.post(notification)
    }
    
    func notification(userInfo:[String:Any]?){
        var notification = Notification.init(name: Notification.Name.init(CustomNotification.name.notification.rawValue))
        notification.userInfo = userInfo
        NotificationCenter.default.post(notification)
    }

    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
