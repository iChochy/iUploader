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
    
    
    func uploadWithURL(fileURL: URL){
        let file = urlToFile(url: fileURL)
        guard let info = file else {
            return
        }
        let imageInfo = imageCompression(image: info)
        uploader.uploadWithFile(file: imageInfo)
    }
    
    func uploadWithPasteboard(pasteboard:NSPasteboard){
        guard let items = pasteboard.pasteboardItems else {
            return
        }
        var images = Array<FileInfo>();
        for item in items {
            let file = pasteboardToFile(item: item)
            guard let info = file else {
                continue
            }
            let imageInfo = imageCompression(image: info)
            images.append(imageInfo)
        }
        uploader.uploadWithFiles(files: images)
    }    
    private func imageCompression(image:FileInfo) -> FileInfo{
        guard let config = BaseConfig.share.getConfig() else{
            return image
        }
        if config.compress == NSControl.StateValue.on.rawValue {
            image.data = toMin(image: image, maximum: config.rate)
        }
        return image
    }
    
    private func toMin(image:FileInfo,maximum:Double)-> Data{
        if(ImageType.png.rawValue.elementsEqual(image.type)){
            return minipng.data2Data(image.data, Int(maximum*100))!
        }else if(ImageType.jpg.rawValue.elementsEqual(image.type)){
            let properties =  [NSBitmapImageRep.PropertyKey.compressionFactor:maximum]
            let fileType = ImageType.fileType(type: image.type);
            return NSBitmapImageRep.init(data: image.data)!.representation(using: fileType, properties:properties)!
        }
        return image.data;
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
            if isFolder(filePath!) {
                return nil
            }
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
        let data = try! Data.init(contentsOf: url)
        let name = NSString.init(string: fileName).deletingPathExtension
        let type = NSString.init(string: fileName).pathExtension
        return FileInfo.init(name: name, data: data, type: type)
    }
    
    private func isFolder(_ filePath:String) -> Bool{
        return filePath.last == "/"
    }
}
