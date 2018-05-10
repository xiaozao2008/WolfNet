//
//  WolfBaseModel.swift
//  WolfNet
//
//  Created by xiaozao on 2018/5/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

import Foundation

class WolfBaseModel<T: WolfProtocol>: WolfProtocol {
    
    func didInit() {
    }
    
    var code: Int?
    var msg: String?
    var data: T?
}

class WolfBaseModels<T: WolfProtocol>: WolfProtocol {
    
    func didInit() {
    }
    
    var code: Int?
    var msg: String?
    var data: [T]?
}
