//
//  CustomServices.swift
//  iUpload
//
//  Created by MLeo on 2019/3/18.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class CustomServices {

    
    @objc func handleServices(_ pasteboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        FileUploadService.share.uploadWithPasteboard(pasteboard: pasteboard)
    }
    
}
