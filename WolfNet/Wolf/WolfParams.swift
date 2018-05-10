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

public let WolfNetworkParams = WolfParams()

public class WolfParams {
    // 请求头
    public var isDebug = false
    public var header = [String: String]()
    public var sessionManager = DefaultAlamofireManager.sharedManager
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

