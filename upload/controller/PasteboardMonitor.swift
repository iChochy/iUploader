//
//  PasteboardMonitor.swift
//  iUpload
//
//  Created by MLeo on 2019/3/20.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class PasteboardMonitor {
    
    private init(){}    
    static let share = PasteboardMonitor.init()
    
    var timerSource:DispatchSourceTimer!
    var changeCount:Int = -1
    
     func monitor(){
            timerSource = DispatchSource.makeTimerSource()
            timerSource.schedule(deadline: DispatchTime.now()+3, repeating: DispatchTimeInterval.seconds(1))
            timerSource.setEventHandler {
                let pasteboard = NSPasteboard.general
                guard self.changeCount != pasteboard.changeCount && self.changeCount != -1 else{
                    self.changeCount = pasteboard.changeCount
                    return
                }
                self.changeCount = pasteboard.changeCount
                FileUploadService.share.uploadWithPasteboard(pasteboard: pasteboard)
            }
            timerSource.resume()
    }

}
