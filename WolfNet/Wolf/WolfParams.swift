//
//  WolfParams.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation
import Alamofire
import Moya

let WolfNetworkParams = WolfParams()

public class WolfParams: NSObject {
    var msg = "msg"
    var code = "code"
    var data = "data"
    // 请求头
    var isDebug = false
    var header = [String: String]()
    var sessionManager = DefaultAlamofireManager.sharedManager
}

public class DefaultAlamofireManager: Alamofire.SessionManager {
    
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 60
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return DefaultAlamofireManager(configuration: configuration)
    }()
    
}

