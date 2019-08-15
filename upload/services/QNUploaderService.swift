//
//  QNUpload.swift
//  qupload
//
//  Created by MLeo on 2019/3/14.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa


/// 七牛云文件上传服务
class QNUploaderService: CustomUploaderService{
    
    private var uploaderManager:QNUploadManager!
    
    private override init() {
        super.init()
        uploaderManager = QNUploadManager(configuration: getUploadConfig())
    }    
    static let share = QNUploaderService.init()
    

    override func uploadWithFile(file: FileInfo) {
        let images:Array<FileInfo> = [file]
        uploadWithFiles(files: images)
    }
    
    override func uploadWithFiles(files: Array<FileInfo>) {
        let key = UUID.init().uuidString
        for (index,image) in files.enumerated() {
            let file = UploadFile.init(key:key,fileName: image.getFileName(), fileData: image.data, index: index, count: files.count)
            upload(file)
        }
    }
    
    private func upload(_ file:UploadFile) {
        guard let config = BaseConfig.share.getConfig() else {
            return
        }
        let token = createQiniuToken(config:config,fileName: file.fileName)
        let option = createOption()
        uploader(file: file,token: token, option: option)
    }
    

    private func uploader(file:UploadFile,token:String,option:QNUploadOption?){
        uploaderManager.put(file.fileData, key: file.fileName, token: token, complete: { (response, key, result) in
            guard let result = result else{
                let message = self.getErrorMessage(response: response)
                file.message = message
                self.fileUpload(file)
                return
            }
            let message = result["key"] as! String
            file.message = message
            file.status = true
            self.fileUpload(file)
        }, option: option)
    }
    
    private func createOption() -> QNUploadOption?{
        let option = QNUploadOption.init(mime: nil, progressHandler: { (key, percent) in
            self.fileUploadProgress(key: key!, percent: percent)
        }, params: nil, checkCrc: false) { () -> Bool in
            return false
        }
        return option
    }
    
    private func getUploadConfig() -> QNConfiguration{
        let config = QNConfiguration.build { (builder) in
            guard let builder = builder else{
                return
            }
            builder.useHttps = true
        }
        return config!
    }
    
    
    private func getErrorMessage(response:QNResponseInfo?) -> String?{
        guard let response = response else{
            return nil
        }
        guard let error = response.error else {
            return nil
        }
        return error.localizedDescription
    }
    
    
    private func createQiniuToken(config:QNConfig,fileName: String?) -> String {
        let uploadPolicy = UploadPolicy.init(bucket: config.bucket,fileName: fileName)
        let encodedPutPolicyData = try! JSONEncoder.init().encode(uploadPolicy);
        let encodedPutPolicy = QNUrlSafeBase64.encode(encodedPutPolicyData)!
        let encodedSignData = self.hmacsha1WithString(str: encodedPutPolicy, secretKey: config.secretKey)
        let encodedSign = QNUrlSafeBase64.encode(encodedSignData)!
        return config.accessKey + ":" + encodedSign + ":" + encodedPutPolicy
    }
    
    
    private func hmacsha1WithString(str: String, secretKey: String) -> Data {
        let cKey  = secretKey.cString(using: String.Encoding.ascii)
        let cData = str.cString(using: String.Encoding.ascii)
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData: Data = Data(bytes: result, count: (Int(CC_SHA1_DIGEST_LENGTH)))
        return hmacData
    }
    
}
