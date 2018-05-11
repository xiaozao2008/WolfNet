//
//  WolfBaseModel.swift
//  WolfNet
//
//  Created by xiaozao on 2018/5/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

import Foundation

struct WolfBaseModel<T: WolfMapper>: WolfMapper {
    
    func didInit() {
    }
    
    var code: Int?
    var msg: String?
    var data: T?
}

struct WolfBaseModels<T: WolfMapper>: WolfMapper {
    
    func didInit() {
    }
    
    var code: Int?
    var msg: String?
    var data: [T]?
}
