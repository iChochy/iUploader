//
//  FileStorageService.swift
//  iUpload
//
//  Created by MLeo on 2019/8/14.
//  Copyright © 2019 iChochy. All rights reserved.
//

import Cocoa

class FileStorageService {
    private init() {}
    static let share = FileStorageService.init()
    
    private var fileList:Dictionary<String,Array<UploadFile>> = [:]
    private var fileHistory:Array<UploadFile> = Array<UploadFile>()
    
    
    func addUploadFile(_ file:UploadFile) -> Bool{
        addHistory(file)
        return addList(file)
    }
    
    func getHistory() -> Array<UploadFile>{
        return fileHistory
    }
    
    func getListByKey(_ key:String) -> Array<UploadFile>?{
        return fileList.removeValue(forKey: key)
    }
    
    private func addHistory(_ file:UploadFile){
        if file.status{
            fileHistory.append(file)
        }
        if(fileHistory.count > 10){
            fileHistory.removeFirst()
        }
    }
    
    private func addList(_ file:UploadFile) -> Bool{
        let key = file.key
        var files:Array<UploadFile> = fileList[key] ?? Array<UploadFile>()
        files.append(file)
        fileList.updateValue(files, forKey: key)
        if(files.count == file.count){
            return true
        }
        return false
    }
    
    
    

}
