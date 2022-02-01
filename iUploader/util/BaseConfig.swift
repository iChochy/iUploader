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
        let baseConfig = getDefaultConfig()
        guard let config = baseConfig else {
            CustomNotification.share.sendError(message: "未设置配置信息")
            return nil
        }
        return config
    }
    
    func getDefaultConfig() -> QNConfig?{
        let baseConfig = UserDefaultsUtil.get(key: "config", type: QNConfig.self)
        guard let config = baseConfig else {
            return nil
        }
        return config
    }
    
    
}
