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
        case success
        case error
        case progress
        case configIsEmpty
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
        successNotification()
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
        errorNotification()
    }
    
    func sendProgress(percent:Float){
        var notification = Notification.init(name: Notification.Name.init(CustomNotification.name.progress.rawValue))
        let userInfo = ["progress":percent]
        notification.userInfo = userInfo
        NotificationCenter.default.post(notification)
    }
    
    private func successNotification(){
        let notification = Notification.init(name: Notification.Name.init(CustomNotification.name.success.rawValue))
        NotificationCenter.default.post(notification)
    }
    
    func handleSuccessNotification(using block: @escaping (Notification) -> Void) -> NSObjectProtocol{
        return NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.success.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                block(notification)
            }
        }
    }
    
    
    private func errorNotification(){
        let notification = Notification.init(name: Notification.Name.init(CustomNotification.name.error.rawValue))
        NotificationCenter.default.post(notification)
    }
    
    func handleErrorNotification(using block: @escaping (Notification) -> Void){
        NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.error.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                block(notification)
            }
        }
    }
    
    func configIsEmptyNotification(){
        let notification = Notification.init(name: Notification.Name.init(CustomNotification.name.configIsEmpty.rawValue))
        NotificationCenter.default.post(notification)
    }
    
    
    func handleConfigIsEmptyNotification(using block: @escaping (Notification) -> Void){
        NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.configIsEmpty.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                block(notification)
            }
        }
    }

    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    

    
}
