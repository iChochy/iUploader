//
//  FileUploadService.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class FileUploadService {
    
    private init() {}
    
    static let share = FileUploadService.init()
    
    var uploader:Uploader!
    
    
    func uploadWithURL(fileURL: URL){
        let image = urlToImage(url: fileURL)
        uploadWithImage(image: image)
    }
    
    func uploadWithPasteboard(pasteboard:NSPasteboard){
        guard let items = pasteboard.pasteboardItems else {
            return
        }
        for item in items {
            let image = pasteboardItemToImageInfo(item: item)
            uploadWithImage(image: image)
        }
    }
    
    private func uploadWithImage(image:ImageInfo?){
        guard let info = image else {
            return
        }
        guard BaseConfig.share.getConfig() != nil else{
            return 
        }
        let imageInfo = compressImage(image: info)
        uploader.uploadWithImage(image: imageInfo)
    }
    
    
    private func compressImage(image:ImageInfo) -> ImageInfo{
        guard let config = BaseConfig.share.getConfig() else{
            return image
        }
        if config.compress == NSControl.StateValue.on.rawValue {
            let properties =  [NSBitmapImageRep.PropertyKey.compressionFactor:config.rate]
            
            if config.conversion == NSControl.StateValue.on.rawValue {
                image.type = ImageType.jpg.rawValue
            }
            let fileType = ImageType.fileType(type: image.type);
            image.data = NSBitmapImageRep.init(data: image.data)!.representation(using: fileType, properties:properties)!
        }
        return image
    }
    
    
    
    
    private func pasteboardItemToImageInfo(item:NSPasteboardItem) -> ImageInfo?{
        var data = item.data(forType: NSPasteboard.PasteboardType.tiff)
        if data != nil {
            data = NSBitmapImageRep.init(data: data!)?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
            return ImageInfo.init(name: nil, data: data!, type: ImageType.png.rawValue)
            
        }
        data = item.data(forType: NSPasteboard.PasteboardType.png)
        if data != nil {
           return ImageInfo.init(name: nil, data: data!, type: ImageType.png.rawValue)
        }
        
        let filePath = item.string(forType: NSPasteboard.PasteboardType.fileURL)
        if filePath != nil {
            let url = URL.init(string: filePath!)!
            return urlToImage(url: url)
        }
        return nil
    }
    
    
    private func urlToImage(url:URL) -> ImageInfo?{
        guard NSImage.init(contentsOf: url) != nil else{
            return nil
        }
        let fileName = url.lastPathComponent
        let data = try! Data.init(contentsOf: url)
        let name = NSString.init(string: fileName).deletingPathExtension
        let type = NSString.init(string: fileName).pathExtension
        return ImageInfo.init(name: name, data: data, type: type)
    }

    
    
}
