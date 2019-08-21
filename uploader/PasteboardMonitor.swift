//
//  PasteboardMonitor.swift
//  iUpload
//
//  Created by MLeo on 2019/3/20.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

/// 剪贴板监控
class PasteboardMonitor {
    
    var timerSource:DispatchSourceTimer!
    var changeCount:Int = -1
    
    private init(){
        timerSource = DispatchSource.makeTimerSource()
        timerSource.schedule(deadline: DispatchTime.now()+3, repeating: DispatchTimeInterval.seconds(1))
        timerSource.setEventHandler {
            let pasteboard = NSPasteboard.general
            if(self.changeCount == -1){
                self.changeCount = pasteboard.changeCount
            }
            if self.changeCount == pasteboard.changeCount {
                return
            }
            self.changeCount = pasteboard.changeCount
            FileUploadService.share.asyncUploadWithPasteboard(pasteboard: pasteboard)
        }
    }
    static let share = PasteboardMonitor.init()

    
    
    /// 开启监控
    func open(){
        timerSource.resume();
    }
    
    func close(){
        timerSource.suspend()
    }
    
}
