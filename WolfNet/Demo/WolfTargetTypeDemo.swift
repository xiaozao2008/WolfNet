//
//  WolfTargetTypeDemo.swift
//  WolfNetwork
//
//  Created by xiaozao on 2017/11/15.
//  Copyright © 2017年 Tony. All rights reserved.
//

import Foundation
import Moya

enum WolfApi {
    case wolfGet
    case wolfPost
    case wolfUpdate(URL)
    case wolfDownload(DownloadDestination)
}

extension WolfApi: TargetType {
    
    
    var baseURL: URL {
        return URL.init(string: "http://staging.intviu.cn:8200")!
    }
    
    var path: String {
        switch self {
        case .wolfGet:
            return "gift/list"
        case .wolfPost:
            return "post"
        case .wolfUpdate(let url):
            return url.absoluteString
        case .wolfDownload:
            return "download"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .wolfGet:
            return .get
        case .wolfPost:
            return .post
        case .wolfUpdate:
            return .post
        case .wolfDownload:
            return .post
        }
    }
    
    var sampleData: Data {
        return "{'code': 1,6'Token':'123455'}".data(using: .utf8)!
    }
    
    var task: Moya.Task {
        switch self {
        case .wolfGet, .wolfPost:
            return .requestPlain
        case .wolfUpdate(let url):
            return .uploadFile(url)
        case .wolfDownload(let downLoad):
            return .downloadDestination(downLoad)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
