//
//  UserDefaultsUtil.swift
//  qupload
//
//  Created by MLeo on 2019/3/13.
//  Copyright © 2019年 iChochy. All rights reserved.
//

import Cocoa

class UserDefaultsUtil: NSObject {
    
    static func set<T>(key:String,value:T) where T:Codable{
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func get <T> (key:String,type:T.Type) -> T? where T:Codable{
        let data = UserDefaults.standard.value(forKey: key)
        guard let item = data else {
            return nil
        }
        do {
            let t = try JSONDecoder().decode(type, from: item as! Data)
            return t
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
