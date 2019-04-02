//
//  BaseConfig.swift
//  iUpload
//
//  Created by MLeo on 2019/3/21.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class BaseConfig {

    private init() {}
    
    static let share:BaseConfig = BaseConfig.init()
    
    func setConfig(config:QNConfig){
        UserDefaultsUtil.set(key: "config",value: config)
    }
    
    func getConfig() -> QNConfig?{
        let baseConfig = UserDefaultsUtil.get(key: "config", type: QNConfig.self)
        guard let config = baseConfig else {
            CustomNotification.share.configIsEmptyNotification()
            CustomNotification.share.sendError(key: UUID.init().uuidString, fileData: nil, message: "未设置配置信息")
            return nil
        }
        return config
    }
    
}
