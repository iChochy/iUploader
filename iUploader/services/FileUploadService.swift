//
//  FileUploadService.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa
import libminipng

/// 文件上传服务
class FileUploadService {
    
    private init() {}
    
    static let share = FileUploadService.init()
    
    var uploader:Uploader!
    
    
    func asyncUploadWithURL(fileURL: URL){
        DispatchQueue.global().async {
            self.uploadWithURL(fileURL: fileURL)
        }
    }
    
    private func uploadWithURL(fileURL: URL){
        let info = urlToFile(url: fileURL)
        guard let file = info else {
            return
        }
        uploadWithFile(files: [file])
    }
    
    func asyncUploadWithPasteboard(pasteboard:NSPasteboard){
        DispatchQueue.global().async {
            self.uploadWithPasteboard(pasteboard: pasteboard)
        }
    }
    
    private func uploadWithPasteboard(pasteboard:NSPasteboard){
        guard let items = pasteboard.pasteboardItems else {
            return
        }
        var files = Array<FileInfo>();
        for item in items {
            let file = pasteboardToFile(item: item)
            guard let info = file else {
                continue
            }
            files.append(info)
        }
        uploadWithFile(files: files)
    }
    
    private func uploadWithFile(files:Array<FileInfo>){
        if files.isEmpty{
            return
        }
        guard let config = BaseConfig.share.getConfig() else{
            return
        }
        CustomNotification.share.sendBeginStatus()
        if config.compress == NSControl.StateValue.on.rawValue {
            imageCompression(files: files,maximum: config.rate)
        }
        uploader.uploadWithFiles(files: files)
    }
    
    private func imageCompression(files:Array<FileInfo>,maximum:Double){
        files.forEach { (file) in
            file.data = toMin(file: file, maximum:maximum)
        }
    }
    
    private func toMin(file:FileInfo,maximum:Double)-> Data{
        if(ImageType.png.rawValue.elementsEqual(file.type)){
            return minipng.data2Data(file.data, Int(maximum*100))!
        }else if(ImageType.jpg.rawValue.elementsEqual(file.type)){
            let properties =  [NSBitmapImageRep.PropertyKey.compressionFactor:maximum]
            let fileType = ImageType.fileType(type: file.type);
            return NSBitmapImageRep.init(data: file.data)!.representation(using: fileType, properties:properties)!
        }
        return file.data;
    }
    
    
    private func pasteboardToFile(item:NSPasteboardItem) -> FileInfo?{
        var data = item.data(forType: NSPasteboard.PasteboardType.tiff)
        if data != nil {
            data = NSBitmapImageRep.init(data: data!)?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
            return FileInfo.init(name: nil, data: data!, type: ImageType.png.rawValue)
        }
        data = item.data(forType: NSPasteboard.PasteboardType.png)
        if data != nil {
            return FileInfo.init(name: nil, data: data!, type: ImageType.png.rawValue)
        }
        let filePath = item.string(forType: NSPasteboard.PasteboardType.fileURL)
        if filePath != nil {
            let url = URL.init(string: filePath!)!
            return urlToFile(url: url)
        }
        return nil
    }
    
    
    func availableFile(pasteboard:NSPasteboard)-> Bool{
        guard let items = pasteboard.pasteboardItems else {
            return false
        }
        var files = Array<String>();
        for item in items {
            let path = item.string(forType: NSPasteboard.PasteboardType.fileURL)
            guard let filePath = path else{
                continue
            }
            if isFolder(filePath){
                continue
            }
            files.append(filePath)
        }
        return !files.isEmpty
    }
    
    private func urlToFile(url:URL) -> FileInfo?{
        let fileName = url.lastPathComponent
        do {
            let data = try Data.init(contentsOf: url)
            let name = NSString.init(string: fileName).deletingPathExtension
            let type = NSString.init(string: fileName).pathExtension
            return FileInfo.init(name: name, data: data, type: type)
        } catch  {
            return nil
        }
    }
    
    private func isFolder(_ filePath:String) -> Bool{
        return filePath.last == "/"
    }
}
