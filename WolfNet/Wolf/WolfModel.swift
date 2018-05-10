//
//  WolfBaseModel.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation

public protocol WolfProtocol: Codable {
    mutating func didInit()
}

public class WolfModel {
    
    public static func model<T: WolfProtocol>(_ data: Data?) -> T? {
        if let data = data {
            do {
                var model = try JSONDecoder.init().decode(T.self, from: data)
                model.didInit()
                return model
            } catch {
                // 此问题一般表示model属性的类型不匹配, 比如 age: String?, 可能服务器的参数为Int
                debugPrint("key的类型不匹配" + error.localizedDescription)
                return nil
            }
        } else {
            debugPrint("WolfModel传入data为nil")
            return nil
        }
    }
    
    public static func JSON<T: Encodable>(_ model: T?) -> Data? {
        if let model = model {
            do {
                return try JSONEncoder.init().encode(model)
            } catch {
                debugPrint("将\(model.self)转成jsondata失败 \(error.localizedDescription)")
                return nil
            }
        } else {
            debugPrint("传入\(String(describing: model))为nil")
            return nil
        }
    }
    
}

