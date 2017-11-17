//
//  WolfBaseModel.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import ObjectMapper
import Foundation

public class WolfEmpty<T: Mappable>: Mappable {
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
    }

}

class WolfBaseModel<T: Mappable>: Mappable {
    
    var code = 404
    var msg: String?
    var data: T?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map[WolfNetworkParams.code]
        msg <- map[WolfNetworkParams.msg]
        data <- map[WolfNetworkParams.data]
    }
}

class WolfListModel<T: Mappable>: Mappable {
    
    var code = 404
    var msg: String?
    var dataList: [T]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map[WolfNetworkParams.code]
        msg <- map[WolfNetworkParams.msg]
        dataList <- map[WolfNetworkParams.data]
    }
}
