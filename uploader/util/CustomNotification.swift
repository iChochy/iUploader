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
    
    func sendSuccess(message:String){
        let userNotification = NSUserNotification()
        userNotification.identifier = UUID.init().uuidString
        userNotification.title = "成功"
        userNotification.informativeText = message
        userNotificationCenter.scheduleNotification(userNotification)//用户系统通知
        successNotification()
    }
    
    func sendError(message:String?){
        let userNotification = NSUserNotification()
        userNotification.identifier = UUID.init().uuidString
        userNotification.title = "错误"
        userNotification.informativeText = message
        userNotificationCenter.scheduleNotification(userNotification)//用户系统通知
        errorNotification()
    }
    

    
    private func successNotification(){
        let notification = Notification.init(name: Notification.Name.init(CustomNotification.name.success.rawValue))
        NotificationCenter.default.post(notification)//调度通知
    }
    
    private func errorNotification(){
        let notification = Notification.init(name: Notification.Name.init(CustomNotification.name.error.rawValue))
        NotificationCenter.default.post(notification)
    }
    
    
    func sendProgress(percent:Float){
        var notification = Notification.init(name: Notification.Name.init(CustomNotification.name.progress.rawValue))
        let userInfo = ["progress":percent]
        notification.userInfo = userInfo
        NotificationCenter.default.post(notification)
    }
    

    func handleSuccessNotification(using block: @escaping (Notification) -> Void) -> NSObjectProtocol{
        return NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.success.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                block(notification)
            }
        }
    }
    
    
    
    func handleErrorNotification(using block: @escaping (Notification) -> Void){
        NotificationCenter.default.addObserver(forName: Notification.Name.init(CustomNotification.name.error.rawValue), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                block(notification)
            }
        }
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
